USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAsset_TemplateExport]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/*========================================================================================================  
Application Name : UETrack-BEMS                
Version    : 1.0  
Procedure Name  : UspFM_EngAsset_GetById  
Description   : To Get the data from table EngAsset using the Primary Key id  
Authors    : Balaji M S  
Date    : 30-Mar-2018  
-----------------------------------------------------------------------------------------------------------  
  
Unit Test:  
EXEC [UspFM_EngAsset_GetById]  @pAssetId=153  
SELECT * FROM EngAsset  
-----------------------------------------------------------------------------------------------------------  
Version History   
-----:------------:---------------------------------------------------------------------------------------  
Init : Date       : Details  
========================================================================================================*/  
CREATE PROCEDURE  [dbo].[uspFM_EngAsset_TemplateExport]                             
  
  @pAssetId    INT   
AS                                                
  
BEGIN TRY  
  

 SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  

  
 IF(ISNULL(@pAssetId,0) = 0) RETURN  
  
 DECLARE @TotSchdDownTime NUMERIC(24,2)  
 DECLARE @TotUnSchdDownTime NUMERIC(24,2)  
 DECLARE @DefectList INT  
 DECLARE @pPreviousAssetNo NVARCHAR(100),@pPreviousAssetID INT   
 Declare	@pLovIdSupplierCategoryMainSupplier		INT	=	13

 --------- Main Supplier ---------------



-- RealTimeStatus from Work Order -AssesmentTxn  
 --SET @pPreviousAssetID = (SELECT PreviousAssetNo FROM EngAsset WHERE AssetId = @pAssetId)  
 --SET @pPreviousAssetNo = (SELECT AssetNo FROM EngAsset WHERE AssetId = @pPreviousAssetID)  
  
 SELECT TOP 1 Asset.AssetNo,   
   ISNULL(MWOAssetssment.AssetRealtimeStatus,55)AssetRealtimeStatus,  
   ISNULL(LovRealTimeStatus.FieldValue,'Functioning') AS AssetRealTimeStatusValue   
   INTO #AssetRealTimeStatus   
 FROM EngMaintenanceWorkOrderTxn AS MWO  
   INNER JOIN EngAsset AS Asset ON MWO.AssetId=Asset.AssetId  
   INNER JOIN EngMwoAssesmentTxn AS MWOAssetssment ON MWO.WorkOrderId=MWOAssetssment.WorkOrderId  
   LEFT JOIN FMLovMst AS LovRealTimeStatus ON MWOAssetssment.AssetRealtimeStatus=LovRealTimeStatus.LovId  
 WHERE MWO.AssetId=@pAssetId  
 --GROUP BY MWO.AssetId  
 ORDER BY MWO.CreatedDate DESC  
  
