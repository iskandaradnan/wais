USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_EngMaintenanceWorkOrderTxn_UnSchedule_Export]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
CREATE VIEW [dbo].[V_EngMaintenanceWorkOrderTxn_UnSchedule_Export]  
AS  
  
 SELECT  Distinct  
    MWO.CustomerId,  
    Customer.CustomerName,  
    MWO.FacilityId,  
    Facility.FacilityName,  
  
    MWO.WorkOrderId,  
    MWO.MaintenanceWorkNo,  
    cast(MWO.MaintenanceWorkDateTime as datetime) AS MaintenanceWorkDateTime,  
    Asset.AssetNo,  
    Asset.AssetDescription,  
    LovTypeOfPlanner.FieldValue AS TypeOfWorkOrder,  
    LovTypeOfPlanner.FieldValue AS WorkOrderCategoryGrid,  
    WorkGroup.WorkGroupCode,  
    MWO.TargetDateTime,  
    LovPriority.FieldValue  AS WorkOrderPriority,  
    LovPriority.FieldValue  AS WorkOrderPriorityGrid,  
    LovMWOStatus.LovId   AS WorkOrderStatusId,  
    LovMWOStatus.FieldValue  AS WorkOrderStatus,  
    LovMWOStatus.FieldValue  AS WorkOrderStatusGrid,  
    MWO.MaintenanceDetails,  
    MWO.EngineerUserId,  
    EngineerUserId.StaffName AS EngineerUserName,  
    MWO.MaintenanceWorkType,  
    MaintenanceWorkType.FieldValue AS MaintenanceWorkTypeValue,  
    Model.Model,  
    Manufacturer.Manufacturer,  
    MWO.ModifiedDateUTC,  
    SuppUserReg.UserRegistrationId,  
    UserLocation.UserLocationId as UserLocationId,  
    UserLocation.UserLocationCode as UserLocationCode,  
    UserLocation.UserLocationName as UserLocationName,  
    Assignee.UserRegistrationId as Assignee_UserRegistrationId,  
    Assignee.StaffName as AssigneeName,  
    DATEDIFF(DD,MWO.MaintenanceWorkDateTime,GETDATE()) CountingDays,  
    AssesmentTxn.AssignedVendor  as AssignedVendorid,  
    AssesmentTxn.ResponseDateTime as AssessmentResponsedate  
 FROM  EngMaintenanceWorkOrderTxn AS MWO    WITH(NOLOCK)  
    INNER JOIN MstCustomer     AS Customer   WITH(NOLOCK) ON MWO.CustomerId = Customer.CustomerId  
    INNER JOIN MstLocationFacility   AS Facility   WITH(NOLOCK) ON MWO.FacilityId = Facility.FacilityId  
    INNER JOIN EngAsset      AS Asset    WITH(NOLOCK) ON MWO.AssetId    = Asset.AssetId  
    LEFT  JOIN MstLocationUserLocation  AS UserLocation  WITH(NOLOCK) ON Asset.UserLocationId  = UserLocation.UserLocationId  
    INNER JOIN FMLovMst      AS LovTypeOfPlanner WITH(NOLOCK) ON MWO.TypeOfWorkOrder  = LovTypeOfPlanner.LovId  
    LEFT JOIN EngAssetWorkGroup   AS WorkGroup   WITH(NOLOCK) ON Asset.WorkGroupId  = WorkGroup.WorkGroupId  
    LEFT JOIN FMLovMst      AS LovPriority   WITH(NOLOCK) ON MWO.WorkOrderPriority  = LovPriority.LovId  
    LEFT JOIN FMLovMst      AS LovMWOStatus  WITH(NOLOCK) ON MWO.WorkOrderStatus  = LovMWOStatus.LovId    
    LEFT JOIN UMUserRegistration   AS EngineerUserId  WITH(NOLOCK) ON MWO.EngineerUserId  = EngineerUserId.UserRegistrationId    
    LEFT JOIN FMLovMst      AS MaintenanceWorkType WITH(NOLOCK) ON MWO.MaintenanceWorkType  = MaintenanceWorkType.LovId   
    LEFT JOIN EngAssetStandardizationModel AS Model    WITH(NOLOCK) ON Asset.Model  = Model.ModelId   
    LEFT JOIN EngAssetStandardizationManufacturer  AS Manufacturer WITH(NOLOCK) ON Asset.Manufacturer  = Manufacturer.ManufacturerId    
    LEFT  JOIN UMUserRegistration   AS Assignee   WITH(NOLOCK) ON MWO.AssignedUserId  = Assignee.UserRegistrationId  
    OUTER APPLY (select ContractorId,AssetId from  
       (select COR.ContractorId,CORDet.AssetId,RANK() over(Partition by CORDet.AssetId order by COR.ContractorId,CORDet.AssetId ) as RowValue  
       from EngContractOutRegister COR  
       inner join  EngContractOutRegisterDet CORDet on COR.ContractId=CORDet.ContractId   
       WHERE CORDet.AssetId=Asset.AssetId  
       group by COR.ContractorId,CORDet.AssetId)a where RowValue =1  ) Contractor  
  
    LEFT JOIN UMUserRegistration     AS SuppUserReg  WITH(NOLOCK) ON Contractor.ContractorId = SuppUserReg.ContractorId  
    LEFT JOIN   EngMwoAssesmentTxn                  AS AssesmentTxn     WITH(NOLOCK)     ON MWO.WorkOrderId         =    AssesmentTxn.WorkOrderId     
   WHERE MWO.MaintenanceWorkCategory = 188
GO
