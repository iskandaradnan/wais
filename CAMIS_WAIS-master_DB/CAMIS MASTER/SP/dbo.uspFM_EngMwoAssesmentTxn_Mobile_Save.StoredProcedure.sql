USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMwoAssesmentTxn_Mobile_Save]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================    
Application Name : UETrack-BEMS                  
Version    : 1.0    
Procedure Name  : uspFM_EngMwoAssesmentTxn_Save    
Description   : If Assesment already exists then update else insert.    
Authors    : Balaji M S    
Date    : 09-April-2018    
-----------------------------------------------------------------------------------------------------------    
    
Unit Test:    
    
Unit Test:    
    
DECLARE @EngMwoAssesmentTxn_Mobile  [dbo].[udt_EngMwoAssesmentTxn_Mobile]    
INSERT INTO @EngMwoAssesmentTxn_Mobile([AssesmentId],[CustomerId],[FacilityId],[ServiceId],[WorkOrderId],[StaffMasterId],[Justification],    
[ResponseDateTime],[ResponseDateTimeUTC],[ResponseDuration],[AssetRealtimeStatus],[UserId])    
values (1138,1,1,2,546,32,'input from mobile',getdate(),getdate(),15,1,32)    
    
exec uspFM_EngMwoAssesmentTxn_Mobile_Save @EngMwoAssesmentTxn_Mobile=@EngMwoAssesmentTxn_Mobile    
-----------------------------------------------------------------------------------------------------------    
Version History     
-----:------------:---------------------------------------------------------------------------------------    
Init :  Date       : Details    
========================================================================================================*/    
    
CREATE PROCEDURE  [dbo].[uspFM_EngMwoAssesmentTxn_Mobile_Save]    
      
  @EngMwoAssesmentTxn_Mobile  AS [dbo].[udt_EngMwoAssesmentTxn_Mobile]   READONLY    
      
    
AS                                                  
    
BEGIN TRY    
    
 DECLARE @mTRANSCOUNT INT = @@TRANCOUNT    
    
 BEGIN TRANSACTION    
    
-- Paramter Validation     
    
 SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;    
    
-- Declaration    
     
 DECLARE @Table TABLE (ID INT)     
 DECLARE @PrimaryKeyId  INT    
 DECLARE @pTimestamp varbinary(200)     
    
    
    
--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------    
    
--//1.MwoCompletionInfo    
    
   IF EXISTS (SELECT 1 FROM @EngMwoAssesmentTxn_Mobile WHERE AssesmentId = NULL OR AssesmentId =0)    
    