-- Asset Maintenance Tab from Work Order  
 --1 Scheduled  
 SELECT @TotSchdDownTime=SUM(CompletionInfo.DowntimeHoursMin)     
   FROM EngMaintenanceWorkOrderTxn AS MWO   
   LEFT JOIN EngMwoCompletionInfoTxn AS CompletionInfo ON MWO.WorkOrderId=CompletionInfo.WorkOrderId  
   LEFT JOIN EngMwoPartReplacementTxn AS PartRep   ON MWO.WorkOrderId=PartRep.WorkOrderId  
 WHERE MWO.AssetId=@pAssetId  
   AND MaintenanceWorkCategory = 187  
 GROUP BY MWO.AssetId  
  
 SELECT TOP 1 MWO.MaintenanceWorkNo  AS LastSchduledWorkOrderNo,  
   MWO.MaintenanceWorkDateTime  AS LastSchduledWorkOrderDateTime,  
   CompletionInfo.DowntimeHoursMin,  
   @TotSchdDownTime    AS TotDowntimeHoursMinYTD  
   INTO #AssetMaintenanceSchd  
 FROM EngMaintenanceWorkOrderTxn AS MWO   
   LEFT JOIN EngMwoCompletionInfoTxn AS CompletionInfo ON MWO.WorkOrderId=CompletionInfo.WorkOrderId  
 WHERE MWO.AssetId=@pAssetId  
   AND MaintenanceWorkCategory = 187  
 ORDER BY MWO.CreatedDate DESC  
  
  
 --2 UnScheduled  
 SELECT @TotUnSchdDownTime = SUM(CompletionInfo.DowntimeHours)   
   FROM EngMaintenanceWorkOrderTxn AS MWO   
   LEFT JOIN EngMwoCompletionInfoTxn AS CompletionInfo ON MWO.WorkOrderId=CompletionInfo.WorkOrderId  
 WHERE MWO.AssetId=@pAssetId  
   AND MaintenanceWorkCategory = 188  
 GROUP BY MWO.AssetId  
  
 SELECT TOP 1 MWO.MaintenanceWorkNo  AS LastUnSchduledWorkOrderNo,  
   MWO.MaintenanceWorkDateTime  AS LastUnSchduledWorkOrderDateTime,  
   CompletionInfo.DowntimeHoursMin,  
   @TotUnSchdDownTime    AS TotDowntimeHoursMinYTD  
   INTO #AssetMaintenanceUnSchd  
 FROM EngMaintenanceWorkOrderTxn AS MWO   
   LEFT JOIN EngMwoCompletionInfoTxn AS CompletionInfo ON MWO.WorkOrderId=CompletionInfo.WorkOrderId  
 WHERE MWO.AssetId=@pAssetId  
   AND MaintenanceWorkCategory = 188  
 ORDER BY MWO.CreatedDate DESC  
  
  
   --------------------------- Accessories Description -------------------------------------
   Declare @AccessoriesDescription varchar(2000)= null 
   Declare @VariationStatus varchar(2000)= null 
   Declare @AuthorizedStatus varchar(2000)= null 
   Declare @UnderWarranty varchar(2000)= null 
   Set @AccessoriesDescription=( SELECT	top 1 AssetAccessories.AccessoriesDescription AS AccessoriesDescription
			
	FROM	EngAssetAccessories									AS AssetAccessories			WITH(NOLOCK)
			INNER JOIN	EngAsset								AS Asset					WITH(NOLOCK)			on AssetAccessories.AssetId				= Asset.AssetId
			--LEFT JOIN  EngAssetStandardizationManufacturer		AS Manufacturer				WITH(NOLOCK)			on AssetAccessories.Manufacturer		= Manufacturer.ManufacturerId
			--LEFT JOIN  EngAssetStandardizationModel			AS Model					WITH(NOLOCK)			on AssetAccessories.Model				= Model.ModelId
	WHERE	AssetAccessories.AssetId = @pAssetId 
	ORDER BY AssetAccessories.ModifiedDate DESC)

	 set @VariationStatus = (SELECT top 1 VariationStatus	FROM [V_EngAsset] where AssetId= @pAssetId)

   set @AuthorizedStatus = (SELECT top 1 [AuthorizationStatus]	FROM [V_EngAsset] where AssetId= @pAssetId)

   set @UnderWarranty= (SELECT			

					CASE WHEN TestingandCommissioning.WarrantyEndDate >=	GETDATE()	THEN 'Yes'
				         WHEN TestingandCommissioning.WarrantyEndDate <	GETDATE()	THEN 'No'
				         ELSE	NULL	
			         END AS WarrantyStatus	
		            FROM	EngTestingandCommissioningTxn										AS TestingandCommissioning		WITH(NOLOCK)
					LEFT JOIN  EngTestingandCommissioningTxnDet							AS TestingandCommissioningDet	WITH(NOLOCK)			on TestingandCommissioningDet.TestingandCommissioningId		= TestingandCommissioning.TestingandCommissioningId
					LEFT JOIN  EngAsset							AS Asset	WITH(NOLOCK)			on Asset.TestingandCommissioningDetId		= TestingandCommissioningDet.TestingandCommissioningDetId
					OUTER APPLY (	SELECT  CASE WHEN COUNT(1)>0 THEN 1 
									ELSE 0 END AS IsUsed
							FROM EngAsset AS A WHERE  A.TestingandCommissioningDetId=TestingandCommissioningDet.TestingandCommissioningDetId
						 ) PreRegUsed
					    Where Asset.AssetId=@pAssetId
						 )





	--------------------------- Accessories Description -------------------------------------

  

  
