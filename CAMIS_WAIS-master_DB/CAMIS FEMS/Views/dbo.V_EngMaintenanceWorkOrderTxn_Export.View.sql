USE [UetrackFemsdbPreProd]
GO

/****** Object:  View [dbo].[V_EngMaintenanceWorkOrderTxn_Export]    Script Date: 12-01-2022 16:28:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP VIEW [dbo].[V_EngMaintenanceWorkOrderTxn_Export]
GO
              
CREATE VIEW [dbo].[V_EngMaintenanceWorkOrderTxn_Export]              
AS              
        WITH CTE AS(SELECT MIN(StartDateTime) StartDateTime,    
 MAX(EndDateTime) EndDateTime,    
 WorkOrderId     
 FROM EngMwoCompletionInfoTxn GROUP BY WorkOrderId)    
     
 SELECT  Distinct              
    MWO.CustomerId,              
    Customer.CustomerName,              
    MWO.FacilityId,              
    Facility.FacilityName,              
    MWO.WorkOrderId,              
    MWO.MaintenanceWorkNo,              
    MWO.MaintenanceWorkDateTime,              
    Asset.AssetNo,              
    Asset.AssetDescription,         
 CASE WHEN MWO.TypeOfWorkOrder=35 THEN 'RI-001' ELSE TaskCode.TaskCode END AS Taskcode,      
    Userarea.UserAreaCode AS UserArea,           
  WorkOrderCategory.FieldValue As WorkOrderCategoryType,            
    LovTypeOfPlanner.FieldValue AS TypeOfWorkOrder,              
    LovTypeOfPlanner.FieldValue AS TypeOfWorkOrderGrid,              
    WorkGroup.WorkGroupCode,              
    MWO.TargetDateTime,              
    LovPriority.FieldValue  AS WorkOrderPriority,              
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
    UserLocation.UserLocationName as LocationName,              
    Assignee.UserRegistrationId as Assignee_UserRegistrationId,              
    Assignee.StaffName as AssigneeName,    
 CTE.StartDateTime,    
 CTE.EndDateTime,  
    isnull(DATEDIFF(DD,MWO.TargetDateTime,GETDATE()),0) AS CountingDays,              
      EngMwoAssesmen.ResponseDateTime,EngMwoAssesmen.ResponseDuration,EngMWOHandOverHistor.CreatedDate as HandOverDate,EngAssetClass.AssetClassificationDescription              
 FROM  EngMaintenanceWorkOrderTxn AS MWO    WITH(NOLOCK)              
    INNER JOIN MstCustomer     AS Customer   WITH(NOLOCK) ON MWO.CustomerId = Customer.CustomerId              
    INNER JOIN MstLocationFacility   AS Facility   WITH(NOLOCK) ON MWO.FacilityId = Facility.FacilityId              
    LEFT OUTER JOIN EngAsset      AS Asset    WITH(NOLOCK) ON MWO.AssetId    = Asset.AssetId              
    LEFT  JOIN MstLocationUserLocation  AS UserLocation  WITH(NOLOCK) ON Asset.UserLocationId  = UserLocation.UserLocationId              
    INNER JOIN FMLovMst      AS LovTypeOfPlanner WITH(NOLOCK) ON MWO.TypeOfWorkOrder  = LovTypeOfPlanner.LovId              
    LEFT JOIN EngAssetWorkGroup   AS WorkGroup   WITH(NOLOCK) ON Asset.WorkGroupId  = WorkGroup.WorkGroupId              
    LEFT JOIN FMLovMst      AS LovPriority   WITH(NOLOCK) ON MWO.WorkOrderPriority  = LovPriority.LovId              
    LEFT JOIN FMLovMst      AS LovMWOStatus  WITH(NOLOCK) ON MWO.WorkOrderStatus  = LovMWOStatus.LovId                
    LEFT JOIN UMUserRegistration   AS EngineerUserId  WITH(NOLOCK) ON MWO.EngineerUserId  = EngineerUserId.UserRegistrationId                
    LEFT JOIN FMLovMst      AS MaintenanceWorkType WITH(NOLOCK) ON MWO.MaintenanceWorkType  = MaintenanceWorkType.LovId                
    LEFT JOIN MstLocationUserArea   AS Userarea   WITH(NOLOCK) ON Asset.UserAreaId  = Userarea.UserAreaId                
    LEFT JOIN EngAssetStandardizationModel AS Model    WITH(NOLOCK) ON Asset.Model  = Model.ModelId                
    LEFT JOIN EngAssetStandardizationManufacturer AS Manufacturer    WITH(NOLOCK) ON Asset.Manufacturer  = Manufacturer.ManufacturerId                
    LEFT  JOIN UMUserRegistration   AS Assignee   WITH(NOLOCK) ON MWO.AssignedUserId  = Assignee.UserRegistrationId              
    OUTER APPLY (select ContractorId,AssetId from              
       (select COR.ContractorId,CORDet.AssetId,RANK() over(Partition by CORDet.AssetId order by COR.ContractorId,CORDet.AssetId ) as RowValue              
       from EngContractOutRegister COR              
       inner join  EngContractOutRegisterDet CORDet on COR.ContractId=CORDet.ContractId               
       WHERE CORDet.AssetId=Asset.AssetId              
       group by COR.ContractorId,CORDet.AssetId)a where RowValue =1  ) Contractor           
              
    LEFT JOIN UMUserRegistration     AS SuppUserReg  WITH(NOLOCK) ON Contractor.ContractorId = SuppUserReg.ContractorId              
    LEFT JOIN              
EngMwoAssesmentTxn AS EngMwoAssesmen WITH (NOLOCK) ON MWO.WorkOrderId = EngMwoAssesmen.WorkOrderId              
              
LEFT JOIN              
EngMWOHandOverHistoryTxn AS EngMWOHandOverHistor WITH (NOLOCK) ON MWO.WorkOrderId = EngMWOHandOverHistor.WorkOrderId              
LEFT JOIN              
EngAssetClassification AS EngAssetClass WITH (NOLOCK) ON Asset.AssetClassification = EngAssetClass.AssetClassificationId            
LEFT JOIN              
 FMLovMst AS WorkOrderCategory WITH (NOLOCK) ON MWO.WorkOrderCategoryType = WorkOrderCategory.LovId           
 -- Below 3 lines commented and new line added to get Task code directly from PPM Checklist table          
 --  LEFT JOIN EngAssetPPMCheckList AS Taskcode WITH  (NOLOCK) ON Asset.AssetTypeCodeId =Taskcode.AssetTypeCodeId        
 --AND Model.ModelId =Taskcode.ModelId         
 --AND Manufacturer.ManufacturerId = Taskcode.ManufacturerId
  LEFT JOIN EngAssetPPMCheckList AS Taskcode WITH  (NOLOCK) ON mwo.StandardTaskDetId =Taskcode.PPMCheckListId     
 LEFT JOIN CTE ON MWO.WorkOrderId=CTE.WorkOrderId    
   WHERE MWO.MaintenanceWorkCategory = 187 
GO


