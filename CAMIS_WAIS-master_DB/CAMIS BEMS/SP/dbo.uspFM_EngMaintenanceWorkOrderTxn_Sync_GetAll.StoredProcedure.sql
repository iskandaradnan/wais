USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMaintenanceWorkOrderTxn_Sync_GetAll]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================  
Application Name : UETrack-BEMS                
Version    : 1.0  
Procedure Name  : uspFM_EngMaintenanceWorkOrderTxn_Sync_GetAll  
Description   : To Maintenance WorkOrder details   
Authors    : Dhilip V  
Date    : 07-June-2018  
-----------------------------------------------------------------------------------------------------------  
  
Unit Test:  
EXEC [uspFM_EngMaintenanceWorkOrderTxn_Sync_GetAll] @pWorkOrderId='25,26'  
select * from MstLocationFacility  
-----------------------------------------------------------------------------------------------------------  
Version History   
-----:------------:---------------------------------------------------------------------------------------  
Init : Date       : Details  
========================================================================================================*/  
  
CREATE PROCEDURE  [dbo].[uspFM_EngMaintenanceWorkOrderTxn_Sync_GetAll]     
                          
  
  @pWorkOrderId  nvarchar(1000)  
  
  
AS                                                
  
BEGIN TRY  
  
  
 SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
 select AssetId,SUM(B.ContractValue)ContractValue INTO #ContractValue from EngContractOutRegister A INNER JOIN EngContractOutRegisterDet B ON A.ContractId = B.ContractId  
 WHERE CAST(A.ContractEndDate AS DATE) > CAST(GETDATE() AS DATE)  
 GROUP BY AssetId  
  
  
    SELECT MaintenanceWorkOrder.WorkOrderId     AS WorkOrderId,  
   MaintenanceWorkOrder.CustomerId      AS CustomerId,  
   MaintenanceWorkOrder.FacilityId      AS FacilityId,  
   MaintenanceWorkOrder.ServiceId      AS ServiceId,  
   MaintenanceWorkOrder.AssetId      AS AssetId,  
   Asset.AssetNo          AS AssetNo,  
   --Asset.AssetDescription        AS AssetDescription,  
   MaintenanceWorkOrder.MaintenanceWorkNo    AS MaintenanceWorkNo,  
   MaintenanceWorkOrder.MaintenanceDetails    AS MaintenanceDetails,  
   MaintenanceWorkOrder.MaintenanceWorkDateTime  AS [StartDateTime],  
   MaintenanceWorkOrder.TargetDateTime     AS TargetDateTime,  
   --MaintenanceWorkOrder.EngineerUserId     AS EngineerStaffId,  
   --EngineerStaffId.StaffName       AS EngineerStaffIdValue,  
   --MaintenanceWorkOrder.RequestorUserId    AS RequestorStaffId,  
   --RequestorStaffId.StaffName       AS RequestorStaffIdValue,  
   MaintenanceWorkOrder.WorkOrderPriority    AS WorkOrderPriority,  
   WorkOrderPriority.FieldValue      AS WorkOrderPriorityValue,  
   MaintenanceWorkOrder.TypeOfWorkOrder    AS TypeOfWorkOrder,  
   TypeOfWorkOrder.FieldValue       AS TypeOfWorkOrderValue,  
   WorkOrderStatus.FieldValue       AS WorkOrderStatus,  
   MaintenanceWorkOrder.MaintenanceWorkCategory  AS  MaintenanceWorkCategory,  
   MaintenanceWorkCategory.FieldValue     AS MaintenanceWorkCategoryValue,  
   ISNULL(Facility.Address,'') +' ' + ISNULL(Facility.Address2,'')   AS [HospitalAddress],  
   ISNULL(cast( Facility.Latitude as varchar(500)),'') +',' + ISNULL(cast(Facility.Longitude as varchar(500)),'')  AS [DesginationCode],     
   MaintenanceWorkOrder.MobileGuid      AS MobileGuid,  
   MaintenanceWorkOrder.WOImage      AS WOImage,  
   MaintenanceWorkOrder.WOVideo      AS WOVideo,  
   MaintenanceWorkOrder.UserAreaId      AS UserAreaId,  
   UserArea.UserAreaCode        AS UserAreaCode,  
   UserArea.UserAreaName        AS UserAreaName,  
   Asset.ContractType         AS ContractType,  
   ContractType.FieldValue        AS ContractTypeValue,  
   ISNULL(Contractor.ContractValue,0)    AS ContractValue,  
   MaintenanceWorkOrder.AssignedUserId     AS AssignedUserId,  
   MaintenanceWorkOrder.WorkOrderStatus      AS WorkOrderStatusInt  ,
    MaintenanceWorkOrder.MaintenanceWorkDateTime AS MaintenanceWorkDateTime
 FROM EngMaintenanceWorkOrderTxn       AS MaintenanceWorkOrder    WITH(NOLOCK)  
   INNER JOIN  MstService        AS ServiceKey      WITH(NOLOCK) ON MaintenanceWorkOrder.ServiceId    = ServiceKey.ServiceId  
   INNER JOIN  MstLocationFacility      AS Facility       WITH(NOLOCK) ON MaintenanceWorkOrder.FacilityId    = Facility.FacilityId  
   LEFT  JOIN  EngAsset        AS Asset       WITH(NOLOCK) ON MaintenanceWorkOrder.AssetId     = Asset.AssetId  
   LEFT  JOIN  MstLocationUserArea      AS UserArea       WITH(NOLOCK) ON MaintenanceWorkOrder.UserAreaId    = UserArea.UserAreaId  
   LEFT  JOIN  UMUserRegistration      AS EngineerStaffId     WITH(NOLOCK) ON MaintenanceWorkOrder.EngineerUserId   = EngineerStaffId.UserRegistrationId  
   LEFT  JOIN  UMUserRegistration      AS RequestorStaffId     WITH(NOLOCK) ON MaintenanceWorkOrder.RequestorUserId   = RequestorStaffId.UserRegistrationId  
   LEFT  JOIN  FMLovMst        AS WorkType       WITH(NOLOCK) ON MaintenanceWorkOrder.MaintenanceWorkType  = WorkType.LovId  
   LEFT  JOIN  FMLovMst        AS TypeOfWorkOrder     WITH(NOLOCK) ON MaintenanceWorkOrder.TypeOfWorkOrder   = TypeOfWorkOrder.LovId  
   LEFT  JOIN  FMLovMst        AS WorkOrderPriority    WITH(NOLOCK) ON MaintenanceWorkOrder.WorkOrderPriority  = WorkOrderPriority.LovId  
   LEFT  JOIN  FMLovMst        AS WorkOrderStatus     WITH(NOLOCK) ON MaintenanceWorkOrder.WorkOrderStatus   = WorkOrderStatus.LovId  
   LEFT  JOIN  FMLovMst        AS MaintenanceWorkCategory   WITH(NOLOCK) ON MaintenanceWorkOrder.MaintenanceWorkCategory = MaintenanceWorkCategory.LovId  
   LEFT  JOIN  FMLovMst        AS ContractType      WITH(NOLOCK) ON Asset.ContractType       = ContractType.LovId  
   OUTER APPLY (SELECT DISTINCT TOP 1 ContractorId,AssetId, ContractValue from  
      (SELECT COR.ContractorId,CORDet.AssetId,SUM(ContractValue) AS ContractValue,RANK() over(Partition by CORDet.AssetId order by COR.ContractorId,CORDet.AssetId ) as RowValue  
      from EngContractOutRegister COR  
      inner join  EngContractOutRegisterDet CORDet on COR.ContractId=CORDet.ContractId   
      WHERE CORDet.AssetId=Asset.AssetId  
      group by COR.ContractorId,CORDet.AssetId)a where RowValue =1  ) Contractor  
 WHERE MaintenanceWorkOrder.WorkOrderId  IN  (SELECT ITEM FROM dbo.[SplitString] (@pWorkOrderId,','))     
 ORDER BY MaintenanceWorkOrder.ModifiedDate ASC  
  
  
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
