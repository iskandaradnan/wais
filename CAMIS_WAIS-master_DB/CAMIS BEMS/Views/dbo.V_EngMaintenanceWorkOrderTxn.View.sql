USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngMaintenanceWorkOrderTxn]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
    
    
    
    
    
    
    
    
ALTER VIEW [dbo].[V_EngMaintenanceWorkOrderTxn]    
AS    
SELECT DISTINCT     
                         MWO.CustomerId, Customer.CustomerName, MWO.FacilityId, Facility.FacilityName, isnull(DATEDIFF(DD, MWO.MaintenanceWorkDateTime, MWO.ModifiedDate), 0) AS CountingDays, MWO.WorkOrderId, MWO.MaintenanceWorkNo,     
                         MWO.MaintenanceWorkDateTime, Asset.AssetNo, Asset.AssetDescription, 
						 case when MWO.MaintenanceWorkType=35 then RIUserAreaId.UserAreaCode else Userarea.UserAreaCode end AS UserArea, 
						 LovTypeOfPlanner.FieldValue AS TypeOfWorkOrder, LovTypeOfPlanner.FieldValue AS TypeOfWorkOrderGrid,     
                         'W2' AS WorkGroupCode, MWO.TargetDateTime, LovPriority.FieldValue AS WorkOrderPriority, LovMWOStatus.FieldValue AS WorkOrderStatus, LovMWOStatus.FieldValue AS WorkOrderStatusGrid, MWO.MaintenanceDetails,     
                         MWO.ModifiedDateUTC, SuppUserReg.ContractorId, SuppUserReg.UserRegistrationId, UMUser.UserRegistrationId AS TandCSupplier, UserLocation.UserLocationId AS UserLocationId,     
                         UserLocation.UserLocationCode AS UserLocationCode, UserLocation.UserLocationName AS LocationName, Assignee.UserRegistrationId AS Assignee_UserRegistrationId, Assignee.StaffName AS Assignee, MWO.IsDelete,    
       EngMwoAssesmen.ResponseDateTime,EngMwoAssesmen.ResponseDuration,EngMWOHandOverHistor.HandoverDateTime as HandOverDate,EngAssetClass.AssetClassificationDescription,WorkOrderCategory.LovId As WorkOrderCategoryTypeId,TRIM(WorkOrderCategory.FieldValue)
 As WorkOrderCategoryType  
FROM            EngMaintenanceWorkOrderTxn AS MWO WITH (NOLOCK) INNER JOIN    
                         MstCustomer AS Customer WITH (NOLOCK) ON MWO.CustomerId = Customer.CustomerId INNER JOIN    
                         MstLocationFacility AS Facility WITH (NOLOCK) ON MWO.FacilityId = Facility.FacilityId LEFT JOIN    
                         EngAsset AS Asset WITH (NOLOCK) ON MWO.AssetId = Asset.AssetId LEFT JOIN    
                         MstLocationUserLocation AS UserLocation WITH (NOLOCK) ON Asset.UserLocationId = UserLocation.UserLocationId LEFT JOIN    
                         FMLovMst AS LovTypeOfPlanner WITH (NOLOCK) ON MWO.TypeOfWorkOrder = LovTypeOfPlanner.LovId LEFT JOIN    
                         FMLovMst AS LovPriority WITH (NOLOCK) ON MWO.WorkOrderPriority = LovPriority.LovId LEFT JOIN    
                         FMLovMst AS LovMWOStatus WITH (NOLOCK) ON MWO.WorkOrderStatus = LovMWOStatus.LovId LEFT JOIN    
                         MstLocationUserArea AS Userarea WITH (NOLOCK) ON Asset.UserAreaId = Userarea.UserAreaId LEFT JOIN    
                         UMUserRegistration AS Assignee WITH (NOLOCK) ON MWO.AssignedUserId = Assignee.UserRegistrationId OUTER APPLY    
                             (SELECT        ContractorId, AssetId    
                               FROM            (SELECT        COR.ContractorId, CORDet.AssetId, RANK() OVER (Partition BY CORDet.AssetId    
                                                         ORDER BY COR.ContractorId, CORDet.AssetId) AS RowValue    
                               FROM            EngContractOutRegister COR INNER JOIN    
                                                         EngContractOutRegisterDet CORDet ON COR.ContractId = CORDet.ContractId    
                               WHERE        CORDet.AssetId = Asset.AssetId    
                               GROUP BY COR.ContractorId, CORDet.AssetId) a    
WHERE        RowValue = 1) Contractor LEFT JOIN    
EngTestingandCommissioningTxn TAndC ON Asset.AssetId = TAndC.AssetId LEFT JOIN    
MstContractorandVendor Contr ON TAndC.ContractorId = Contr.ContractorId LEFT JOIN    
UMUserRegistration UMUser ON Contr.ContractorId = UMUser.ContractorId LEFT JOIN    
UMUserRegistration AS SuppUserReg WITH (NOLOCK) ON Contractor.ContractorId = SuppUserReg.ContractorId    
LEFT JOIN    
EngMwoAssesmentTxn AS EngMwoAssesmen WITH (NOLOCK) ON MWO.WorkOrderId = EngMwoAssesmen.WorkOrderId    
    
LEFT JOIN    
EngMwoCompletionInfoTxn AS EngMWOHandOverHistor WITH (NOLOCK) ON MWO.WorkOrderId = EngMWOHandOverHistor.WorkOrderId    
LEFT JOIN    
EngAssetClassification AS EngAssetClass WITH (NOLOCK) ON Asset.AssetClassification = EngAssetClass.AssetClassificationId   
LEFT JOIN  
 FMLovMst AS WorkOrderCategory WITH (NOLOCK) ON MWO.WorkOrderCategoryType = WorkOrderCategory.LovId  
 LEFT  JOIN  MstLocationUserArea      AS RIUserAreaId      WITH(NOLOCK)   on MWO.UserAreaId    = RIUserAreaId.UserAreaId 
 WHERE        MWO.MaintenanceWorkCategory = 187    
    
  
GO


