
    
/*========================================================================================================        
Application Name : UETrack-BEMS                      
Version    : 1.0        
Procedure Name  : UspFM_EngPlannerTxn_GetById        
Description   : To Get the data from table EngPlannerTxn using the Primary Key id        
Authors    : Balaji M S        
Date    : 11-April-2018        
-----------------------------------------------------------------------------------------------------------        
        
Unit Test:        
EXEC [UspFM_EngPlannerTxn_GetById] @pPlannerId=10995,@pUserId=1        
        
-----------------------------------------------------------------------------------------------------------        
Version History         
-----:------------:---------------------------------------------------------------------------------------        
Init : Date       : Details        
      
Added Asset_Name,UserAreaCode,UserAreaName By Pranay kumar      
========================================================================================================*/        
ALTER PROCEDURE  [dbo].[UspFM_EngPlannerTxn_GetById]                                   
  @pUserId   INT = NULL,        
  @pPlannerId  INT        
        
        
AS                                                      
        
BEGIN TRY



        
        
        
 SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;        
        
    SELECT         
   Planner.PlannerId         AS PlannerId,        
   Planner.CustomerId         AS CustomerId,        
   Planner.FacilityId         AS FacilityId,        
    1       AS ServiceId,        
   ServiceKey.ServiceKey        AS ServiceKey,        
   Planner.[Year]          AS [Year],        
   PlannerYear.FieldValue        AS PlannerName,        
   planner.WorkGroupId         AS WorkGroupId,        
   --AssetWorkGroup.WorkGroupCode      AS WorkGroupCode,        
   --AssetWorkGroup.WorkGroupDescription     AS WorkGroupDescription,        
   'W2'            AS WorkGroupCode,        
   'Biomedical Engineering'       AS WorkGroupDescription,        
   Planner.TypeOfPlanner        AS TypeOfPlanner,        
   Planner.WorkOrderType        AS WorkOrderType,        
   WorkOrderType.FieldValue       AS WorkOrderTypeName,        
   --Planner.UserAreaId         AS UserAreaId,        
   (SELECT ISNULL(COUNT(DISTINCT AssetNo),0)        
   FROM EngAsset         
   WHERE UserAreaId = LocationUserArea.UserAreaId) AS TotalNoOfAssets,        
   LocationUserArea.UserAreaCode      AS UserAreaCode,        
   LocationUserArea.UserAreaName      AS UserAreaName,        
   Planner.AssigneeCompanyUserId      AS AssigneeCompanyStaffId,        
   CompanyStaff.StaffName        AS CompanyStaffName,        
   Planner.FacilityUserId        AS FacilityStaffId,        
   FacilityStaff.StaffName        AS HospitalStaffName,        
   Planner.AssetClassificationId      AS AssetClassificationId,        
   AssetClassification.AssetClassificationCode   AS AssetClassificationCode,        
   AssetClassification.AssetClassificationDescription  AS AssetClassificationDescription,        
   Planner.AssetTypeCodeId        AS AssetTypeCodeId,        
   AssetTypeCode.AssetTypeCode       AS AssetTypeCode,        
   AssetTypeCode.AssetTypeDescription     AS AssetTypeDescription,        
   Planner.AssetId          AS AssetId,        
   Asset.AssetNo          AS AssetNo,       
   Asset.Asset_Name     AS Asset_Name,      
   Planner.UserAreaId   AS UserAreaId,      
   LocationUserArea.UserAreaCode  AS UserAreaCode,      
   LocationUserArea.UserAreaName  AS UserAreaName,      
      
   Asset.WarrantyEndDate        AS WarrantyEndDate,        
   ContractorandVendor.SSMRegistrationCode    AS SSMRegistrationCode,        
   Contractor.ContractorName       AS MainSupplier,        
   ContractorContactInfo.ContactNo      AS WarrantyContactNo,        
   ContractOutRegister.ContractEndDate     AS ContractEndDate,        
   CContractorandVendor.SSMRegistrationCode   AS SSMRegistrationCode,        
   CContractorandVendor.ContractorName     AS ContractorName,        
   CContractorContactInfo.ContactNo     AS ContractContactNo,        
   Planner.StandardTaskDetId       AS StandardTaskDetId,        
   StandardTasks.TaskCode        AS TaskCode,        
   StandardTasks.TaskDescription      AS TaskDescription,        
   Planner.ContactNo         AS ContactNo,        
   Planner.EngineerUserId        AS EngineerStaffId,        
   EngineerStaff.StaffName        AS EngineerStaffName,        
   Planner.ScheduleType        AS ScheduleType,        
   ScheduleType.FieldValue        AS ScheduleTypeName,        
   Planner.Month          AS Month,        
   Planner.Date          AS Date,        
   Planner.Week          AS Week,        
   Planner.Day           AS Day,        
   Planner.Status          AS Status,        
   PlannerStatus.FieldValue       AS PlannerStatusName,        
   Planner.WarrantyType        AS WarrantyType,        
   WarrantyType.FieldValue        AS WarrantyTypeName,        
   Asset.SerialNo          AS SerialNo,        
   Model.Model           AS Model,        
   Manufacturer.Manufacturer       AS Manufacturer,        
   Planner.GenerationType        AS GenerationType,        
   GenerationType.FieldValue       AS GenerationTypeValue,        
   Planner.FirstDate         AS FirstDate,        
   Planner.NextDate         AS NextDate,        
   Planner.LastDate         AS LastDate,  
   StandardTasks.PPMCheckListId,
   StandardTasks.PPMfrequency,        
   frequencyLov.FieldValue as PPMfrequencyValue        
 FROM EngPlannerTxn          AS Planner     WITH(NOLOCK)        
   INNER JOIN  MstService        AS ServiceKey    WITH(NOLOCK)   ON Planner.ServiceId     = ServiceKey.ServiceId        
   --LEFT JOIN EngAssetWorkGroup      AS AssetWorkGroup   WITH(NOLOCK)   ON Planner.WorkGroupId     = AssetWorkGroup.WorkGroupId        
   LEFT  JOIN  MstLocationUserArea      AS LocationUserArea   WITH(NOLOCK)   ON Planner.UserAreaId     = LocationUserArea.UserAreaId         
   LEFT  JOIN  UMUserRegistration      AS CompanyStaff    WITH(NOLOCK)   ON Planner.AssigneeCompanyUserId  = CompanyStaff.UserRegistrationId         
   LEFT  JOIN  UMUserRegistration      AS FacilityStaff   WITH(NOLOCK)   ON Planner.FacilityUserId    = FacilityStaff.UserRegistrationId         
   LEFT  JOIN  UMUserRegistration      AS EngineerStaff   WITH(NOLOCK)   ON Planner.EngineerUserId    = EngineerStaff.UserRegistrationId         
   LEFT JOIN   EngAssetClassification     AS AssetClassification  WITH(NOLOCK)   ON Planner.AssetClassificationId  = AssetClassification.AssetClassificationId        
   LEFT  JOIN  EngAssetTypeCode      AS AssetTypeCode   WITH(NOLOCK)   on Planner.AssetTypeCodeId    = AssetTypeCode.AssetTypeCodeId          
   LEFT  JOIN  EngAsset        AS Asset     WITH(NOLOCK)   ON Planner.AssetId      = Asset.AssetId        
   LEFT  JOIN  EngAssetPPMCheckList     AS StandardTasks   WITH(NOLOCK)   ON Planner.StandardTaskDetId   = StandardTasks.PPMCheckListId --and AssetTypeCode.AssetTypeCodeId   = StandardTasks.AssetTypeCodeId        
   left  JOIN FMLovMst        AS  frequencyLov   WITH(NOLOCK)   ON frequencyLov.LovId     = StandardTasks.PPMFrequency        
   LEFT  JOIN  FMLovMst        AS ScheduleType    WITH(NOLOCK)   ON Planner.ScheduleType     = ScheduleType.LovId        
   LEFT  JOIN  FMLovMst        AS PlannerStatus   WITH(NOLOCK)   ON Planner.Status      = PlannerStatus.LovId        
   LEFT  JOIN  FMLovMst        AS WorkOrderType   WITH(NOLOCK)   ON Planner.WorkOrderType    = WorkOrderType.LovId        
   LEFT  JOIN  FMLovMst        AS WarrantyType    WITH(NOLOCK)   ON Planner.WarrantyType     = WarrantyType.LovId        
   LEFT  JOIN  EngAssetSupplierWarranty    AS AssetSupplier   WITH(NOLOCK)   ON Planner.AssetId      = AssetSupplier.AssetId AND  AssetSupplier.Category =13        
   LEFT  JOIN  MstContractorandVendor     AS ContractorandVendor  WITH(NOLOCK)   ON AssetSupplier.ContractorId   = ContractorandVendor.ContractorId        
   LEFT  JOIN MstContractorandVendorContactInfo  AS ContractorContactInfo WITH(NOLOCK)   ON ContractorandVendor.ContractorId  = ContractorContactInfo.ContractorId        
   LEFT  JOIN  EngContractOutRegisterDet    AS ContractOutRegisterDet WITH(NOLOCK)   ON Planner.AssetId      = ContractOutRegisterDet.AssetId        
   LEFT  JOIN EngContractOutRegister     AS ContractOutRegister  WITH(NOLOCK)   ON ContractOutRegisterDet.ContractId = ContractOutRegister.ContractId        
   LEFT  JOIN MstContractorandVendor     AS CContractorandVendor  WITH(NOLOCK)   ON ContractOutRegister.ContractorId  = CContractorandVendor.ContractorId        
   LEFT  JOIN MstContractorandVendorContactInfo  AS CContractorContactInfo WITH(NOLOCK)   ON CContractorandVendor.ContractorId = CContractorContactInfo.ContractorId        
   LEFT  JOIN  FMLovMst        AS PlannerYear    WITH(NOLOCK)   ON Planner.Year       = PlannerYear.LovId        
   LEFT  JOIN  EngAssetStandardizationModel   AS Model     WITH(NOLOCK)   ON Asset.Model       = Model.ModelId        
   LEFT  JOIN  EngAssetStandardizationManufacturer  AS Manufacturer    WITH(NOLOCK)   ON Asset.Manufacturer     = Manufacturer.ManufacturerId        
   LEFT  JOIN  FMLovMst        AS GenerationType   WITH(NOLOCK)   ON Planner.GenerationType    = GenerationType.LovId        
   LEFT  JOIN  EngTestingandCommissioningTxn   AS TAndC     WITH(NOLOCK)   ON Asset.AssetId      = TAndC.AssetId        
   LEFT  JOIN  MstContractorandVendor     AS Contractor    WITH(NOLOCK)   ON TAndC.ContractorId     = Contractor.ContractorId        
 WHERE Planner.PlannerId = @pPlannerId         
 ORDER BY Planner.ModifiedDate ASC        
         
        
        
        
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
