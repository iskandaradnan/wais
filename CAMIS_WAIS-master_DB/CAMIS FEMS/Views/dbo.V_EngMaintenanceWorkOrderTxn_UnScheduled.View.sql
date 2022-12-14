USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngMaintenanceWorkOrderTxn_UnScheduled]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
      
      
      
      
      
      
CREATE VIEW [dbo].[V_EngMaintenanceWorkOrderTxn_UnScheduled]      
      
AS      
 SELECT  Distinct      
    MWO.CustomerId,      
    Customer.CustomerName,      
    MWO.FacilityId,      
    Facility.FacilityName,     
 Userarea.UserAreaCode AS Department,   
    isnull(DATEDIFF(DD,MWO.MaintenanceWorkDateTime,MWO.ModifiedDate), 0) as CountingDays,     
    MWO.WorkOrderId,      
    MWO.MaintenanceWorkNo,      
    CAST(MWO.MaintenanceWorkDateTime AS DATE)  AS MaintenanceWorkDateTime,      
    Asset.AssetNo,      
    Asset.AssetDescription,      
    LovTypeOfPlanner.FieldValue AS TypeOfWorkOrder,      
     TRIM(LovTypeOfPlanner.FieldValue) AS WorkOrderCategoryGrid,      
    LovTypeOfPlanner.LovId AS WorkOrderCategoryLovId,      
    WorkGroup.WorkGroupCode,      
    MWO.TargetDateTime,      
    LovPriority.FieldValue  AS WorkOrderPriority,      
    LovPriority.FieldValue  AS WorkOrderPriorityGrid,      
    LovPriority.LovId   AS WorkOrderPriorityLovId,      
    LovMWOStatus.LovId   AS WorkOrderStatusId,      
    LovMWOStatus.FieldValue  AS WorkOrderStatus,      
    LovMWOStatus.FieldValue  AS WorkOrderStatusGrid,      
    MWO.MaintenanceDetails,      
    MWO.ModifiedDateUTC      
    ,SuppUserReg.ContractorId,      
    SuppUserReg.UserRegistrationId,      
    UserLocation.UserLocationId as UserLocationId,      
    UserLocation.UserLocationCode as UserLocationCode,      
    UserLocation.UserLocationName as LocationName,      
    Assignee.UserRegistrationId as Assignee_UserRegistrationId,      
    Assignee.StaffName as AssigneeName,      
    AssesmentTxn.ResponseDateTime as AssessmentResponsedate,      
    AssesmentTxn.AssignedVendor  as AssignedVendorid,      
    MWO.IsDelete,      
          
      EngMwoAssesmen.ResponseDateTime,EngMwoAssesmen.ResponseDuration,EngMWOHandOverHistor.CreatedDate as HandOverDate,EngAssetClass.AssetClassificationDescription      
 FROM  EngMaintenanceWorkOrderTxn AS MWO    WITH(NOLOCK)      
    INNER JOIN MstCustomer     AS Customer   WITH(NOLOCK) ON MWO.CustomerId    = Customer.CustomerId      
    INNER JOIN MstLocationFacility   AS Facility   WITH(NOLOCK) ON MWO.FacilityId    = Facility.FacilityId      
    INNER JOIN EngAsset      AS Asset    WITH(NOLOCK) ON MWO.AssetId     = Asset.AssetId      
    LEFT  JOIN MstLocationUserLocation  AS UserLocation  WITH(NOLOCK) ON Asset.UserLocationId  = UserLocation.UserLocationId      
    INNER JOIN FMLovMst      AS LovTypeOfPlanner WITH(NOLOCK) ON MWO.TypeOfWorkOrder   = LovTypeOfPlanner.LovId      
    LEFT JOIN EngAssetWorkGroup   AS WorkGroup   WITH(NOLOCK) ON Asset.WorkGroupId   = WorkGroup.WorkGroupId      
    LEFT JOIN FMLovMst      AS LovPriority   WITH(NOLOCK) ON MWO.WorkOrderPriority  = LovPriority.LovId      
    LEFT JOIN FMLovMst      AS LovMWOStatus  WITH(NOLOCK) ON MWO.WorkOrderStatus   = LovMWOStatus.LovId     
 LEFT JOIN MstLocationUserArea AS Userarea WITH (NOLOCK) ON Asset.UserAreaId = Userarea.UserAreaId      
    LEFT  JOIN UMUserRegistration   AS Assignee   WITH(NOLOCK) ON MWO.AssignedUserId  = Assignee.UserRegistrationId      
          
    OUTER APPLY (select ContractorId,AssetId from      
       (select COR.ContractorId,CORDet.AssetId,RANK() over(Partition by CORDet.AssetId order by COR.ContractorId,CORDet.AssetId ) as RowValue      
       from EngContractOutRegister COR      
       inner join  EngContractOutRegisterDet CORDet on COR.ContractId=CORDet.ContractId       
       WHERE CORDet.AssetId=Asset.AssetId      
       group by COR.ContractorId,CORDet.AssetId)a where RowValue =1  ) Contractor      
    LEFT JOIN UMUserRegistration     AS SuppUserReg  WITH(NOLOCK) ON Contractor.ContractorId = SuppUserReg.ContractorId      
    LEFT JOIN   EngMwoAssesmentTxn                  AS AssesmentTxn     WITH(NOLOCK)     ON MWO.WorkOrderId         =    AssesmentTxn.WorkOrderId       
          
          
    LEFT JOIN      
EngMwoAssesmentTxn AS EngMwoAssesmen WITH (NOLOCK) ON MWO.WorkOrderId = EngMwoAssesmen.WorkOrderId      
     
LEFT JOIN      
EngMWOHandOverHistoryTxn AS EngMWOHandOverHistor WITH (NOLOCK) ON MWO.WorkOrderId = EngMWOHandOverHistor.WorkOrderId      
LEFT JOIN      
EngAssetClassification AS EngAssetClass WITH (NOLOCK) ON Asset.AssetClassification = EngAssetClass.AssetClassificationId            
   WHERE MWO.MaintenanceWorkCategory = 188   
GO