-- PurchaseDetails Tab from Work Order-- Cumilative costs  
 --1 Scheduled  
 SELECT AssetId,  
   SUM(ISNULL(PartRep.TotalPartsCost,0))  AS CumilativePartsCost,  
   SUM(ISNULL(PartRep.LabourCost,0)) +   
   SUM(((ISNULL(CAST(PARSENAME(C.RepairHours, 2) AS INT),0) * 60) + ISNULL(CAST(PARSENAME(C.RepairHours, 1) AS INT),0)) * ISNULL(D.LabourCostPerHour, 0)/60) AS CumilativeLabourCost,  
   0 AS CumilativeContractorCost  
   INTO #CumilativeCosts  
   FROM EngMaintenanceWorkOrderTxn AS MWO   
   LEFT JOIN EngMwoCompletionInfoTxn AS CompletionInfo ON MWO.WorkOrderId=CompletionInfo.WorkOrderId  
   LEFT JOIN EngMwoPartReplacementTxn AS PartRep   ON MWO.WorkOrderId=PartRep.WorkOrderId  
   --LEFT JOIN EngMwoCompletionInfoTxn B ON A.WorkOrderId = B.WorkOrderId  
   LEFT JOIN EngMwoCompletionInfoTxnDet C ON CompletionInfo.CompletionInfoId = C.CompletionInfoId  
   LEFT JOIN UMUserRegistration D ON C.UserId = D.UserRegistrationId  
  
 WHERE MWO.AssetId=@pAssetId  
 GROUP BY MWO.AssetId  
  
 declare @CumilativeContractValue numeric(30,2)  
  
 SELECT @CumilativeContractValue = SUM(ContractValue)  
      from EngContractOutRegister COR  
      inner join  EngContractOutRegisterDet CORDet on COR.ContractId=CORDet.ContractId   
      WHERE CORDet.AssetId=@pAssetId  


-- Defect List  
 SET @DefectList=0  
 SELECT @DefectList=COUNT(1)  
 FROM EngDefectDetailsTxn WHERE AssetId = @pAssetId  
  
   
