USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_KpiGenerationTxn_Popup_DeductionValue_test]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspFM_KpiGenerationTxn_Popup_DeductionValue_test] (
	@pYear INT,
	@pMonth INT,
	@pServiceId INT,
	@pFacilityId INT,
	@pIndicatorNo nvarchar(10) ,
    @pPageIndex			INT = null,
    @pPageSize			INT = null	
	)AS

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_DedGenerationTxn]
Description			: Asset number fetch control
Authors				: Dhilip V
Date				: 08-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_KpiGenerationTxn_Popup_DeductionValue] @pYear=2018,@pMonth=05, @pServiceId=2,@pFacilityId=2,@pIndicatorNo = 'B.1',@pPageIndex=1,@pPageSize=5
select * from DedGenerationBemsPopupTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================
------------------:------------:-------------------------------------------------------------------
Raguraman J		  : 07/09/2016 : B1 - Responsetime emergency:15 mins / normal:120 mins
								 B2 - Working days greater than 7 days
								 B3 - PPM,SCM & RI
								 B4 - Uptime & Downtime Calculation
								 B5 - From NCR 
-----:------------:------------------------------------------------------------------------------*/


BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	
		Declare  @WOcriticalmins int,@WONormalmins int,@WOCompletiondays int,@customerid int


		select @customerid= CustomerId from MstLocationFacility where  FacilityId=@pFacilityId

		select @WOcriticalmins=ConfigKeyLovId from FMConfigCustomerValues  where CustomerId=@customerid and ConfigKeyId=13
		select @WONormalmins=ConfigKeyLovId from FMConfigCustomerValues  where CustomerId=@customerid and ConfigKeyId=14
		select @WOCompletiondays=ConfigKeyLovId from FMConfigCustomerValues  where CustomerId=@customerid and ConfigKeyId=15

		select @WOcriticalmins=isnull(@WOcriticalmins,15),@WONormalmins = isnull(@WONormalmins,2)*60,@WOCompletiondays=isnull(@WOCompletiondays,7)


-- Declaration

/*-- Test Parameters
	DECLARE @pYear INT=2017,
	@pMonth INT = 1,
	@pServiceId INT=2,
	@GROUPID INT=1,
	@pFacilityId INT=85,
	@pMonthlyServiceFee FLOAT=1.0
*/
	
	--===========================================
	-- Input Month From Lov.
	--===========================================

	

	DECLARE @StartDate AS DATETIME , @LastDate AS DATETIME, @EOM AS DATETIME, @EOMT AS DATETIME
	DECLARE @TotalRecords INT
	DECLARE	@pTotalPage		NUMERIC(24,2)
	
	SET @StartDate= DATEFROMPARTS(@pYear, @pMonth , 01)
	SET @EOM = CAST(EOMONTH(@StartDate) AS DATE)
	SET @EOMT = DATEADD(ms, -100, DATEADD(s, 86400, @EOM))	
	SET @LastDate  = @EOMT
	
	IF(@pMonth=MONTH(GETDATE()))
	BEGIN
		SET @LastDate = GETDATE()
	END


	IF OBJECT_ID('tempdb..#TotalParameterDemerit') IS NOT NULL
	DROP TABLE #TotalParameterDemerit

	create table #TotalParameterDemerit
	(
		IndicatorName nvarchar(300),
		AssetNo nvarchar(300),
		AssetDescription nvarchar(300),
		TypeofTransaction nvarchar(300),
		Totalrecords nvarchar(300),
		ServiceWorkOrder nvarchar(300)
	)	

	IF OBJECT_ID('tempdb..#TotalParameterDeduction') IS NOT NULL
	DROP TABLE #TotalParameterDeduction

	create table #TotalParameterDeduction
	(
		IndicatorName nvarchar(300),
		AssetNo nvarchar(300),
		PurchaseCost nvarchar(300),
		DemeritPoint numeric(24,2),
		DemeritValue numeric(24,2)		
	)	


	--===========================================
	--Asset Exemption Approved from BER service - Get All Assets
	--===========================================
	IF OBJECT_ID('tempdb..#tmpBerAssets') IS NOT NULL
	DROP TABLE #tmpBerAssets

	select ba.AssetId
	INTO #tmpBerAssets
	from   BerApplicationTxn ba 
	inner join BerApplicationHistoryTxn bh on ba.ApplicationId=bh.ApplicationId 
    inner join EngAsset ar on ba.AssetId=ar.AssetId
    where bh.[Status]  IN (208)
    AND ba.ApplicationDate <= @LastDate
	and CAST(@LastDate AS DATE) >= CAST(bh.CreatedDate AS DATE) and ba.FacilityId  = @pFacilityId
	and ar.Active=1 and ar.ServiceId=@pServiceId and ar.FacilityId = @pFacilityId
	--and ar.[Authorization] = 199
	group by ba.AssetId


	--===========================================
	-- Authorized & Active Assets
	--===========================================
	IF OBJECT_ID('tempdb..#tmpAssetRegister') IS NOT NULL
	DROP TABLE #tmpAssetRegister

	SELECT distinct ar.*
	INTO #tmpAssetRegister
	FROM EngAsset ar
	WHERE ar.[Authorization] = 199 -- Authorized
	AND ar.AssetStatusLovId = 1 -- Active
	AND ar.CommissioningDate <= @LastDate
	AND ar.WarrantyEndDate <= @LastDate -- Warranty
	AND ar.ServiceId = @pServiceId
	AND ar.FacilityId  = @pFacilityId
	AND ar.AssetId NOT IN (SELECT AssetId FROM #tmpBerAssets)

	-- Select * from #tmpAssetRegister where AssetId=236243
	---------------------------------------------

	--===========================================
	-- Working days in a month for the selected Facility
	--===========================================
	
	DECLARE @MonthWorkingDays int

	SELECT @MonthWorkingDays = COUNT(*)		
	FROM MstWorkingCalenderDet  det
	INNER JOIN MstWorkingCalender mst (NOLOCK) ON det.CalenderId = mst.CalenderId
				AND det.Active = 1 AND mst.Active = 1 
	WHERE mst.[Year] = @pYear
	AND det.[Month] = @pMonth
	AND mst.FacilityId = @pFacilityId
	GROUP BY IsWorking
	HAVING IsWorking = 1
	---------------------------------------------

	--===========================================
	-- Number of Days for the selected year
	--===========================================
	
	DECLARE @DaysInYear INT
	SET @DaysInYear = DATEDIFF(DAY,  CAST(@pYear AS CHAR(4)),  CAST(@pYear+1 AS CHAR(4))) 
	---------------------------------------------

	--===========================================
	-- Temp Tables
	--===========================================

	IF OBJECT_ID('tempdb..#tmpIndicator') IS NOT NULL
	DROP TABLE #tmpIndicator
	
	IF OBJECT_ID('tempdb..#tmpAssetSlab') IS NOT NULL
	DROP TABLE #tmpAssetSlab

	IF OBJECT_ID('tempdb..#BemsResults') IS NOT NULL
	DROP TABLE #BemsResults

	IF OBJECT_ID('tempdb..#tmpResults') IS NOT NULL
	DROP TABLE #tmpResults
	
	IF OBJECT_ID('tempdb..#tmpWorkOrder') IS NOT NULL
	DROP TABLE #tmpWorkOrder

	IF OBJECT_ID('tempdb..#tmpSnfAssets') IS NOT NULL
	DROP TABLE #tmpSnfAssets
	
	---------------------------------------------

	--===========================================
	-- Indicator Id for BEMS.
	--===========================================

	DECLARE @IndicatorId INT=1;

	SELECT * 
	INTO #tmpIndicator
	FROM MstDedIndicatorDet d
	WHERE IndicatorId = @IndicatorId;

	---------------------------------------------

	--===========================================
	-- Asset Slab
	--===========================================

	CREATE TABLE #tmpAssetSlab(CostStart FLOAT, CostEnd FLOAT
								, DeductionValue FLOAT,B4DeductionValue FLOAT)

	INSERT INTO #tmpAssetSlab
	SELECT 1.0 AS CostStart,4999.99 AS CostEnd,10.00 AS DeductionValue
												,20.00 AS B4DeductionValue UNION
	SELECT 5000.00  AS CostStart,9999.99 AS CostEnd,20.00 AS DeductionValue
												,40.00 AS B4DeductionValue UNION
	SELECT 10000.00 AS CostStart,14999.99 AS CostEnd,30.00 AS DeductionValue
												,60.00 AS B4DeductionValue UNION
	SELECT 15000.00 AS CostStart,19999.99 AS CostEnd,40.00 AS DeductionValue
												,80.00 AS B4DeductionValue UNION
	SELECT 20000.00 AS CostStart,24999.99 AS CostEnd,50.00 AS DeductionValue
												,90.00 AS B4DeductionValue UNION
	SELECT 25000.00 AS CostStart,29999.99 AS CostEnd,60.00 AS DeductionValue
												,100.00 AS B4DeductionValue UNION
	SELECT 30000.00 AS CostStart,34999.99 AS CostEnd,70.00 AS DeductionValue
												,120.00 AS B4DeductionValue UNION
	SELECT 35000.00 AS CostStart,39999.99 AS CostEnd,80.00 AS DeductionValue
												,160.00 AS B4DeductionValue UNION
	SELECT 40000.00 AS CostStart,44999.99 AS CostEnd,90.00 AS DeductionValue
												,180.00 AS B4DeductionValue UNION
	SELECT 45000.00 AS CostStart,NULL AS CostEnd,100.00 AS DeductionValue
												,200.00 AS B4DeductionValue 