BEGIN    
     
   INSERT INTO EngMwoAssesmentTxn    
      (     
       CustomerId,    
       FacilityId,    
       ServiceId,    
       WorkOrderId,    
       UserId,    
       Justification,    
       ResponseDateTime,    
       ResponseDateTimeUTC,    
       ResponseDuration,    
       CreatedBy,    
       CreatedDate,    
       CreatedDateUTC,    
       ModifiedBy,    
       ModifiedDate,    
       ModifiedDateUTC,    
       AssetRealtimeStatus,    
       TargetDateTime,    
       IsChangeToVendor,    
       AssignedVendor,  
    [Signature]  
      ) OUTPUT INSERTED.AssesmentId INTO @Table           
    
   SELECT       
       CustomerId,       
       FacilityId,       
       ServiceId,       
       WorkOrderId,       
       StaffMasterId,      
       Justification,      
       ResponseDateTime,     
       ResponseDateTimeUTC,     
       ResponseDuration,     
       UserId,    
       GETDATE(),    
       GETUTCDATE(),    
       UserId,    
       GETDATE(),    
       GETUTCDATE(),    
       AssetRealtimeStatus,    
       TargetDateTime,    
       IsChangeToVendor,    
       AssignedVendor,    
       [Signature]        
   FROM @EngMwoAssesmentTxn_Mobile WHERE (AssesmentId = NULL OR AssesmentId =0)    
             
   SELECT AssesmentId,    
     WorkOrderId,    
     '' ErrorMessage,    
     [Timestamp]    
   FROM EngMwoAssesmentTxn    
   WHERE AssesmentId IN (SELECT ID FROM @Table)    
    
   INSERT INTO QueueWebtoMobile (TableName,Tableprimaryid,UserId)    
   select 'WorkOrderStatus',TransferTable.WorkOrderId,WorkOrderTable.AssignedUserId        
   from EngMWOHandOverHistoryTxn as WorkOrderTable    
   inner join @EngMwoAssesmentTxn_Mobile as TransferTable on WorkOrderTable.WorkOrderId=TransferTable.WorkOrderId    
   where ISNULL(TransferTable.WorkOrderId,0)>0    
    
   INSERT INTO QueueWebtoMobile (TableName,Tableprimaryid,UserId)    
   SELECT 'WorkOrderStatus',c.WorkOrderId,c.CreatedBy FROM @Table A INNER JOIN EngMwoAssesmentTxn B ON A.ID = B.AssesmentId    
   inner join EngMaintenanceWorkOrderTxn c on c.WorkOrderId = b.WorkOrderId    
    
   UPDATE EngMaintenanceWorkOrderTxn SET WorkOrderStatus = 193 WHERE WorkOrderId =  (SELECT WorkOrderId FROM @EngMwoAssesmentTxn_Mobile WHERE (AssesmentId = NULL OR AssesmentId =0))    
    
      INSERT INTO EngMaintenanceWorkOrderStatusHistory(CustomerId,FacilityId,ServiceId,WorkOrderId,Status,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)    
   SELECT A.CustomerId,A.FacilityId,A.ServiceId,A.WorkOrderId,A.WorkOrderStatus,B.UserId,GETDATE(),GETUTCDATE(),B.UserId,GETDATE(),GETUTCDATE()  FROM EngMaintenanceWorkOrderTxn A     
   INNER JOIN @EngMwoAssesmentTxn_Mobile B ON A.WorkOrderId = B.WorkOrderId WHERE A.WorkOrderId = (SELECT WorkOrderId FROM @EngMwoAssesmentTxn_Mobile WHERE (AssesmentId = NULL OR AssesmentId =0))    
       
   DECLARE @workOrderid int    
   DECLARE @WorkOrderStatus int    
   DECLARE @AssingedUserId int    
       
   SET @workOrderid  = (select WorkOrderId from @EngMwoAssesmentTxn_Mobile)    
   SELECT @WorkOrderStatus= WorkOrderStatus,@AssingedUserId= AssignedUserId from EngMaintenanceWorkOrderTxn WHERE WorkOrderId = @workOrderid    
    
   IF (@WorkOrderStatus IN (193))    
   BEGIN    
    DELETE FEUserAssigned where Userid=@AssingedUserId    
   END    
        
    
end    
    
IF EXISTS (SELECT 1 FROM @EngMwoAssesmentTxn_Mobile WHERE AssesmentId >0)    
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------    
    
--1.MwoCompletionInfo UPDATE    
    
       
    