-- ParentAsset  
  
 SELECT TOP 1 AssetNo,AssetDescription   
 INTO #ParentAssetNo  
 FROM EngAsset WHERE AssetId in (  
 SELECT AssetParentId FROM EngAsset WHERE AssetId=@pAssetId)  
  
  
    SELECT DISTINCT Asset.AssetId            AS AssetId,  
   Faci.FacilityName,
   @AccessoriesDescription as Accessories,
   @VariationStatus         as Variationstatus,
   @AuthorizedStatus as AuthorizedStatus,
   @UnderWarranty as UnderWarranty,
   Asset.CustomerId           AS CustomerId,  
   Asset.FacilityId           AS FacilityId,  
   Asset.ServiceId            AS ServiceId,  
   AssetService.ServiceKey          AS ServiceName,  
   Asset.AssetNo            AS AssetNo,  
   Asset.AssetPreRegistrationNo        AS AssetPreRegistrationNo,  
   Asset.TestingandCommissioningDetId       AS TestingandCommissioningDetId,  
   Asset.AssetTypeCodeId          AS AssetTypeCodeId,  
   AssetTypeCode.AssetTypeCode         AS AssetTypeCode,  
   AssetTypeCode.AssetTypeDescription       AS AssetTypeDescription,  
   Asset.AssetClassification         AS AssetClassification,  
   AssetClassification.AssetClassificationCode     AS AssetClassificationCode,  
   AssetClassification.AssetClassificationDescription   AS AssetClassificationDescription,  
   Asset.AssetDescription          AS AssetDescription,  
   Asset.WorkGroupId           AS WorkGroupId,  
   AssetWorkGroup.WorkGroupCode        AS WorkGroupCode,  
   AssetWorkGroup.WorkGroupDescription       AS WorkGroupDescription,         
  format(cast( Asset.CommissioningDate   as Date),'dd-MMM-yyyy')       AS CommissioningDate,  
   Asset.AssetParentId           AS AssetParentId,  
   (SELECT AssetNo FROM #ParentAssetNo)      AS ParentAssetNo,    --1  
   format(cast(Asset.ServiceStartDate  as Date),'dd-MMM-yyyy')         AS ServiceStartDate,  
   Asset.ServiceStartDateUTC         AS ServiceStartDateUTC,  
   TandC1.ServiceEndDate          AS EffectiveDate,  
   TandC1.ServiceEndDateUTC         AS EffectiveDateUTC,  
   Asset.ExpectedLifespan          AS ExpectedLifespan,  
  
   (SELECT ISNULL(AssetRealtimeStatus,55)  
   FROM #AssetRealTimeStatus)        AS RealTimeStatusLovId,    --2  
   (SELECT ISNULL(AssetRealTimeStatusValue,'Functioning')  
   FROM #AssetRealTimeStatus)        AS AssetRealTimeStatusValue,  
  
   Asset.AssetStatusLovId          AS AssetStatusLovId,  
   AssetStatus.FieldValue          AS AssetStatusValue,  
   Asset.OperatingHours          AS OperatingHours,  
  
   InstallUserArea.UserAreaId         AS UserAreaId,      --4  
   InstallUserArea.UserAreaCode        AS UserAreaCode,  
   InstallUserArea.UserAreaName        AS UserAreaName,  
   Asset.InstalledLocationId         AS InstallUserLocationId,  
   InstallUserLocation.UserLocationCode      AS InstalledLocationCode,  
   InstallUserLocation.UserLocationName      AS InstalledLocationName,  
   InstallBlock.BlockCode,  
   InstallBlock.BlockName,  
   InstallLevel.LevelCode,  
   InstallLevel.LevelName,  
  
   Asset.UserLocationId          AS UserLocationId,  
   UserLocation.UserLocationCode        AS UserLocationCode,  
   UserLocation.UserLocationName        AS UserLocationName,  
   UserArea.UserAreaCode          AS CurrentAreaCode,  
   UserArea.UserAreaName          AS CurrentAreaName,  
  
   --InstallUserLocation.UserLocationCode      AS InstallUserLocationCode,  
   --InstallUserLocation.UserLocationName      AS InstallUserLocationName,  
  
  
  
  
   Asset.Manufacturer           AS Manufacturer,  
   Manufacturer.Manufacturer         AS ManufacturerName,  
   Asset.Model             AS Model,  
   Model.Model             AS ModelName,  
   --Asset.AppliedPartTypeLovId         AS AppliedPartTypeLovId,  
   --AppliedPartType.FieldValue         AS AppliedPartType,  
   --Asset.EquipmentClassLovId         AS EquipmentClassLovId,  
   --EquipmentClass.FieldValue         AS EquipmentClass,  
   Asset.Specification           AS Specification,  
   Asset.SerialNo            AS SerialNo,  
  
   Asset.RiskRating           AS RiskRating,  
     
  
   Asset.MainSupplier           AS MainSupplier,  
   Asset.ManufacturingDate          AS ManufacturingDate,  
   Asset.ManufacturingDateUTC         AS ManufacturingDateUTC,  
   --Asset.PowerSpecification         AS PowerSpecification,  
   --PowerSpecification.FieldValue        AS PowerSpecificationName,  
 
  
   isnull(Asset.PurchaseCostRM,TandC.PurchaseCost)          AS PurchaseCostRM,  
   format(cast(Asset.PurchaseDate as Date),'dd-MMM-yyyy')  AS PurchaseDate,  
 
   Asset.WarrantyDuration          AS WarrantyDuration,  
    format(cast(Asset.WarrantyStartDate   as Date),'dd-MMM-yyyy')       AS WarrantyStartDate,  
   Asset.WarrantyStartDateUTC         AS WarrantyStartDateUTC,  
    format(cast(Asset.WarrantyEndDate   as Date),'dd-MMM-yyyy')       AS WarrantyEndDate,  
   Asset.WarrantyEndDateUTC         AS WarrantyEndDateUTC,  
  
   --Asset.CumulativePartCost         AS CumulativePartCost,  
   --Asset.CumulativeLabourCost         AS CumulativeLabourCost,  
   --Asset.CumulativeContractCost        AS CumulativeContractCost,  
  
  
   Asset.PurchaseCategory          AS PurchaseCategory,  
   PurchaseCategory.FieldValue         AS PurchaseCategoryName,  
   Asset.[Timestamp]           AS [Timestamp],  
   Asset.NamePlateManufacturer         AS NamePlateManufacturer,  
   Asset.QRCode            AS QRCode,  
   Asset.IsLoaner            AS IsLoaner,  
   CASE WHEN Asset.IsLoaner = 1  THEN 'YES'  
     WHEN Asset.IsLoaner = 0  THEN 'NO'  
     ELSE  'NO'  
   END               AS IsLoanerValue,  
   Asset.TypeOfAsset           AS TypeOfAsset,  
   LovAssetType.FieldValue          AS TypeOfAssetValue,  
   Asset.[Authorization]          AS [Authorization],  
   [Authorization].FieldValue         AS AuthorizationName,  
  
   (SELECT LastSchduledWorkOrderNo   
   FROM #AssetMaintenanceSchd)        AS LastSchduledWorkOrderNo,  
   (SELECT LastSchduledWorkOrderDateTime   
   FROM #AssetMaintenanceSchd)         AS LastSchduledWorkOrderDateTime,  
   --(SELECT DowntimeHoursMin   
   --FROM #AssetMaintenanceSchd)         AS SchduledDowntimeHoursMin,  
   --isnull((SELECT TotDowntimeHoursMinYTD   
   --FROM #AssetMaintenanceSchd)  ,0.00)       AS SchduledTotDowntimeHoursMinYTD,  
   (SELECT LastUnSchduledWorkOrderNo   
   FROM #AssetMaintenanceUnSchd)        AS LastUnSchduledWorkOrderNo,  
   (SELECT LastUnSchduledWorkOrderDateTime   
   FROM #AssetMaintenanceUnSchd)        AS LastUnSchduledWorkOrderDateTime,  
   --(SELECT DowntimeHoursMin   
   --FROM #AssetMaintenanceUnSchd)        AS UnSchduledDowntimeHoursMin,  
   (SELECT TotDowntimeHoursMinYTD   
   FROM #AssetMaintenanceUnSchd)        AS UnSchduledTotDowntimeHoursMinYTD,  
  
   (SELECT cast(CumilativePartsCost  as numeric(24,0))  
   FROM #CumilativeCosts)          AS CumulativePartCost,  
   (SELECT cast(CumilativeLabourCost   as numeric(24,0))  
   FROM #CumilativeCosts)          AS CumulativeLabourCost,  
   @CumilativeContractValue as CumulativeContractCost,  
   --(SELECT cast(CumilativeContractorCost   as numeric(24,0))  
   --FROM #CumilativeCosts)          AS CumulativeContractCost,  
  
   Porter.TransferModeLovId         AS TransferModeLovId,  
   --Porter.TransferMode           AS TransferMode,  
  
   CASE WHEN Porter.TransferModeLovId=67 THEN Porter.UserLocationName   
   ELSE NULL    END         AS TransferUserLocation,  
   CASE WHEN Porter.TransferModeLovId=67 THEN Porter.TransferDate             
   ELSE NULL    END         AS TransferDate,  
  
   Porter.TransferModeLovId         AS OtherTransferTypeLovId,  
     
   CASE WHEN Porter.TransferModeLovId=68 THEN  Porter.TransferType             
   ELSE NULL    END AS OtherTransferType,  
   --CASE WHEN Porter.TransferModeLovId=68 THEN  Porter.TransferDate             
   --ELSE NULL    END AS OtherTransferDate,  
   CASE WHEN Porter.TransferModeLovId=68 THEN  Porter.FacilityId             
   ELSE NULL    END AS OtherFacilityId,  
   CASE WHEN Porter.TransferModeLovId=68 THEN  Porter.FacilityName             
   ELSE NULL    END AS OtherFacilityName,  
   CASE WHEN Porter.TransferModeLovId=68 THEN  Porter.OtherSpecify             
   ELSE NULL    END AS OtherSpecify,  
   CASE WHEN Porter.TransferModeLovId=68 THEN  Porter.PreviousAssetNo            
   ELSE NULL    END AS OtherPreviousAssetNo,  
  
   ''               AS SNFDocumentNO,  
   @DefectList             AS DefectList,  
   CAST(CAST((DATEDIFF(m, TandC.PurchaseDate, GETDATE())/12) AS VARCHAR) + '.' +   
    CASE WHEN DATEDIFF(m, TandC.PurchaseDate, GETDATE())%12 = 0 THEN '1'   
      ELSE cast((abs(DATEDIFF(m, TandC.PurchaseDate, GETDATE())%12))   
    AS VARCHAR) END as NUMERIC(24,2))    AS AssetAge,   
   CAST(CAST((DATEDIFF(m, TandC.TandCDate, GETDATE())/12) AS VARCHAR) + '.' +   
    CASE WHEN DATEDIFF(m, TandC.TandCDate, GETDATE())%12 = 0 THEN '1'   
      ELSE CAST((abs(DATEDIFF(m, TandC.TandCDate, GETDATE())%12))   
    AS VARCHAR) END as NUMERIC(24,2))    AS YearsInService,  
   Asset.GuId,  
   Asset.PreviousAssetNo  AS PreviousAssetNo,  
   Asset.TransferFacilityName,  
   Asset.TransferRemarks,  
   Asset.PurchaseOrderNo,  
   Asset.SoftwareVersion AS SoftwareVersion,  
   Asset.SoftwareKey   AS SoftwareKey,  
   Asset.TransferMode   AS TransferMode,  
   --TransferModeAsset.FieldValue AS TransferModeAssetValue,  
   Asset.MainsFuseRating  AS MainsFuseRating,  
   Asset.OtherTransferDate  AS OtherTransferDate,  
   isnull(VmVar.MonthlyProposedFeeDW,0) as CalculatedFeeDW,  
   isnull(VmVar.MonthlyProposedFeePW,0) as CalculatedFeePW,  
   --VmVar.CalculatedFeeDW,  
   WarDowntime.DowntimeHoursMin AS TotalWarrantyDownTime,  
   Asset.RunningHoursCapture,  
   CASE WHEN Asset.RunningHoursCapture = 99 THEN 'Yes'  
     ELSE 'No'  
   END AS RunningHoursCaptureValue,  
   Asset.ContractType,  
   ContractType.FieldValue    AS ContractTypeValue,  
   Asset.AssetWorkingStatus,  
   AssetWorkingStatus.FieldValue as AssetWorkingStatusValue,  
   Asset.CompanyStaffId,  
   CompanyStaffId.StaffName  ,

   format(cast(TandC.TandCCompletedDate as Date),'dd-MMM-yyyy') as TnCCompletedDate,
   format(cast(TandC.HandoverDate as Date),'dd-MMM-yyyy') as HandOverDate,
   format(cast(TandC.TandCDate as Date),'dd-MMM-yyyy')  as TnCDate,
   Tandc.ApprovalRemarks as WarrantyRemarks,
   CustRep.StaffName as CompanyRepresentative,
   FacRep.StaffName as FacilityRepresentative,
   format(cast(Crmreq.TargetDate as Date),'dd-MMM-yyyy')  as TargetDate, 
   crmreq.Requester,
   Requester.StaffName as RequesterName,
   crmreq.RequestDescription,
   Crmreq.Remarks,
   Crmreq.AssigneeId,
   Assign.staffname as Assignee
  
   
  
 FROM EngAsset            AS Asset    WITH(NOLOCK)  
   INNER JOIN MstLocationFacility		AS Faci						ON Faci.FacilityId= Asset.FacilityId 
   --LEFT JOIN  EngAsset        AS ParentAsset   WITH(NOLOCK)   ON Asset.AssetId       = ParentAsset.AssetParentId  
   INNER JOIN  MstService        AS AssetService   WITH(NOLOCK)   ON Asset.ServiceId       = AssetService.ServiceId  
   LEFT  JOIN  EngAssetWorkGroup      AS AssetWorkGroup  WITH(NOLOCK)   ON Asset.WorkGroupId      = AssetWorkGroup.WorkGroupId  
   LEFT JOIN  EngAssetClassification     AS AssetClassification WITH(NOLOCK)   ON Asset.AssetClassification    = AssetClassification.AssetClassificationId  
   INNER JOIN  EngAssetTypeCode      AS AssetTypeCode  WITH(NOLOCK)   ON Asset.AssetTypeCodeId     = AssetTypeCode.AssetTypeCodeId  
   --LEFT JOIN  FMLovMst        AS LovRiskRating     WITH(NOLOCK)   ON Asset.RiskRating       = LovRiskRating.LovId  
   LEFT JOIN  FMLovMst        AS AssetStatus   WITH(NOLOCK)   ON Asset.AssetStatusLovId     = AssetStatus.LovId  
  
   LEFT JOIN  MstLocationUserLocation     AS InstallUserLocation WITH(NOLOCK)   ON Asset.InstalledLocationId    = InstallUserLocation.UserLocationId  
   LEFT JOIN  MstLocationUserArea      AS InstallUserArea  WITH(NOLOCK)   ON InstallUserLocation.UserAreaId   = InstallUserArea.UserAreaId  
   LEFT JOIN  MstLocationLevel      AS InstallLevel   WITH(NOLOCK)   ON InstallUserLocation.LevelId    = InstallLevel.LevelId  
   LEFT JOIN  MstLocationBlock      AS InstallBlock   WITH(NOLOCK)   ON InstallUserLocation.BlockId    = InstallBlock.BlockId  
     
   LEFT JOIN  MstLocationUserLocation     AS UserLocation   WITH(NOLOCK)   ON Asset.UserLocationId      = UserLocation.UserLocationId  
   LEFT JOIN  MstLocationUserArea      AS UserArea    WITH(NOLOCK)   ON UserLocation.UserAreaId     = UserArea.UserAreaId  
  
   LEFT JOIN  EngAssetStandardizationManufacturer  AS Manufacturer   WITH(NOLOCK)   ON Asset.Manufacturer      = Manufacturer.ManufacturerId  
   LEFT JOIN  EngAssetStandardizationModel   AS Model    WITH(NOLOCK)   ON Asset.Model        = Model.ModelId  
   LEFT JOIN  FMLovMst        AS AppliedPartType  WITH(NOLOCK)   ON Asset.AppliedPartTypeLovId    = AppliedPartType.LovId  
   --LEFT JOIN  FMLovMst        AS EquipmentClass  WITH(NOLOCK)   ON Asset.EquipmentClassLovId    = EquipmentClass.LovId  
   LEFT JOIN  EngTestingandCommissioningTxnDet  AS TandCDet    WITH(NOLOCK)   ON Asset.TestingandCommissioningDetId  = TandCDet.TestingandCommissioningDetId  
   LEFT JOIN  EngTestingandCommissioningTxn   AS TandC    WITH(NOLOCK)   ON TandCDet.TestingandCommissioningId  = TandC.TestingandCommissioningId  
  
   LEFT JOIN  UMUserRegistration   AS CustRep    WITH(NOLOCK)   ON CustRep.UserRegistrationId  = TandC.CustomerRepresentativeUserId  
   LEFT JOIN  UMUserRegistration   AS FacRep    WITH(NOLOCK)    ON FacRep.UserRegistrationId  = TandC.CustomerRepresentativeUserId 
   LEFT JOIN  CRMRequest   AS Crmreq    WITH(NOLOCK)    ON Crmreq.CRMRequestId  = TandC.CRMRequestId
   LEFT JOIN  UMUserRegistration   AS Requester    WITH(NOLOCK)    ON  crmreq.Requester  = Requester.UserRegistrationId 
   LEFT JOIN  UMUserRegistration   AS Assign    WITH(NOLOCK)    ON  crmreq.AssigneeId  = Assign.UserRegistrationId 
   LEFT JOIN  EngTestingandCommissioningTxn   AS TandC1    WITH(NOLOCK)   ON Asset.AssetId  = TandC1.AssetId AND TandC1.IsSNF = 1  
  
   --LEFT JOIN  FMLovMst        AS DisposeMethod  WITH(NOLOCK)   ON Asset.DisposeMethod      = DisposeMethod.LovId  
   LEFT JOIN  FMLovMst        AS [Authorization]  WITH(NOLOCK)   ON Asset.[Authorization]     = [Authorization].LovId  
   --LEFT JOIN  FMLovMst        AS SpecificationUnit WITH(NOLOCK)   ON Asset.SpecificationUnit     = SpecificationUnit.LovId  
     
   LEFT JOIN  FMLovMst        AS FuelType    WITH(NOLOCK)   ON Asset.FuelType       = FuelType.LovId  
   --LEFT JOIN  FMLovMst        AS PowerSpecification WITH(NOLOCK)   ON Asset.PowerSpecification     = PowerSpecification.LovId  
   LEFT JOIN  FMLovMst        AS PurchaseCategory  WITH(NOLOCK)   ON Asset.PurchaseCategory     = PurchaseCategory.LovId  
   LEFT JOIN  FMLovMst        AS LovAssetType   WITH(NOLOCK)   ON Asset.TypeOfAsset      = LovAssetType.LovId  
   --LEFT JOIN  FMLovMst        AS TransferModeAsset WITH(NOLOCK)   ON Asset.TransferMode      = TransferModeAsset.LovId  
   LEFT JOIN  FMLovMst        AS ContractType   WITH(NOLOCK)   ON Asset.ContractType      = ContractType.LovId  
   LEFT JOIN  FMLovMst        AS AssetWorkingStatus WITH(NOLOCK)   ON Asset.AssetWorkingStatus     = AssetWorkingStatus.LovId  
   LEFT JOIN  UMUserRegistration      AS CompanyStaffId  WITH(NOLOCK)   ON Asset.CompanyStaffId      = CompanyStaffId.UserRegistrationId  
   --LEFT JOIN  VmVariationTxn       AS VmVar    WITH(NOLOCK)   ON Asset.AssetId       = VmVar.AssetId  
   OUTER APPLY (select  sum(MonthlyProposedFeeDW) as MonthlyProposedFeeDW,sum(MonthlyProposedFeePW) as MonthlyProposedFeePW from  VmVariationTxn       AS VmVar1    WITH(NOLOCK)     
         where Asset.AssetId       = VmVar1.AssetId  and VmVar1.VariationWFStatus = 230) VmVar  
   --LEFT JOIN  MstLocationFacility      AS TransferFacility  WITH(NOLOCK)   ON Asset.TransferFacilityId     = TransferFacility.FacilityId  
   OUTER APPLY ( SELECT TOP 1 Portering.AssignPorterId,  
         Portering.MovementCategory AS TransferModeLovId,  
         LovTransferMode.FieldValue AS TransferMode,  
         UserLocation.UserLocationName,  
         Portering.SubCategory  AS TransferTypeLovId,  
         LovTransferType.FieldValue AS TransferType,  
         Portering.PorteringDate AS TransferDate,  
         PorterFacility.FacilityId,  
         PorterFacility.FacilityName,  
         'NA' AS  OtherSpecify,  
         Asset.AssetNo AS PreviousAssetNo  
       FROM PorteringTransaction AS Portering WITH(NOLOCK)  
         LEFT JOIN FMLovMst AS LovTransferMode WITH(NOLOCK) ON Portering.MovementCategory=LovTransferMode.LovId  
         LEFT JOIN FMLovMst AS LovTransferType WITH(NOLOCK) ON Portering.SubCategory=LovTransferType.LovId  
         LEFT JOIN MstLocationFacility AS PorterFacility WITH(NOLOCK) ON Portering.FromFacilityId=PorterFacility.FacilityId  
         LEFT JOIN MstLocationUserLocation AS UserLocation WITH(NOLOCK) ON Portering.ToUserLocationId=UserLocation.UserLocationId  
         WHERE Portering.AssetId=Asset.AssetId  
         ORDER BY Asset.ModifiedDate DESC  
      ) Porter  
  
   OUTER APPLY ( SELECT SUM(DownTimeHours) AS DowntimeHoursMin   
      FROM EngMwoCompletionInfoTxn A INNER JOIN EngMaintenanceWorkOrderTxn B ON A.WorkOrderId=B.WorkOrderId  
        INNER JOIN EngAsset C ON B.AssetId  = C.AssetId  
      WHERE B.AssetId = @pAssetId AND C.WarrantyEndDate >= MaintenanceWorkDateTime  
      --GETDATE()  
      GROUP BY B.AssetId) WarDowntime  
   WHERE Asset.AssetId = @pAssetId   
  
  


 
       SELECT	
	   --      
				MstContractor.ContractorName			AS	ContractorName,
				CContactInfo.ContactPerson				AS	ContactPerson,
				CContactInfo.ContactNo					AS	TelephoneNo,
				CContactInfo.Email						AS	Email,
				MstContractor.FaxNo						AS	FaxNo
				--MstContractor.[Address]					AS	[Address],
			
 		FROM	EngAssetSupplierWarranty						AS	SupplierWarranty	WITH(NOLOCK)
				INNER JOIN	EngAsset							AS	Asset				WITH(NOLOCK)	ON Asset.AssetId					=	SupplierWarranty.AssetId
				INNER JOIN	MstContractorandVendor				AS	MstContractor		WITH(NOLOCK)	ON SupplierWarranty.ContractorId	=	MstContractor.ContractorId
				OUTER APPLY( SELECT DISTINCT TOP 1 Name AS ContactPerson,ISNULL(Designation,'')Designation,ISNULL(ContactNo,'')ContactNo,ISNULL(Email,'')Email
							FROM MstContractorandVendorContactInfo AS ContractorDet WITH(NOLOCK)  
							WHERE MstContractor.ContractorId	=	ContractorDet.ContractorId) AS 	CContactInfo
				INNER JOIN	FMLovMst							AS	LovCategory			WITH(NOLOCK)	ON SupplierWarranty.Category		=	LovCategory.LovId
		WHERE	SupplierWarranty.AssetId		=	@pAssetId
				AND SupplierWarranty.Category	=	@pLovIdSupplierCategoryMainSupplier
		


  
  
END TRY  
  
BEGIN CATCH  
  
 INSERT INTO ErrorLog(  
    Spname,  
    ErrorMessage,  
    createddate)  
 VALUES(  OBJECT_NAME(@@PROCID),  
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),  
    getdate()  
     )  
  
END CATCH
GO
