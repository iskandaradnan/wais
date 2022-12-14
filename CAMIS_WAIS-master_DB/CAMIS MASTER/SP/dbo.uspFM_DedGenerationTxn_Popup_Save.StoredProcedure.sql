USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_DedGenerationTxn_Popup_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspFM_DedGenerationTxn_Popup_Save] (
	@pYear INT,
	@pMonth INT,
	@pServiceId INT,
	@pFacilityId INT
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
EXEC [uspFM_DedGenerationTxn_Popup_Save] @pYear=2018,@pMonth=05, @pServiceId=2,@pFacilityId=2
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
			AND DATEDIFF(MINUTE, wo.MaintenanceWorkDateTime, ISNULL(eass.ResponseDateTime,@LastDate)) >120)
		OR (lov.FieldValue ='Critical' 
			AND DATEDIFF(MINUTE,wo.MaintenanceWorkDateTime, ISNULL(eass.ResponseDateTime,@LastDate)) >15) 
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
			AND DATEDIFF(MINUTE, wo.MaintenanceWorkDateTime, ISNULL(eass.ResponseDateTime,@LastDate)) >120)
		OR (lov.FieldValue ='Critical' 
			AND DATEDIFF(MINUTE,wo.MaintenanceWorkDateTime, ISNULL(eass.ResponseDateTime,@LastDate)) >15) 
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
	select 'B.1' as IndicatorName,ar.assetno,ar.purchasecostrm,count(*),1 
	from #tmpb1 t
	inner join EngMaintenanceWorkOrderTxn wo on t.workorderid=wo.workorderid
	inner join EngAsset ar on t.AssetId= ar.AssetId
	group by ar.assetno,ar.purchasecostrm

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
-------------------------------------------------------------------------------------------------------------------
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



	IF EXISTS (SELECT 1 FROM DedGenerationTxn A INNER JOIN DedGenerationBemsPopupTxn B ON A.DedGenerationId = B.DedGenerationId WHERE A.FacilityId = @pFacilityId AND A.MONTH = @pMonth AND A.Year = @pYear)

	BEGIN


		SELECT 'Record Already Saved' as ErrorMessage

 END

 ELSE
				

 BEGIN
 		
				
				INSERT INTO DedGenerationBemsPopupTxn
			(
				IndicatorNo,DedGenerationId,FacilityId,[Month],[Year],ServiceWorkDateTime,ServiceWorkNo,
				AssetNo,WorkGroup,AssetTypeCode,AssetDescription,UnderWarranty,ResponseDateTime,RepsonseDurationHrs,StartDateTime,
				EndDateTime,DowntimeHrs,WorkOrderStatus,DemeritPoint,

				PurchaseCostRM,UserLocationCode,ServiceWorkComplaintDetails,ResponseCategory,TotalResponseTime,ServiceWorkCompletionDate,
				ServiceWorkDate,DeductionValueperasset,B1Deduction,B2TotalRepairTime,B2DemeritPoint,GroupFlag,
				
				IsNCR,IsDemerit,CreatedBy,CreatedDate,CreatedDateUTC,ID
			)

	select distinct
			'B.1',
			(select DedGenerationId from DedGenerationTxn where FacilityId = @pFacilityId and Month = @pMonth and Year = @pYear) AS DedGenerationId,
			@pFacilityId AS FacilityId, 
			@pMonth AS Month,
			@pyear AS year,
			FORMAT (wo.MaintenanceWorkDateTime,'dd-MMM-yyyy HH:mm') as 'Service Work Date/Time',
			wo.MaintenanceWorkNo as 'Service Work No.',
			ar.AssetNo as 'Asset No.',
			wg.WorkGroupDescription as 'Work Group',
			atc.AssetTypeCode as 'Asset Type Code',
			atc.AssetTypeDescription AS 'Asset Description',
			CASE WHEN cast(ar.WarrantyEndDate as date) >= cast(GETDATE() as date) THEN 'Yes' ELSE 'No' END AS 'Under Warranty',
			FORMAT(wa.ResponseDateTime ,'dd-MMM-yyyy HH:mm') as 'Response Date/Time',
			CAST((DATEDIFF(MINUTE,wo.MaintenanceWorkDateTime,wa.ResponseDateTime)/60.00) AS DECIMAL(18,2)) as 'Repsonse Duration (Hrs)',
			FORMAT(wc.StartDateTime,'dd-MMM-yyyy HH:mm') as 'Start Date/Time',
			FORMAT(wc.EndDateTime,'dd-MMM-yyyy HH:mm')  as 'End Date/Time',
			CAST(DATEDIFF(MINUTE,wo.MaintenanceWorkDateTime,wc.EndDateTime) / 60.00 AS DECIMAL(18,2)) 'Downtime (Hrs)',
			wslov.FieldValue AS 'Work Order Status',
			1 as 'Demerit Points',
			t.PurchaseCostRM,
			LUL.UserLocationCode,
			wo.MaintenanceDetails as [ServiceWorkComplaintDetails],
			t.FieldValue as [ResponseCategory],
			t.Mins as [TotalResponseTime],
			FORMAT(wc.EndDateTime,'dd-MMM-yyyy HH:mm') as [ServiceWorkCompletionDate],
			FORMAT(wo.MaintenanceWorkDateTime,'dd-MMM-yyyy HH:mm') as [ServiceWorkDate],
			t.DeductionValue as [DeductionValueperasset],
			--'Y' as [B1ValidateStatus],
			t.DeductionValue as [B1Deduction],
			-- '' as [B1RemarksExemption],
			-- 'N' as [B2ValidateStatus],
			0 as [B2TotalRepairTime],
			0 as [B2DemeritPoint],
			-- 0 as [B2Deduction],
			-- '' as [B2RemarksExemption],
			CASE WHEN MONTH(wo.MaintenanceWorkDateTime) = @pMonth and YEAR(wo.MaintenanceWorkDateTime) = @pYear AND wc.EndDateTime is not null THEN 'D. Current Month (Work order closed/completed)' 
				ELSE CASE WHEN MONTH(wo.MaintenanceWorkDateTime) = @pMonth and YEAR(wo.MaintenanceWorkDateTime) = @pYear AND wc.EndDateTime IS NULL THEN 'C. Current Month (Work order still open)'
				ELSE CASE WHEN MONTH(wo.MaintenanceWorkDateTime) < @StartDate AND wc.EndDateTime IS NULL THEN 'A. Prevoius Month (Work order still open)' 
				ELSE CASE WHEN MONTH(wo.MaintenanceWorkDateTime) < @StartDate AND wc.EndDateTime IS NOT NULL THEN 'B. Prevoius Month (Work order closed/completed)' 
				END END END END  GroupFlag,
			0,0,2, GETDATE(),GETUTCDATE(), 0

			 from #tmpB1 t
			left join EngMaintenanceWorkOrderTxn wo on t.workorderid=wo.workorderid
			inner join EngAsset ar on t.assetid= ar.assetid
			left join EngMwoAssesmentTxn wa on wo.WorkOrderId = wa.WorkOrderId 
			left join EngMwoCompletionInfoTxn wc on wo.WorkOrderId = wc.WorkOrderId 
			left join MstLocationUserLocation LUL on ar.UserLocationId = LUL.UserLocationId
			--LEFT JOIN SrServiceRequestMst sr on t.ServiceRequestId = sr.ServiceRequestId and sr.IsDeleted = 0
			--left join MstStaff fs on fs.StaffMasterId = sr.FmsStaffMstId --and fs.IsDeleted = 0
			LEFT JOIN EngAssetWorkGroup AS wg on ar.WorkGroupId = wg.WorkGroupId	
			left join EngAssetTypeCode atc on ar.assettypecodeid = atc.AssetTypeCodeId
			left join FMLovMst wslov on wo.WorkOrderStatus = wslov.LovId
			where wo.FacilityId = @pFacilityId

			-----------------------------------------------


			INSERT INTO DedGenerationBemsPopupTxn
			(
				IndicatorNo,DedGenerationId,FacilityId,[Month],[Year],AssetNo,PurchaseCost,DemeritValue1,DemeritPoint,DeductionValue,
				IsNCR,IsDemerit,CreatedBy,CreatedDate,CreatedDateUTC,ID
			)
			SELECT 
			'B.1',
			(select DedGenerationId from DedGenerationTxn where FacilityId = @pFacilityId and Month = @pMonth and Year = @pYear),
			@pFacilityId, 
			@pMonth,
			@pYear, 
			AssetNo as 'Asset No.',
			PurchaseCost as 'Purchase Cost (RM)',
			DemeritValue as 'Demerit Value (RM)',
			DemeritPoint as 'Demerit Point',
			cast(DemeritPoint*DemeritValue AS decimal(12,2)) as 'Deduction (RM)',
			0,1,2, GETDATE(),GETUTCDATE() ,0
			FROM #TotalParameterDeduction





 END



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
