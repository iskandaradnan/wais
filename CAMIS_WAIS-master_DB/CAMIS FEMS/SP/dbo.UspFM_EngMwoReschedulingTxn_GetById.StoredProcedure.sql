USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngMwoReschedulingTxn_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================  
Application Name : UETrack-BEMS                
Version    : 1.0  
Procedure Name  : UspFM_EngMwoReschedulingTxn_GetById  
Description   : To Get the data from table EngPPMRescheduleTxnDet using the Primary Key id  
Authors    : Balaji M S  
Date    : 30-Mar-2018  
Date    : 11-Nov-2019 
-----------------------------------------------------------------------------------------------------------  
  
Unit Test:  
EXEC [UspFM_EngMwoReschedulingTxn_GetById] @pWorkOrderId=134, @pUserId='1'  
  
-----------------------------------------------------------------------------------------------------------  
Version History   
-----:------------:---------------------------------------------------------------------------------------  
Init : Date       : Details  
========================================================================================================*/  
CREATE PROCEDURE  [dbo].[UspFM_EngMwoReschedulingTxn_GetById]                             
  @pUserId      INT  =null,   
  @pWorkOrderId     INT   
AS                                                
  
BEGIN TRY  
  
  
 SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
 IF(ISNULL(@pWorkOrderId,0) = 0) RETURN  
  
    SELECT PPMReschedule.WorkOrderReschedulingId        AS WorkOrderReschedulingId,  
   PPMReschedule.WorkOrderId           AS WorkOrderId,  
   WorkOrder.MaintenanceWorkNo           AS MaintenanceWorkNo,  
   WorkOrder.MaintenanceWorkDateTime         AS MaintenanceWorkDateTime, 
    WorkOrder.RescheduleRemarks AS RescheduleRemarks,
   Asset.AssetNo              AS AssetNo,  
   Asset.AssetDescription            AS AssetDescription,  
   AssetTypeCode.AssetTypeCodeId          AS AssetTypeCodeId,  
   AssetTypeCode.AssetTypeCode           AS AssetTypeCode,  
   TypeofPlanners.FieldValue           AS TypeOfPlanner,  
   WorkOrder.MaintenanceDetails          AS MaintenanceDetails,  
   WorkOrder.TargetDateTime           AS TargetDateTime,  
   dbo.[EngNextScheduleDateCalc](3,WorkOrder.TargetDateTime)   AS NextScheduleDate,  
   PPMReschedule.RescheduleDate          AS RescheduleDate,  
   --PPMReschedule.RescheduleApprovedBy         AS RescheduleApprovedBy,  
   --Staff.StaffName              AS RescheduleApprovedByValue,  
   --Reasons.LovId              AS ReasonId,  
   --Reasons.FieldValue             AS ReasonName,  
   isnull(PPMReschedule.Remarks,'')                 AS ReasonName,  
   CASE  
    WHEN  PPMReschedule.ImpactSchedulePlanner=0 THEN 'No'  
    WHEN  PPMReschedule.ImpactSchedulePlanner=1 THEN 'Yes'  
   END                 AS ImpactSchedulePlanner  
 FROM EngMwoReschedulingTxn            AS PPMReschedule  WITH(NOLOCK)  
   INNER JOIN  EngMaintenanceWorkOrderTxn        AS WorkOrder   WITH(NOLOCK)   on PPMReschedule.WorkOrderId   = WorkOrder.WorkOrderId  
   INNER JOIN EngAsset            AS Asset    WITH(NOLOCK)   on WorkOrder.AssetId     = Asset.AssetId  
   INNER JOIN EngAssetTypeCode          AS AssetTypeCode  WITH(NOLOCK)   on Asset.AssetTypeCodeId    = AssetTypeCode.AssetTypeCodeId  
   LEFT JOIN  EngPlannerTxn           AS Planner    WITH(NOLOCK)   on WorkOrder.PlannerId     = Planner.PlannerId  
   LEFT JOIN UMUserRegistration          AS Staff    WITH(NOLOCK)   on PPMReschedule.RescheduleApprovedBy = Staff.UserRegistrationId  
   INNER JOIN FMLovMst            AS TypeofPlanners  WITH(NOLOCK)   on WorkOrder.TypeOfWorkOrder   = TypeofPlanners.LovId  
   --INNER JOIN FMLovMst            AS Reasons    WITH(NOLOCK)   on PPMReschedule.Reason     = Reasons.LovId  
 WHERE PPMReschedule.WorkOrderId = @pWorkOrderId   
 ORDER BY PPMReschedule.ModifiedDate DESC  
END TRY  
  
BEGIN CATCH  
  
 INSERT INTO ErrorLog(  
    Spname,  
    ErrorMessage,  
    createddate)  
 VALUES(  OBJECT_NAME(@@PROCID),  
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),  
    getdate()  
     );  
  THROW;  
  
END CATCH
GO
