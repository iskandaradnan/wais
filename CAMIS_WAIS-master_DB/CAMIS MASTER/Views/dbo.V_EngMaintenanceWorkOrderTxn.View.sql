USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_EngMaintenanceWorkOrderTxn]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
CREATE VIEW [dbo].[V_EngMaintenanceWorkOrderTxn]  
AS  
  
 SELECT  DISTINCT MWO.CustomerId,  
    Customer.CustomerName,  
    MWO.FacilityId,  
    Facility.FacilityName,  
    isnull(DATEDIFF(DD,MWO.TargetDateTime,GETDATE()),0) AS CountingDays,  
    MWO.WorkOrderId,  
    MWO.MaintenanceWorkNo,  
    MWO.MaintenanceWorkDateTime,  
    Asset.AssetNo,  
    Asset.AssetDescription,  
    Userarea.UserAreaCode AS UserArea,  
    LovTypeOfPlanner.FieldValue AS TypeOfWorkOrder,  
    LovTypeOfPlanner.FieldValue AS TypeOfWorkOrderGrid,  
    'W2' AS WorkGroupCode,  
    MWO.TargetDateTime,  
    LovPriority.FieldValue  AS WorkOrderPriority,  
    LovMWOStatus.FieldValue  AS WorkOrderStatus,  
    LovMWOStatus.FieldValue  AS WorkOrderStatusGrid,  
    MWO.MaintenanceDetails,  
    MWO.ModifiedDateUTC,  
    SuppUserReg.ContractorId,  
    SuppUserReg.UserRegistrationId,  
    UMUser.UserRegistrationId AS TandCSupplier,  
    UserLocation.UserLocationId as UserLocationId,  
    UserLocation.UserLocationCode as UserLocationCode,  
    UserLocation.UserLocationName as LocationName,  
    Assignee.UserRegistrationId as Assignee_UserRegistrationId,  
    Assignee.StaffName as Assignee  
 FROM  EngMaintenanceWorkOrderTxn AS MWO    WITH(NOLOCK)  
    INNER JOIN MstCustomer     AS Customer   WITH(NOLOCK) ON MWO.CustomerId    = Customer.CustomerId  
    INNER JOIN MstLocationFacility   AS Facility   WITH(NOLOCK) ON MWO.FacilityId    = Facility.FacilityId  
    LEFT JOIN EngAsset      AS Asset    WITH(NOLOCK) ON MWO.AssetId     = Asset.AssetId  
    LEFT  JOIN MstLocationUserLocation  AS UserLocation  WITH(NOLOCK) ON Asset.UserLocationId  = UserLocation.UserLocationId  
    left JOIN FMLovMst      AS LovTypeOfPlanner WITH(NOLOCK) ON MWO.TypeOfWorkOrder   = LovTypeOfPlanner.LovId  
    LEFT JOIN FMLovMst      AS LovPriority   WITH(NOLOCK) ON MWO.WorkOrderPriority  = LovPriority.LovId  
    LEFT JOIN FMLovMst      AS LovMWOStatus  WITH(NOLOCK) ON MWO.WorkOrderStatus   = LovMWOStatus.LovId  
    LEFT JOIN MstLocationUserArea   AS Userarea   WITH(NOLOCK) ON Asset.UserAreaId   = Userarea.UserAreaId  
    LEFT  JOIN UMUserRegistration   AS Assignee   WITH(NOLOCK) ON MWO.AssignedUserId  = Assignee.UserRegistrationId  
    OUTER APPLY (select ContractorId,AssetId from  
       (select COR.ContractorId,CORDet.AssetId,RANK() over(Partition by CORDet.AssetId order by COR.ContractorId,CORDet.AssetId ) as RowValue  
       from EngContractOutRegister COR  
       inner join  EngContractOutRegisterDet CORDet on COR.ContractId=CORDet.ContractId   
       WHERE CORDet.AssetId=Asset.AssetId  
       group by COR.ContractorId,CORDet.AssetId)a where RowValue =1  ) Contractor  
    LEFT JOIN EngTestingandCommissioningTxn TAndC ON Asset.AssetId = TAndC.AssetId  
    LEFT JOIN MstContractorandVendor Contr ON TAndC.ContractorId = Contr.ContractorId  
    LEFT JOIN UMUserRegistration UMUser ON Contr.ContractorId = UMUser.ContractorId  
    LEFT JOIN UMUserRegistration     AS SuppUserReg  WITH(NOLOCK) ON Contractor.ContractorId = SuppUserReg.ContractorId  
       
   WHERE MWO.MaintenanceWorkCategory = 187
GO
