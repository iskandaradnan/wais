USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_BEMSAssetRegistration_Rpt_L2]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
Application Name : UE-Track    
Version    :    
File Name   :    
Procedure Name  : uspFM_CRMRequest_Rpt    
Author(s) Name(s) : Krishna S    
Date    : 28/12/2018    
Purpose    : SP to Check Service Request    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
        
EXEC usp_BEMSAssetRegistration_Rpt @Facility_Id= 1    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~             
Modification History            
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~            
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS            
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~               
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/           
CREATE PROCEDURE  [dbo].[usp_BEMSAssetRegistration_Rpt_L2](      
   @Facility_Id  INT = null,      
   @AssetCategory  INT = null,      
   @AssetStatus  varchar(200) = null,      
   @Typecode   VARCHAR(50) = '',    
   @VariationStatus INT = null,    
   @Level    VARCHAR(100) = NULL,    
   @AssetNo            varchar(100)= null    
 )      
AS      
BEGIN      
      
SET NOCOUNT ON
SET FMTONLY OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
      
BEGIN TRY    
/*    
EXEC usp_BEMSAssetRegistration_Rpt @Facility_Id= 1, @AssetStatus= 1, @AssetCategory = 73, @Typecode = 1057 , @VariationStatus = 125    
*/    
    
DECLARE @FacilityNameParam NVARCHAR(512),    
@AssetCategoryParam   NVARCHAR(512),     
@TypecodeParam    NVARCHAR(512),    
@VariationStatusParam  NVARCHAR(512)    
    
if(@AssetStatus = 'null')    
begin     
  set @AssetStatus= null    
 end     
    
    
    
IF(ISNULL(@Facility_Id,'') <> '')    
BEGIN     
 SELECT @FacilityNameParam = FacilityName FROM MstLocationFacility where FacilityId = @Facility_Id    
END    
    
IF(ISNULL(@AssetCategory,'') <> '')    
BEGIN     
 SELECT @AssetCategoryParam = FieldValue FROM FMLovMst where lovid = @AssetCategory    
END    
    
      
  declare @pAssetId int =218    
     
 DECLARE @TotSchdDownTime NUMERIC(24,2)     
    
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
      
