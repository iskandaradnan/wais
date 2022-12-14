USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[BEMSDeductionDemeritMappingSaveB1]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[BEMSDeductionDemeritMappingSaveB1]
	@pDedGenerationId int,
	@pFacilityId int,
	@pServiceId int,
	@pMonth int,
	@pYear int,
	
	@pCreatedBy int,
	@pDedGenerationType int= null
AS 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--	-- Exec [BEMSDeductionDemeritMappingSaveB1] 2,2,2,04,2018,1

--/*=====================================================================================================================
--APPLICATION		: ASIS
--NAME				: Popup for B1 Indicator
--DESCRIPTION		: BEMS - DEDUCTION INDICATORS
--AUTHORS			: Raguraman J
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:------------:---------------------------------------------------------------------------------------
--Init				: Date       : Details
--------------------:------------:---------------------------------------------------------------------------------------
--Raguraman J       : 04/15/2016 : B1
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	/*
	Declare 
	@pServiceId int=2,
	@pFacilityId int=118,
	@pMonth int=1,	
	@pYear int=2017
	--*/

DECLARE @StartDate AS DATETIME , @LastDate AS DATETIME, @EOM AS DATETIME, @EOMT AS DATETIME
	
	SET @StartDate= DATEFROMPARTS(@pYear, @pMonth , 01)
	SET @EOM = CAST(EOMONTH(@StartDate) AS DATE)
	SET @EOMT = DATEADD(ms, -100, DATEADD(s, 86400, @EOM))	
	SET @LastDate  = @EOMT
	if(@pMonth=MONTH(GETDATE()))
	Begin
	SET @LastDate = GETDATE()
	End

	IF OBJECT_ID('tempdb..#TotalParameterDemerit') IS NOT NULL
	DROP TABLE #TotalParameterDemerit

	create table #TotalParameterDemerit
	(
		IndicatorName nvarchar(300),
		AssetNo nvarchar(300),
		AssetDescription nvarchar(300),
		TypeofTransaction nvarchar(300),
		Totalrecords nvarchar(300),
		ServiceWorkOrder nvarchar(300),
	)	

	IF OBJECT_ID('tempdb..#TotalParameterDeduction') IS NOT NULL
	DROP TABLE #TotalParameterDeduction

	create table #TotalParameterDeduction
	(
		IndicatorName nvarchar(300),
		AssetNo nvarchar(300),
		PurchaseCost nvarchar(300),
		DemeritPoint nvarchar(300),
		DemeritValue decimal(12,2)
	)	
	--===========================================
	-- The asset is exemption approved.
	--=========================================== 

	DECLARE @AssetApprExem INT;
	SELECT @AssetApprExem = LovId 
							FROM FMLovMst 
							WHERE LovKey = 'ASConclusionValue' 
							AND FieldCode = 2
							--AND FieldValue='Approved for Exemption';
	--select @AssetApprExem
	---------------------------------------------

	--===========================================
	--Asset Exemption Approved from BER service - Get All Assets
	--===========================================
	IF OBJECT_ID('tempdb..#tmpBerAssets') IS NOT NULL
	DROP TABLE #tmpBerAssets

	select ba.AssetId
	INTO #tmpBerAssets
	from   BerApplicationTxn ba join BerApplicationHistoryTxn bh on ba.ApplicationId=bh.ApplicationId 
    inner join EngAsset ar on ba.AssetId=ar.AssetId
    where bh.[Status]  IN (208)
    AND ba.ApplicationDate <= @LastDate
	and CAST(@LastDate AS DATE) >= CAST(bh.CreatedDate AS DATE) and ba.FacilityId = @pFacilityId
	and ar.Active=1 and ar.ServiceId=@pServiceId and ar.FacilityId = @pFacilityId
	and ar.[Authorization] = 199
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
	AND ar.FacilityId = @pFacilityId
	AND ar.Active =1
	AND ar.AssetId NOT IN (SELECT AssetId FROM #tmpBerAssets)

	-- Select * from #tmpAssetRegister where assetregisterid=236243
	---------------------------------------------

	--===========================================
	-- Working days in a month for the selected hospital state
	--===========================================
	DECLARE @pMonthWorkingDays int

	SELECT @pMonthWorkingDays = COUNT(*)		
	-- SELECT COUNT(*)	
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

	IF OBJECT_ID('tempdb..#tmpAdvisory') IS NOT NULL
	DROP TABLE #tmpAdvisory
	
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

	---------------------------------------------

	--===========================================
	--Asset Below Ememption applied for Variation Status V2, V4 or V5.	
	--===========================================
	SELECT snf.AssetId as AssetId
	INTO #tmpSnfAssets
	FROM EngTestingandCommissioningTxn snf 
	INNER JOIN EngMaintenanceWorkOrderTxn wo on snf.AssetId = wo.AssetId	
												AND snf.VariationStatus IN 
													(SELECT LovId 
													FROM FMLovMst 		
													WHERE ModuleName = 'FEMS'
													AND LovKey = 'VariationStatusValue' 
													AND FieldCode IN (3,4,6))
	WHERE wo.FacilityId = @pFacilityId
	AND wo.ServiceId=@pServiceId	
	

	--select * from #tmpSnfAssets
	--===========================================
	-- Get all Rejected Exemptions workorders
	--===========================================
	SELECT wo.WorkOrderId, wo.MaintenanceWorkNo, wo.WorkOrderPriority, wo.MaintenanceDetails
	    , wo.AssetId, wo.MaintenanceWorkDateTime, wo.CustomerId
		, wo.FacilityId, wo.ServiceId, wo.MaintenanceWorkCategory
		, wo.TargetDateTime, wo.TypeOfWorkOrder, ar.AssetNo,typedec.AssetTypeDescription as AssetDescription
		, ar.PurchaseCostRM, ar.TestingandCommissioningdetId, ar.UserLocationId, wo.UserAreaId
	INTO #tmpWorkOrder
	FROM EngMaintenanceWorkOrderTxn wo
	INNER JOIN EngAsset ar (NOLOCK) ON ar.AssetId = wo.AssetId 
    LEFT Join EngAssetTypeCode typedec on ar.AssetTypeCodeId=typedec.AssetTypeCodeId and typedec.Active=1
	LEFT JOIN engmwocompletioninfotxn wc ON wo.workorderid=wc.workorderid
	WHERE 
	ar.[Authorization] = 199 -- Authorized
	AND ar.AssetStatusLovId = 1 -- Active
	AND ar.CommissioningDate <= @LastDate
	AND ar.ServiceId = @pServiceId
	AND ar.FacilityId = @pFacilityId

	AND ar.Active = 1
	and wo.ServiceId = @pServiceId 
	AND wo.FacilityId = @pFacilityId

	AND wo.MaintenanceWorkDateTime <= @LastDate
	AND wo.WorkOrderStatus not in  (196,197)
	--AND (wc.EndDatetime IS NULL OR (MONTH(wc.EndDatetime)=@pMonth AND YEAR(wc.EndDatetime)=@pYear))	
	AND wo.AssetId NOT IN (SELECT AssetId FROM #tmpSnfAssets)
	AND ar.AssetId NOT IN (SELECT AssetId FROM #tmpBerAssets)
		
	-- select * from #tmpWorkOrder where assetregisterid=236243
	---------------------------------------------						

--=================================================================================================
--								BEMS Indicator - B1												 --
--=================================================================================================

	--===========================================
	-- B1 Temp Tables
	--===========================================

	IF OBJECT_ID('tempdb..#tmpB1') IS NOT NULL
	DROP TABLE #tmpB1

	IF OBJECT_ID('tempdb..#tmpB3Ncr') IS NOT NULL
	DROP TABLE #tmpB3Ncr
	---------------------------------------------
	--===========================================
	--Response Time: Normal call: 120 minutes, Emergency call: 15 minutes
	--===========================================
	
		SELECT 
		  wo.WorkOrderId
		, wo.MaintenanceWorkNo
		, wo.AssetId
		, wo.AssetNo
		, wo.AssetDescription
		, wo.PurchaseCostRM
		, wo.WorkOrderPriority
		, lov.FieldValue
		, wo.UserLocationId
		, case when ul.UserLocationCode is null then '' else ul.UserLocationCode end as UserLocationCode
		, WO.MaintenanceDetails
		, wo.maintenanceworkdatetime AS SRDate
		, wc.EndDateTime AS CompletionDate
		, COUNT(*) AS CountofReq
		, DATEDIFF(MINUTE,wo.MaintenanceWorkDateTime, ISNULL(eass.ResponseDateTime,@LastDate)) as Mins
		, CASE WHEN (lov.FieldValue ='Normal' AND DATEDIFF(MINUTE, wo.MaintenanceWorkDateTime, ISNULL(eass.ResponseDateTime,@LastDate)) >120)
		  OR (lov.FieldValue ='Critical' AND DATEDIFF(MINUTE,wo.MaintenanceWorkDateTime, ISNULL(eass.ResponseDateTime,@LastDate)) >15) 
		  THEN 1 ELSE 0 END AS Demeritpoint 
		, tmp.DeductionValue
		, 0 as TotalDeduction
		, 0 TotalRepairTime
		, 0 B2DemeritPoint
		, 0 B2Deduction
		,'Y' B1ValidateStatus
		, 'N' B2ValidateStatus
		, MONTH(wo.maintenanceworkdatetime) as StartedMonth
		, MONTH(eass.ResponseDateTime) as CompletedMonth

		INTO #tmpB1
		FROM #tmpWorkOrder wo (NOLOCK)	
		INNER JOIN FMLovMst lov (NOLOCK) ON lov.LovId = wo.WorkOrderPriority
		LEFT JOIN EngMwoAssesmentTxn eass (NOLOCK) ON eass.WorkOrderId = wo.WorkOrderId
		LEFT JOIN EngMwoCompletionInfoTxn wc ON wo.WorkOrderId = wc.WorkOrderId
		LEFT JOIN MstLocationUserLocation ul (NOLOCK) ON wo.UserLocationId = ul.UserLocationId AND ul.Active = 1 
		CROSS JOIN #tmpAssetSlab tmp 
		WHERE wo.PurchaseCostRM BETWEEN tmp.CostStart AND ISNULL(tmp.CostEnd,wo.PurchaseCostRM)	
		and convert(varchar(6),wo.MaintenanceWorkDateTime,112) = convert(varchar(6),@StartDate,112)	
		AND ((Eass.ResponseDateTime IS NULL ) 
		OR (cast(eass.ResponseDateTime as date)>=cast(@StartDate as date)))	
		AND wo.MaintenanceWorkCategory IN (188) -- Unscheduled 	
		AND (CASE WHEN (lov.FieldValue ='Normal' 
		AND DATEDIFF(MINUTE, wo.MaintenanceWorkDateTime, ISNULL(eass.ResponseDateTime,@LastDate)) >120)
		OR (lov.FieldValue ='Critical' AND DATEDIFF(MINUTE,wo.MaintenanceWorkDateTime, ISNULL(eass.ResponseDateTime,@LastDate)) >15) 
		THEN 1 ELSE 0 END)>0 	
		GROUP BY wo.WorkOrderId, wo.AssetId, wo.FacilityId, wo.CustomerId, wo.PurchaseCostRM
		, WO.WorkOrderPriority, lov.FieldValue,wo.maintenanceworkdatetime, eass.ResponseDateTime, wc.EndDateTime, tmp.DeductionValue
		, wo.UserLocationId
		, ul.UserLocationCode
		, wo.MaintenanceDetails
		, eass.ResponseDateTime 
		, wo.MaintenanceWorkNo, wo.AssetNo, wo.AssetDescription
	 
		--insert INTO #tmpB1
		--select 	 
		--	isnull(emw.WorkOrderId,0)
		--, isnull(emw.MaintenanceWorkNo,RequestNo) as MaintenanceWorkNo
		--, ar.AssetId		
		--, ar.AssetNo
		--, ar.AssetDescription
		--, sr.ServiceRequestId	
		--, ar.PurchaseCostRM
		--, sr.[Priority]
		--, lov.FieldValue
		--, ar.EngUserLocationId
		--, case when ful.UserLocationCode is null then '' else ful.UserLocationCode end as UserLocationCode
		--, sr.Details
		--, sr.datetime AS SRDate
		--, null AS CompletionDate
		--, COUNT(*) AS CountofReq
		--, DATEDIFF(MINUTE,sr.[DateTime], ISNULL(null,@LastDate)) as Mins
		--, count (1) AS Demeritpoint
		--, tmp.DeductionValue
		--, 0 as TotalDeduction
		--, 0 TotalRepairTime
		--, 0 B2DemeritPoint
		--, 0 B2Deduction
		--,'Y' B1ValidateStatus
		--,'N' B2ValidateStatus
		--, MONTH(sr.datetime) as StartedMonth
		--, null as CompletedMonth

		--from EngMaintenanceWorkOrderTxn  sr
		--join EngAsset ar  on ar.AssetId = sr.AssetId	
		--INNER JOIN FMLovMst lov (NOLOCK) ON lov.LovId = sr.[Priority] AND lov.IsDeleted = 0 
		--left join FmsStaffMst fs on fs.StaffMasterId = sr.FmsStaffMstId --and fs.IsDeleted = 0
		--LEFT JOIN GmWorkGroupDetailsMst AS wg on ar.WorkGroupId = wg.WorkGroupId and wg.IsDeleted = 0
		--LEFT JOIN EngUserLocationMst eul  ON ar.EngUserLocationId = eul.EngUserLocationId
		--LEFT JOIN FmsUserLocationMst ful  ON eul.UserLocationId = ful.UserLocationId
		--LEFT JOIN FmsUserAreaMst fua  ON ful.FmsUserAreaId = fua.FmsUserAreaId	
		--CROSS JOIN #tmpAssetSlab tmp 
		--where convert(varchar(6),DateTime,112) = convert(varchar(6),@StartDate,112)
		--and  ar.PurchaseCostRM BETWEEN tmp.CostStart AND ISNULL(tmp.CostEnd,ar.PurchaseCostRM)	
		--and ar.[Authorization]=4799 
		--and ar.AssetStatus=127	
		--and sr.IsDeleted = 0
		--and srd.IsDeleted = 0
		--and srd.TypeOfRequest = 973		
		--and ar.IsDeleted = 0
		--and sr.FacilityId = @pFacilityId

		--and ar.FacilityId = @pFacilityId

		--and ar.ServiceId = @pServiceId
		--and sr.Service = @pServiceId
		--and ar.WarrantyEndDate is not null
		----AND (ar.AssetClassification in (2325,2326) or  ar.WarrantyEndDate is not null)
		--AND sr.[Status] not in  (2315,5887)
		--and emw.WorkOrderId is null
		--AND ar.AssetId not in (SELECT AssetId FROM #tmpBerAssets)
		--GROUP BY 
		--emw.WorkOrderId
		--, ar.AssetId
		--, sr.ServiceRequestId
		--, ar.FacilityId
		--, ar.CompanyId
		--, ar.PurchaseCostRM
		--, sr.[Priority]
		--, lov.FieldValue
		--, sr.[DateTime]
		--, tmp.DeductionValue
		--, ar.EngUserLocationId
		--, ful.UserLocationCode
		--, sr.Details	
		--, emw.MaintenanceWorkNo
		--, sr.RequestNo 
		--, ar.AssetNo
		--, ar.AssetDescription




	INSERT INTO #TotalParameterDeduction
	select 'B.1' as IndicatorName,ar.assetno,ar.purchasecostrm,count(*) , DeductionValue
	from #tmpb1 t
	left join EngMaintenanceWorkOrderTxn wo on t.workorderid=wo.workorderid
	inner join EngAsset ar on t.AssetId= ar.AssetId
	group by ar.assetno,ar.purchasecostrm,DeductionValue



	-- Demerit Point 

			INSERT INTO DedGenerationBemsPopupTxn
			(
				IndicatorNo,DedGenerationId,FacilityId,[Month],[Year],ServiceWorkDateTime,ServiceWorkNo,
				AssetNo,WorkGroup,AssetTypeCode,AssetDescription,UnderWarranty,Requestor,ResponseDateTime,RepsonseDurationHrs,StartDateTime,
				EndDateTime,DowntimeHrs,WorkOrderStatus,DemeritPoint,SRDetails,

				PurchaseCostRM,UserLocationCode,ServiceWorkComplaintDetails,ResponseCategory,TotalResponseTime,ServiceWorkCompletionDate,
				ServiceWorkDate,DeductionValueperasset,B1Deduction,B2TotalRepairTime,B2DemeritPoint,GroupFlag,
				IsDemerit,CreatedBy,CreatedDate,CreatedDateUTC
			)

			select distinct
			'B.1',
			@pDedGenerationId,
			@pFacilityId, 
			@pMonth,
			@pYear,
			FORMAT(wo.MaintenanceWorkDateTime,'dd-MMM-yyyy HH:mm') as 'Service Work Date/Time',
			wo.MaintenanceWorkNo as 'Service Work No.',
			ar.AssetNo as 'Asset No.',
			wg.WorkGroupDescription as 'Work Group',
			atc.AssetTypeCode as 'Asset Type Code',
			atc.AssetTypeDescription AS 'Asset Description',
			CASE WHEN cast(ar.WarrantyEndDate as date) >= cast(GETDATE() as date) THEN 'Yes' ELSE 'No' END AS 'Under Warranty',
			fs.StaffName as 'Requestor',
			FORMAT(wa.ResponseDateTime ,'dd-MMM-yyyy HH:mm') as 'Response Date/Time',
			CAST((DATEDIFF(MINUTE,wo.MaintenanceWorkDateTime,wa.ResponseDateTime)/60.00) AS DECIMAL(18,2)) as 'Repsonse Duration (Hrs)',
			FORMAT(wc.StartDateTime,'dd-MMM-yyyy HH:mm') as 'Start Date/Time',
			FORMAT(wc.EndDateTime,'dd-MMM-yyyy HH:mm')  as 'End Date/Time',
			CAST(DATEDIFF(MINUTE,wo.MaintenanceWorkDateTime,wc.EndDateTime) / 60.00 AS DECIMAL(18,2)) 'Downtime (Hrs)',
			wslov.FieldValue AS 'Work Order Status',
			1 as 'Demerit Points',
			wo.MaintenanceDetails as 'SR Details',
			t.PurchaseCostRM,
			t.UserLocationCode,
			t.MaintenanceDetails as [ServiceWorkComplaintDetails],
			t.FieldValue as [ResponseCategory],
			t.Mins as [TotalResponseTime],
			FORMAT(t.CompletionDate,'dd-MMM-yyyy HH:mm') as [ServiceWorkCompletionDate],
			FORMAT(t.SRDate,'dd-MMM-yyyy HH:mm') as [ServiceWorkDate],
			t.DeductionValue as [DeductionValueperasset],
			t.DeductionValue as [B1Deduction],
			t.TotalRepairTime as [B2TotalRepairTime],
			t.B2DemeritPoint as [B2DemeritPoint],
			CASE WHEN MONTH(SRDate) = @pMonth and YEAR(SRDate) = @pYear AND CompletionDate is not null THEN 'D. Current Month (Work order closed/completed)' 
				ELSE CASE WHEN MONTH(SRDate) = @pMonth and YEAR(SRDate) = @pYear AND CompletionDate IS NULL THEN 'C. Current Month (Work order still open)'
				ELSE CASE WHEN MONTH(SRDate) < @StartDate AND CompletionDate IS NULL THEN 'A. Prevoius Month (Work order still open)' 
				ELSE CASE WHEN MONTH(SRDate) < @StartDate AND CompletionDate IS NOT NULL THEN 'B. Prevoius Month (Work order closed/completed)' 
				END END END END GroupFlag,
0,@pCreatedBy, GETDATE(),GETUTCDATE()

			from #tmpb1 t
			left join EngMaintenanceWorkOrderTxn wo on t.workorderid=wo.workorderid
			inner join EngAsset ar on t.AssetId= ar.AssetId
			left join EngMwoAssesmentTxn wa on wo.WorkOrderId = wa.WorkOrderId
			left join EngMwoCompletionInfoTxn wc on wo.WorkOrderId = wc.WorkOrderId
			left join MstStaff fs on fs.StaffMasterId = WO.EngineerStaffId --and fs.IsDeleted = 0
			LEFT JOIN EngAssetWorkGroup AS wg on ar.WorkGroupId = wg.WorkGroupId	
			left join EngAssetTypeCode atc on ar.assettypecodeid = atc.AssetTypeCodeId
			left join FMLovMst wslov on wo.WorkOrderStatus = wslov.LovId
			where wo.FacilityId = @pFacilityId

	-- Demerit Type 1

			 INSERT INTO DedGenerationBemsPopupTxn
			(
				IndicatorNo,DedGenerationId,FacilityId,[Month],[Year],AssetNo,PurchaseCost,DemeritValue1,DemeritPoint,DeductionValue,
				IsNCR,IsDemerit,CreatedBy,CreatedDate,ID
			)
			SELECT 
			'B.1',
			@pDedGenerationId,
			@pFacilityId, 
			@pMonth,
			@pYear, 
			AssetNo as 'Asset No.',
			PurchaseCost as 'Purchase Cost (RM)',
			DemeritValue as 'Demerit Value (RM)',
			DemeritPoint as 'Demerit Point',
			cast(DemeritPoint*DemeritValue AS decimal(12,2)) as 'Deduction (RM)',
			0,1,@pCreatedBy, GETDATE(), 0
			FROM #TotalParameterDeduction

			select * from #tmpB1
			select * from #TotalParameterDeduction
END TRY
BEGIN CATCH
--select error_message()
insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate());

		throw;

END CATCH
SET NOCOUNT OFF
END
GO