--SELECT * FROM DeductionValueMetaData
	---------------------------------------------

	--===========================================
	-- Result Table Generation
	--===========================================

	CREATE TABLE #BemsResults(IndicatorDetId INT, IndicatorNo NVARCHAR(MAX)
	, IndicatorName VARCHAR(MAX), SubParameter NVARCHAR(MAX)
	, SubParameterDetId INT, TransDemeritPoints INT
	, TotalDemeritPoints INT
	, DeductionValue FLOAT, DeductionPer FLOAT)


	INSERT INTO #BemsResults
	SELECT IndicatorDetId, IndicatorNo, IndicatorName
	, NULL SubParameter, NULL SubParameterDetId, NULL TransDemeritPoints
	, NULL TotalDemeritPoints
	, NULL DeductionValue, NULL DeductionPer
	FROM #tmpIndicator t
	UNION 
	SELECT 0,'Total', NULL IndicatorName
	, NULL SubParameter, NULL SubParameterDetId, NULL TransDemeritPoints
	, NULL TotalDemeritPoints
	, NULL DeductionValue, NULL DeductionPer

	---------------------------------------------

	--===========================================
	--Asset Below Ememption applied for Variation Status V3, V4 or V6.	
	--===========================================
	
	--DD 3 stop service assets

	SELECT snf.AssetId as AssetId
	INTO #tmpSnfAssets
	FROM EngTestingandCommissioningTxn snf 
	INNER JOIN EngMaintenanceWorkOrderTxn wo on snf.AssetId = wo.AssetId	
												AND snf.VariationStatus IN 
													(SELECT LovId 
													FROM FMLovMst 		
													WHERE LovKey = 'VariationStatusValue' 
													AND FieldCode IN (3,4,6))
	WHERE wo.FacilityId  = @pFacilityId
	AND wo.ServiceId=@pServiceId	
	

	--select * from #tmpSnfAssets
	--===========================================
	-- Get all Rejected Exemptions workorders
	--===========================================

	SELECT wo.WorkOrderId, wo.AssetId, wo.MaintenanceWorkDateTime, wo.CustomerId
		, wo.FacilityId, wo.ServiceId, wo.MaintenanceWorkCategory
		, ar.PurchaseCostRM, ar.TestingandCommissioningdetId, ar.UserLocationId, ar.UserAreaId
		, wo.TargetDateTime, wo.TypeOfWorkOrder,wo.WorkOrderPriority
	INTO #tmpWorkOrder
	FROM EngMaintenanceWorkOrderTxn wo
	INNER JOIN EngAsset ar (NOLOCK) ON ar.AssetId = wo.AssetId 
	LEFT JOIN engmwocompletioninfotxn wc ON wo.workorderid=wc.workorderid 
	WHERE 
	ar.[Authorization] = 199 -- Authorized
	AND ar.AssetStatusLovId = 1 -- Active
	AND ar.CommissioningDate <= @LastDate
	AND ar.ServiceId = @pServiceId
	AND ar.FacilityId  = @pFacilityId
	and wo.ServiceId = @pServiceId 
	AND wo.FacilityId  = @pFacilityId
	AND wo.MaintenanceWorkDateTime <= @LastDate
	AND wo.WorkOrderStatus not in  (196,197)
	AND wo.AssetId NOT IN (SELECT AssetId FROM #tmpSnfAssets)
	AND ar.AssetId NOT IN (SELECT AssetId FROM #tmpBerAssets)
	

	-- select * from #tmpWorkOrder where AssetId=236243
	---------------------------------------------						

--=================================================================================================
--								BEMS Indicator - B1												 --
--=================================================================================================

	--===========================================
	-- B1 Temp Tables
	--===========================================

	
	IF OBJECT_ID('tempdb..#tmpB1') IS NOT NULL
	DROP TABLE #tmpB1

	---------------------------------------------
	--===========================================
	--Response Time: Normal call: 120 minutes, Emergency call: 15 minutes
	--===========================================
	-- DD 4 -- SR details with priority values
	
	--select 1 as WorkOrderId,1 as AssetId,1 PurchaseCostRM,1 Priority,'Normal' FieldValue,
	--1 CountofReq,1 Mins,1 Demeritpoint,0 NCRDemeritPoints,1 DeductionValue into #tmpB1
	
	SELECT wo.WorkOrderId
		, wo.AssetId
		, wo.PurchaseCostRM
		, wo.WorkOrderPriority
		, lov.FieldValue
		, COUNT(*) AS CountofReq
		, DATEDIFF(MINUTE,wo.MaintenanceWorkDateTime, ISNULL(eass.ResponseDateTime,@LastDate)) as Mins
		, CASE WHEN (lov.FieldValue ='Normal' 
			AND DATEDIFF(MINUTE, wo.MaintenanceWorkDateTime, ISNULL(eass.ResponseDateTime,@LastDate)) >@WONormalmins)
		OR (lov.FieldValue ='Critical' 
			AND DATEDIFF(MINUTE,wo.MaintenanceWorkDateTime, ISNULL(eass.ResponseDateTime,@LastDate)) >@WOcriticalmins) 
		THEN 1 ELSE 0 END AS Demeritpoint 
		, 0 AS NCRDemeritPoints
		,tmp.DeductionValue
	INTO #tmpB1
	FROM #tmpWorkOrder wo (NOLOCK)	
	INNER JOIN FMLovMst lov (NOLOCK) ON lov.LovId = wo.WorkOrderPriority
	LEFT JOIN EngMwoAssesmentTxn eass (NOLOCK) ON eass.WorkOrderId = wo.WorkOrderId  
	LEFT JOIN MstLocationUserLocation ul (NOLOCK) ON wo.UserLocationId = ul.UserLocationId 																					
	
	CROSS JOIN #tmpAssetSlab tmp 
	WHERE wo.PurchaseCostRM BETWEEN tmp.CostStart AND ISNULL(tmp.CostEnd,wo.PurchaseCostRM)		
	--and convert(varchar(6),wo.MaintenanceWorkDateTime,112) = convert(varchar(6),@StartDate,112)
	--and YEAR(wo.MaintenanceWorkDateTime) = YEAR(@StartDate) AND MONTH(wo.MaintenanceWorkDateTime) = MONTH(@StartDate)
	AND ((Eass.ResponseDateTime IS NULL ) 
	OR (cast(eass.ResponseDateTime as date)>=cast(@StartDate as date)))
	--OR (MONTH(eass.ResponseDateTime)=@pMonth AND YEAR(eass.ResponseDateTime)=@pYear))	 	
	AND wo.MaintenanceWorkCategory IN (188,189) -- Unscheduled 	
	AND (CASE WHEN (lov.FieldValue ='Normal' 
			AND DATEDIFF(MINUTE, wo.MaintenanceWorkDateTime, ISNULL(eass.ResponseDateTime,@LastDate)) >@WONormalmins)
		OR (lov.FieldValue ='Critical' 
			AND DATEDIFF(MINUTE,wo.MaintenanceWorkDateTime, ISNULL(eass.ResponseDateTime,@LastDate)) >@WOcriticalmins) 
		THEN 1 ELSE 0 END)>0 	
	GROUP BY wo.WorkOrderId, wo.AssetId, wo.FacilityId, wo.CustomerId, wo.PurchaseCostRM
	, wo.WorkOrderPriority, lov.FieldValue, wo.MaintenanceWorkDateTime, eass.ResponseDateTime, tmp.DeductionValue
	
	--select * from #tmpB1

	/*
	Insert INTO #tmpB1
	select 
	 0 as WorkOrderId, ar.AssetId, ar.PurchaseCostRM 
	, 0 as [Priority], '' as FieldValue
	, 0 AS CountofReq, 0 as Mins
	, COUNT(wo.WorkOrderId) as DemeritPoint
	,  0 as NCRDemeritPoints
	, (COUNT(*) * (select DeductionValue from #tmpAssetSlab
				where ar.PurchaseCostRM BETWEEN CostStart AND ISNULL(CostEnd,ar.PurchaseCostRM))
			)AS TotalDeduction			
		from EngMaintenanceWorkOrderTxn  wo
		join EngAsset Ar  on Ar.AssetId = wo.AssetId
		inner join FMLovMst a on ar.AssetClassification = a.LovId

 and wo.ServiceId = @pServiceId 
		left join MstStaff fs on fs.StaffMasterId = wo.RequestorStaffId
		LEFT JOIN EngAssetWorkGroup AS wg on ar.WorkGroupId = wg.WorkGroupId and wg.Active = 1
		LEFT JOIN MstLocationUserLocation ul  ON ar.UserLocationId = ul.UserLocationId
		LEFT JOIN MstLocationUserArea ua  ON ul.UserAreaId = ua.UserAreaId	
		where convert(varchar(6),MaintenanceWorkDateTime,112)   = convert(varchar(6),@StartDate,112)
		and ar.[Authorization]=199 
		and ar.AssetStatusLovId=1	
		and wo.FacilityId  = @pFacilityId
		and ar.FacilityId  = @pFacilityId

		and ar.ServiceId = @pServiceId
		and wo.ServiceId = @pServiceId
		and ar.WarrantyEndDate is not null
		AND wo.WorkOrderStatus not in  (196,197)
		--and emw.WorkOrderId is null
		AND ar.AssetId NOT IN (SELECT AssetId FROM #tmpBerAssets)
		GROUP BY ar.AssetId, ar.PurchaseCostRM
*/

	INSERT INTO #TotalParameterDeduction
	select 'B.1' as IndicatorName,ar.assetno,ar.purchasecostrm,count(*),t.DeductionValue 
	from #tmpb1 t
	inner join EngMaintenanceWorkOrderTxn wo on t.workorderid=wo.workorderid
	inner join EngAsset ar on t.AssetId= ar.AssetId
	group by ar.assetno,ar.purchasecostrm,t.DeductionValue

	INSERT INTO #TotalParameterDemerit 
	select 'B.1' as IndicatorName,ar.assetno,ar.assetdescription,'Service work' TypeofTransaction,1 TotalRecords ,wo.maintenanceworkno	
	from #tmpb1 t
	inner join EngMaintenanceWorkOrderTxn wo on t.workorderid=wo.workorderid
	inner join EngAsset ar on t.AssetId= ar.AssetId
	---------------------------------------------
	--===========================================
	-- Add to Result Table
	--===========================================
	

	SELECT ti.IndicatorDetId, ti.IndicatorNo
		, ti.IndicatorName, NULL AS SubParameter
		, SUM(t.Demeritpoint) AS TransDemeritPoints
		, SUM(t.Demeritpoint)+SUM(t.NCRDemeritPoints) AS TotalDemeritPoints
		, NULL AS TotalParameters
		, SUM(t.DeductionValue) AS DeductionValue
		, (SUM(t.DeductionValue)/100) AS DeductionPer	
	INTO #tmpResults 	
	-- select *
	FROM #tmpB1 t
	CROSS JOIN #tmpIndicator ti 
	WHERE  ti.IndicatorNo = 'B.1'
	AND (t.Demeritpoint > 0 OR t.NCRDemeritPoints>0) 
	GROUP BY ti.IndicatorDetId, ti.IndicatorNo, ti.IndicatorName	

------------------------------------------------------------------------------------------------------------

--=================================================================================================
	--									BEMS Indicator - B2											 --
	--=================================================================================================

	--===========================================
	-- B2 Temp Tables
	--===========================================

	IF OBJECT_ID('tempdb..#tmpDays') IS NOT NULL
	DROP TABLE #tmpDays

	IF OBJECT_ID('tempdb..#tmpCalcAll') IS NOT NULL
	DROP TABLE #tmpCalcAll

	IF OBJECT_ID('tempdb..#tmpCalc') IS NOT NULL
	DROP TABLE #tmpCalc

	IF OBJECT_ID('tempdb..#tmpWOPoint') IS NOT NULL
	DROP TABLE #tmpWOPoint

	IF OBJECT_ID('tempdb..#tmpDiffDays') IS NOT NULL
	DROP TABLE #tmpDiffDays

	IF OBJECT_ID('tempdb..#tmpB2') IS NOT NULL
	DROP TABLE #tmpB2	

	IF OBJECT_ID('tempdb..#tmpWorkOrderExWarranty') IS NOT NULL
	DROP TABLE #tmpWorkOrderExWarranty

	IF OBJECT_ID('tempdb..#tmpCalcWOPoint') IS NOT NULL
	DROP TABLE #tmpCalcWOPoint	

	IF OBJECT_ID('tempdb..#tmpB2WorkOrder') IS NOT NULL
	DROP TABLE #tmpB2WorkOrder

	IF OBJECT_ID('tempdb..#tmpWorkOrderExWarranty1') IS NOT NULL
	DROP TABLE #tmpWorkOrderExWarranty1

	---------------------------------------------

	--===========================================
	-- Days For Selected Month from FMS working Calendar
	--===========================================

	SELECT DISTINCT [Day], IsWorking, [Month], det.[Year]
	INTO #tmpDays
	FROM MstWorkingCalenderDet  det
	INNER JOIN MstWorkingCalender mst ON mst.CalenderId = det.CalenderId
	WHERE mst.[Year] = @pYear AND det.[Month] = @pMonth 
	AND mst.FacilityId = @pFacilityId 



	INSERT INTO #tmpDays
	SELECT DISTINCT [Day], IsWorking, [Month], det.[Year] 
	FROM MstWorkingCalenderDet  det
	INNER JOIN MstWorkingCalender mst ON mst.CalenderId = det.CalenderId
	WHERE mst.[Year] = YEAR(DATEADD(month, -1, @StartDate)) AND det.[Month] = MONTH(DATEADD(month, -1, @StartDate))
	AND  mst.FacilityId = @pFacilityId



	INSERT INTO #tmpDays
	SELECT DISTINCT [Day], IsWorking, [Month], det.[Year] 	
	FROM MstWorkingCalenderDet  det
	INNER JOIN MstWorkingCalender mst ON mst.CalenderId = det.CalenderId
	WHERE mst.[Year] = YEAR(DATEADD(month, -2, @StartDate)) AND det.[Month] = MONTH(DATEADD(month, -2, @StartDate))
	AND mst.FacilityId = @pFacilityId 

	


	
	--SELECT YEAR(DATEADD(month, -1, '2017-01-01'))

	 --select * from #tmpDays
	--select * from #tmpDaysPrev
	---------------------------------------------

	--===========================================
	-- Exemption The asset is under warranty.
	--===========================================

	SELECT wo.*,ar.WarrantyEndDate
	INTO #tmpWorkOrderExWarranty
	FROM #tmpWorkOrder wo
	INNER JOIN #tmpAssetRegister ar ON wo.AssetId = ar.AssetId
	WHERE CAST(@LastDate AS DATE) > CAST(ar.WarrantyEndDate AS DATE)
	AND   CAST( wo.MaintenanceWorkDateTime  as date) > CAST(ar.WarrantyEndDate AS DATE) 
	--AND wo.AssetId NOT IN (SELECT AssetId FROM #tmpAdvisory)
		
		--select * from #tmpAssetRegister
	-- select * from #tmpWorkOrderExWarranty
	---------------------------------------------
	--===========================================
	--Get all Open Workorder greater than 7 working days.
	--===========================================
	-- Get all workorders with exemptions 
	SELECT wo.*
	INTO #tmpB2WorkOrder
	FROM #tmpWorkOrderExWarranty wo  (NOLOCK)
	--LEFT JOIN EngMwoRepairStatusTxnDet prs (NOLOCK) ON prs.WorkOrderId = wo.WorkOrderId	
			--	AND prs.IsDeleted = 0 
				--Exemption: Delay due to parts delivery
			--	AND prs.PartsDelayed <> 145 
	LEFT JOIN EngMwoCompletionInfoTxn wc (NOLOCK) ON wc.WorkOrderId = wo.WorkOrderId 
				--AND wc.IsDeleted = 0 
	WHERE wo.MaintenanceWorkCategory IN (188,189) -- Unscheduled 

	 --select * from #tmpB2WorkOrder
	---------------------------------------------
	--===========================================
	-- Current Month work orders
	--===========================================

	--SELECT @LastDate

	SELECT DATEDIFF(DAY,wo.MaintenanceWorkDateTime,CASE WHEN ISNULL(wc.EndDateTime,@LastDate)>@LastDate THEN @LastDate+1 ELSE ISNULL(wc.EndDateTime,@LastDate)+1 END) as DiffDays		
		, wo.WorkOrderId
		, wo.AssetId
		, wo.MaintenanceWorkDateTime AS StartDateTime
		, CASE WHEN ISNULL(wc.EndDateTime,@LastDate)>@LastDate THEN @LastDate ELSE ISNULL(wc.EndDateTime,@LastDate) END  AS EndDateTime
		, wo.MaintenanceWorkDateTime AS ActualStartDate
	INTO #tmpDiffDays
	FROM #tmpB2WorkOrder wo  (NOLOCK)
	LEFT JOIN EngMwoCompletionInfoTxn wc (NOLOCK) ON wc.WorkOrderId = wo.WorkOrderId 

	WHERE DATEPART(MONTH,wo.MaintenanceWorkDateTime) = @pMonth
	AND DATEPART(YEAR,wo.MaintenanceWorkDateTime)= @pYear
	AND DATEDIFF(DAY,wo.MaintenanceWorkDateTime,CASE WHEN ISNULL(wc.EndDateTime,@LastDate)>@LastDate THEN @LastDate+1 ELSE ISNULL(wc.EndDateTime,@LastDate)+1 END) > @WOCompletiondays
	group by  wo.WorkOrderId,wo.MaintenanceWorkDateTime,wc.EndDateTime,wo.MaintenanceWorkDateTime, wo.AssetId
	 --select * from #tmpDiffDays
	---------------------------------------------
	--=============================================================================================
	-- Month Validation --If repair time is more than 1 (Calender) month (> 1 month) 
	-- Workorder started previous month and ended with selected month or still open.
	--=============================================================================================
	--Previous month workorders
	INSERT INTO #tmpDiffDays
	SELECT 
		DATEDIFF(DAY,wo.MaintenanceWorkDateTime,ISNULL(wc.EndDateTime,@LastDate)+1) as DiffDays
		, wo.WorkOrderId
		,wo.AssetId
		-- Have to calculate from 1st of Current Month		
		, @StartDate AS StartDateTime		
		, ISNULL(wc.EndDateTime,@LastDate)
		, wo.MaintenanceWorkDateTime AS ActualStartDate
	FROM #tmpB2WorkOrder wo
	LEFT JOIN EngMwoCompletionInfoTxn wc ON wo.WorkOrderId = wc.WorkOrderId 
	WHERE 
	(wc.EndDateTime IS NULL OR  (CAST(wc.EndDateTime AS DATE)>=CAST(@StartDate AS DATE)))-- and CAST(wc.EndDateTime AS DATE)<=CAST(@LastDate AS DATE)) )
	AND 
	CAST(wo.MaintenanceWorkDateTime AS DATE) < @StartDate
	AND DATEDIFF(DAY,wo.MaintenanceWorkDateTime,ISNULL(wc.EndDateTime,@LastDate)+1) > @WOCompletiondays
	group by  wo.WorkOrderId,wo.MaintenanceWorkDateTime,wc.EndDateTime,wo.MaintenanceWorkDateTime, wo.AssetId
	-- select * from #tmpDiffDays

	-- select * from #tmpDays order by month,day
	---------------------------------------------
	--select * from #tmpCalc
	--INSERT INTO #tmpCalc
	SELECT * 
	,CAST(CAST( t.[Year]  AS VARCHAR(4)) +
      RIGHT('0' + CAST( t.[Month] AS VARCHAR(2)), 2) +
      RIGHT('0' + CAST( t.[Day] AS VARCHAR(2)), 2) AS DATETIME) as CurrDate
	INTO #tmpCalcAll	
	FROM #tmpDiffDays d
	CROSS JOIN #tmpDays t 
	--WHERE
	--CONVERT(DATE,CAST(t.[Year] AS VARCHAR(4))+'-'+
 --                   CAST(t.[Month] AS VARCHAR(2))+'-'+
 --                   CAST(t.[Day] AS VARCHAR(2)))
	-- --t.[Day] 
	--BETWEEN d.ActualStartDate-1 AND d.EndDateTime
	--AND Day(d.ActualStartDate)<=t.[day]
	--AND t.[Day]=Day()
	ORDER BY d.WorkOrderId,[Year],[Month], [Day]

	select  DiffDays,WorkOrderId,AssetId, StartDateTime,EndDateTime,ActualStartDate,Day,IsWorking,Month,Year,CurrDate
	into #tmpCalc	
	-- from #tmpCalcAll where  (CurrDate>=ActualStartDate) and (CurrDate<=EndDateTime)
	from #tmpCalcAll where  (CurrDate>=cast(ActualStartDate as date)) and (CurrDate<=cast(EndDateTime as date))


	 --select * from #tmpCalc order by workorderid,year,month, day
	---------------------------------------------
	
	--===========================================
	-- Provided Loaner & Alternate service
	--===========================================
	IF OBJECT_ID('tempdb..#tmpLP') IS NOT NULL
	DROP TABLE #tmpLP	
	IF OBJECT_ID('tempdb..#tmpALT') IS NOT NULL
	DROP TABLE #tmpALT	
	IF OBJECT_ID('tempdb..#tmpLPDays') IS NOT NULL
	DROP TABLE #tmpLPDays	
	IF OBJECT_ID('tempdb..#tmpALTDays') IS NOT NULL
	DROP TABLE #tmpALTDays	
	IF OBJECT_ID('tempdb..#tmpMaxDays') IS NOT NULL
	DROP TABLE #tmpMaxDays
	
	

	SELECT DISTINCT t.WorkOrderId, lp.ProvisionDateTime StartDate, lp.EndDateTime EndDate 	
	INTO #tmpLP
	FROM #tmpCalc t 
	INNER JOIN EngMwoCompletionInfoTxn wc ON t.WorkOrderId = wc.WorkOrderId   
	INNER JOIN EngMwoProcessStatusTxnDet wp ON wc.CompletionInfoId = wp.CompletionInfoId 
	and wp.AssetProvided = 99 AND wp.ProvideLoaner = 1
	LEFT JOIN EngMwoProcessStatusLpTxnDet lp ON wp.ProcessStatusId = lp.ProcessStatusId


	SELECT DISTINCT t.WorkOrderId, alt.StartDateTime StartDate, alt.EndDateTime EndDate
	INTO #tmpALT
	FROM #tmpCalc t 
	INNER JOIN EngMwoCompletionInfoTxn wc ON t.WorkOrderId = wc.WorkOrderId  
	INNER JOIN EngMwoProcessStatusTxnDet wp ON wc.CompletionInfoId = wp.CompletionInfoId 
	AND wp.AssetProvided = 99 AND wp.AlternativeServiceProvided = 1
	LEFT JOIN EngMwoProcessStatusAspTxnDet alt ON wp.ProcessStatusId = alt.ProcessStatusId 
	  
	
	SELECT * 
	INTO #tmpLPDays
	FROM #tmpLP d
	CROSS JOIN #tmpDays t 	
	WHERE DATEFROMPARTS(t.year,t.month,t.[Day]) BETWEEN cast(d.StartDate as date) 
	AND cast(isnull(d.EndDate,@LastDate) as date)  
	ORDER BY d.WorkOrderId, t.[Day]


	SELECT * 
	INTO #tmpALTDays
	FROM #tmpALT d
	CROSS JOIN #tmpDays t 
	WHERE DATEFROMPARTS(t.year,t.month,t.[Day]) BETWEEN cast(d.StartDate as date) 
	AND cast(isnull(d.EndDate,@LastDate) as date)  
	ORDER BY d.WorkOrderId, t.[Day]


	Delete tc 
	--SELECT tc.*
	FROM #tmpCalc tc
	INNER JOIN #tmpLPDays tl ON tc.WorkOrderId = tl.WorkOrderId AND tc.[Day] = tl.[Day] and tc.Month = tl.month and tc.Year = tl.year


	Delete tc 
	--SELECT tc.*
	FROM #tmpCalc tc
	INNER JOIN #tmpALTDays ta ON tc.WorkOrderId = ta.WorkOrderId AND tc.[Day] = ta.[Day] and tc.Month = ta.month and tc.Year = ta.year


	--===========================================
	-- Get demerit point from the working date differences
	--===========================================

	IF OBJECT_ID('tempdb..#tt1') IS NOT NULL
	DROP TABLE #tt1
	IF OBJECT_ID('tempdb..#tmpMaxCurr') IS NOT NULL
	DROP TABLE #tmpMaxCurr
	IF OBJECT_ID('tempdb..#tmpDistWO') IS NOT NULL
	DROP TABLE #tmpDistWO
	

	select distinct WorkOrderId, 'N' Flag
	INTO #tmpDistWO
	FROM #tmpCalc

	 --select * from #tmpDistWO

	DECLARE @RECCOUNT INT, @INDEX INT = 0, @WO_Id INT
	SELECT	@RECCOUNT = COUNT(*) FROM #tmpDistWO
	CREATE TABLE #tt1(WorkOrderId int,CurrDate Datetime)

	WHILE	(@INDEX <= @RECCOUNT)
	BEGIN

	SELECT	@WO_Id	= WorkOrderId FROM #tmpDistWO
	WHERE	FLAG = 'N'

	INSERT INTO #tt1
		SELECT TOP (@WOCompletiondays) t1.WorkOrderId, t1.[CurrDate] 
		FROM #tmpCalc t1--,#tmpCalc t2
					WHERE t1.WorkOrderId =@WO_Id
					and t1.IsWorking=1 
					ORDER BY WorkOrderId,[Year],[Month],[DAY]

	UPDATE	#tmpDistWO
	SET		FLAG = 'Y'
	WHERE	WorkOrderId	= @WO_Id

	SET		@INDEX	= @INDEX + 1

	END
	--select * from #tt1
		--select * from #tt1 
	IF OBJECT_ID('tempdb..#tt2') IS NOT NULL
	DROP TABLE #tt2

	select distinct workorderid,CurrDate into #tt2 from #tt1

		--select * from #tt1 
	IF OBJECT_ID('tempdb..#tt1_final') IS NOT NULL
	DROP TABLE #tt1_final
	
	select  distinct workorderid,CurrDate into #tt1_final from #tt2 where workorderid in (select workorderid from #tt2 group by  workorderid having count(1)>=@WOCompletiondays)

	select workorderid,max(CurrDate) MaxCurrDate
	INTO #tmpMaxCurr
	FROM #tt1_final
	group by WorkOrderId

	--select * from #tt1

	select t.*
	INTO #tmpCalcWOPoint
	FROM #tmpCalc t
	Left JOIN #tmpMaxCurr t1 on t.WorkOrderId = t1.WorkOrderId
	WHERE t.CurrDate > t1.MaxCurrDate

	 --select * from #tmpCalcWOPoint where workorderid=47161
	 --select * from #tmpWOPoint 

	 IF OBJECT_ID('tempdb..#tmpB2WorkOrderPartDelay') IS NOT NULL
	DROP TABLE #tmpB2WorkOrderPartDelay

	IF OBJECT_ID('tempdb..#tmpB2WorkOrderPartDelayFinal') IS NOT NULL
	DROP TABLE #tmpB2WorkOrderPartDelayFinal


	--Note In the below scenario I am using EngMwoCompletionInfoTxn instead of EngMwoRepairStatusTxnDet
	
	-- The Old Scenario Commented the below line

	-- SELECT DISTINCT t.WorkOrderId, min(wc.PODate) StartDate, isnull(com.EndDateTime,@LastDate) EndDate 	
	--INTO #tmpB2WorkOrderPartDelay
	--FROM #tmpCalc t 
	--INNER JOIN EngMwoRepairStatusTxnDet wc ON t.WorkOrderId = wc.WorkOrderId AND wc.IsDeleted=0
	--left join EngMwoCompletionInfoTxn com on t.WorkOrderId=com.WorkOrderId and com.IsDeleted=0  
	--where wc.IsDeleted=0  and wc.PODate is not null --and wc.PartsDelayed = 145 
	--group by t.WorkOrderId,com.EndDateTime




	
	--select @LastDate