--drop table #AssetRealTimeStatus    
 -- RealTime Status     
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
      
      
      
   SELECT DISTINCT     
  Asset.AssetId            AS AssetId,      
    Asset.AssetNo            AS AssetNo,      
    Asset.AssetDescription          AS AssetDescription,      
    AssetTypeCode.AssetTypeCode         AS AssetTypeCode,     
    Asset.AssetPreRegistrationNo        AS AssetPreRegistrationNo,      
    AssetTypeCode.AssetTypeDescription       AS AssetTypeDescription,     
    AssetClassification.AssetClassificationCode     AS AssetClassificationCode,       
    Manufacturer.Manufacturer         AS ManufacturerName,         
    Model.Model             AS ModelName,      
    ContractType.FieldValue    AS ContractTypeValue,      
    Asset.SerialNo            AS SerialNo,      
    AssetStatus.FieldValue          AS AssetStatusValue,    
    
    
   format(cast( Asset.CommissioningDate   as Date),'dd-MMM-yyyy') as    CommissioningDate,      
   format(cast( Asset.ServiceStartDate     as Date),'dd-MMM-yyyy')      AS ServiceStartDate,     
   Asset.ExpectedLifespan          AS ExpectedLifespan,    
   CAST(CAST((DATEDIFF(m, TandC.PurchaseDate, GETDATE())/12) AS VARCHAR) + '.' +       
    CASE WHEN DATEDIFF(m, TandC.PurchaseDate, GETDATE())%12 = 0 THEN '1'       
      ELSE cast((abs(DATEDIFF(m, TandC.PurchaseDate, GETDATE())%12))       
    AS VARCHAR) END as NUMERIC(24,2))    AS AssetAge,       
   CAST(CAST((DATEDIFF(m, TandC.TandCDate, GETDATE())/12) AS VARCHAR) + '.' +       
    CASE WHEN DATEDIFF(m, TandC.TandCDate, GETDATE())%12 = 0 THEN '1'       
      ELSE CAST((abs(DATEDIFF(m, TandC.TandCDate, GETDATE())%12))       
    AS VARCHAR) END as NUMERIC(24,2))    AS YearsInService,      
        
      (SELECT ISNULL(AssetRealtimeStatus,55)      
   FROM #AssetRealTimeStatus)        AS RealTimeStatusLovId,    --2      
   (SELECT ISNULL(AssetRealTimeStatusValue,'Functioning')      
   FROM #AssetRealTimeStatus)        AS AssetRealTimeStatusValue,      
   Asset.RunningHoursCapture,      
       
    Porter.TransferMode           AS TransferMode,      
     CASE WHEN Porter.TransferModeLovId=67 THEN Porter.TransferDate                 
   ELSE NULL    END         AS TransferDate,      
      CASE WHEN Porter.TransferModeLovId=68 THEN  Porter.TransferType                 
   ELSE NULL    END AS OtherTransferType,      
      
   TransferModeAsset.FieldValue AS TransferModeAssetValue,      
   Asset.TransferFacilityName,      
   Asset.TransferRemarks,      
    
       
       
    InstallUserArea.UserAreaCode        AS UserAreaCode,      
   InstallUserArea.UserAreaName        AS UserAreaName,      
   UserArea.UserAreaCode          AS CurrentAreaCode,      
   UserArea.UserAreaName          AS CurrentAreaName,      
   InstallUserLocation.UserLocationCode      AS InstalledLocationCode,      
   InstallUserLocation.UserLocationName      AS InstalledLocationName,     
   UserLocation.UserLocationCode        AS CurrentUserLocationCode,      
   UserLocation.UserLocationName        AS CurrentUserLocationName,      
    
    
    format(cast(   Asset.ManufacturingDate   as Date),'dd-MMM-yyyy') as          ManufacturingDate,     
      
     AppliedPartType.FieldValue         AS AppliedPartType,     
     EquipmentClass.FieldValue         AS EquipmentClass,     
	 Asset.RiskRating           AS RiskRating,     
	 Asset.SoftwareVersion AS SoftwareVersion,      
     Asset.SoftwareKey   AS SoftwareKey,       
     Asset.Volt             AS Volt,      
     Asset.PowerSpecificationWatt        AS PowerSpecificationWatt,       
     Asset.PowerSpecificationAmpere        AS PowerSpecificationAmpere,      
     Asset.MainsFuseRating  AS MainsFuseRating,     
    
    isnull(Asset.PurchaseCostRM,TandC.PurchaseCost)          AS PurchaseCostRM,      
  format(cast(   Asset.PurchaseDate   as Date),'dd-MMM-yyyy')         AS PurchaseDate,      
   Asset.WarrantyDuration          AS WarrantyDuration,      
   format(cast(  Asset.WarrantyStartDate     as Date),'dd-MMM-yyyy')        AS WarrantyStartDate,      
  format(cast(   Asset.WarrantyEndDate   as Date),'dd-MMM-yyyy')        AS WarrantyEndDate,        
   PurchaseCategory.FieldValue         AS PurchaseCategoryName,      
   Asset.PurchaseOrderNo,         
   Asset.Specification           AS Specification,      
   Asset.MainSupplier    AS MainSupplier,    
    
   CASE WHEN Asset.PpmPlannerId = 99  THEN 'YES'      
     WHEN Asset.PpmPlannerId =100 THEN 'NO'      
     ELSE  'NO'      
   END               AS PpmPlanner,        
   Asset.RiPlannerId           AS RiPlannerId,      
   CASE WHEN Asset.RiPlannerId = 99  THEN 'YES'      
     WHEN Asset.RiPlannerId =100 THEN 'NO'      
     ELSE  'NO'      
   END               AS RiPlanner,       
    
    CASE WHEN Asset.OtherPlannerId = 99  THEN 'YES'      
     WHEN Asset.OtherPlannerId =100 THEN 'NO'      
     ELSE  'NO'      
   END               AS Calibration,       
     (SELECT LastSchduledWorkOrderNo       
   FROM #AssetMaintenanceSchd)        AS LastSchduledWorkOrderNo,      
   (SELECT LastSchduledWorkOrderDateTime       
   FROM #AssetMaintenanceSchd)         AS LastSchduledWorkOrderDateTime    
     ,ms.ServiceName  
     ,mc.customername  as customerid
     ,mlf.facilityname  
     , @FacilityNameParam as FacilityNameParam  
     , ISNULL(CASE WHEN @AssetStatus = 1 THEN 'Active' WHEN @AssetStatus = 2 THEN 'Inactive' END,'') AS AssetStatusParam    
     , '' AS MaintenanceHistory  
     , '' AS VariationHistory  
 FROM EngAsset            AS Asset    WITH(NOLOCK)      
   --LEFT JOIN  EngAsset        AS ParentAsset   WITH(NOLOCK)   ON Asset.AssetId       = ParentAsset.AssetParentId      
   INNER JOIN  MstService        AS AssetService   WITH(NOLOCK)   ON Asset.ServiceId       = AssetService.ServiceId      
   LEFT  JOIN  EngAssetWorkGroup      AS AssetWorkGroup  WITH(NOLOCK)   ON Asset.WorkGroupId      = AssetWorkGroup.WorkGroupId      
   LEFT JOIN  EngAssetClassification     AS AssetClassification WITH(NOLOCK)   ON Asset.AssetClassification    = AssetClassification.AssetClassificationId      
   INNER JOIN  EngAssetTypeCode      AS AssetTypeCode  WITH(NOLOCK)   ON Asset.AssetTypeCodeId     = AssetTypeCode.AssetTypeCodeId      
   LEFT JOIN  FMLovMst        AS LovRiskRating     WITH(NOLOCK)   ON Asset.RiskRating       = LovRiskRating.LovId      
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
   LEFT JOIN  FMLovMst        AS EquipmentClass  WITH(NOLOCK)   ON Asset.EquipmentClassLovId    = EquipmentClass.LovId      
   LEFT JOIN  EngTestingandCommissioningTxnDet  AS TandCDet    WITH(NOLOCK)   ON Asset.TestingandCommissioningDetId  = TandCDet.TestingandCommissioningDetId      
   LEFT JOIN  EngTestingandCommissioningTxn   AS TandC    WITH(NOLOCK)   ON TandCDet.TestingandCommissioningId  = TandC.TestingandCommissioningId      
      
   LEFT JOIN  EngTestingandCommissioningTxn   AS TandC1    WITH(NOLOCK)   ON Asset.AssetId  = TandC1.AssetId AND TandC1.IsSNF = 1      
      
   LEFT JOIN  FMLovMst        AS DisposeMethod  WITH(NOLOCK)   ON Asset.DisposeMethod      = DisposeMethod.LovId      
   LEFT JOIN  FMLovMst        AS [Authorization]  WITH(NOLOCK)   ON Asset.[Authorization]     = [Authorization].LovId      
   LEFT JOIN  FMLovMst        AS SpecificationUnit WITH(NOLOCK)   ON Asset.SpecificationUnit     = SpecificationUnit.LovId      
         
   LEFT JOIN  FMLovMst        AS FuelType    WITH(NOLOCK)   ON Asset.FuelType       = FuelType.LovId      
   LEFT JOIN  FMLovMst        AS PowerSpecification WITH(NOLOCK)   ON Asset.PowerSpecification     = PowerSpecification.LovId      
   LEFT JOIN  FMLovMst        AS PurchaseCategory  WITH(NOLOCK)   ON Asset.PurchaseCategory     = PurchaseCategory.LovId      
   LEFT JOIN  FMLovMst        AS LovAssetType   WITH(NOLOCK)   ON Asset.TypeOfAsset      = LovAssetType.LovId      
   LEFT JOIN  FMLovMst        AS TransferModeAsset WITH(NOLOCK)   ON Asset.TransferMode      = TransferModeAsset.LovId      
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
 OUTER APPLY ( SELECT SUM(DownTimeHours) AS DowntimeHoursMin FROM EngMwoCompletionInfoTxn A   
    INNER JOIN EngMaintenanceWorkOrderTxn B ON A.WorkOrderId=B.WorkOrderId      
    INNER JOIN EngAsset C ON B.AssetId  = C.AssetId      
    WHERE B.AssetId = @pAssetId AND C.WarrantyEndDate >= MaintenanceWorkDateTime      
    --GETDATE()      
    GROUP BY B.AssetId) WarDowntime    
 LEFT JOIN   MstLocationFacility AS MLF with (nolock) on mlf.facilityid = Asset.facilityid  
 LEFT JOIN   Mstservice AS MS WITH (NOLOCK) ON MS.ServiceId = Asset.ServiceId  
 LEFT JOIN   Mstcustomer AS MC WITH (NOLOCK) ON MC.customerid = Asset.customerid  
   WHERE Asset.AssetId = @pAssetId       
      
    
    
    
END TRY        
BEGIN CATCH        
        
 insert into ErrorLog(Spname,ErrorMessage,createddate)        
 values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())        
      
END CATCH        
      
SET NOCOUNT OFF        
      
END
GO
