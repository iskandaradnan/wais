USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngMaintenanceWorkOrderTxn_GetById]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================    
Application Name : UETrack-BEMS                  
Version    : 1.0    
Procedure Name  : UspFM_EngMaintenanceWorkOrderTxn_GetById    
Description   : To Get the data from table EngMaintenanceWorkOrderTxn using the Primary Key id    
Authors    : Balaji M S    
Date    : 30-Mar-2018    
-----------------------------------------------------------------------------------------------------------    
    
Unit Test:    
EXEC [UspFM_EngMaintenanceWorkOrderTxn_GetById] @pWorkOrderId=1483,@pUserId=1    
    
-----------------------------------------------------------------------------------------------------------    
Version History     
-----:------------:---------------------------------------------------------------------------------------    
Init : Date       : Details    
========================================================================================================*/    
    
CREATE PROCEDURE  [dbo].[UspFM_EngMaintenanceWorkOrderTxn_GetById]       
                            
  @pUserId   INT = NULL,    
  @pWorkOrderId  INT    
    
    
AS                                                  
    
BEGIN TRY    
    
    
    
 SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;    
    
 DECLARE   @TotalRecords  INT    
 DECLARE   @pTotalPage  NUMERIC(24,2)    
 DECLARE   @pTotalPageCalc NUMERIC(24,2)    
    
 IF(ISNULL(@pWorkOrderId,0) = 0) RETURN    
    
 DECLARE @pTypeOfWorkOrder INT    
    
 SET @pTypeOfWorkOrder = (SELECT TypeOfWorkOrder FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId = @pWorkOrderId)    
    
    
    
 IF(@pTypeOfWorkOrder<>35)    
 BEGIN    
    SELECT MaintenanceWorkOrder.WorkOrderId     AS WorkOrderId,    
   MaintenanceWorkOrder.CustomerId      AS CustomerId,    
   MaintenanceWorkOrder.FacilityId      AS FacilityId,    
   MaintenanceWorkOrder.ServiceId      AS ServiceId,    
   ServiceKey.ServiceKey        AS ServiceValue,    
   MaintenanceWorkOrder.AssetId      AS AssetId,    
   Asset.AssetNo          AS AssetNo,    
   Asset.AssetDescription        AS AssetDescription,    
   Manuf.Manufacturer,    
   Model.Model,    
   MaintenanceWorkOrder.MaintenanceWorkNo    AS MaintenanceWorkNo,    
   MaintenanceWorkOrder.MaintenanceDetails    AS MaintenanceDetails,    
   MaintenanceWorkOrder.MaintenanceWorkCategory  AS MaintenanceWorkCategory,    
   WorkCategory.FieldValue        AS WorkCategoryValue,    
   MaintenanceWorkOrder.MaintenanceWorkType   AS MaintenanceWorkType,    
   WorkType.FieldValue         AS MaintenanceWorkTypeValue,    
   MaintenanceWorkOrder.TypeOfWorkOrder    AS TypeOfWorkOrder,    
   TypeOfWorkOrder.FieldValue       AS TypeOfWorkOrderValue,    
   MaintenanceWorkOrder.QRCode       AS QRCode,    
   MaintenanceWorkOrder.MaintenanceWorkDateTime  AS MaintenanceWorkDateTime,    
   MaintenanceWorkOrder.TargetDateTime     AS TargetDateTime,    
   MaintenanceWorkOrder.EngineerUserId     AS EngineerStaffId,    
   EngineerStaffId.StaffName       AS EngineerStaffIdValue,    
   MaintenanceWorkOrder.RequestorUserId    AS RequestorStaffId,    
   RequestorStaffId.StaffName       AS RequestorStaffIdValue,    
   MaintenanceWorkOrder.WorkOrderPriority    AS WorkOrderPriority,    
   WorkOrderPriority.FieldValue      AS WorkOrderPriorityValue,    
   MaintenanceWorkOrder.Image1FMDocumentId    AS Image1FMDocumentId,    
   MaintenanceWorkOrder.Image2FMDocumentId    AS Image2FMDocumentId,    
   MaintenanceWorkOrder.Image3FMDocumentId    AS Image3FMDocumentId,    
   MaintenanceWorkOrder.PlannerId      AS PlannerId,    
   MaintenanceWorkOrder.WorkGroupId     AS WorkGroupId,    
   WorkGroupId.WorkGroupCode       AS WorkGroupCode,    
   WorkGroupId.WorkGroupDescription     AS WorkGroupDescription,    
   MaintenanceWorkOrder.WorkOrderStatus    AS WorkOrderStatus,    
   WorkOrderStatus.FieldValue       AS WorkOrderStatusValue,    
   MaintenanceWorkOrder.PlannerHistoryId    AS PlannerHistoryId,    
   MaintenanceWorkOrder.Remarks   AS Remarks,    
   MaintenanceWorkOrder.BreakDownRequestId    AS BreakDownRequestId,    
   MaintenanceWorkOrder.WOAssignmentId     AS WOAssignmentId,    
   MaintenanceWorkOrder.UserAreaId      AS UserAreaId,   
   --/////add RescheduleRemarks,  
   MaintenanceWorkOrder.RescheduleRemarks  AS RescheduleRemarks,  
   --////////  
   UserAreaId.UserAreaCode        AS UserAreaCode,    
   UserAreaId.UserAreaName        AS UserAreaName,    
   MaintenanceWorkOrder.UserLocationId     AS UserLocationId,    
   UserLocationId.UserLocationCode      AS UserLocationCode,    
   UserLocationId.UserLocationName      AS UserLocationName,    
   Block.BlockId          AS BlockId,    
   Block.BlockCode          AS BlockCode,    
   Block.BlockName          AS BlockName,    
   Level.LevelId          AS LevelId,    
   Level.LevelCode          AS LevelCode,    
   Level.LevelName          AS LevelName,    
   MaintenanceWorkOrder.StandardTaskDetId    AS StandardTaskDetId,    
   StandardTaskDetId.TaskCode       AS TaskCode,    
   StandardTaskDetId.TaskDescription     AS TaskDescription,    
   MaintenanceWorkOrder.Timestamp      AS Timestamp,    
   MaintenanceWorkOrder.AssigneeLovId,    
   LovAssignee.FieldValue        AS AssignedLov,    
   MaintenanceWorkOrder.AssignedUserId,    
   AssigneeUser.StaffName  as AssigneeUserName,    
   MaintenanceWorkOrder.GuId,    
   MaintenanceWorkOrder.WOImage,    
   MaintenanceWorkOrder.WOVideo,    
   Signature1.Signatureimage as WOSignature,    
   Asset.RunningHoursCapture AS RunningHoursCapture,    
   Contractor.ContractValue,    
   Asset.ContractType,    
   ContractType.FieldValue as ContractTypeValue,    
   Asset.AssetWorkingStatus,    
   AssetWorkingStatus.FieldValue as AssetWorkingStatusValue,    
   MwoAssesment.AssesmentId       AS AssesmentId    
 FROM EngMaintenanceWorkOrderTxn       AS MaintenanceWorkOrder    WITH(NOLOCK)    
   left join EngMwoAssesmentTxn         AS MwoAssesment WITH(NOLOCK)   on MwoAssesment.WorkOrderId   = MaintenanceWorkOrder.WorkOrderId    
   INNER JOIN  MstService        AS ServiceKey      WITH(NOLOCK)   on MaintenanceWorkOrder.ServiceId    = ServiceKey.ServiceId    
   LEFT JOIN  EngAsset         AS Asset       WITH(NOLOCK)   on MaintenanceWorkOrder.AssetId     = Asset.AssetId    
   LEFT JOIN  EngAssetStandardizationManufacturer  AS Manuf       WITH(NOLOCK)   on Asset.Manufacturer       = Manuf.ManufacturerId    
   LEFT JOIN  EngAssetStandardizationModel    AS Model       WITH(NOLOCK)   on Asset.Model         = Model.ModelId    
   LEFT  JOIN  UMUserRegistration      AS EngineerStaffId     WITH(NOLOCK)   on MaintenanceWorkOrder.EngineerUserId   = EngineerStaffId.UserRegistrationId    
   LEFT  JOIN  UMUserRegistration      AS RequestorStaffId     WITH(NOLOCK)   on MaintenanceWorkOrder.RequestorUserId   = RequestorStaffId.UserRegistrationId    
   LEFT  JOIN  EngAssetWorkGroup      AS WorkGroupId      WITH(NOLOCK)   on MaintenanceWorkOrder.WorkGroupId    = WorkGroupId.WorkGroupId       
   LEFT  JOIN  MstLocationUserLocation     AS UserLocationId     WITH(NOLOCK)   on Asset.UserLocationId       = UserLocationId.UserLocationId    
   LEFT  JOIN  MstLocationUserArea      AS UserAreaId      WITH(NOLOCK)   on UserLocationId.UserAreaId     = UserAreaId.UserAreaId    
   LEFT  JOIN  EngAssetTypeCodeStandardTasksDet  AS StandardTaskDetId    WITH(NOLOCK)   on MaintenanceWorkOrder.StandardTaskDetId  = StandardTaskDetId.StandardTaskDetId    
   LEFT  JOIN  FMLovMst        AS WorkCategory      WITH(NOLOCK)   on MaintenanceWorkOrder.MaintenanceWorkCategory = WorkCategory.LovId    
   LEFT  JOIN  FMLovMst        AS WorkType       WITH(NOLOCK)   on MaintenanceWorkOrder.MaintenanceWorkType  = WorkType.LovId    
   LEFT  JOIN  FMLovMst        AS TypeOfWorkOrder     WITH(NOLOCK)   on MaintenanceWorkOrder.TypeOfWorkOrder   = TypeOfWorkOrder.LovId    
   LEFT  JOIN  FMLovMst        AS WorkOrderPriority    WITH(NOLOCK)   on MaintenanceWorkOrder.WorkOrderPriority  = WorkOrderPriority.LovId    
   LEFT  JOIN  FMLovMst        AS WorkOrderStatus     WITH(NOLOCK)   on MaintenanceWorkOrder.WorkOrderStatus   = WorkOrderStatus.LovId    
   LEFT  JOIN  FMLovMst        AS ContractType      WITH(NOLOCK)   on Asset.ContractType       = ContractType.LovId    
   LEFT  JOIN  MstLocationBlock      AS Block       WITH(NOLOCK)   on UserLocationId.BlockId       = Block.BlockId    
   LEFT  JOIN  MstLocationLevel      AS Level       WITH(NOLOCK)   on UserLocationId.LevelId       = Level.LevelId    
   LEFT  JOIN  FMLovMst        AS LovAssignee      WITH(NOLOCK)   on MaintenanceWorkOrder.AssigneeLovId   = LovAssignee.LovId    
   LEFT  JOIN  UMUserRegistration      AS AssigneeUser      WITH(NOLOCK)   on MaintenanceWorkOrder.AssignedUserId   = AssigneeUser.UserRegistrationId    
   LEFT  JOIN  FMLovMst        AS AssetWorkingStatus    WITH(NOLOCK)   on Asset.AssetWorkingStatus      = AssetWorkingStatus.LovId    
   LEFT  JOIN  FEAcknowledge       AS Signature1                       WITH(NOLOCK)   on MaintenanceWorkOrder.WorkOrderId    = Signature1.Documentid    
   OUTER APPLY (SELECT DISTINCT TOP 1 ContractorId,AssetId, ContractValue from    
      (SELECT COR.ContractorId,CORDet.AssetId,SUM(ContractValue) AS ContractValue,RANK() over(Partition by CORDet.AssetId order by COR.ContractorId,CORDet.AssetId ) as RowValue    
      from EngContractOutRegister COR    
      inner join  EngContractOutRegisterDet CORDet on COR.ContractId=CORDet.ContractId     
      WHERE CORDet.AssetId=Asset.AssetId    
      group by COR.ContractorId,CORDet.AssetId)a where RowValue =1  ) Contractor    
    
 WHERE MaintenanceWorkOrder.WorkOrderId = @pWorkOrderId      
 ORDER BY MaintenanceWorkOrder.ModifiedDate ASC    
    
 END    
    
 ELSE    
    
 BEGIN    
    SELECT MaintenanceWorkOrder.WorkOrderId     AS WorkOrderId,    
   MaintenanceWorkOrder.CustomerId      AS CustomerId,    
   MaintenanceWorkOrder.FacilityId      AS FacilityId,    
   MaintenanceWorkOrder.ServiceId      AS ServiceId,    
   ServiceKey.ServiceKey        AS ServiceValue,    
   MaintenanceWorkOrder.AssetId      AS AssetId,    
   Asset.AssetNo          AS AssetNo,    
   Asset.AssetDescription        AS AssetDescription,    
   Manuf.Manufacturer,    
   Model.Model,    
   MaintenanceWorkOrder.MaintenanceWorkNo    AS MaintenanceWorkNo,    
   MaintenanceWorkOrder.MaintenanceDetails    AS MaintenanceDetails,    
   MaintenanceWorkOrder.MaintenanceWorkCategory  AS MaintenanceWorkCategory,    
   WorkCategory.FieldValue        AS WorkCategoryValue,    
   MaintenanceWorkOrder.MaintenanceWorkType   AS MaintenanceWorkType,    
   WorkType.FieldValue         AS MaintenanceWorkTypeValue,    
   MaintenanceWorkOrder.TypeOfWorkOrder    AS TypeOfWorkOrder,    
   TypeOfWorkOrder.FieldValue       AS TypeOfWorkOrderValue,    
   MaintenanceWorkOrder.QRCode       AS QRCode,    
   MaintenanceWorkOrder.MaintenanceWorkDateTime  AS MaintenanceWorkDateTime,    
   MaintenanceWorkOrder.TargetDateTime     AS TargetDateTime,    
   MaintenanceWorkOrder.EngineerUserId     AS EngineerStaffId,    
   EngineerStaffId.StaffName       AS EngineerStaffIdValue,    
   MaintenanceWorkOrder.RequestorUserId    AS RequestorStaffId,    
   RequestorStaffId.StaffName       AS RequestorStaffIdValue,    
   MaintenanceWorkOrder.WorkOrderPriority    AS WorkOrderPriority,    
   WorkOrderPriority.FieldValue      AS WorkOrderPriorityValue,    
   MaintenanceWorkOrder.Image1FMDocumentId    AS Image1FMDocumentId,    
   MaintenanceWorkOrder.Image2FMDocumentId    AS Image2FMDocumentId,    
   MaintenanceWorkOrder.Image3FMDocumentId    AS Image3FMDocumentId,    
   MaintenanceWorkOrder.PlannerId      AS PlannerId,    
   MaintenanceWorkOrder.WorkGroupId     AS WorkGroupId,    
   WorkGroupId.WorkGroupCode       AS WorkGroupCode,    
   WorkGroupId.WorkGroupDescription     AS WorkGroupDescription,    
   MaintenanceWorkOrder.WorkOrderStatus    AS WorkOrderStatus,    
   WorkOrderStatus.FieldValue       AS WorkOrderStatusValue,    
   MaintenanceWorkOrder.PlannerHistoryId    AS PlannerHistoryId,    
   MaintenanceWorkOrder.Remarks      AS Remarks,    
   MaintenanceWorkOrder.BreakDownRequestId    AS BreakDownRequestId,    
   MaintenanceWorkOrder.WOAssignmentId     AS WOAssignmentId,    
   MaintenanceWorkOrder.UserAreaId      AS UserAreaId,   
    --/////add RescheduleRemarks,  
   MaintenanceWorkOrder.RescheduleRemarks  AS RescheduleRemarks,  
   --////////   
   UserAreaId.UserAreaCode        AS UserAreaCode,    
   UserAreaId.UserAreaName        AS UserAreaName,    
   MaintenanceWorkOrder.UserLocationId     AS UserLocationId,    
   UserLocationId.UserLocationCode      AS UserLocationCode,    
   UserLocationId.UserLocationName      AS UserLocationName,    
   Block.BlockId          AS BlockId,    
   Block.BlockCode          AS BlockCode,    
   Block.BlockName          AS BlockName,    
   Level.LevelId          AS LevelId,    
   Level.LevelCode          AS LevelCode,    
   Level.LevelName          AS LevelName,    
   MaintenanceWorkOrder.StandardTaskDetId    AS StandardTaskDetId,    
   StandardTaskDetId.TaskCode       AS TaskCode,    
   StandardTaskDetId.TaskDescription     AS TaskDescription,    
   MaintenanceWorkOrder.Timestamp      AS Timestamp,    
   MaintenanceWorkOrder.AssigneeLovId,    
   LovAssignee.FieldValue        AS AssignedLov,    
   MaintenanceWorkOrder.AssignedUserId,    
   AssigneeUser.StaffName  as AssigneeUserName,    
   MaintenanceWorkOrder.GuId,    
   MaintenanceWorkOrder.WOImage,    
   MaintenanceWorkOrder.WOVideo,    
   Signature1.Signatureimage as WOSignature,    
   Asset.RunningHoursCapture AS RunningHoursCapture,    
   Contractor.ContractValue,    
   Asset.ContractType,    
   ContractType.FieldValue as ContractTypeValue,    
   Asset.AssetWorkingStatus,    
   AssetWorkingStatus.FieldValue as AssetWorkingStatusValue,    
   MwoAssesment.AssesmentId       AS AssesmentId    
 FROM EngMaintenanceWorkOrderTxn       AS MaintenanceWorkOrder    WITH(NOLOCK)    
   left join EngMwoAssesmentTxn         AS MwoAssesment WITH(NOLOCK)   on MwoAssesment.WorkOrderId   = MaintenanceWorkOrder.WorkOrderId    
   INNER JOIN  MstService        AS ServiceKey      WITH(NOLOCK)   on MaintenanceWorkOrder.ServiceId    = ServiceKey.ServiceId    
   LEFT JOIN  EngAsset         AS Asset       WITH(NOLOCK)   on MaintenanceWorkOrder.AssetId     = Asset.AssetId    
   LEFT JOIN  EngAssetStandardizationManufacturer  AS Manuf       WITH(NOLOCK)   on Asset.Manufacturer       = Manuf.ManufacturerId    
   LEFT JOIN  EngAssetStandardizationModel    AS Model       WITH(NOLOCK)   on Asset.Model         = Model.ModelId    
   LEFT  JOIN  UMUserRegistration      AS EngineerStaffId     WITH(NOLOCK)   on MaintenanceWorkOrder.EngineerUserId   = EngineerStaffId.UserRegistrationId    
   LEFT  JOIN  UMUserRegistration      AS RequestorStaffId     WITH(NOLOCK)   on MaintenanceWorkOrder.RequestorUserId   = RequestorStaffId.UserRegistrationId    
   LEFT  JOIN  EngAssetWorkGroup      AS WorkGroupId      WITH(NOLOCK)   on MaintenanceWorkOrder.WorkGroupId    = WorkGroupId.WorkGroupId       
   LEFT  JOIN  MstLocationUserLocation     AS UserLocationId     WITH(NOLOCK)   on Asset.UserLocationId       = UserLocationId.UserLocationId    
   LEFT  JOIN  MstLocationUserArea      AS UserAreaId      WITH(NOLOCK)   on MaintenanceWorkOrder.UserAreaId    = UserAreaId.UserAreaId    
   LEFT  JOIN  EngAssetTypeCodeStandardTasksDet  AS StandardTaskDetId    WITH(NOLOCK)   on MaintenanceWorkOrder.StandardTaskDetId  = StandardTaskDetId.StandardTaskDetId    
   LEFT  JOIN  FMLovMst        AS WorkCategory      WITH(NOLOCK)   on MaintenanceWorkOrder.MaintenanceWorkCategory = WorkCategory.LovId    
   LEFT  JOIN  FMLovMst        AS WorkType       WITH(NOLOCK)   on MaintenanceWorkOrder.MaintenanceWorkType  = WorkType.LovId    
   LEFT  JOIN  FMLovMst        AS TypeOfWorkOrder     WITH(NOLOCK)   on MaintenanceWorkOrder.TypeOfWorkOrder   = TypeOfWorkOrder.LovId    
   LEFT  JOIN  FMLovMst        AS WorkOrderPriority    WITH(NOLOCK)   on MaintenanceWorkOrder.WorkOrderPriority  = WorkOrderPriority.LovId    
   LEFT  JOIN  FMLovMst        AS WorkOrderStatus     WITH(NOLOCK)   on MaintenanceWorkOrder.WorkOrderStatus   = WorkOrderStatus.LovId    
   LEFT  JOIN  FMLovMst        AS ContractType      WITH(NOLOCK)   on Asset.ContractType       = ContractType.LovId    
   LEFT  JOIN  MstLocationBlock      AS Block       WITH(NOLOCK)   on UserAreaId.BlockId      = Block.BlockId    
   LEFT  JOIN  MstLocationLevel      AS Level       WITH(NOLOCK)   on UserAreaId.LevelId      = Level.LevelId    
   LEFT  JOIN  FMLovMst        AS LovAssignee      WITH(NOLOCK)   on MaintenanceWorkOrder.AssigneeLovId   = LovAssignee.LovId    
   LEFT  JOIN  UMUserRegistration      AS AssigneeUser      WITH(NOLOCK)   on MaintenanceWorkOrder.AssignedUserId   = AssigneeUser.UserRegistrationId    
   LEFT  JOIN  FMLovMst        AS AssetWorkingStatus    WITH(NOLOCK)   on Asset.AssetWorkingStatus      = AssetWorkingStatus.LovId    
   LEFT  JOIN  FEAcknowledge       AS Signature1                       WITH(NOLOCK)   on MaintenanceWorkOrder.WorkOrderId    = Signature1.Documentid    
   OUTER APPLY (SELECT DISTINCT TOP 1 ContractorId,AssetId, ContractValue from    
      (SELECT COR.ContractorId,CORDet.AssetId,SUM(ContractValue) AS ContractValue,RANK() over(Partition by CORDet.AssetId order by COR.ContractorId,CORDet.AssetId ) as RowValue    
      from EngContractOutRegister COR    
      inner join  EngContractOutRegisterDet CORDet on COR.ContractId=CORDet.ContractId     
      WHERE CORDet.AssetId=Asset.AssetId    
      group by COR.ContractorId,CORDet.AssetId)a where RowValue =1  ) Contractor    
    
 WHERE MaintenanceWorkOrder.WorkOrderId = @pWorkOrderId      
 ORDER BY MaintenanceWorkOrder.ModifiedDate ASC    
    
 END    
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
