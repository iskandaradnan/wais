USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngAsset_Mobile_GetByIdUsingAssetNo]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
/*========================================================================================================  
Application Name : UETrack-BEMS                
Version    : 1.0  
Procedure Name  : UspFM_EngAsset_GetById  
Description   : To Get the data from table EngAsset using the Primary Key id  
Authors    : Balaji M S  
Date    : 30-Mar-2018  
-----------------------------------------------------------------------------------------------------------  
  
Unit Test:  
EXEC [UspFM_EngAsset_Mobile_GetByIdUsingAssetNo]  @pAssetNo='PANH00016'  
SELECT * FROM EngAsset  
-----------------------------------------------------------------------------------------------------------  
Version History   
-----:------------:---------------------------------------------------------------------------------------  
Init : Date       : Details  
========================================================================================================*/  
CREATE PROCEDURE  [dbo].[UspFM_EngAsset_Mobile_GetByIdUsingAssetNo]                             
  
  @pAssetNo    NVARCHAR(500)  
AS                                                
  
BEGIN TRY  
   
  
 DECLARE @pAssetId INT  
  
 SET @pAssetId = (SELECT AssetId FROM EngAsset WHERE AssetNo=@pAssetNo)  
  
 SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
 IF(ISNULL(@pAssetId,0) = 0) RETURN  
  
 DECLARE @TotSchdDownTime NUMERIC(24,2)  
 DECLARE @TotUnSchdDownTime NUMERIC(24,2)  
 DECLARE @DefectList INT  
  