--	;WITH CTE_month AS (
--  --select * from #tmpB2WorkOrderPartDelay a cross apply (
--   SELECT @StartDate as MonthofDate--, @From_Year1 as from_year
--   UNION ALL
   
--   SELECT dateadd(day,1,MonthofDate ) as  MonthofDate 
--   FROM   CTE_month a
--   WHERE MonthofDate  <= @LastDate
--)

----select WorkOrderId,MonthofDate into #tmpB2WorkOrderPartDelayFinal from  CTE_month cross apply #tmpB2WorkOrderPartDelay 
----where MonthofDate between StartDate and EndDate
--order by WorkOrderId,MonthofDate

--select * from #tmpB2WorkOrderPartDelayFinal  
	--select * from #tmpCalcWOPoint

	--delete a from  #tmpCalcWOPoint a join #tmpB2WorkOrderPartDelayFinal  fl on a.WorkOrderId=fl.WorkOrderId and cast(a.CurrDate as date)=cast(fl.MonthofDate as date)


	/* overlapping  start*/

	IF OBJECT_ID('tempdb..#tmp_ForOverlapping') IS NOT NULL
	DROP TABLE #tmp_ForOverlapping
		
	IF OBJECT_ID('tempdb..#overlapwithin_notrequired') IS NOT NULL
	DROP TABLE #overlapwithin_notrequired
	IF OBJECT_ID('tempdb..#completedays') IS NOT NULL
	DROP TABLE #completedays
	--DROP TABLE #tmpDowntime	
	IF OBJECT_ID('tempdb..#tmpCalcWOPoint1') IS NOT NULL
	DROP TABLE #tmpCalcWOPoint1
			

		select workorderid,AssetId,min(currdate) as stdate,max(currdate) enddate into #tmp_ForOverlapping 
		from #tmpCalcWOPoint 
		group by workorderid,AssetId
		
		

		---For remove overlapwith in another workorder
		select distinct a.AssetId ,a.WorkOrderId,a.stdate,a.enddate into #overlapwithin_notrequired 
		from #tmp_ForOverlapping a 
		left join #tmp_ForOverlapping b 	on a.AssetId = b.AssetId 
		and a.WorkOrderId<>b.WorkOrderId and ( a.stdate between b.stdate and b.enddate  and a.enddate between b.stdate and b.enddate )
		where b.WorkOrderId is not null
		--select * from #tmp_ForOverlapping
		--select * from #overlapwithin_notrequired

		-- days after overlapping
		;with CTE_completedays
		as
		(
		SELECT AssetId,WorkOrderId,stdate,enddate,LAG(enddate) OVER (partition by AssetId ORDER BY AssetId,stdate) stdate1 
		FROM #tmp_ForOverlapping 
		WHERE WorkOrderId not in (select WorkOrderId from #overlapwithin_notrequired)
		)
		select AssetId,WorkOrderId,case when stdate <= stdate1 then dateadd(MINUTE,1,stdate1) else stdate end as stdate,  enddate
		into #completedays
		from CTE_completedays		
		
		--select * from #completedays
		
		select cp.* into #tmpCalcWOPoint1 from #tmpCalcWOPoint cp join  #completedays d on cp.WorkOrderId =  d.WorkOrderId
		and cp.currdate  between stdate and enddate

	/* overlapping  end*/

	CREATE TABLE #tmpWOPoint(workorderid int, DemeritPoint int)

	Insert INTO #tmpWOPoint
	SELECT workorderid,DATEDIFF(Day, @StartDate,CASE WHEN CAST(@LastDate AS DATE) = Max(t.CurrDate) THEN @lastdate ELSE Max(t.currdate) END)+1 AS DemeritPoint
	FROM #tmpCalcWOPoint1 t
	--WHERE 
	Group by WorkOrderId
	having DATEDIFF(Day, Min(t.CurrDate),Max(t.currDate)) >= 8 AND Min(Month)<@pMonth
	union
	SELECT workorderid,COUNT(*) AS DemeritPoint
	FROM #tmpCalcWOPoint1 t
	where t.Month = @pMonth and t.Year=@pYear
	Group by WorkOrderId
	--having Min(Month) = @pMonth

	 --select * from #tmpWOPoint
	--===========================================
	-- Get Deduction value 
	--===========================================
	SELECT 

	c.workorderid
	, c.MaintenanceWorkNo
	, t.AssetId
	, EAS.AssetNo
	, EAS.AssetDescription
	, t.PurchaseCostRM
	, c.[WorkOrderPriority]
	, lov.FieldValue
	, ul.UserLocationCode
	,  c.MaintenanceDetails
	, t.[MaintenanceWorkDateTime] AS SRDate
	, wc.EndDateTime AS CompletionDate
	, '' AS CountofReq
	, DATEDIFF(MINUTE, c.maintenanceworkdatetime, ISNULL(wa.ResponseDateTime,@LastDate)) as Mins
	, s.DeductionValue as DeductionValue
	, w.DemeritPoint as TotalRepairTime
	, w.DemeritPoint as B2DemeritPoint
	, (s.DeductionValue*w.DemeritPoint) B2Deduction,'Y' B2ValidateStatus
	, MONTH(t.[MaintenanceWorkDateTime]) as StartedMonth
	, MONTH(wc.EndDateTime) as CompletedMonth	
	, w.DemeritPoint
	, (s.DeductionValue*w.DemeritPoint) AS TotalDeduction

	INTO #tmpb2
	FROM EngMaintenanceWorkOrderTxn c
	INNER JOIN #tmpWOPoint w ON w.WorkOrderId = c.WorkOrderId
	INNER JOIN #tmpWorkOrderExWarranty t ON c.WorkOrderId = t.WorkOrderId
	LEFT JOIN MstLocationUserLocation ul ON t.UserLocationId = ul.UserLocationId
	LEFT JOIN EngMwoAssesmentTxn wa ON c.WorkOrderId = wa.WorkOrderId 
	LEFT JOIN EngMwoCompletionInfoTxn wc ON c.WorkOrderId = wc.WorkOrderId
	LEFT JOIN FMLovMst lov ON c.[WorkOrderPriority] = lov.LovId
	left join EngAsset EAS on t.AssetId = EAS.AssetId
	CROSS JOIN #tmpAssetSlab s
	WHERE t.PurchaseCostRM BETWEEN s.CostStart AND ISNULL(s.CostEnd,t.PurchaseCostRM)
	group by 
	c.workorderid, t.AssetId, t.PurchaseCostRM, w.DemeritPoint
	, c.MaintenanceWorkNo
	, EAS.AssetNo
	, EAS.AssetDescription
	, t.PurchaseCostRM
	, c.[WorkOrderPriority]
	, lov.FieldValue
	, ul.UserLocationCode
	, c.MaintenanceDetails
	, t.[MaintenanceWorkDateTime] 
	, wc.EndDateTime 
	, c.maintenanceworkdatetime
	, wa.ResponseDateTime 
	, t.[MaintenanceWorkDateTime]
	, wc.EndDateTime
	, s.DeductionValue having w.DemeritPoint>0
	 --select * from #tmpB2

	INSERT INTO #TotalParameterDeduction
	select 'B.2' as IndicatorName,ar.assetno,ar.purchasecostrm,count(*), DemeritPoint 
	from #tmpb2 t
	inner join EngMaintenanceWorkOrderTxn wo on t.workorderid=wo.workorderid
	inner join engasset ar on t.AssetId= ar.AssetId
	group by ar.assetno,ar.purchasecostrm, DemeritPoint,t.WorkOrderId

	INSERT INTO #TotalParameterDemerit 
	select distinct 'B.2' as IndicatorName,ar.assetno,ar.assetdescription,'Service work' TypeofTransaction,DemeritPoint TotalRecords ,wo.maintenanceworkno	
	from #tmpb2 t
	inner join EngMaintenanceWorkOrderTxn wo on t.workorderid=wo.workorderid
	inner join engasset ar on t.AssetId= ar.AssetId
	---------------------------------------------
	
	

	

	--===========================================
	-- Add to Result Table
	--===========================================
	


	INSERT INTO #tmpResults
	SELECT ti.IndicatorDetId,
		   ti.IndicatorNo
		, ti.IndicatorName, NULL AS SubParameter
		, SUM(ISNULL(t.Demeritpoint,0)) AS TransDemeritPoints
		, SUM(t.Demeritpoint) AS TotalDemeritPoints
		, NULL AS TotalParameters		
		, SUM(t.TotalDeduction) AS DeductionValue
		, (SUM(t.TotalDeduction)/100) AS DeductionPer	
	FROM #tmpB2 t
	CROSS JOIN #tmpIndicator ti 	
	WHERE  ti.IndicatorNo = 'B.2'	
	GROUP BY ti.IndicatorDetId, ti.IndicatorNo, ti.IndicatorName

------------------------------------------------------------------------------------------------------------
--=============================================================================================
--								BEMS Indicator - B3											 --
--=============================================================================================

	--===========================================
	--Temp Tables
	--===========================================

	IF OBJECT_ID('tempdb..#tmpB3') IS NOT NULL
	DROP TABLE #tmpB3

	IF OBJECT_ID('tempdb..#tmpWOPPMSchedule') IS NOT NULL
	DROP TABLE #tmpWOPPMSchedule
	
	IF OBJECT_ID('tempdb..#tmpRIB3') IS NOT NULL
	DROP TABLE #tmpRIB3	
	IF OBJECT_ID('tempdb..#tmpWorkOrderExWarrantyB3') IS NOT NULL
	DROP TABLE #tmpWorkOrderExWarrantyB3	
	IF OBJECT_ID('tempdb..#tmpWorkOrderExWarrantyB3RI') IS NOT NULL
	DROP TABLE #tmpWorkOrderExWarrantyB3RI
	
			
	---------------------------------------------
	
	SELECT wo.*,ar.WarrantyEndDate
	INTO #tmpWorkOrderExWarrantyB3	 
	FROM EngMaintenanceWorkOrderTxn wo
	INNER JOIN EngAsset ar (NOLOCK) ON ar.AssetId = wo.AssetId 
												--AND ar.IsDeleted = 0 
 --   LEFT JOIN BerApplicationTxn ba ON ar.AssetRegisterId = ba.AssetRegisterId AND ba.IsDeleted = 0
	--LEFT JOIN BerApplicationHistoryTxn bh ON ba.ApplicationId = bh.ApplicationId AND bh.IsDeleted = 0 AND bh.[Status] NOT IN (2638)
	LEFT JOIN engmwocompletioninfotxn wc ON wo.workorderid=wc.workorderid --and  wc.IsDeleted = 0
	WHERE 
	ar.[Authorization] = 199 -- Authorized
	AND ar.AssetStatusLovId = 1 -- Active
	AND ar.CommissioningDate <= @LastDate
	AND ar.ServiceId = @pServiceId
	AND ar.FacilityId  =@pFacilityId

	--AND ar.IsDeleted = 0
	--AND wo.IsDeleted = 0
	and wo.ServiceId = @pServiceId 
	AND wo.FacilityId=@pFacilityId 

	AND wo.TargetDateTime <= @LastDate
	AND wo.WorkOrderStatus not in  (193,196)
	AND (wc.EndDatetime IS NULL OR (MONTH(wc.EndDatetime)>=@pMonth AND YEAR(wc.EndDatetime)>=@pYear))
	--AND (wc.EndDatetime IS NULL OR (MONTH(wc.EndDatetime)=@MONTH AND YEAR(wc.EndDatetime)=@YEAR))	
	AND wo.AssetId NOT IN (SELECT AssetId FROM #tmpSnfAssets)
	AND ar.AssetId NOT IN (SELECT AssetId FROM #tmpBerAssets)	
	and CAST(@LastDate AS DATE) > CAST(ar.WarrantyEndDate AS DATE)

	SELECT wo.*
	INTO #tmpWorkOrderExWarrantyB3RI	 
	FROM EngMaintenanceWorkOrderTxn wo	  
	LEFT JOIN engmwocompletioninfotxn wc ON wo.workorderid=wc.workorderid --AND wc.IsDeleted = 0
	WHERE 	
	 wo.ServiceId = @pServiceId 
	AND wo.FacilityId = @pFacilityId 

	AND wo.TargetDateTime <= @LastDate
	AND wo.WorkOrderStatus not in  (193,196)
	--AND wo.IsDeleted = 0
	--AND (wc.EndDatetime IS NULL OR (MONTH(wc.EndDatetime)=@MONTH AND YEAR(wc.EndDatetime)=@YEAR))	
	
	--===========================================
	-- Get all PPM and SCM scheduled work orders 
	--===========================================
	-- Workorder created on current month
	SELECT wo.AssetId, wo.WorkOrderId, wo.MaintenanceWorkDateTime, a.FieldValue
	, wc.PPMAgreedDate, wo.TargetDateTime
	, wc.StartDateTime AS StartDateTime, wc.EndDateTime AS EndDateTime	
	INTO #tmpWOPPMSchedule
	-- select * 
	FROM #tmpWorkOrderExWarrantyB3 wo	--where AssetRegisterId = 236243
	INNER JOIN FMLovMst a (NOLOCK)  ON wo.[TypeOfWorkOrder] = a.LovId 
											--AND a.IsDeleted = 0
	LEFT JOIN EngMwoCompletionInfoTxn wc (NOLOCK) ON wo.WorkOrderId = wc.WorkOrderId 
											--AND wc.IsDeleted = 0
	--LEFT JOIN EngMwoCompletionInfoTxnDet wcd (NOLOCK) ON wc.CompletionInfoId = wcd.CompletionInfoId 
	--										AND wcd.IsDeleted = 0 
	WHERE  	
	MONTH(wo.TargetDateTime) = @pMonth
	AND YEAR(wo.TargetDateTime) = @pYear
	AND wo.MaintenanceWorkCategory = 187 -- Scheduled 	
	AND wo.TypeOfWorkOrder in (34)
	GROUP BY wo.AssetId, wo.WorkOrderId, wo.MaintenanceWorkDateTime, a.FieldValue
	, wc.PPMAgreedDate, wo.TargetDateTime, wc.StartDateTime, wc.EndDateTime
	

	 
	---------------------------------------------
	--===========================================
	-- Scheduled Workorder created by previous months
	--===========================================
	INSERT INTO #tmpWOPPMSchedule
	SELECT wo.AssetId, wo.WorkOrderId, wo.MaintenanceWorkDateTime, a.FieldValue
	, wc.PPMAgreedDate, wo.TargetDateTime
	, wc.StartDateTime AS StartDateTime, wc.EndDateTime AS EndDateTime		
	FROM #tmpWorkOrderExWarrantyB3  wo (NOLOCK)
	left JOIN EngMwoCompletionInfoTxn wc (NOLOCK) ON wo.WorkOrderId = wc.WorkOrderId 
															--AND wc.IsDeleted = 0
	--LEFT JOIN EngMwoCompletionInfoTxnDet wcd (NOLOCK) ON wc.CompletionInfoId = wcd.CompletionInfoId 
	--														AND wcd.IsDeleted = 0 
	INNER JOIN FMLovMst a (NOLOCK)  ON wo.[TypeOfWorkOrder] = a.LovId --AND a.IsDeleted = 0	
	WHERE  
	CAST(wo.TargetDateTime AS DATE) < CAST(@StartDate AS DATE)		
	--AND a.FieldValue IN ('PPM','SCM') 
	AND wo.TypeOfWorkOrder in (34)
	AND (wc.EndDatetime IS NULL OR (MONTH(wc.EndDatetime)>=@pMonth AND YEAR(wc.EndDatetime)>=@pYear))
	--AND (wc.EndDateTime IS NULL OR (MONTH(wc.EndDateTime) = @MONTH AND YEAR(wc.EndDateTime) = @YEAR)
	--	)
	GROUP BY wo.AssetId, wo.WorkOrderId, wo.MaintenanceWorkDateTime, a.FieldValue
	, wc.PPMAgreedDate, wo.TargetDateTime, wc.StartDateTime, wc.EndDateTime
	-- select * from #tmpWOPPMSchedule p
	--INNER JOIN #tmpAssetRegister ar ON ar.AssetRegisterId = p.AssetRegisterId	
	--where workorderid=221136

--	select * from #tmpAssetRegister where AssetRegisterId =232826
	---------------------------------------------


		--Delete the PPM & SCM which is not applicable for demerit.
		DELETE
		--select *
		from #tmpWOPPMSchedule
		where FieldValue = 'ppm'
			and (((PPMAgreedDate is null or StartDateTime is null) and cast(TargetDateTime as date)>@LastDate) or (cast(PPMAgreedDate as date)=cast(StartDateTime as date)))
		
		DELETE
		--select *
		from #tmpWOPPMSchedule
		where FieldValue = 'scm'
			and (((PPMAgreedDate is null or StartDateTime is null) and cast(TargetDateTime as date)>@LastDate) or (cast(PPMAgreedDate as date)=cast(StartDateTime as date)))

			
	--===========================================
	-- Get Demerit and Deduction
	--===========================================
	SELECT wo.WorkOrderId, wo.AssetId, ar.PurchaseCostRM
		, COUNT(*) AS DemeritPoint
		, NULL AS NCRDemeritPoints
		, (CASE WHEN ar.PurchaseCostRM>49999 THEN 
			CASE WHEN (ar.PurchaseCostRM/5000)%1 >0 
			THEN (CAST((ar.PurchaseCostRM/5000) AS INT)+1)*10
			ELSE (CAST((ar.PurchaseCostRM/5000) AS INT))*10 END 
			ELSE ta.DeductionValue END) AS TotalDeduction				
	INTO #tmpB3
	FROM #tmpWOPPMSchedule wo  	
	INNER JOIN #tmpAssetRegister ar ON ar.AssetId = wo.AssetId		
	CROSS JOIN #tmpAssetSlab ta 
	WHERE  ar.PurchaseCostRM BETWEEN ta.CostStart AND ISNULL(ta.CostEnd,ar.PurchaseCostRM)	
	AND ar.RiPlannerId<>145 --For Routine Inspection (RI) Flag in asset register.	
	Group by wo.WorkOrderId, wo.AssetId
	, ar.PurchaseCostRM, ta.DeductionValue, wo.MaintenanceWorkDateTime;


	---------------------------------------------

	--===========================================
	-- RI scheduled work order
	--===========================================
	INSERT INTO #tmpB3

	select WorkOrderId,  AssetRegisterId, sum(PurchaseCostRM) as PurchaseCostRM ,DemeritPoint, NCRDemeritPoints, sum(TotalDeduction) as TotalDeduction from
	(SELECT 
	wo.WorkOrderId, 0 AssetRegisterId, 0 PurchaseCostRM 
	, 1 AS DemeritPoint
	, NULL AS NCRDemeritPoints
			,(CASE WHEN SUM(ar.PurchaseCostRM)>49999 THEN 
			CASE WHEN (SUM(ar.PurchaseCostRM)/5000)%1 >0 
			THEN (CAST((SUM(ar.PurchaseCostRM)/5000) AS INT)+1)*10
			ELSE (CAST((SUM(ar.PurchaseCostRM)/5000) AS INT))*10 END 
			ELSE (ta.DeductionValue) END) AS TotalDeduction	
	-- select *							
	FROM #tmpWorkOrderExWarrantyB3RI  wo 
	LEFT JOIN EngMwoCompletionInfoTxn wc (NOLOCK) ON wo.WorkOrderId = wc.WorkOrderId 
				--AND wc.IsDeleted = 0
	INNER JOIN FMLovMst a (NOLOCk)  ON wo.[TypeOfWorkOrder] = a.LovId 
				--AND a.IsDeleted = 0
	LEFT JOIN EngAsset ar ON  ar.UserAreaId = wo.UserAreaId  --pd.EngUserLocationId 
				AND ar.RiPlannerId =1 --and ar.IsDeleted=0
	CROSS JOIN #tmpAssetSlab ta 
	WHERE  	
	 ar.PurchaseCostRM BETWEEN ta.CostStart AND ISNULL(ta.CostEnd,ar.PurchaseCostRM)	
	AND ar.WarrantyEndDate < @LastDate 
	AND MONTH(wo.TargetDateTime) = @pMonth
	AND YEAR(wo.TargetDateTime) = @pYear
	AND a.FieldValue IN ('RI') 
	and (((PPMAgreedDate is null or StartDateTime is null) and cast(TargetDateTime as date)<@LastDate) or (cast(PPMAgreedDate as date)!=cast(StartDateTime as date)))
	--AND (wc.EndDateTime IS NULL OR (YEAR(wc.EndDateTime)= @YEAR AND MONTH(wc.EndDateTime) = @MONTH))	
	GROUP BY ar.UserAreaId, ta.DeductionValue,	wo.WorkOrderId)a
	group  by WorkOrderId,  AssetRegisterId, DemeritPoint, NCRDemeritPoints

	
	INSERT INTO #tmpB3
	select WorkOrderId,  AssetRegisterId, sum(PurchaseCostRM) as PurchaseCostRM ,DemeritPoint, NCRDemeritPoints, sum(TotalDeduction) as TotalDeduction from
	(SELECT 	
	wo.WorkOrderId, 0 AssetRegisterId,  0 PurchaseCostRM 
	, 1 AS DemeritPoint
	, NULL AS NCRDemeritPoints
			,(CASE WHEN SUM(ar.PurchaseCostRM)>49999 THEN 
			CASE WHEN (SUM(ar.PurchaseCostRM)/5000)%1 >0 
			THEN (CAST((SUM(ar.PurchaseCostRM)/5000) AS INT)+1)*10
			ELSE (CAST((SUM(ar.PurchaseCostRM)/5000) AS INT))*10 END 
			ELSE (ta.DeductionValue) END) AS TotalDeduction	
	--select *--sum(ar.PurchaseCostRM) 	
	FROM #tmpWorkOrderExWarrantyB3RI  wo (NOLOCK)
	LEFT JOIN EngMwoCompletionInfoTxn wc (NOLOCK) ON wo.WorkOrderId = wc.WorkOrderId 
				--AND wc.IsDeleted = 0
	INNER JOIN FMLovMst a (NOLOCk)  ON wo.[TypeOfWorkOrder] = a.LovId 
				--AND a.IsDeleted = 0
	INNER JOIN EngAsset ar ON  ar.UserAreaId = wo.UserAreaId AND ar.RiPlannerId =1 --and ar.IsDeleted=0
	CROSS JOIN #tmpAssetSlab ta 
	WHERE  ar.PurchaseCostRM BETWEEN ta.CostStart AND ISNULL(ta.CostEnd,ar.PurchaseCostRM)	
	AND ar.WarrantyEndDate < @LastDate 
	AND wo.TargetDateTime < @StartDate	
	AND a.FieldValue IN ('RI') 
	and (((PPMAgreedDate is null or StartDateTime is null) and cast(TargetDateTime as date)<@LastDate) or (cast(PPMAgreedDate as date)!=cast(StartDateTime as date)))
	AND (wc.EndDatetime IS NULL OR (MONTH(wc.EndDatetime)>=@pMonth AND YEAR(wc.EndDatetime)>=@pYear))
	--AND (wc.EndDateTime IS NULL OR (YEAR(wc.EndDateTime)= @YEAR AND MONTH(wc.EndDateTime) = @MONTH)	)	
	GROUP BY ar.UserAreaId, ta.DeductionValue,	wo.WorkOrderId ) a
	group  by WorkOrderId,  AssetRegisterId, DemeritPoint, NCRDemeritPoints

	-- select * from #tmpB3
	-- select * from #tmpAssetRegister where assetregisterid=236243
	---------------------------------------------

--	--===========================================
--	-- B3 Indicator Data from NCR 
--	--===========================================
--	Insert Into #tmpB3
--	select --*
--	0 as WorkOrderId, ar.AssetRegisterId, ar.PurchaseCostRM 
--	, NULL as DemeritPoint
--	, count(*) as NCRDemeritPoints
--	, (count(*)* (select DeductionValue from #tmpAssetSlab
--						where ar.PurchaseCostRM BETWEEN CostStart AND ISNULL(CostEnd,ar.PurchaseCostRM))
--			)AS TotalDeduction		
--			--select *
--	from FmsNCREntryTxn n (NOLOCK)
--	INNER JOIN SrServiceRequestMst sr (NOLOCK) on n.ServiceRequestId = sr.ServiceRequestId
--	INNER JOIN EngAssetRegisterMst ar (NOLOCK) on ar.AssetRegisterId = sr.AssetRegisterId
--	--LEFT JOIN BerApplicationTxn ba ON ar.AssetRegisterId = ba.AssetRegisterId AND ba.IsDeleted = 0 and ba.ApplicationId in (
--	--    select bh.ApplicationId from BerApplicationHistoryTxn bh where ba.ApplicationId = bh.ApplicationId AND bh.IsDeleted = 0 AND bh.[Status] NOT IN (2638)	
--	--    )
--	--LEFT JOIN BerApplicationTxn ba ON ar.AssetRegisterId = ba.AssetRegisterId AND ba.IsDeleted = 0
--	--LEFT JOIN BerApplicationHistoryTxn bh ON ba.ApplicationId = bh.ApplicationId AND bh.IsDeleted = 0 AND bh.[Status] NOT IN (2638)
--	INNER JOIN DedIndicatorMstDet d (NOLOCK) on d.IndicatorDetId = n.IndicatorDetId
--	WHERE d.IndicatorNo='B.3'
--	AND n.[Service] = @SERVICEID
--	AND n.HospitalId 

--in (select HospitalId from #GetGMHospitalMstAndGroup)


--	AND MONTH(n.NCRDateTime) =@MONTH
--	AND YEAR(n.NCRDateTime) = @YEAR
--	AND n.IsDeleted = 0 AND sr.IsDeleted = 0  AND sr.[Status] != 2315 -- Cancelled Status
--	AND d.IsDeleted = 0
--	and ar.[Authorization] = 4799 -- Authorized
--	AND ar.AssetStatus = 127 -- Active
--	AND ar.CommissioningDate <= @LastDate
--	--AND ar.WarrantyEndDate <= @LastDate -- Warranty
--	and ar.WarrantyEndDate<=@LastDate
--	AND ar.ServiceId = @SERVICEID
--	AND ar.HospitalId 

--in (select HospitalId from #GetGMHospitalMstAndGroup)


--	AND ar.IsDeleted = 0
--	AND ar.AssetRegisterId NOT IN (SELECT AssetRegisterId FROM #tmpBerAssets)
--	GROUP BY ar.AssetRegisterId, ar.PurchaseCostRM

--	-- select * from #tmpB3

	INSERT INTO #TotalParameterDeduction
	select 'B.3' as IndicatorName,ar.assetno,ar.purchasecostrm, count(*),1 
	from #tmpb3 t
	inner join EngMaintenanceWorkOrderTxn wo on t.workorderid=wo.workorderid
	inner join engasset ar on t.assetid= ar.assetid
	group by ar.assetno,ar.purchasecostrm

	INSERT INTO #TotalParameterDemerit 
	select 'B.3' as IndicatorName,ar.assetno,ar.assetdescription,'Work order' TypeofTransaction,1 TotalRecords ,wo.maintenanceworkno	
	from #tmpb3 t
	inner join EngMaintenanceWorkOrderTxn wo on t.workorderid=wo.workorderid
	inner join engasset ar on t.assetid= ar.assetid
	---------------------------------------------
	--===========================================
	--Add to Results
	--===========================================
	
	INSERT INTO #tmpResults
	SELECT ti.IndicatorDetId, ti.IndicatorNo
		, ti.IndicatorName, NULL AS SubParameter
		, SUM(ISNULL(t.Demeritpoint,0)) AS TransDemeritPoints
		, SUM(ISNULL(t.Demeritpoint,0))+SUM(ISNULL(t.NCRDemeritPoints,0)) AS TotalDemeritPoints
		, NULL AS TotalParameters
		, SUM(t.TotalDeduction) AS DeductionValue
		, SUM(t.TotalDeduction)/100 AS DeductionPer
	FROM #tmpB3 t
	CROSS JOIN #tmpIndicator ti
	WHERE ti.IndicatorNo='B.3'
	GROUP BY ti.IndicatorDetId, ti.IndicatorNo, ti.IndicatorName
-------------------------------------------------------------------------------------------------------------------
--=============================================================================================
	--										BEMS Indicator - B4
	--=============================================================================================

	--===========================================
	-- Temp Table 
	--===========================================
	IF OBJECT_ID('tempdb..#tmpUptime') IS NOT NULL
	DROP TABLE #tmpUptime

	IF OBJECT_ID('tempdb..#tmpDowntime') IS NOT NULL
	DROP TABLE #tmpDowntime

	IF OBJECT_ID('tempdb..#tmpTargetCalc') IS NOT NULL
	DROP TABLE #tmpTargetCalc

	IF OBJECT_ID('tempdb..#tmpTargetPercent') IS NOT NULL
	DROP TABLE #tmpTargetPercent

	IF OBJECT_ID('tempdb..#tmpDemerit') IS NOT NULL
	DROP TABLE #tmpDemerit

	IF OBJECT_ID('tempdb..#tmpB4') IS NOT NULL
	DROP TABLE #tmpB4

	IF OBJECT_ID('tempdb..#tmpDedValues') IS NOT NULL
	DROP TABLE #tmpDedValues
	---------------------------------------------

	--===========================================
	-- Uptime Calculation = Number of days from warranty end in a year*24
	--===========================================

	DECLARE @StartOfYear Date, @EndofYear Date
	SELECT @EndofYear = DATEADD(yy, DATEDIFF(yy,0,@LastDate) + 1, -1) 
	SELECT @StartOfYear = DATEADD(yy, DATEDIFF(yy,0,@LastDate), 0) 
	--SELECT @StartOfYear,@EndofYear

	--DECLARE @StMonth INT =1;
	--IF OBJECT_ID('tempdb..#tmMonthDays') IS NOT NULL
	--DROP TABLE #tmMonthDays;

	--CREATE TABLE #tmMonthDays(MonthNo INT,YearNo INT,DaysCount int,SumDaysCount INT)

	--WHILE(@StMonth<=12)
	--BEGIN

	--	DECLARE @Date DATE = CAST(
	--							CAST(@Year AS CHAR(4)) 
	--							+ RIGHT('0' + CAST(@StMonth AS VARCHAR(2)), 2)
	--							+ '01' AS DATE);    
	
	--	INSERT INTO #tmMonthDays
	--	SELECT @StMonth ,@year , DATEDIFF(DAY, 
	--			DATEADD(MONTH, DATEDIFF(MONTH, 0, @Date), 0),
	--			DATEADD(MONTH, DATEDIFF(MONTH, 0, @Date) + 1, 0)) DaysCount, 0			
		
	--	UPDATE t SET t.SumDaysCount= (SELECT SUM(DaysCount) FROM #tmMonthDays)
	--	--SELECT *
	--	FROM #tmMonthDays t
	--	WHERE t.MonthNo=@StMonth		

	--	SET @StMonth=@StMonth+1;
	--END



	SELECT t.workorderid, t.assetid
	, CASE WHEN YEAR(t.WarrantyEndDate) = @pYear 
		THEN (DateDiff(Day,DATEFROMPARTS(YEAR(t.WarrantyEndDate), MONTH(t.WarrantyEndDate) , 01) , @EndofYear)+1)*24 
		ELSE (DateDiff(Day, @StartOfYear, @EndofYear)+1)*24
		END
	AS Uptime
	INTO #tmpUptime
	FROM EngMaintenanceWorkOrderTxn sr 
	INNER JOIN #tmpWorkOrderExWarranty t ON sr.WorkOrderId = t.WorkOrderId 
											AND t.assetid = sr.AssetId 
	left  JOIN EngMwoCompletionInfoTxn tc (NOLOCK) ON tc.WorkOrderId = t.WorkOrderId  
	--INNER JOIN #tmpAssetRegister ar ON t.assetregisterid = ar.AssetRegisterId	
	WHERE t.MaintenanceWorkCategory IN (188) -- Unscheduled 	
	AND t.assetid NOT IN 
		(SELECT AssetId 
		FROM DedExempAssetLogBI
		WHERE UpdatedDate < @StartDate
		AND year(UpdatedDate)=@pYear
		GROUP BY AssetId
		HAVING COUNT(*) >1)
	AND ( tc.EndDateTime  is null or year(tc.EndDateTime)=@pYear )
	--AND  ( year(t.MaintenanceWorkDateTime) = @YEAR)
	GROUP BY t.WorkOrderId, t.AssetId, t.WarrantyEndDate--, ber.[Status]

	 --select * from #tmpUptime
	---------------------------------------------
		
	--===========================================
	--DownTime Calculation
	--===========================================
	SELECT t.AssetId 
			, CASE WHEN a.FieldValue= 'Functioning' THEN 0 ELSE CASE WHEN a.FieldValue='Non-Functioning' 
			--DATEDIFF(HOUR,MIN(tci.StartDateTime),MAX(tci.EndDateTime))
			--THEN DATEDIFF(HOUR, (CASE WHEN MIN(t.MaintenanceWorkDateTime)<@StartOfYear THEN @StartOfYear ELSE MIN(t.MaintenanceWorkDateTime) END)
			--	, ISNULL(MAX(tc.EndDateTime),@LastDate))--SUM(tc.DowntimeHoursMin) --DATEDIFF(HOUR,tc.w,ISNULL(tc.EndDateTime,getdate()))
			THEN sum(DATEDIFF(HOUR, (CASE WHEN (t.MaintenanceWorkDateTime)<@StartOfYear THEN @StartOfYear ELSE (t.MaintenanceWorkDateTime) END)
				, ISNULL((tc.EndDateTime),@LastDate)))--SUM(tc.DowntimeHoursMin) --DATEDIFF(HOUR,tc.w,ISNULL(tc.EndDateTime,getdate()))
			ELSE 0--SUM(tci.RepairHours)
			END END AS DownTime			
	INTO #tmpDowntime
	--select *
	FROM #tmpWorkOrderExWarranty t
	--INNER JOIN #tmpUptime tu ON t.WorkOrderId = tu.WorkOrderId --t.AssetRegisterId = tu.AssetRegisterId
	INNER JOIN EngMwoAssesmentTxn ast (NOLOCK) ON t.WorkOrderId = ast.WorkOrderId 
	INNER JOIN FMLovMst a (NOLOCK) ON ast.AssetRealtimeStatus = a.LovId
	Left JOIN EngMwoCompletionInfoTxn tc (NOLOCK) ON tc.workorderid = ast.workorderid 
--	INNER JOIN EngMwoCompletionInfoTxnDet tci (NOLOCK) ON tci.CompletionInfoId = tc.CompletionInfoId AND tci.isdeleted = 0	
	WHERE  ( tc.EndDateTime  is null or year(tc.EndDateTime)=@pYear )
	--AND  ( year(t.MaintenanceWorkDateTime) = @YEAR)
	--YEAR(tc.EndDateTime) = @YEAR AND tc.EndDateTime<=@LastDate
	AND t.MaintenanceWorkCategory IN (188) -- Unscheduled 	
	GROUP BY t.AssetId, a.FieldValue--, t.MaintenanceWorkDateTime--, tc.EndDateTime
	--, tc.DowntimeHoursMin--, tc.StartDateTime, tc.EndDateTime 

	-- select * from #tmpDowntime
	---------------------------------------------

	--===========================================
	--Generating Percentage using (uptime-downtime/(uptime))*100
	--===========================================
	SELECT tu.AssetId, tu.Uptime, td.DownTime AS DownTime
	, (((tu.Uptime-td.DownTime)*100.00/(tu.Uptime))) AS GenPercentage	
	INTO #tmpTargetCalc
	FROM #tmpDowntime td 
	INNER JOIN #tmpUptime tu ON tu.AssetId = td.AssetId
	GROUP BY tu.AssetId, tu.Uptime,TD.DownTime

	-- select * from #tmpTargetCalc where genpercentage<0
	---------------------------------------------

	--===========================================
	--Target Percentage based on asset age
	--===========================================
	SELECT 
	DISTINCT ar.AssetId,ar.PurchaseCostRM
	, ISNULL(Datediff(Year,CAST(PurchaseDate AS DATE),CAST(@LastDate AS DATE)),0) AssetAge
	, (CASE WHEN Datediff(Year,CAST(PurchaseDate AS DATE),CAST(@LastDate AS DATE))<5 
		THEN atd.TRPILessThan5YrsPerc ELSE 
		CASE WHEN Datediff(Year,CAST(PurchaseDate AS DATE),CAST(@LastDate AS DATE))>5
		AND Datediff(Year,CAST(PurchaseDate AS DATE),CAST(@LastDate AS DATE))<10
		THEN atd.TRPI5to10YrsPerc
		ELSE 
		atd.TRPIGreaterThan10YrsPerc END END) as TargetPercentage
	INTO #tmpTargetPercent	
	FROM #tmpAssetRegister ar	
	INNER JOIN #tmpUptime tu ON ar.AssetId = tu.AssetId
	INNER JOIN EngAssetTypeCode atd on ar.AssetTypeCodeId = atd.AssetTypeCodeId 
											
	

	-- select * from #tmpTargetPercent
	---------------------------------------------	

	SELECT tt.AssetId
		, tt.PurchaseCostRM,tt.AssetAge, tt.TargetPercentage, td.GenPercentage
		,(CASE WHEN (Count(al.AssetId) = 1 AND 80 > td.GenPercentage) THEN 1
		ELSE CASE WHEN (Count(al.AssetId) = 0 AND tt.TargetPercentage > td.GenPercentage AND 80>td.GenPercentage) THEN 2
		ELSE CASE WHEN (Count(al.AssetId) = 0 AND tt.TargetPercentage > td.GenPercentage) THEN 1		
		ELSE 0
		END END END) AS DemeritPoint
	INTO #tmpDemerit
	FROM #tmpTargetPercent tt
	INNER JOIN #tmpTargetCalc td ON tt.AssetId = td.AssetId
	LEFT JOIN DedExempAssetLogBI al ON tt.AssetId = al.AssetId AND  UpdatedDate<@StartDate AND year(UpdatedDate)=@pYear
	GROUP BY tt.AssetId, tt.PurchaseCostRM,tt.AssetAge, tt.TargetPercentage, td.GenPercentage

	INSERT INTO #tmpDemerit
	SELECT tt.AssetId
		, tt.PurchaseCostRM,tt.AssetAge, tt.TargetPercentage, td.GenPercentage
		, CASE WHEN td.GenPercentage < tt.TargetPercentage AND td.GenPercentage<80 THEN 2
		ELSE CASE WHEN td.GenPercentage < tt.TargetPercentage AND td.GenPercentage > 80 THEN 1
		ELSE 0 END END AS DemeritPoint 		
	FROM #tmpTargetPercent tt
	INNER JOIN #tmpTargetCalc td ON tt.AssetId = td.AssetId
	LEFT JOIN DedExempAssetLogBI al ON tt.AssetId = al.AssetId 
	WHERE  Month(UpdatedDate) = @pMonth AND Year(UpdatedDate) = @pYear	
	AND tt.AssetId NOT IN (SELECT AssetId FROM #tmpDemerit)
	GROUP BY tt.AssetId, tt.PurchaseCostRM,tt.AssetAge, tt.TargetPercentage, td.GenPercentage

	-- select * from #tmpDemerit
	
	if exists ( select 1 from DedExempAssetLogBI a join #tmpDemerit b on a.AssetId = b.AssetId  where UpdatedDate >= @startdate )
	begin 
				--update a set UpdatedDate = @startdate  from DedExempAssetLogBI a join #tmpDemerit b on a.AssetRegisterId = b.AssetRegisterId  where UpdatedDate >= @startdate 				
				delete a from DedExempAssetLogBI a join #tmpDemerit b on a.AssetId = b.AssetId  where UpdatedDate >= @startdate 
	END
	
-- 1st level
	INSERT INTO DedExempAssetLogBI(AssetId, UpdatedDate,CreatedBy,CreatedDate,CreatedDateUTC)
	SELECT t.AssetId, @startdate, 1, GETDATE(),GETUTCDATE()
	FROM #tmpDemerit t
	LEFT JOIN DedExempAssetLogBI d ON t.AssetId = d.AssetId AND year(UpdatedDate)=@pYear
	WHERE t.DemeritPoint > 0
	AND d.AssetId IS NULL

	-- 2nd level
	INSERT INTO DedExempAssetLogBI(AssetId, UpdatedDate,CreatedBy,CreatedDate,CreatedDateUTC)
	SELECT t.AssetId,@startdate, 1, GETDATE(),GETUTCDATE()
	FROM #tmpDemerit t
	WHERE (t.DemeritPoint = 2 OR t.GenPercentage<80)
	AND t.AssetId NOT IN (SELECT AssetId FROM DedExempAssetLogBI d WHERE d.AssetId = t.AssetId
	--AND MONTH(UpdatedDate)=@MONTH 
	AND YEAR(UpdatedDate)=@pYear 
	GROUP BY AssetId HAVING COUNT(AssetId)=2)
	-- select distinct * from #tmpDemerit order by assetregisterid
	
	---------------------------------------------
	
	--===========================================
	-- Calculating Deduction
	--===========================================
	
		SELECT dp.*
		,CASE WHEN (SELECT COUNT(*) FROM DedExempAssetLogBI l where  l.AssetId = dp.AssetId AND YEAR(UpdatedDate)=@pYear )=1
		THEN
			(CASE WHEN PurchaseCostRM>49999 THEN 
						--(CASE WHEN (PurchaseCostRM/5000)%1 >0 
							--THEN
							 ((CAST((PurchaseCostRM/5000) AS INT)+1)*10)--*dp.DemeritPoint 
						--ELSE ((CAST((PurchaseCostRM/5000) AS INT))*10)--*dp.DemeritPoint 
						--END) 
			ELSE ts.DeductionValue 
					END) 
					
		ELSE CASE WHEN (SELECT COUNT(*) FROM DedExempAssetLogBI l where l.AssetId = dp.AssetId 
		AND MONTH(l.UpdatedDate)=@pMonth AND YEAR(l.UpdatedDate)=@pYear)=2
		THEN 
					(CASE WHEN PurchaseCostRM>49999 THEN 
								--(CASE WHEN (PurchaseCostRM/5000)%10 = 0 
									--THEN 
									((CAST((PurchaseCostRM/5000) AS INT)+1)*10)--*dp.DemeritPoint 
								--ELSE ((CAST((PurchaseCostRM/5000) AS INT))*10)--*dp.DemeritPoint 
								--END) 
					ELSE ts.DeductionValue END) +
					(CASE WHEN PurchaseCostRM>49999 THEN 
						--(CASE WHEN (PurchaseCostRM/5000)%10 = 0 
							--THEN 
							((CAST((PurchaseCostRM/5000) AS INT)+1)*20)--*dp.DemeritPoint 
						--ELSE ((CAST((PurchaseCostRM/5000) AS INT))*20)--*dp.DemeritPoint 
						--END) 
						ELSE ts.B4DeductionValue
					END)
		ELSE
			(CASE WHEN PurchaseCostRM>49999 THEN 
						--(CASE WHEN (PurchaseCostRM/5000)%10 = 0 
							--THEN 
							((CAST((PurchaseCostRM/5000) AS INT)+1)*20)--*dp.DemeritPoint 
						--ELSE ((CAST((PurchaseCostRM/5000) AS INT))*20)--*dp.DemeritPoint 
						--END) 
						ELSE ts.B4DeductionValue
					END)									
		END END AS DedValue
		, (CASE WHEN PurchaseCostRM>49999 THEN 
						--(CASE WHEN (PurchaseCostRM/5000)%1 >0 
							--THEN
							 ((CAST((PurchaseCostRM/5000) AS INT)+1)*10)--*dp.DemeritPoint 
						--ELSE ((CAST((PurchaseCostRM/5000) AS INT))*10)--*dp.DemeritPoint 
						--END) 
			ELSE ts.DeductionValue 
					END)  AS DeductionValue
		, CASE WHEN (SELECT COUNT(*) FROM DedExempAssetLogBI l where l.AssetId = dp.AssetId 
		AND MONTH(l.UpdatedDate)=@pMonth AND YEAR(l.UpdatedDate)=@pYear)=2
		THEN (CASE WHEN PurchaseCostRM>49999 THEN 
						--(CASE WHEN (PurchaseCostRM/5000)%10 = 0 
							--THEN 
							((CAST((PurchaseCostRM/5000) AS INT)+1)*20)--*dp.DemeritPoint 
						--ELSE ((CAST((PurchaseCostRM/5000) AS INT))*20)--*dp.DemeritPoint 
						--END) 
						ELSE ts.B4DeductionValue
					END) 
		ELSE null END  AS B4DeductionValue,
			CASE WHEN (SELECT COUNT(*) FROM DedExempAssetLogBI l where l.AssetId = dp.AssetId AND year(UpdatedDate)=@pYear)=1	THEN	1					
			 WHEN (SELECT COUNT(*) FROM DedExempAssetLogBI l where l.AssetId = dp.AssetId AND MONTH(l.UpdatedDate)=@pMonth AND YEAR(l.UpdatedDate)=@pYear)=2 THEN 2
		ELSE 1.5									
		END  AS DemeritSlab
		INTO #tmpDedValues
		FROM #tmpDemerit dp
		CROSS JOIN #tmpAssetSlab ts 
		WHERE dp.PurchaseCostRM Between ts.CostStart AND ISNULL(ts.CostEnd,dp.PurchaseCostRM)
	--SELECT dp.*
	--	,CASE WHEN (SELECT COUNT(*) FROM DedExempAssetLogBI l where l.AssetRegisterId = dp.AssetRegisterId)=1
	--	THEN
	--		(CASE WHEN PurchaseCostRM>49999 THEN 
	--					(CASE WHEN (PurchaseCostRM/5000)%1 >0 
	--						THEN ((CAST((PurchaseCostRM/5000) AS INT)+1)*10)--*dp.DemeritPoint 
	--					ELSE ((CAST((PurchaseCostRM/5000) AS INT))*10)--*dp.DemeritPoint 
	--					END) 
	--		ELSE ts.DeductionValue 
	--				END) 
					
	--	ELSE CASE WHEN (SELECT COUNT(*) FROM DedExempAssetLogBI l where l.AssetRegisterId = dp.AssetRegisterId 
	--	AND MONTH(l.UpdatedDate)=@MONTH AND YEAR(l.UpdatedDate)=@YEAR)=2
	--	THEN 
	--				(CASE WHEN PurchaseCostRM>49999 THEN 
	--							(CASE WHEN (PurchaseCostRM/5000)%10 = 0 
	--								THEN ((CAST((PurchaseCostRM/5000) AS INT)+1)*10)--*dp.DemeritPoint 
	--							ELSE ((CAST((PurchaseCostRM/5000) AS INT))*10)--*dp.DemeritPoint 
	--							END) 
	--				ELSE ts.DeductionValue END) +
	--				(CASE WHEN PurchaseCostRM>49999 THEN 
	--					(CASE WHEN (PurchaseCostRM/5000)%10 = 0 
	--						THEN ((CAST((PurchaseCostRM/5000) AS INT)+1)*20)--*dp.DemeritPoint 
	--					ELSE ((CAST((PurchaseCostRM/5000) AS INT))*20)--*dp.DemeritPoint 
	--					END) 
	--					ELSE ts.B4DeductionValue
	--				END)
	--	ELSE
	--		(CASE WHEN PurchaseCostRM>49999 THEN 
	--					(CASE WHEN (PurchaseCostRM/5000)%10 = 0 
	--						THEN ((CAST((PurchaseCostRM/5000) AS INT)+1)*20)--*dp.DemeritPoint 
	--					ELSE ((CAST((PurchaseCostRM/5000) AS INT))*20)--*dp.DemeritPoint 
	--					END) 
	--					ELSE ts.B4DeductionValue
	--				END)									
	--	END END AS DedValue
	--	INTO #tmpDedValues
	--	FROM #tmpDemerit dp
	--	CROSS JOIN #tmpAssetSlab ts 
	--	WHERE dp.PurchaseCostRM Between ts.CostStart AND ISNULL(ts.CostEnd,dp.PurchaseCostRM)

	-- select * from #tmpDedValues where genpercentage<0
	---------------------------------------------
	
	--===========================================
	-- Get Deduction
	--===========================================
	SELECT dp.AssetId, dp.DemeritPoint,0 as NCRDemeritPoints
	,  isnull(dp.DedValue,0) AS TotalDeduction	,dp.DemeritSlab	, TargetPercentage , GenPercentage , DedValue, AssetAge
	INTO #tmpB4
	FROM #tmpDedValues dp
	
	-- select * from #tmpB4



	INSERT INTO #TotalParameterDeduction
	select distinct 'B.4' as IndicatorName,ar.assetno,ar.purchasecostrm,DemeritPoint , TotalDeduction
	from #tmpb4 t
	--inner join EngMaintenanceWorkOrderTxn wo on t.workorderid=wo.workorderid
	inner join engasset ar on t.assetid= ar.assetid
	where DemeritPoint>0

	INSERT INTO #TotalParameterDemerit 
	select 'B.4' as IndicatorName,ar.assetno,ar.assetdescription,'Service work' TypeofTransaction,DemeritPoint TotalRecords ,'' maintenanceworkno	
	from #tmpb4 t
	--inner join EngMaintenanceWorkOrderTxn wo on t.workorderid=wo.workorderid
	inner join engasset ar on t.assetid= ar.assetid
	where DemeritPoint>0

	--select * from #TotalParameterDemerit
	---------------------------------------------
	
	--===========================================
	-- Add to Result
	--===========================================
	INSERT INTO #tmpResults
	SELECT ti.IndicatorDetId, ti.IndicatorNo
		, ti.IndicatorName, NULL AS SubParameter
		, SUM(t.Demeritpoint) AS TransDemeritPoints		
		, SUM(t.Demeritpoint)+SUM(t.NCRDemeritPoints) AS TotalDemeritPoints
		, NULL AS TotalParameters		
		, SUM(t.TotalDeduction) AS DeductionValue
		, (SUM(t.TotalDeduction)/100) AS DeductionPer
	FROM #tmpB4 t
	CROSS JOIN #tmpIndicator ti
	WHERE ti.IndicatorNo='B.4'
	AND t.DemeritPoint > 0
	GROUP BY ti.IndicatorDetId, ti.IndicatorNo, ti.IndicatorName

	select wo1.assetid ,max(wo1.workorderid) as workorderid into #tmpWorkOrderExWarranty1 
	from #tmpWorkOrderExWarranty wo1 
	INNER JOIN EngMwoAssesmentTxn ast (NOLOCK) ON wo1.WorkOrderId = ast.WorkOrderId
	where ast.AssetRealtimeStatus !=55 and  wo1.MaintenanceWorkCategory IN (188)   group by wo1.assetid


-------------------------------------------------------------------------------------------------------------------

	--=============================================================================================
	--BEMS Indicator - B5
	--=============================================================================================

	--===========================================
	-- Temp Tables
	IF OBJECT_ID('tempdb..#tmpB5') IS NOT NULL
	DROP TABLE #tmpB5

 select tc.TestingandCommissioningId,0 as AssetRegisterId,tc.PurchaseCost as PurchaseCostRM
	, count(*) as DemeritPoint
	, 0 as NCRDemeritPoints
	, count(*)*(CASE WHEN tc.PurchaseCost>49999 THEN 
			CASE WHEN (tc.PurchaseCost/5000)%1 >0 
			THEN (CAST((tc.PurchaseCost/5000) AS INT)+1)*10
			ELSE (CAST((tc.PurchaseCost/5000) AS INT))*10 END 
			ELSE (select DeductionValue from #tmpAssetSlab
						where tc.PurchaseCost BETWEEN CostStart AND ISNULL(CostEnd,tc.PurchaseCost)
			) END)  AS TotalDeduction	
	into #tmpb5
	from  EngTestingandCommissioningTxn tc 
		inner join EngTestingandCommissioningTxnDet tcd on tcd.TestingandCommissioningId=tc.TestingandCommissioningId 
		where tc.ServiceId = @pServiceId and tc.FacilityId=@pFacilityId 
		and  ((cast(tc.TandCCompletedDate as date)>=cast(@StartDate as date)) or (tc.TandCCompletedDate is null))
		and cast(tc.RequiredCompletionDate as date)<=cast(@LastDate as date)
		--and (tc.TandCCompletedDate is null or cast(tc.TandCCompletedDate as date)>cast(RequiredDateTime as date))
		--and (tc.TandCStatus in (2821,2820) or tc.TandCStatus is null)	
		and( (tc.TandCStatus = 71 and  (cast(tc.TandCCompletedDate as date)>cast(RequiredCompletionDate as date) or (tc.TandCCompletedDate is null) )))
		group by tc.TestingandCommissioningId,tc.PurchaseCost

	insert into #TotalParameterDeduction
	select 'B.5' as IndicatorName,'' as AssetNo,Isnull(PurchaseCostRM,0) as PurchaseCost, 1  as DemeritPoint, TotalDeduction as DemeritValue
	 from #tmpb5 t


	
	--===========================================
	-- Add to Results
	--===========================================
	INSERT INTO #tmpResults
	SELECT ti.IndicatorDetId, ti.IndicatorNo
		, ti.IndicatorName, NULL AS SubParameter
		,  sum(DemeritPoint) AS TransDemeritPoints		
		, SUM(t.NCRDemeritPoints)+sum(DemeritPoint) AS TotalDemeritPoints
		, NULL AS TotalParameters	
		, SUM(t.TotalDeduction) AS DeductionValue
		, (SUM(t.TotalDeduction)/100) AS DeductionPer
	FROM #tmpB5 t
	CROSS JOIN #tmpIndicator ti
	WHERE ti.IndicatorNo='B.5'
	GROUP BY ti.IndicatorDetId, ti.IndicatorNo, ti.IndicatorName

-------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------  
--=============================================================================================  
 --BEMS Indicator - B6  
 --=============================================================================================  
  
 --===========================================  
  
 IF OBJECT_ID('tempdb..#tmpB6') IS NOT NULL  
 DROP TABLE #tmpB6  


				select distinct customerreportid,ReportName  into #Custreport from MstCustomerReport  
				where  customerid in (select customerid from MstLocationFacility where facilityid = @pFacilityId)
				and active=1

				select distinct b.customerreportid,b.ReportsandRecordTxnDetId,b.Verified,b.Remarks into #KPIreport from KPIReportsandRecordTxn a join KPIReportsandRecordTxnDet  b on a.ReportsandRecordTxnId=b.ReportsandRecordTxnId
				where a.facilityid = @pFacilityId
				AND Month	=	@pMonth 
				AND Year	=	@pYear

				--select count(a.customerreportid)  as DemeritPoint into #tmpB6 from #Custreport  a
				--left join #KPIreport  b on a.customerreportid=b.customerreportid
				--where b.customerreportid is null


				 
				select ReportName as Item,Remarks as Remarks , case when Verified=0 then 'No' else 'Yes' end as Verified, 1 as DemeritPoint into #tmpB6 from #Custreport  a
				left join #KPIreport  b on a.customerreportid=b.customerreportid
				where b.customerreportid is null

		
			

				--select  WTSPI.Item,  WSTPD.Remarks, 'No' as Verified, ISNULL(WTSPI.Parameter, 0) * 1 as [DemeritPoint]
				--into	#tmpB6
				--from	WpmTechServicePerfTxn WTSP  
				--join	WpmTechServicePerfTxnDet  WSTPD  on WTSP.TechServicePerfId = WSTPD.TechServicePerfId
				--left	join WpmTechServicePerfAssessmentItem  WTSPI  on WTSPI.ItemId = WSTPD.ItemId --and isdeleted = 0
				--where	WTSP.FacilityId =  @pFacilityId
				--and		WTSP.month		=  @pMonth 
				--and		WTSP.Year		=  @pYear
				--and     isverified = 0
				--and     isapplicable = 1 

	declare @Weightage  numeric(24,2)  , @mCustomerId  int , @MonthlyServiceFee  float,@keyIndicatorValue decimal(24,4),
			@Ringittequivalent decimal(12,2),@TotalParameters float,@MonthlyServiceFeeVal float,@TotalDM int,@GearingRatio decimal(12,4),
			@DeductionValue decimal(12,2), @DeductionPer decimal(12,2)

	
	select @mCustomerId = customerid from MstLocationFacility where facilityid = @pFacilityId


	set @Weightage = ( select Weightage from MstDedIndicatorDet dmd where  dmd.IndicatorNo = 'B.6' )
	set @Weightage=1.00

	SELECT	@MonthlyServiceFee = B.BemsMSF
	FROM	FinMonthlyFeeTxn A
			JOIN FinMonthlyFeeTxnDet B ON A.MonthlyFeeId = B.MonthlyFeeId
	WHERE A.[Year] = @pYear AND B.[Month] = @pMonth AND A.CustomerId = @mCustomerId AND A.FacilityId = @pFacilityId

	
	
	set @MonthlyServiceFeeVal = @MonthlyServiceFee;
	set @keyIndicatorValue = (@Weightage * @MonthlyServiceFeeVal);
		
	
	select @TotalParameters = count(customerreportid) from  #Custreport
	select @TotalDM = count(DemeritPoint) from  #tmpB6

	if(@TotalParameters !=0)

	begin

	set @Ringittequivalent = (@keyIndicatorValue/@TotalParameters);

	end

	set @GearingRatio = (@Ringittequivalent * 200)/100.00;
	set @DeductionValue = (@GearingRatio * @TotalDM);

	set @DeductionPer = (@DeductionValue / @MonthlyServiceFeeVal)*100.00;


	
	--update #dedCalc set TotalDemeritPoints = isnull(@TotalDM,0) ,
	--NCRDemeritPoints = (ISNULL(@totalNcrPoints,0)),
	--TotalParameters = isnull(@TotalParameter,0),DeductionValue = isnull(@DeductionValue,0),
	--DeductionPer = isnull(@DeductionPer,0),GearingRatio=isnull(@GearingRatio,0),
	--Ringittequivalent=isnull(@Ringittequivalent,0),keyIndicatorValue=isnull(@keyIndicatorValue,0),Weightage = ISNULL(@Weightage, 0) 
	--where IndicatorNo = 'FM.1' 

	
	
	INSERT INTO #tmpResults
	SELECT 6, 'B.6'
		, 'Report', NULL AS SubParameter
		,  @TotalDM AS TransDemeritPoints		
		,  @TotalDM AS TotalDemeritPoints
		, NULL AS TotalParameters	
		, @DeductionValue AS DeductionValue
		, @DeductionPer AS DeductionPer
	FROM #tmpB6 t

      
  
 --   select  WTSPI.Item,  WSTPD.Remarks, 'No' as Verified, ISNULL(WTSPI.Parameter, 0) * 1 as [DemeritPoint]  
 --   into #tmpB6  
 --   from WpmTechServicePerfTxn WTSP    
 --   join WpmTechServicePerfTxnDet  WSTPD  on WTSP.TechServicePerfId = WSTPD.TechServicePerfId  
 --   left join WpmTechServicePerfAssessmentItem  WTSPI  on WTSPI.ItemId = WSTPD.ItemId --and isdeleted = 0  
 --   where WTSP.FacilityId =  @pFacilityId  
 --   and  WTSP.month  =  @pMonth   
 --   and  WTSP.Year  =  @pYear  
 --   and     isverified = 0  
 --   and     isapplicable = 1   
  
 --INSERT INTO #tmpResults  
 --SELECT 6, 'B.6'  
 -- , 'Report', NULL AS SubParameter  
 -- ,  sum(DemeritPoint) AS TransDemeritPoints    
 -- , sum(DemeritPoint) AS TotalDemeritPoints  
 -- , NULL AS TotalParameters   
 -- , 0 AS DeductionValue  
 -- , 0 AS DeductionPer  
 --FROM #tmpB6 t  
  
  
-------------------------------------------------------------------------------------------------------------------------------------  

UPDATE b SET
	b.TransDemeritPoints = a.TransDemeritPoints
	, b.TotalDemeritPoints = a.TotalDemeritPoints
	, b.DeductionValue = a.DeductionValue
	, b.DeductionPer = a.DeductionPer
	--SELECT *
	FROM #tmpResults a
	INNER JOIN #BemsResults b ON a.IndicatorDetId = b.IndicatorDetId

	UPDATE  #BemsResults
	SET 
	TotalDemeritPoints= (SELECT SUM(TotalDemeritPoints) FROM #BemsResults)
	, TransDemeritPoints= (SELECT SUM(TransDemeritPoints) FROM #BemsResults)
	, DeductionValue = TotalDeductionValue
	, DeductionPer = TotalDeductionPer
	, IndicatorDetId = id+1
	FROM (SELECT MAX(IndicatorDetId)id, SUM(DeductionValue)TotalDeductionValue
		, SUM(DeductionPer) TotalDeductionPer 
	FROM #BemsResults ) AS s
	where IndicatorNo='total'

		


	--SELECT IndicatorDetId, IndicatorNo, IndicatorName
	--, ISNULL(SubParameter,0) SubParameter
	--, ISNULL(SubParameterDetId,0) SubParameterDetId
	--, ISNULL(TransDemeritPoints,0) TransDemeritPoints
	--, ISNULL(TotalDemeritPoints,0) TotalDemeritPoints
	--, ISNULL(DeductionValue,0) DeductionValue
	--, case when isnull(ft.BemsMSF,0) = 0 then 0.00 else  CAST(((ISNULL(DeductionValue,0)/isnull(ft.BemsPercent,0))*100.00) as decimal(10,2)) end DeductionPer
	----select *
	--FROM #BemsResults t, FinMonthlyFeeTxn f, FinMonthlyFeeTxnDet ft
	--WHERE f.FacilityId = @pFacilityId

 --AND f.Year = @pYear
	--AND ft.Month = @pMonth AND f.MonthlyFeeId = ft.MonthlyFeeId 

	--SELECT * FROM #TotalParameterDemerit
	--SELECT * FROM #TotalParameterDeduction


	IF(@pIndicatorNo = 'B.1')
	BEGIN
	IF NOT EXISTS (SELECT 1 FROM DedGenerationTxn A INNER JOIN DedGenerationBemsPopupTxn B ON A.DedGenerationId = B.DedGenerationId WHERE A.FacilityId = @pFacilityId AND A.MONTH = @pMonth AND A.Year = @pYear)

	BEGIN

	

------------------- Service Work No is not null Is NULL

	SELECT	@TotalRecords	=	COUNT(*) FROM #TotalParameterDeduction WHERE IndicatorName='B.1'
	
	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(5 AS NUMERIC(24,2))

	SET @pTotalPage = CEILING(@pTotalPage)

	



			SELECT 
			CONVERT(INT,ROW_NUMBER() OVER (ORDER BY AssetNo DESC)) AS SerialNo,
			'B.1' AS IndicatorNo,
			(select DedGenerationId from DedGenerationTxn where FacilityId = @pFacilityId and Month = @pMonth and Year = @pYear) AS DedGenerationId,
			@pFacilityId AS FacilityId, 
			@pMonth AS Month,
			@pYear AS Year, 
			AssetNo as 'AssetNo',
			CAST(PurchaseCost AS numeric(24,2)) as 'PurchaseCost',
			CAST(DemeritValue AS INT) as 'DemeritValue1',
			CAST(DemeritPoint AS INT) as 'DemeritPoint',
			ISNULL(cast(DemeritPoint*DemeritValue AS decimal(12,2)),0) as 'DeductionValue',
			0 AS IsNCR,1 AS IsDemerit,2 AS CreatedBy, GETDATE() AS CreatedDate,GETUTCDATE() AS CreatedDateUTC ,0 AS ID,
			@TotalRecords											AS TotalRecords,
			@pTotalPage												AS TotalPageCalc
			FROM #TotalParameterDeduction WHERE IndicatorName='B.1'
			ORDER BY SerialNo ASC
			OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY

 END

 ELSE
				

 BEGIN
 		

		


---------select for Service Work No Is Null

			SELECT @TotalRecords =  count(*) FROM DedGenerationTxn A INNER JOIN DedGenerationBemsPopupTxn B ON A.DedGenerationId = B.DedGenerationId
			WHERE A.FacilityId = @pFacilityId AND A.Month = @pMonth AND A.Year = @pYear and ServiceWorkNo is null AND B.IndicatorNo ='B.1'
				
			SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(5 AS NUMERIC(24,2))

			SET @pTotalPage = CEILING(@pTotalPage)
			
		
			SELECT * FROM (SELECT CONVERT(INT,ROW_NUMBER() OVER (ORDER BY AssetNo DESC)) AS SerialNo,
			B.BEMSDedGenerationPopupId,B.DedGenerationId,B.FacilityId,B.ServiceWorkDateTime,B.ID,B.ServiceRequestNo,B.ServiceWorkNo,B.AssetNo,B.AssetDescription,B.WorkGroup,B.AssetTypeCode,B.UnderWarranty,B.Requestor,B.ResponseDateTime,B.RepsonseDurationHrs,
			B.StartDateTime,B.EndDateTime,B.WorkOrderStatus,B.DowntimeHrs,B.Type,B.TargetDate,B.UserLocationCode,B.TaskCode,B.SCMAgreedDate,B.TypeofTransaction,B.PurchaseCost,isnull(B.DemeritValue1,0) DemeritValue1,isnull(B.DemeritValue2,0) as DemeritValue2,
isnull(B.DemeritPoint,0) as DemeritPoint,isnull(B.DeductionValue,0) as DeductionValue,B.TCDocumentNo,B.SRDateTime,B.RequiredDateTime,B.SRDetails,B.TCStatus,B.PurchaseCostRM,B.IndicatorNo,B.SubParameterDetId,B.Month,B.Year,B.IsNCR,B.TCDate,B.TCCompletedDate,B.NCRNo,
B.NCRDateTime,B.IsDemerit,B.TotalDeduction,B.GroupFlag,B.TotalTransactionCount,B.RescheduleDate,B.PurchaseDate,B.TargetPercentage,B.ServiceWorkComplaintDetails,B.ResponseCategory,B.ServiceWorkCompletionDate,B.ServiceWorkDate,B.DeductionValueperasset,
B.B1Deduction,B.B2DemeritPoint,B.B2Deduction,B.TotalResponseTime,B.B2TotalRepairTime,B.AssetAge,B.GenPercentage,B.DemeritSlab,B.DedValue,B.FirstPrevDed,B.SecPrevDed,B.AssetRegisterId,B.VariationPurchaseCost,B.Deduction,B.CreatedBy,B.CreatedDate,B.CreatedDateUTC,
B.ModifiedBy,B.ModifiedDate,B.ModifiedDateUTC,B.GuId,  
			@TotalRecords											AS TotalRecords,
			@pTotalPage												AS TotalPageCalc
			FROM DedGenerationTxn A INNER JOIN DedGenerationBemsPopupTxn B ON A.DedGenerationId = B.DedGenerationId
			WHERE A.FacilityId = @pFacilityId AND A.Month = @pMonth AND A.Year = @pYear and ServiceWorkNo is null AND B.IndicatorNo ='B.1'
			ORDER BY SerialNo ASC
			OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY) as DATA
			WHERE SerialNo>=1
			ORDER BY SerialNo

 END
 END
 --------------------------------------------------------------------------------------------------------------------------------------------------------
 	IF(@pIndicatorNo = 'B.2')
	BEGIN
	IF NOT EXISTS (SELECT 1 FROM DedGenerationTxn A INNER JOIN DedGenerationBemsPopupTxn B ON A.DedGenerationId = B.DedGenerationId WHERE A.FacilityId = @pFacilityId AND A.MONTH = @pMonth AND A.Year = @pYear)

	BEGIN

------------------- Service Work No is not null Is NULL

	SELECT	@TotalRecords	=	COUNT(*) FROM #TotalParameterDeduction WHERE IndicatorName='B.2'
	
	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(5 AS NUMERIC(24,2))

	SET @pTotalPage = CEILING(@pTotalPage)



			SELECT 
			CONVERT(INT,ROW_NUMBER() OVER (ORDER BY AssetNo DESC)) AS SerialNo,
			'B.2' AS IndicatorNo,
			(select DedGenerationId from DedGenerationTxn where FacilityId = @pFacilityId and Month = @pMonth and Year = @pYear) AS DedGenerationId,
			@pFacilityId AS FacilityId, 
			@pMonth AS Month,
			@pYear AS Year, 
			AssetNo as 'AssetNo',
			CAST(isnull(PurchaseCost,0) AS numeric(24,2)) as 'PurchaseCost',
			CAST(isnull(DemeritValue,0) AS INT) as 'DemeritValue1',
			CAST(isnull(DemeritPoint,0) AS INT) as 'DemeritPoint',
			ISNULL(cast(DemeritPoint*DemeritValue AS decimal(12,2)),0) as 'DeductionValue',
			0 AS IsNCR,1 AS IsDemerit,2 AS CreatedBy, GETDATE() AS CreatedDate,GETUTCDATE() AS CreatedDateUTC ,0 AS ID,
			@TotalRecords											AS TotalRecords,
			@pTotalPage												AS TotalPageCalc
			FROM #TotalParameterDeduction WHERE IndicatorName='B.2'
			ORDER BY SerialNo ASC
			OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY

 END

 ELSE
				

 BEGIN
 		

---------select for Service Work No Is Null

			SELECT @TotalRecords =  count(*) FROM DedGenerationTxn A INNER JOIN DedGenerationBemsPopupTxn B ON A.DedGenerationId = B.DedGenerationId
			WHERE A.FacilityId = @pFacilityId AND A.Month = @pMonth AND A.Year = @pYear and ServiceWorkNo is null AND B.IndicatorNo ='B.2'
				
			SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(5 AS NUMERIC(24,2))

			SET @pTotalPage = CEILING(@pTotalPage)
			
			SELECT * FROM (SELECT CONVERT(INT,ROW_NUMBER() OVER (ORDER BY AssetNo DESC)) AS SerialNo,
			B.BEMSDedGenerationPopupId,B.DedGenerationId,B.FacilityId,B.ServiceWorkDateTime,B.ID,B.ServiceRequestNo,B.ServiceWorkNo,B.AssetNo,B.AssetDescription,B.WorkGroup,B.AssetTypeCode,B.UnderWarranty,B.Requestor,B.ResponseDateTime,B.RepsonseDurationHrs,
			B.StartDateTime,B.EndDateTime,B.WorkOrderStatus,B.DowntimeHrs,B.Type,B.TargetDate,B.UserLocationCode,B.TaskCode,B.SCMAgreedDate,B.TypeofTransaction,isnull(B.PurchaseCost,0) as PurchaseCost,isnull(B.DemeritValue1,0) as DemeritValue1,
			isnull(B.DemeritValue2,0) as DemeritValue2,isnull(B.DemeritPoint,0) as DemeritPoint ,isnull(B.DeductionValue,0) as DeductionValue,B.TCDocumentNo,B.SRDateTime,B.RequiredDateTime,B.SRDetails,B.TCStatus,B.PurchaseCostRM,B.IndicatorNo,B.SubParameterDetId,
			B.Month,B.Year,B.IsNCR,B.TCDate,B.TCCompletedDate,B.NCRNo,B.NCRDateTime,B.IsDemerit,B.TotalDeduction,B.GroupFlag,B.TotalTransactionCount,B.RescheduleDate,B.PurchaseDate,B.TargetPercentage,B.ServiceWorkComplaintDetails,B.ResponseCategory,B.ServiceWorkCompletionDate,B.ServiceWorkDate,
			B.DeductionValueperasset,B.B1Deduction,B.B2DemeritPoint,B.B2Deduction,B.TotalResponseTime,B.B2TotalRepairTime,B.AssetAge,B.GenPercentage,B.DemeritSlab,B.DedValue,B.FirstPrevDed,B.SecPrevDed,B.AssetRegisterId,B.VariationPurchaseCost,B.Deduction,B.CreatedBy,
			B.CreatedDate,B.CreatedDateUTC,B.ModifiedBy,B.ModifiedDate,B.ModifiedDateUTC,B.GuId,  
			@TotalRecords											AS TotalRecords,
			@pTotalPage												AS TotalPageCalc
			FROM DedGenerationTxn A INNER JOIN DedGenerationBemsPopupTxn B ON A.DedGenerationId = B.DedGenerationId
			WHERE A.FacilityId = @pFacilityId AND A.Month = @pMonth AND A.Year = @pYear and ServiceWorkNo is null AND B.IndicatorNo ='B.2'
			ORDER BY SerialNo ASC
			OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY) as DATA
			WHERE SerialNo>=1
			ORDER BY SerialNo

 END
 END
 ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 	IF(@pIndicatorNo = 'B.3')
	BEGIN
	IF NOT EXISTS (SELECT 1 FROM DedGenerationTxn A INNER JOIN DedGenerationBemsPopupTxn B ON A.DedGenerationId = B.DedGenerationId WHERE A.FacilityId = @pFacilityId AND A.MONTH = @pMonth AND A.Year = @pYear)

	BEGIN

------------------- Service Work No is not null Is NULL

	SELECT	@TotalRecords	=	COUNT(*) FROM #TotalParameterDeduction WHERE IndicatorName='B.3'
	
	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(5 AS NUMERIC(24,2))

	SET @pTotalPage = CEILING(@pTotalPage)



			SELECT 
			CONVERT(INT,ROW_NUMBER() OVER (ORDER BY AssetNo DESC)) AS SerialNo,
			'B.3' AS IndicatorNo,
			(select DedGenerationId from DedGenerationTxn where FacilityId = @pFacilityId and Month = @pMonth and Year = @pYear) AS DedGenerationId,
			@pFacilityId AS FacilityId, 
			@pMonth AS Month,
			@pYear AS Year, 
			AssetNo as 'AssetNo',
			CAST(PurchaseCost AS numeric(24,2)) as 'PurchaseCost',
			CAST(DemeritValue AS INT) as 'DemeritValue1',
			CAST(DemeritPoint AS INT) as 'DemeritPoint',
			ISNULL(cast(DemeritPoint*DemeritValue AS decimal(12,2)),0) as 'DeductionValue',
			0 AS IsNCR,1 AS IsDemerit,2 AS CreatedBy, GETDATE() AS CreatedDate,GETUTCDATE() AS CreatedDateUTC ,0 AS ID,
			@TotalRecords											AS TotalRecords,
			@pTotalPage												AS TotalPageCalc
			FROM #TotalParameterDeduction WHERE IndicatorName='B.3'
			ORDER BY SerialNo ASC
			OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY

 END

 ELSE
				

 BEGIN
 		

---------select for Service Work No Is Null

			SELECT @TotalRecords =  count(*) FROM DedGenerationTxn A INNER JOIN DedGenerationBemsPopupTxn B ON A.DedGenerationId = B.DedGenerationId
			WHERE A.FacilityId = @pFacilityId AND A.Month = @pMonth AND A.Year = @pYear and ServiceWorkNo is null AND B.IndicatorNo ='B.3'
				
			SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(5 AS NUMERIC(24,2))

			SET @pTotalPage = CEILING(@pTotalPage)
			
			SELECT * FROM (SELECT CONVERT(INT,ROW_NUMBER() OVER (ORDER BY AssetNo DESC)) AS SerialNo,
			B.BEMSDedGenerationPopupId,B.DedGenerationId,B.FacilityId,B.ServiceWorkDateTime,B.ID,B.ServiceRequestNo,B.ServiceWorkNo,B.AssetNo,B.AssetDescription,B.WorkGroup,B.AssetTypeCode,B.UnderWarranty,B.Requestor,B.ResponseDateTime,B.RepsonseDurationHrs,
			B.StartDateTime,B.EndDateTime,B.WorkOrderStatus,B.DowntimeHrs,B.Type,B.TargetDate,B.UserLocationCode,B.TaskCode,B.SCMAgreedDate,B.TypeofTransaction,B.PurchaseCost,B.DemeritValue1,B.DemeritValue2,B.DemeritPoint,B.DeductionValue,B.TCDocumentNo,B.SRDateTime,
			B.RequiredDateTime,B.SRDetails,B.TCStatus,B.PurchaseCostRM,B.IndicatorNo,B.SubParameterDetId,B.Month,B.Year,B.IsNCR,B.TCDate,B.TCCompletedDate,B.NCRNo,B.NCRDateTime,B.IsDemerit,B.TotalDeduction,B.GroupFlag,B.TotalTransactionCount,B.RescheduleDate,B.PurchaseDate,
			B.TargetPercentage,B.ServiceWorkComplaintDetails,B.ResponseCategory,B.ServiceWorkCompletionDate,B.ServiceWorkDate,B.DeductionValueperasset,B.B1Deduction,B.B2DemeritPoint,B.B2Deduction,B.TotalResponseTime,B.B2TotalRepairTime,B.AssetAge,B.GenPercentage,
			B.DemeritSlab,B.DedValue,B.FirstPrevDed,B.SecPrevDed,B.AssetRegisterId,B.VariationPurchaseCost,B.Deduction,B.CreatedBy,B.CreatedDate,B.CreatedDateUTC,B.ModifiedBy,B.ModifiedDate,B.ModifiedDateUTC,B.GuId,  
			@TotalRecords											AS TotalRecords,
			@pTotalPage												AS TotalPageCalc
			FROM DedGenerationTxn A INNER JOIN DedGenerationBemsPopupTxn B ON A.DedGenerationId = B.DedGenerationId
			WHERE A.FacilityId = @pFacilityId AND A.Month = @pMonth AND A.Year = @pYear and ServiceWorkNo is null AND B.IndicatorNo ='B.3'
			ORDER BY SerialNo ASC
			OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize ROWS ONLY) as DATA
			WHERE SerialNo>=1
			ORDER BY SerialNo

 END
END

 ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 	IF(@pIndicatorNo = 'B.4')
	BEGIN
	IF NOT EXISTS (SELECT 1 FROM DedGenerationTxn A INNER JOIN DedGenerationBemsPopupTxn B ON A.DedGenerationId = B.DedGenerationId WHERE A.FacilityId = @pFacilityId AND A.MONTH = @pMonth AND A.Year = @pYear)

	BEGIN

------------------- Service Work No is not null Is NULL

	SELECT	@TotalRecords	=	COUNT(*) FROM #TotalParameterDeduction WHERE IndicatorName='B.4'
	
	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(5 AS NUMERIC(24,2))

	SET @pTotalPage = CEILING(@pTotalPage)



			SELECT 
			CONVERT(INT,ROW_NUMBER() OVER (ORDER BY AssetNo DESC)) AS SerialNo,
			'B.4' AS IndicatorNo,
			(select DedGenerationId from DedGenerationTxn where FacilityId = @pFacilityId and Month = @pMonth and Year = @pYear) AS DedGenerationId,
			@pFacilityId AS FacilityId, 
			@pMonth AS Month,
			@pYear AS Year, 
			AssetNo as 'AssetNo',
			CAST(PurchaseCost AS numeric(24,2)) as 'PurchaseCost',
			CAST(isnull(DemeritValue,0) AS INT) as 'DemeritValue1',
			CAST(isnull(DemeritPoint,0) AS INT) as 'DemeritPoint',
			ISNULL(cast(DemeritPoint*DemeritValue AS decimal(12,2)),0) as 'DeductionValue',
			0 AS IsNCR,1 AS IsDemerit,2 AS CreatedBy, GETDATE() AS CreatedDate,GETUTCDATE() AS CreatedDateUTC ,0 AS ID,
			@TotalRecords											AS TotalRecords,
			@pTotalPage												AS TotalPageCalc
			FROM #TotalParameterDeduction WHERE IndicatorName='B.4'
			ORDER BY SerialNo ASC
			OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY

 END

 ELSE
				

 BEGIN
 		

---------select for Service Work No Is Null

			SELECT @TotalRecords =  count(*) FROM DedGenerationTxn A INNER JOIN DedGenerationBemsPopupTxn B ON A.DedGenerationId = B.DedGenerationId
			WHERE A.FacilityId = @pFacilityId AND A.Month = @pMonth AND A.Year = @pYear and ServiceWorkNo is null AND B.IndicatorNo ='B.4'
				
			SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(5 AS NUMERIC(24,2))

			SET @pTotalPage = CEILING(@pTotalPage)
			
			SELECT * FROM (SELECT CONVERT(INT,ROW_NUMBER() OVER (ORDER BY AssetNo DESC)) AS SerialNo,
			B.BEMSDedGenerationPopupId,B.DedGenerationId,B.FacilityId,B.ServiceWorkDateTime,B.ID,B.ServiceRequestNo,B.ServiceWorkNo,B.AssetNo,B.AssetDescription,B.WorkGroup,B.AssetTypeCode,B.UnderWarranty,B.Requestor,B.ResponseDateTime,B.RepsonseDurationHrs,
			B.StartDateTime,B.EndDateTime,B.WorkOrderStatus,B.DowntimeHrs,B.Type,B.TargetDate,B.UserLocationCode,B.TaskCode,B.SCMAgreedDate,B.TypeofTransaction,B.PurchaseCost,isnull(B.DemeritValue1,0) DemeritValue1,isnull(B.DemeritValue2,0) as DemeritValue2,
			isnull(B.DemeritPoint,0) as DemeritPoint,isnull(B.DeductionValue,0) as DeductionValue,B.TCDocumentNo,B.SRDateTime,B.RequiredDateTime,B.SRDetails,B.TCStatus,B.PurchaseCostRM,B.IndicatorNo,B.SubParameterDetId,B.Month,B.Year,B.IsNCR,B.TCDate,B.TCCompletedDate,B.NCRNo,
			B.NCRDateTime,B.IsDemerit,B.TotalDeduction,B.GroupFlag,B.TotalTransactionCount,B.RescheduleDate,B.PurchaseDate,B.TargetPercentage,B.ServiceWorkComplaintDetails,B.ResponseCategory,B.ServiceWorkCompletionDate,B.ServiceWorkDate,B.DeductionValueperasset,
			B.B1Deduction,B.B2DemeritPoint,B.B2Deduction,B.TotalResponseTime,B.B2TotalRepairTime,B.AssetAge,B.GenPercentage,B.DemeritSlab,B.DedValue,B.FirstPrevDed,B.SecPrevDed,B.AssetRegisterId,B.VariationPurchaseCost,B.Deduction,B.CreatedBy,B.CreatedDate,B.CreatedDateUTC,
			B.ModifiedBy,B.ModifiedDate,B.ModifiedDateUTC,B.GuId,  
			@TotalRecords											AS TotalRecords,
			@pTotalPage												AS TotalPageCalc
			FROM DedGenerationTxn A INNER JOIN DedGenerationBemsPopupTxn B ON A.DedGenerationId = B.DedGenerationId
			WHERE A.FacilityId = @pFacilityId AND A.Month = @pMonth AND A.Year = @pYear and ServiceWorkNo is null AND B.IndicatorNo ='B.4'
			and isnull(B.DemeritValue2,0)>0
			ORDER BY SerialNo ASC
			OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY) as DATA
			WHERE SerialNo>=1
		
			ORDER BY SerialNo

 END
END
 ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 	IF(@pIndicatorNo = 'B.5')
	BEGIN
	IF NOT EXISTS (SELECT 1 FROM DedGenerationTxn A INNER JOIN DedGenerationBemsPopupTxn B ON A.DedGenerationId = B.DedGenerationId WHERE A.FacilityId = @pFacilityId AND A.MONTH = @pMonth AND A.Year = @pYear)

	BEGIN

------------------- Service Work No is not null Is NULL

	SELECT	@TotalRecords	=	COUNT(*) FROM #TotalParameterDeduction WHERE IndicatorName='B.5'
	
	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(5 AS NUMERIC(24,2))

	SET @pTotalPage = CEILING(@pTotalPage)



			SELECT 
			CONVERT(INT,ROW_NUMBER() OVER (ORDER BY AssetNo DESC)) AS SerialNo,
			'B.5' AS IndicatorNo,
			(select DedGenerationId from DedGenerationTxn where FacilityId = @pFacilityId and Month = @pMonth and Year = @pYear) AS DedGenerationId,
			@pFacilityId AS FacilityId, 
			@pMonth AS Month,
			@pYear AS Year, 
			AssetNo as 'AssetNo',
			CAST(PurchaseCost AS numeric(24,2)) as 'PurchaseCost',
			CAST(isnull(DemeritValue,0) AS INT) as 'DemeritValue1',
			CAST(isnull(DemeritPoint,0) AS INT) as 'DemeritPoint',
			ISNULL(cast(DemeritPoint*DemeritValue AS decimal(12,2)),0) as 'DeductionValue',
			0 AS IsNCR,1 AS IsDemerit,2 AS CreatedBy, GETDATE() AS CreatedDate,GETUTCDATE() AS CreatedDateUTC ,0 AS ID,
			@TotalRecords											AS TotalRecords,
			@pTotalPage												AS TotalPageCalc
			FROM #TotalParameterDeduction WHERE IndicatorName='B.5'
			ORDER BY SerialNo ASC
			OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize ROWS ONLY

 END

 ELSE
				

 BEGIN
 		

---------select for Service Work No Is Null

			SELECT @TotalRecords =  count(*) FROM DedGenerationTxn A INNER JOIN DedGenerationBemsPopupTxn B ON A.DedGenerationId = B.DedGenerationId
			WHERE A.FacilityId = @pFacilityId AND A.Month = @pMonth AND A.Year = @pYear and ServiceWorkNo is null AND B.IndicatorNo ='B.5'
				
			SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(5 AS NUMERIC(24,2))

			SET @pTotalPage = CEILING(@pTotalPage)
			
			SELECT * FROM (SELECT CONVERT(INT,ROW_NUMBER() OVER (ORDER BY AssetNo DESC)) AS SerialNo,
			B.BEMSDedGenerationPopupId,B.DedGenerationId,B.FacilityId,B.ServiceWorkDateTime,B.ID,B.ServiceRequestNo,B.ServiceWorkNo,B.AssetNo,B.AssetDescription,B.WorkGroup,B.AssetTypeCode,B.UnderWarranty,B.Requestor,B.ResponseDateTime,B.RepsonseDurationHrs,
			B.StartDateTime,B.EndDateTime,B.WorkOrderStatus,B.DowntimeHrs,B.Type,B.TargetDate,B.UserLocationCode,B.TaskCode,B.SCMAgreedDate,B.TypeofTransaction,B.PurchaseCost,isnull(B.DemeritValue1,0) as DemeritValue1,isnull(B.DemeritValue2,0)as DemeritValue2,
			isnull(B.DemeritPoint,0)as DemeritPoint,isnull(B.DeductionValue,0) as DeductionValue,B.TCDocumentNo,B.SRDateTime,B.RequiredDateTime,B.SRDetails,B.TCStatus,B.PurchaseCostRM,B.IndicatorNo,B.SubParameterDetId,B.Month,B.Year,B.IsNCR,B.TCDate,B.TCCompletedDate,B.NCRNo,
			B.NCRDateTime,B.IsDemerit,B.TotalDeduction,B.GroupFlag,B.TotalTransactionCount,B.RescheduleDate,B.PurchaseDate,B.TargetPercentage,B.ServiceWorkComplaintDetails,B.ResponseCategory,B.ServiceWorkCompletionDate,B.ServiceWorkDate,B.DeductionValueperasset,
			B.B1Deduction,B.B2DemeritPoint,B.B2Deduction,B.TotalResponseTime,B.B2TotalRepairTime,B.AssetAge,B.GenPercentage,B.DemeritSlab,B.DedValue,B.FirstPrevDed,B.SecPrevDed,B.AssetRegisterId,B.VariationPurchaseCost,B.Deduction,B.CreatedBy,B.CreatedDate,B.CreatedDateUTC,
			B.ModifiedBy,B.ModifiedDate,B.ModifiedDateUTC,B.GuId,  
			@TotalRecords											AS TotalRecords,
			@pTotalPage												AS TotalPageCalc
			FROM DedGenerationTxn A INNER JOIN DedGenerationBemsPopupTxn B ON A.DedGenerationId = B.DedGenerationId
			WHERE A.FacilityId = @pFacilityId AND A.Month = @pMonth AND A.Year = @pYear and ServiceWorkNo is null AND B.IndicatorNo ='B.5'
			ORDER BY SerialNo ASC
			OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY) as DATA
			WHERE SerialNo>=1
			ORDER BY SerialNo

 END
END



 IF(@pIndicatorNo = 'B.6')  
 BEGIN  
 IF NOT EXISTS (SELECT 1 FROM DedGenerationTxn A INNER JOIN DedGenerationBemsPopupTxn B ON A.DedGenerationId = B.DedGenerationId WHERE A.FacilityId = @pFacilityId AND A.MONTH = @pMonth AND A.Year = @pYear)  
  
 BEGIN  
  

------------------- Service Work No is not null  
  
 SELECT @TotalRecords = COUNT(*)  
   from #tmpB6 t  
   where --YEAR(tc.EndDateTime) = @YEAR AND tc.EndDateTime<=@LastDate and    
   DemeritPoint>0  
  
  
 SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))  
  
 SET @pTotalPage = CEILING(@pTotalPage)  
  
  
  
 select distinct   
    CONVERT(INT,ROW_NUMBER() OVER (ORDER BY Item DESC)) AS SerialNo,  
   'B.6' AS IndicatorNo,  
   (select DedGenerationId from DedGenerationTxn where FacilityId = @pFacilityId and Month = @pMonth and Year = @pYear),  
   @pFacilityId,   
   @pMonth,  
   @pyear,  
   t.Item,  
   t.Remarks,  
   'No' as UnderWarranty,  
   DemeritPoint,  
      
   0,0,2, GETDATE(),GETUTCDATE(), 0 AS ID,  
   @TotalRecords           AS TotalRecords,  
   @pTotalPage            AS TotalPageCalc  
       
   from #tmpB6 t  
   where --YEAR(tc.EndDateTime) = @YEAR AND tc.EndDateTime<=@LastDate and    
   DemeritPoint>0  
   ORDER BY t.Item ASC  
   OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT @pPageSize  ROWS ONLY   
  
  
 END  
  
 ELSE  
      
  
 BEGIN  
     
------- select for Service Work No Not Null  
  
   SELECT @TotalRecords =  count(*) FROM DedGenerationTxn A INNER JOIN DedGenerationBemsPopupTxn B ON A.DedGenerationId = B.DedGenerationId  
   WHERE A.FacilityId = @pFacilityId AND A.Month = @pMonth AND A.Year = @pYear and ServiceWorkNo is not null  AND IndicatorNo='B.6'  
      
   SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))  
  
   SET @pTotalPage = CEILING(@pTotalPage)  
     
   SELECT * FROM (SELECT CONVERT(INT,ROW_NUMBER() OVER (ORDER BY AssetNo DESC)) AS SerialNo, b.*,    
   @TotalRecords           AS TotalRecords,  
   cast(@pTotalPage  as int)          AS TotalPageCalc  
   FROM DedGenerationTxn A INNER JOIN DedGenerationBemsPopupTxn B ON A.DedGenerationId = B.DedGenerationId  
   WHERE A.FacilityId = @pFacilityId AND A.Month = @pMonth AND A.Year = @pYear 
   --and ServiceWorkNo is not null 
   and  b.IndicatorNo='B.6'  
   ORDER BY B.AssetNo ASC  
   OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY) as DATA  
   WHERE SerialNo>=1  
   ORDER BY SerialNo  
  
 END  
 end  

	--truncate table DedgenerationResult

	----create table DedgenerationResult(IndicatorDetId INT,DeductionValue NUMERIC(24,2),DeductionPer NUMERIC(24,2),TransDemeritPoints NUMERIC(24,2))
	--insert into DedgenerationResult (IndicatorDetId,DeductionValue,DeductionPer,TransDemeritPoints)
	--SELECT IndicatorDetId,IsNULL(DeductionValue,0),ISNULL(DeductionPer,0),ISNULL(TransDemeritPoints,0)  FROM #BemsResults where IndicatorDetId between 1 and 6

	--select * from DedgenerationResult






END TRY

BEGIN CATCH
THROW
	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
				
		   )
		   
END CATCH
GO