BEGIN    
    
   DECLARE @mTimestamp varbinary(200);    
   SELECT @mTimestamp = Timestamp FROM EngMwoAssesmentTxn     
   WHERE AssesmentId = (SELECT AssesmentId FROM @EngMwoAssesmentTxn_Mobile)    
       
   --IF(@mTimestamp= @pTimestamp)    
   --BEGIN    
     UPDATE  MwoAssesment SET     
       MwoAssesment.CustomerId     = MwoAssesmentType.CustomerId,    
       MwoAssesment.FacilityId     = MwoAssesmentType.FacilityId,    
       MwoAssesment.ServiceId     = MwoAssesmentType.ServiceId,    
       MwoAssesment.WorkOrderId    = MwoAssesmentType.WorkOrderId,    
       MwoAssesment.UserId      = MwoAssesmentType.StaffMasterId,    
       MwoAssesment.Justification    = MwoAssesmentType.Justification,    
       MwoAssesment.ResponseDateTime   = MwoAssesmentType.ResponseDateTime,    
       MwoAssesment.ResponseDateTimeUTC  = MwoAssesmentType.ResponseDateTimeUTC,    
       MwoAssesment.ResponseDuration   = MwoAssesmentType.ResponseDuration,    
       MwoAssesment.AssetRealtimeStatus  = MwoAssesmentType.AssetRealtimeStatus,    
       MwoAssesment.ModifiedBy     = MwoAssesmentType.UserId,    
       MwoAssesment.ModifiedDate    = GETDATE(),    
       MwoAssesment.ModifiedDateUTC   = GETUTCDATE(),    
       MwoAssesment.TargetDateTime    = MwoAssesmentType.TargetDateTime,    
       MwoAssesment.IsChangeToVendor   = MwoAssesmentType.IsChangeToVendor,    
       MwoAssesment.AssignedVendor    = MwoAssesmentType.AssignedVendor  ,  
    MwoAssesment.Signature=MwoAssesmentType.Signature  
       OUTPUT INSERTED.AssesmentId INTO @Table    
    FROM EngMwoAssesmentTxn      AS MwoAssesment    
    INNER JOIN @EngMwoAssesmentTxn_Mobile   AS MwoAssesmentType   on MwoAssesment.AssesmentId = MwoAssesmentType.AssesmentId    
    WHERE ISNULL(MwoAssesmentType.AssesmentId,0)>0    
        
    INSERT INTO QueueWebtoMobile (TableName,Tableprimaryid,UserId)    
   select 'WorkOrderStatus',TransferTable.WorkOrderId,WorkOrderTable.AssignedUserId        
   from EngMWOHandOverHistoryTxn as WorkOrderTable    
   inner join @EngMwoAssesmentTxn_Mobile as TransferTable on WorkOrderTable.WorkOrderId=TransferTable.WorkOrderId    
   where ISNULL(TransferTable.WorkOrderId,0)>0    
    
   SELECT AssesmentId,    
     [Timestamp],    
     WorkOrderId,    
     '' ErrorMessage    
   FROM EngMwoAssesmentTxn    
   WHERE AssesmentId IN (SELECT ID FROM @Table)    
    
      
   SET @workOrderid  = (select WorkOrderId from @EngMwoAssesmentTxn_Mobile)    
   SELECT @WorkOrderStatus= WorkOrderStatus,@AssingedUserId= AssignedUserId from EngMaintenanceWorkOrderTxn WHERE WorkOrderId = @workOrderid    
       
   IF (@WorkOrderStatus IN (193))    
   BEGIN    
    DELETE FEUserAssigned where Userid=@AssingedUserId    
   END    
    
--END       
 --ELSE    
 -- BEGIN    
 --      SELECT AssesmentId,    
 --      [Timestamp],    
 --      WorkOrderId,    
 --      'Record Modified. Please Re-Select' ErrorMessage    
 --      FROM  EngMwoAssesmentTxn    
 --      WHERE AssesmentId =(SELECT AssesmentId FROM @EngMwoAssesmentTxn_Mobile)    
 -- END    
END    
    
    
    
 IF @mTRANSCOUNT = 0    
        BEGIN    
            COMMIT    
        END    
      
END TRY    
    
BEGIN CATCH    
    
 IF @mTRANSCOUNT = 0    
        BEGIN    
            ROLLBACK TRAN    
        END    
    
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
    
    
--------------------------------------------------------------------------udt CREATION--------------------------------------------------    
    
--DROP PROC [uspFM_EngMwoAssesmentTxn_Mobile_Save]    
    
--DROP TYPE [udt_EngMwoAssesmentTxn_Mobile]    
    
--CREATE TYPE [dbo].[udt_EngMwoAssesmentTxn_Mobile] AS TABLE(    
-- [AssesmentId] [int] NULL,    
-- [CustomerId] [int] NULL,    
-- [FacilityId] [int] NULL,    
-- [ServiceId] [int] NULL,    
-- [WorkOrderId] [int] NULL,    
-- [StaffMasterId] [int] NULL,    
-- [Justification] [nvarchar](1000) NULL,    
-- [ResponseDateTime] [datetime] NULL,    
-- [ResponseDateTimeUTC] [datetime] NULL,    
-- [ResponseDuration] [numeric](24, 2) NULL,    
-- [AssetRealtimeStatus] [int] NULL,    
-- [TargetDateTime] [datetime] NULL,    
-- [IsChangeToVendor] [INT] NULL,    
-- [AssignedVendor] [INT] NULL,    
-- [UserId] [int] NULL    
--)    
--GO
GO