-- RealTimeStatus from Work Order -AssesmentTxn  
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
   INNER JOIN EngMwoCompletionInfoTxn AS CompletionInfo ON MWO.WorkOrderId=CompletionInfo.WorkOrderId  
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
   INNER JOIN EngMwoCompletionInfoTxn AS CompletionInfo ON MWO.WorkOrderId=CompletionInfo.WorkOrderId  
 WHERE MWO.AssetId=@pAssetId  
   AND MaintenanceWorkCategory = 188  
 GROUP BY MWO.AssetId  
  
 --SELECT TOP 1 MWO.MaintenanceWorkNo  AS LastUnSchduledWorkOrderNo,  
 --  MWO.MaintenanceWorkDateTime  AS LastUnSchduledWorkOrderDateTime,  
 --  CompletionInfo.DowntimeHoursMin,  
 --  @TotUnSchdDownTime    AS TotDowntimeHoursMinYTD  
 --  INTO #AssetMaintenanceUnSchd  
 --FROM EngMaintenanceWorkOrderTxn AS MWO   
 --  INNER JOIN EngMwoCompletionInfoTxn AS CompletionInfo ON MWO.WorkOrderId=CompletionInfo.WorkOrderId  
 --WHERE MWO.AssetId=@pAssetId   --  AND MaintenanceWorkCategory = 188  
 --ORDER BY MWO.CreatedDate DESC  
  
    
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
  
  
-- PurchaseDetails Tab from Work Order-- Cumilative costs  
 --1 Scheduled  
 --SELECT AssetId,  
 --  SUM(CompletionInfo.PartsCost)  AS CumilativePartsCost,  
 --  SUM(CompletionInfo.LabourCost)  AS CumilativeLabourCost,  
 --  SUM(CompletionInfo.ContractorCost) AS CumilativeContractorCost  
 --  INTO #CumilativeCosts  
 --  FROM EngMaintenanceWorkOrderTxn AS MWO   
 --  INNER JOIN EngMwoCompletionInfoTxn AS CompletionInfo ON MWO.WorkOrderId=CompletionInfo.WorkOrderId  
 --WHERE MWO.AssetId=@pAssetId  
 --GROUP BY MWO.AssetId  
  
  
 SELECT AssetId,  
   SUM(ISNULL(PartRep.TotalPartsCost,0))  AS CumilativePartsCost,  
   SUM(ISNULL(PartRep.LabourCost,0))  +
   SUM(((ISNULL(CAST(PARSENAME(C.RepairHours, 2) AS INT),0) * 60) + ISNULL(CAST(PARSENAME(C.RepairHours, 1) AS INT),0)) * ISNULL(D.LabourCostPerHour, 0)/60) AS CumilativeLabourCost,  
   0 AS CumilativeContractorCost  
   INTO #CumilativeCosts  
   FROM EngMaintenanceWorkOrderTxn AS MWO   
   LEFT JOIN EngMwoCompletionInfoTxn AS CompletionInfo ON MWO.WorkOrderId=CompletionInfo.WorkOrderId  
   LEFT JOIN EngMwoPartReplacementTxn AS PartRep   ON MWO.WorkOrderId=PartRep.WorkOrderId  
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
  
  
    SELECT Asset.AssetId            AS AssetId,  
   Asset.CustomerId           AS CustomerId,  
   Customer.CustomerCode          AS CustomerCode,  
   Customer.CustomerName          AS CustomerName,  
   Asset.FacilityId           AS FacilityId,  
   LocationFacility.FacilityCode        AS FacilityCode,  
   LocationFacility.FacilityName        AS FacilityName,  
   LocationLevel.LevelId          AS LevelId,  
   LocationLevel.LevelCode          AS LevelCode,  
   LocationLevel.LevelName          AS LevelName,  
   LocationBlock.BlockId          AS BlockId,  
   LocationBlock.BlockCode          AS BlockCode,  
   LocationBlock.BlockName          AS BlockName,  
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
   Asset.CommissioningDate          AS CommissioningDate,  
   Asset.AssetParentId           AS AssetParentId,  
   (SELECT AssetNo FROM #ParentAssetNo)      AS ParentAssetNo,    --1  
   Asset.ServiceStartDate          AS ServiceStartDate,  
   Asset.ServiceStartDateUTC         AS ServiceStartDateUTC,  
   --Asset.EffectiveDate           AS EffectiveDate,  
   --Asset.EffectiveDateUTC          AS EffectiveDateUTC,  
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
  
   Asset.UserAreaId           AS UserAreaId,      --4  
   UserArea.UserAreaCode          AS UserAreaCode,  
   UserArea.UserAreaName          AS UserAreaName,  
  
   Asset.UserLocationId          AS UserLocationId,  
   UserLocation.UserLocationCode        AS UserLocationCode,  
   UserLocation.UserLocationName        AS UserLocationName,  
   Asset.Manufacturer           AS Manufacturer,  
   Manufacturer.Manufacturer         AS ManufacturerName,  
   Asset.Model             AS Model,  
   Model.Model             AS ModelName,  
   Asset.AppliedPartTypeLovId         AS AppliedPartTypeLovId,  
   AppliedPartType.FieldValue         AS AppliedPartType,  
   Asset.EquipmentClassLovId         AS EquipmentClassLovId,  
   EquipmentClass.FieldValue         AS EquipmentClass,  
   Asset.Specification           AS Specification,  
   Asset.SerialNo            AS SerialNo,  
  
   --LovRiskRating.FieldValue         AS RiskRating,  
   Asset.RiskRating           AS RiskRating,    -- 3  
  
   Asset.MainSupplier           AS MainSupplier,  
   Asset.ManufacturingDate          AS ManufacturingDate,  
   Asset.ManufacturingDateUTC         AS ManufacturingDateUTC,  
   Asset.PowerSpecification         AS PowerSpecification,  
   PowerSpecification.FieldValue        AS PowerSpecificationName,  
   Asset.PowerSpecificationWatt        AS PowerSpecificationWatt,   
   Asset.PowerSpecificationAmpere        AS PowerSpecificationAmpere,  
   Asset.Volt             AS Volt,  
   Asset.PpmPlannerId           AS PpmPlannerId,  
   CASE WHEN Asset.PpmPlannerId = 99  THEN 'YES'  
     WHEN Asset.PpmPlannerId =100 THEN 'NO'  
     ELSE  'NO'  
   END               AS PpmPlanner,    
   Asset.RiPlannerId           AS RiPlannerId,  
   CASE WHEN Asset.RiPlannerId = 99  THEN 'YES'  
     WHEN Asset.RiPlannerId =100 THEN 'NO'  
     ELSE  'NO'  
   END               AS RiPlanner,   
   Asset.OtherPlannerId          AS OtherPlannerId,  
   CASE WHEN Asset.OtherPlannerId = 99  THEN 'YES'  
     WHEN Asset.OtherPlannerId =100 THEN 'NO'  
     ELSE  'NO'  
   END               AS OtherPlanner,   
  
   Asset.PurchaseCostRM          AS PurchaseCostRM,  
   Asset.PurchaseDate           AS PurchaseDate,  
   Asset.PurchaseDateUTC          AS PurchaseDateUTC,  
   Asset.WarrantyDuration          AS WarrantyDuration,  
   Asset.WarrantyStartDate          AS WarrantyStartDate,  
   Asset.WarrantyStartDateUTC         AS WarrantyStartDateUTC,  
   Asset.WarrantyEndDate          AS WarrantyEndDate,  
   Asset.WarrantyEndDateUTC         AS WarrantyEndDateUTC,  
  
   --Asset.CumulativePartCost         AS CumulativePartCost,  
   --Asset.CumulativeLabourCost         AS CumulativeLabourCost,  
   --Asset.CumulativeContractCost        AS CumulativeContractCost,  
  
   Asset.DisposalApprovalDate         AS DisposalApprovalDate,  
   Asset.DisposalApprovalDateUTC        AS DisposalApprovalDateUTC,  
   Asset.DisposedDate           AS DisposedDate,  
   Asset.DisposedDateUTC          AS DisposedDateUTC,  
   Asset.DisposedBy           AS DisposedBy,  
   Asset.DisposeMethod           AS DisposeMethod,  
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
   (SELECT DowntimeHoursMin   
   FROM #AssetMaintenanceSchd)         AS SchduledDowntimeHoursMin,  
   (SELECT TotDowntimeHoursMinYTD   
   FROM #AssetMaintenanceSchd)         AS SchduledTotDowntimeHoursMinYTD,  
   (SELECT LastUnSchduledWorkOrderNo   
   FROM #AssetMaintenanceUnSchd)        AS LastUnSchduledWorkOrderNo,  
   (SELECT LastUnSchduledWorkOrderDateTime   
   FROM #AssetMaintenanceUnSchd)        AS LastUnSchduledWorkOrderDateTime,  
   (SELECT TotDowntimeHoursMinYTD   
   FROM #AssetMaintenanceUnSchd)        AS UnSchduledDowntimeHoursMin,  
   (SELECT TotDowntimeHoursMinYTD   
   FROM #AssetMaintenanceUnSchd)        AS UnSchduledTotDowntimeHoursMinYTD,  
   (SELECT cast(CumilativePartsCost  as numeric(24,0))  
   FROM #CumilativeCosts)          AS CumulativePartCost,  
   (SELECT cast(CumilativeLabourCost   as numeric(24,0))  
   FROM #CumilativeCosts)          AS CumulativeLabourCost,  
   @CumilativeContractValue         AS CumulativeContractCost,  
   --(SELECT cast(CumilativeContractorCost   as numeric(24,0))  
   --FROM #CumilativeCosts)          AS CumulativeContractCost,  
  
  
   Porter.TransferModeLovId         AS TransferModeLovId,  
   Porter.TransferMode           AS TransferMode,  
  
   CASE WHEN Porter.TransferModeLovId=67 THEN Porter.UserLocationName   
   ELSE NULL    END         AS TransferUserLocation,  
   CASE WHEN Porter.TransferModeLovId=67 THEN Porter.TransferDate             
   ELSE NULL    END         AS TransferDate,  
  
   Porter.TransferModeLovId         AS OtherTransferTypeLovId,  
     
   CASE WHEN Porter.TransferModeLovId=68 THEN  Porter.TransferType             
   ELSE NULL    END AS OtherTransferType,  
   CASE WHEN Porter.TransferModeLovId=68 THEN  Porter.TransferDate             
   ELSE NULL    END AS OtherTransferDate,  
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
   Asset.SoftwareKey,  
   Asset.SoftwareVersion,  
   Asset.AssetWorkingStatus,  
   AssetWorkingStatus.FieldValue as AssetWorkingStatusValue,  
   Asset.CompanyStaffId,  
   CompanyStaffId.StaffName,  
   Asset.ContractType,  
   ContractType.FieldValue as  ContractTypeValue,  
   Asset.PurchaseOrderNo  
  
   --Asset.IsAssetOld           AS IsAssetOld,  
   --Asset.AssetNoOld           AS AssetNoOld,  
   --Asset.Image1FMDocumentId         AS Image1FMDocumentId,  
   --Asset.Image2FMDocumentId         AS Image2FMDocumentId,  
   --Asset.Image3FMDocumentId         AS Image3FMDocumentId,  
   --Asset.Image4FMDocumentId         AS Image4FMDocumentId,  
   --Asset.VedioFMDocumentId          AS VedioFMDocumentId,  
   --RiskRating.FieldValue          AS RiskRatingName,  
   --Asset.SpecificationUnit          AS SpecificationUnit,  
   --SpecificationUnit.FieldValue        AS SpecificationUnitName,  
   --Asset.RegistrationNo          AS RegistrationNo,  
   --Asset.ChassisNo            AS ChassisNo,  
   --Asset.EngineCapacity          AS EngineCapacity,  
   --Asset.FuelType            AS FuelType,  
   --FuelType.FieldValue           AS FuelTypeName,  
   --DisposeMethod.FieldValue         AS DisposeMethodName,  
   --Asset.TestingandCommissioningDetId       AS TestingandCommissioningDetId,  
   --TandC.TandCDocumentNo          AS TandCDocumentNo,  
   --Asset.AssetStandardizationId        AS AssetStandardizationId,  
   --Asset.NamePlateManufacturer         AS NamePlateManufacturer,    
  
 FROM EngAsset            AS Asset    WITH(NOLOCK)  
   --LEFT JOIN  EngAsset        AS ParentAsset   WITH(NOLOCK)   ON Asset.AssetId       = ParentAsset.AssetParentId  
   INNER JOIN  MstService        AS AssetService   WITH(NOLOCK)   ON Asset.ServiceId       = AssetService.ServiceId  
   INNER JOIN  MstLocationFacility      AS LocationFacility  WITH(NOLOCK)   ON Asset.FacilityId       = LocationFacility.FacilityId  
   INNER JOIN  MstCustomer        AS Customer    WITH(NOLOCK)   ON Asset.CustomerId       = Customer.CustomerId  
   LEFT JOIN  EngTestingandCommissioningTxn   AS TandC1    WITH(NOLOCK)   ON Asset.AssetId  = TandC1.AssetId AND TandC1.IsSNF = 1  
   LEFT JOIN  EngAssetWorkGroup      AS AssetWorkGroup  WITH(NOLOCK)   ON Asset.WorkGroupId      = AssetWorkGroup.WorkGroupId  
   LEFT JOIN  EngAssetClassification     AS AssetClassification WITH(NOLOCK)   ON Asset.AssetClassification    = AssetClassification.AssetClassificationId  
   INNER JOIN  EngAssetTypeCode      AS AssetTypeCode  WITH(NOLOCK)   ON Asset.AssetTypeCodeId     = AssetTypeCode.AssetTypeCodeId  
   --LEFT JOIN  FMLovMst        AS LovRiskRating     WITH(NOLOCK)   ON AssetTypeCode.RiskRatingLovId   = LovRiskRating.LovId  
   LEFT JOIN  FMLovMst        AS AssetStatus   WITH(NOLOCK)   ON Asset.AssetStatusLovId     = AssetStatus.LovId  
   LEFT JOIN  MstLocationUserArea      AS UserArea    WITH(NOLOCK)   ON Asset.UserAreaId       = UserArea.UserAreaId  
   LEFT JOIN  MstLocationLevel      AS LocationLevel  WITH(NOLOCK)   ON UserArea.LevelId       = LocationLevel.LevelId  
   LEFT JOIN  MstLocationBlock      AS LocationBlock  WITH(NOLOCK)   ON UserArea.BlockId       = LocationBlock.BlockId  
   LEFT JOIN  MstLocationUserLocation     AS UserLocation   WITH(NOLOCK)   ON Asset.UserLocationId      = UserLocation.UserLocationId  
   LEFT JOIN  EngAssetStandardizationManufacturer  AS Manufacturer   WITH(NOLOCK)   ON Asset.Manufacturer      = Manufacturer.ManufacturerId  
   LEFT JOIN  EngAssetStandardizationModel   AS Model    WITH(NOLOCK)   ON Asset.Model        = Model.ModelId  
   LEFT JOIN  FMLovMst        AS AppliedPartType  WITH(NOLOCK)   ON Asset.AppliedPartTypeLovId    = AppliedPartType.LovId  
   LEFT JOIN  FMLovMst        AS EquipmentClass  WITH(NOLOCK)   ON Asset.EquipmentClassLovId    = EquipmentClass.LovId  
   LEFT JOIN  EngTestingandCommissioningTxnDet  AS TandCDet    WITH(NOLOCK)   ON Asset.TestingandCommissioningDetId  = TandCDet.TestingandCommissioningDetId  
   LEFT JOIN  EngTestingandCommissioningTxn   AS TandC    WITH(NOLOCK)   ON TandCDet.TestingandCommissioningId  = TandC.TestingandCommissioningId  
   LEFT JOIN  FMLovMst        AS DisposeMethod  WITH(NOLOCK)   ON Asset.DisposeMethod      = DisposeMethod.LovId  
   LEFT JOIN  FMLovMst        AS [Authorization]  WITH(NOLOCK)   ON Asset.[Authorization]     = [Authorization].LovId  
   LEFT JOIN  FMLovMst        AS SpecificationUnit WITH(NOLOCK)   ON Asset.SpecificationUnit     = SpecificationUnit.LovId  
     
   LEFT JOIN  FMLovMst        AS FuelType    WITH(NOLOCK)   ON Asset.FuelType       = FuelType.LovId  
   LEFT JOIN  FMLovMst        AS PowerSpecification WITH(NOLOCK)   ON Asset.PowerSpecification     = PowerSpecification.LovId  
   LEFT JOIN  FMLovMst        AS PurchaseCategory  WITH(NOLOCK)   ON Asset.PurchaseCategory     = PurchaseCategory.LovId  
   LEFT JOIN  FMLovMst        AS LovAssetType   WITH(NOLOCK)   ON Asset.TypeOfAsset      = LovAssetType.LovId  
   LEFT JOIN  FMLovMst        AS AssetWorkingStatus WITH(NOLOCK)   ON Asset.AssetWorkingStatus     = AssetWorkingStatus.LovId  
   LEFT JOIN  UMUserRegistration      AS CompanyStaffId  WITH(NOLOCK)   ON Asset.CompanyStaffId      = CompanyStaffId.UserRegistrationId  
   LEFT JOIN  FMLovMst        AS ContractType WITH(NOLOCK)     ON Asset.ContractType     = ContractType.LovId  
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
   --OUTER APPLY ( SELECT WOAsset.AssetId,CAST(DATEDIFF(HOUR,MIN(WOAsset.ServiceStartDate),GETDATE()) AS numeric(24,2) ) - CAST(SUM(ISNULL(DowntimeHoursMin,0))AS numeric(24,2) ) AS OperatingHours  
   --    FROM EngAsset AS WOAsset  
   --      LEFT JOIN EngMaintenanceWorkOrderTxn AS WO ON WO.AssetId=WOAsset.AssetId  
   --      LEFT JOIN EngMwoCompletionInfoTxn AS CWO ON WO.WorkOrderId=CWO.WorkOrderId  
   --      WHERE WOAsset.AssetId=Asset.AssetId  
   --      GROUP BY WOAsset.AssetId  
   --   ) OperatingHours  
   WHERE Asset.AssetId = @pAssetId   
   ORDER BY Asset.ModifiedDate ASC  
     
  SELECT Spec.AssetTypeCodeAddSpecId,  
    Spec.SpecificationType,  
    Spec.SpecificationTypeName  
  FROM EngAsset AS Asset  
  OUTER APPLY ( SELECT AddSpec.AssetTypeCodeAddSpecId,  
        AddSpec.SpecificationType,  
        LovSpecType.FieldValue AS SpecificationTypeName  
      FROM EngAssetTypeCode          AS TypeCode   WITH(NOLOCK)  
        INNER JOIN   EngAssetTypeCodeAddSpecification AS AddSpec   WITH(NOLOCK)  ON TypeCode.AssetTypeCodeId  = AddSpec.AssetTypeCodeId  
        LEFT JOIN   FMLovMst       AS LovSpecType  WITH(NOLOCK)  ON AddSpec.SpecificationType = LovSpecType.LovId  
        LEFT JOIN   FMLovMst       AS LovSpecUnit  WITH(NOLOCK)  ON AddSpec.SpecificationUnit = LovSpecUnit.LovId  
      WHERE TypeCode.AssetTypeCodeId  = Asset.AssetTypeCodeId   
     ) AS Spec  
  WHERE Asset.AssetId = @pAssetId   
    AND Spec.AssetTypeCodeAddSpecId IS NOT NULL  
  ORDER BY Asset.ModifiedDate ASC  
  
  
  
  SELECT  
  Asset.AssetId        AS AssetId,  
  SupplierWarranty.SupplierWarrantyId   AS SupplierWarrantyId,  
  SupplierWarranty.Category     AS Category,  
  Category.FieldValue       AS CategoryValue,  
  SupplierWarranty.ContractorId    AS ContractorId,  
  ContractorandVendor.SSMRegistrationCode  AS ContractorCode,  
  ContractorandVendor.ContractorName   AS ContractorName,  
  SupplierWarranty.GuId      AS Guid  
  FROM EngAsset        AS Asset  
  INNER JOIN EngAssetSupplierWarranty   AS SupplierWarranty  WITH(NOLOCK) ON Asset.AssetId     = SupplierWarranty.AssetId  
  INNER JOIN FMLovMst       AS Category    WITH(NOLOCK) ON SupplierWarranty.Category  = Category.LovId  
  INNER JOIN MstContractorandVendor   AS ContractorandVendor WITH(NOLOCK) ON SupplierWarranty.ContractorId = ContractorandVendor.ContractorId  
  WHERE Asset.AssetId = @pAssetId  
  
END TRY  
  
BEGIN CATCH  
THROW  
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
