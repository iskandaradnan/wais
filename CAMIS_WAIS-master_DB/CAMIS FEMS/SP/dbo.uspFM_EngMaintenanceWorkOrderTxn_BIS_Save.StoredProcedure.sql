USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMaintenanceWorkOrderTxn_BIS_Save]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT * FROM FENotification                      
                      
/*========================================================================================================                          
Application Name : UETrack-FEMS                                        
Version    : 1.0                          
Procedure Name  : uspFM_EngMaintenanceWorkOrderTxn_Save                          
Description   : If Maintenance Work Order already exists then update else insert.                          
Authors    : Balaji M S                          
Date    : 09-April-2018                          
-----------------------------------------------------------------------------------------------------------                          
    select * from dbo.EngPlannerTxn                      
Unit Test:                          
                          
EXECUTE [uspFM_EngMaintenanceWorkOrderTxn_Save] @pWorkOrderId=0,@pCustomerId=157,@pFacilityId=144,@pServiceId=2,@pAssetId=30329,@pMaintenanceWorkNo=null,@pMaintenanceDetails='any',                          
@pMaintenanceWorkCategory=188,@pMaintenanceWorkType=273,@pTypeOfWorkOrder=273,@pQRCode=NULL,@pMaintenanceWorkDateTime='2020-05-16 11:44:24.067',@pTargetDateTime='2021-05-16 11:44:24.067',                           
@pEngineerStaffId=null,@pRequestorStaffId=19,@pWorkOrderPriority=228,@pImage1FMDocumentId=NULL,@pImage2FMDocumentId=NULL,@pImage3FMDocumentId=NULL,@pPlannerId=80,@pWorkGroupId=0,                          
@pWorkOrderStatus=0,@pPlannerHistoryId=NULL,@pRemarks='sAMPLE',@pBreakDownRequestId=NULL,@pWOAssignmentId=NULL,@pUserAreaId=NULL,@pUserLocationId=NULL,@pStandardTaskDetId=NULL,                            
@pUserId=19                          
                          
select * from EngMaintenanceWorkOrderTxn                          
                          
-----------------------------------------------------------------------------------------------------------                          
Version History                           
-----:------------:---------------------------------------------------------------------------------------                          
Init :  Date       : Details                          
========================================================================================================*/                          
                          
CREATE PROCEDURE  [dbo].[uspFM_EngMaintenanceWorkOrderTxn_BIS_Save]                          
                            
  @pWorkOrderId      INT    = NULL,                          
  @pCustomerId      INT    = NULL,                          
  @pFacilityId      INT    = NULL,                          
  @pServiceId       INT    = NULL,                          
  @pAssetId       INT    = NULL,                          
  @pMaintenanceWorkNo     NVARCHAR(100) = NULL,                          
  @pMaintenanceDetails    NVARCHAR(500) = NULL,                          
  @pMaintenanceWorkCategory   INT    = NULL,                          
  @pMaintenanceWorkType    INT    = NULL,                          
  @pTypeOfWorkOrder     INT    = NULL,                          
  @pQRCode       VARBINARY(max) = NULL,                          
  @pMaintenanceWorkDateTime   DATETIME  = NULL,                          
  @pTargetDateTime     DATETIME  = NULL,                          
  @pEngineerStaffId     INT    = NULL,                          
  @pRequestorStaffId     INT    = NULL,                          
  @pWorkOrderPriority     INT    = NULL,                          
  @pImage1FMDocumentId    INT    = NULL,                          
  @pImage2FMDocumentId    INT    = NULL,                          
  @pImage3FMDocumentId    INT    = NULL,                          
  @pPlannerId       INT    = NULL,                          
  @pWorkGroupId      INT    = NULL,                          
  @pWorkOrderStatus     INT    = NULL,                          
  @pPlannerHistoryId     INT    = NULL,                          
  @pRemarks       NVARCHAR(500) = NULL,                          
  @pBreakDownRequestId    INT    = NULL,                          
  @pWOAssignmentId     INT    = NULL,                          
  @pUserAreaId      INT    = NULL,                          
  @pUserLocationId     INT    = NULL,                          
  @pStandardTaskDetId     INT    = NULL,         
  @pUserId       INT    = NULL,                          
  @pTimestamp       VARBINARY(200) = NULL   ,                       
  @pmodel INT=NULL                  
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
 DECLARE @mAssigneeLovId  INT                      
                          
 DECLARE @mDateFmt NVARCHAR(100)                          
 DECLARE @mDateFmtValue NVARCHAR(100)                          
 DECLARE @TableAcknowledge TABLE (ID INT)                          
                          
 IF(@pMaintenanceWorkDateTime IS NULL)                          
 BEGIN                          
 SET @pMaintenanceWorkDateTime = GETUTCDATE() --(SELECT [dbo].[udf_GetMalaysiaDateTime] (GETDATE()))                          
 END                                
 SET @mAssigneeLovId = NULLIF(@mAssigneeLovId,0)                          
  DECLARE @pFacility nvarchar(50)             
  DECLARE @WOSTATUS int            
  DECLARE @WOTYPE int           
   --set @WOSTATUS = (select TOP 1 WorkOrderStatus from EngMaintenanceWorkOrderTxn where AssetId=@pAssetId and TypeOfWorkOrder=273  order by  CreatedDate DESC)                                               
       
  IF ((select count(WorkOrderStatus) from EngMaintenanceWorkOrderTxn where AssetId=@pAssetId and TypeOfWorkOrder=273 )>0)                          
   BEGIN       
    set @WOSTATUS = (select TOP 1 WorkOrderStatus from EngMaintenanceWorkOrderTxn where AssetId=@pAssetId and TypeOfWorkOrder=273  order by  CreatedDate DESC)                       
     END                          
   ELSE                          
   BEGIN                          
   SET @WOSTATUS=0                             
   END    
    
  IF ((select count(TypeOfWorkOrder) from EngMaintenanceWorkOrderTxn where AssetId=@pAssetId and TypeOfWorkOrder=273)>0)                          
   BEGIN       
    set @WOTYPE = (select TOP 1 TypeOfWorkOrder from EngMaintenanceWorkOrderTxn where AssetId=@pAssetId and TypeOfWorkOrder=273 order by  CreatedDate DESC)                       
     END                          
   ELSE                          
   BEGIN                          
   SET @WOTYPE=273                             
   END     
     
                     
   SELECT @pFacility = FacilityCode FROM MstLocationFacility WHERE FacilityId=@pFacilityId                        
                           
--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------                          
                          
--//1.FMLovMst             
                           
             IF(@WOSTATUS = 0 OR @WOSTATUS = NULL OR @WOSTATUS =195 or @WOSTATUS =143 and @WOTYPE=273 )              
    BEGIN              
               
   IF(@pWorkOrderId = NULL OR @pWorkOrderId =0)                          
                          
BEGIN                          
                           
 DECLARE @pOutParam NVARCHAR(50),@mMonth INT,@mYear INT,@mDefaultkey NVARCHAR(50) , @mScheduled NVARCHAR(50)        
                          
 SET @mMonth = MONTH(@pMaintenanceWorkDateTime)                          
 SET @mYear = YEAR(@pMaintenanceWorkDateTime)                          
 IF(@pMaintenanceWorkCategory = 188)                          
 BEGIN                          
  IF EXISTS (SELECT 1 FROM EngContractOutRegisterDet WHERE AssetId = @pAssetId)                          
   BEGIN                          
    SET @mDefaultkey='CWO'                          
   END                          
   ELSE                          
   BEGIN                          
    SET @mDefaultkey='MWR'                          
   END               
   set @mDefaultkey= @mDefaultkey+@pFacility+'/F'                         
 EXEC [uspFM_GenerateDocumentNumber] @pFlag='EngMaintenanceWorkOrderTxn',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey=@mDefaultkey,@pModuleName=NULL,@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT                          
 SELECT @pMaintenanceWorkNo=@pOutParam                          
 SET @mAssigneeLovId =330                          
 set @mScheduled = 'UnScheduled'                        
 END                          
                          
 IF(@pMaintenanceWorkCategory = 187)                          
 BEGIN                          
  IF EXISTS (SELECT 1 FROM EngContractOutRegisterDet WHERE AssetId = @pAssetId)                          
   BEGIN                          
    SET @mDefaultkey='CWO'                          
   END                          
   ELSE                          
   BEGIN                          
    SET @mDefaultkey='PWR'                          
   END                    
    set @mDefaultkey= @mDefaultkey+@pFacility+'/F'                     
 EXEC [uspFM_GenerateDocumentNumber] @pFlag='EngMaintenanceWorkOrderTxn',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey=@mDefaultkey,@pModuleName=@mDefaultkey,@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT                    
   
   
      
 SELECT @pMaintenanceWorkNo=@pOutParam                          
 set @mScheduled = 'Scheduled'                        
 END                          
                          
                          
                          
   INSERT INTO EngMaintenanceWorkOrderTxn                          
      (                           
       CustomerId,                          
       FacilityId,                          
       ServiceId,                          
       AssetId,                          
       MaintenanceWorkNo,                          
       MaintenanceDetails,                          
       MaintenanceWorkCategory,                          
       MaintenanceWorkType,                    
       TypeOfWorkOrder,                          
       QRCode,                          
       MaintenanceWorkDateTime,                          
       TargetDateTime,                          
       EngineerUserId,                          
       RequestorUserId,                          
       WorkOrderPriority,                          
       Image1FMDocumentId,                          
       Image2FMDocumentId,                          
       Image3FMDocumentId,                          
       PlannerId,                          
       WorkGroupId,                          
       WorkOrderStatus,                          
       PlannerHistoryId,                          
Remarks,                          
       CreatedBy,                          
       CreatedDate,                          
       CreatedDateUTC,                          
       ModifiedBy,                          
       ModifiedDate,                          
       ModifiedDateUTC,                          
       BreakDownRequestId,                          
       WOAssignmentId,                          
       UserAreaId,                          
       UserLocationId,                          
       StandardTaskDetId,                          
       AssigneeLovId,                          
       AssignedUserId  ,                
    Isdelete  ,              
 Isbis,  
 Module                   
      ) OUTPUT INSERTED.WorkOrderId INTO @Table                                 
                          
   VALUES                             
      (                           
       @pCustomerId,                          
       @pFacilityId,                          
       @pServiceId,                          
       @pAssetId,                          
       @pMaintenanceWorkNo,                          
       @pMaintenanceDetails,                          
       @pMaintenanceWorkCategory,                          
       @pMaintenanceWorkType,                          
       @pTypeOfWorkOrder,                          
       @pQRCode,                    
       @pMaintenanceWorkDateTime,                          
       @pTargetDateTime,                          
       @pEngineerStaffId,                          
       @pRequestorStaffId,                          
       ISNULL (NULLIF(@pWorkOrderPriority,0),227),                          
       @pImage1FMDocumentId,                          
       @pImage2FMDocumentId,                          
       @pImage3FMDocumentId,                          
       @pPlannerId,                          
       ISNULL (NULLIF(@pWorkGroupId,0),1),                         
       ISNULL (NULLIF(@pWorkOrderStatus,0),192),                          
       @pPlannerHistoryId,                          
       @pRemarks,                           
       @pUserId,                             
       GETDATE(),                           
       GETDATE(),                          
       @pUserId,                           
       GETDATE(),                           
       GETDATE(),                          
       @pBreakDownRequestId,                          
       @pWOAssignmentId,                          
       @pUserAreaId,                          
       @pUserLocationId,                          
       @pStandardTaskDetId,                          
       case when  isnull(@pEngineerStaffId,0) > 0 then 332 else 330 end, --(SELECT coalesce(@pEngineerStaffId,@mAssigneeLovId)),                          
       @pEngineerStaffId   ,                       
          0  ,1 ,@pmodel             
      )                             
   SELECT WorkOrderId,                          
     MaintenanceWorkNo,                                       
     [Timestamp],                          
     GuId                          
   FROM EngMaintenanceWorkOrderTxn                          
   WHERE WorkOrderId IN (SELECT ID FROM @Table)                          
                          
                          
   INSERT INTO EngMaintenanceWorkOrderStatusHistory(CustomerId,FacilityId,ServiceId,WorkOrderId,Status,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)                          
   SELECT CustomerId,FacilityId,ServiceId,WorkOrderId,WorkOrderStatus,@pUserId,GETDATE(),GETUTCDATE(),@pUserId,GETDATE(),GETUTCDATE()  FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId IN (SELECT ID FROM @Table)                          
                          
                          
                          
   SELECT @mDateFmt = b.FieldValue                            
  FROM FMConfigCustomerValues a                           
    INNER JOIN FMLovMst b on a.ConfigKeyLovId=b.LovId                          
  WHERE A.KeyName='DATE'                          
    AND CustomerId = @pCustomerId                          
                          
  IF (@mDateFmt='DD-MMM-YYYY')                          
   BEGIN                          
    SET @mDateFmtValue = REPLACE(CONVERT(VARCHAR, GETDATE(), 6),' ','-')                          
   END                          
  ELSE IF (@mDateFmt='DD/MMM/YYYY')                          
   BEGIN                          
    SET @mDateFmtValue = REPLACE(CONVERT(VARCHAR, GETDATE(), 6),' ','/')                          
   END                          
                          
if((@pEngineerStaffId is not null) OR (@pEngineerStaffId = 0) )                          
BEGIN                          
  INSERT INTO QueueWebtoMobile (  TableName,                          
            Tableprimaryid,                          
            UserId                          
          )                          
      SELECT 'EngMaintenanceWorkOrderTxn',                          
        ID,                          
        @pEngineerStaffId                          
      from @Table                          
                            
  declare @Table1 table (id int)                     
                      
--------06-01-2020                      
                          
                      
                      
  INSERT INTO FENotification ( UserId,                          
         NotificationAlerts,                          
         Remarks,                          
         CreatedBy,                          
         CreatedDate,                          
         CreatedDateUTC,                          
         ModifiedBy,                          
         ModifiedDate,                          
         ModifiedDateUTC,                          
         ScreenName,                          
         DocumentId,                          
         SingleRecord,        
   Isbis                        
        ) OUTPUT INSERTED.NotificationId INTO @Table1                          
     SELECT AssignedUserId,                          
       @mScheduled +' Work Order has been assinged to you - ' + @pMaintenanceWorkNo,-- + ' Dt '+ @mDateFmtValue,                          
    --'AAA',                      
       'Manual Assigned' AS Remarks,                          
       CreatedBy,                          
       GETDATE(),                          
       GETUTCDATE(),                          
       CreatedBy,                          
       GETDATE(),                          
       GETUTCDATE(),                          
       'EngMaintenanceWorkOrderTxn',                          
       @pMaintenanceWorkNo,                          
       1 ,        
    1                         
     FROM EngMaintenanceWorkOrderTxn                    
     WHERE WorkOrderId in (select top 1 id from @Table)                          
                                
--SELECT * FROM EngMaintenanceWorkOrderTxn                      
                                
  INSERT INTO QueueWebtoMobile (  TableName,                          
            Tableprimaryid,                          
            UserId                          
          )                          
      SELECT 'FENotification',                          
        ID,                          
        @pEngineerStaffId                          
      FROM @Table1                          
                          
END                          
                                 
                          
end                          
                          
ELSE                           
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------                          
                          
--1.FMLovMst UPDATE                          
                          
                             
                          
BEGIN                          
                          
  DECLARE @mMaintenanceWorkType INT, @mAssignee INT,@mMaintenanceWorkNo NVARCHAR(50),@ishistory  bit=0          SET @mMaintenanceWorkType = (SELECT MaintenanceWorkType FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId = @pWorkOrderId)                    
   
   
      
  SET @mAssignee    = (SELECT AssignedUserId FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId = @pWorkOrderId)                          
  SET @mMaintenanceWorkNo  = (SELECT MaintenanceWorkNo FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId = @pWorkOrderId)                          
   --DECLARE @mTimestamp varbinary(200);                          
   --SELECT @mTimestamp = Timestamp FROM EngMaintenanceWorkOrderTxn                           
   --WHERE WorkOrderId = @pWorkOrderId                          
  if exists ( select 1   FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId = @pWorkOrderId and WorkOrderStatus  <> @pWorkOrderStatus)                          
  begin                           
  set @ishistory=1                          
  end                              
   --IF(@mTimestamp= @pTimestamp)                          
   --BEGIN                          
     UPDATE  MaintenanceWorkOrder SET                            
       MaintenanceWorkOrder.CustomerId     = @pCustomerId,                          
       MaintenanceWorkOrder.FacilityId     = @pFacilityId,                          
       MaintenanceWorkOrder.ServiceId     = @pServiceId,                      
       MaintenanceWorkOrder.AssetId     = @pAssetId,                          
       MaintenanceWorkOrder.MaintenanceWorkNo   = @pMaintenanceWorkNo,                          
       MaintenanceWorkOrder.MaintenanceDetails   = @pMaintenanceDetails,                          
       MaintenanceWorkOrder.MaintenanceWorkCategory = @pMaintenanceWorkCategory,                          
       MaintenanceWorkOrder.MaintenanceWorkType  = @pMaintenanceWorkType,                          
       MaintenanceWorkOrder.TypeOfWorkOrder   = @pTypeOfWorkOrder,                          
       MaintenanceWorkOrder.QRCode      = @pQRCode,                          
       MaintenanceWorkOrder.EngineerUserId    = @pEngineerStaffId,                          
       MaintenanceWorkOrder.AssignedUserId    = @pEngineerStaffId,                
       MaintenanceWorkOrder.RequestorUserId   = @pRequestorStaffId,                          
       MaintenanceWorkOrder.WorkOrderPriority   = @pWorkOrderPriority,                          
       MaintenanceWorkOrder.Image1FMDocumentId   = @pImage1FMDocumentId,                          
       MaintenanceWorkOrder.Image2FMDocumentId   = @pImage2FMDocumentId,                          
       MaintenanceWorkOrder.Image3FMDocumentId   = @pImage3FMDocumentId,                          
       MaintenanceWorkOrder.WorkGroupId    = @pWorkGroupId,                          
       MaintenanceWorkOrder.WorkOrderStatus   = @pWorkOrderStatus,                          
       MaintenanceWorkOrder.PlannerHistoryId   = @pPlannerHistoryId,                          
       MaintenanceWorkOrder.Remarks     = @pRemarks,                          
       MaintenanceWorkOrder.ModifiedBy     = @pUserId,                          
       MaintenanceWorkOrder.ModifiedDate    = GETDATE(),                          
       MaintenanceWorkOrder.ModifiedDateUTC   = GETUTCDATE(),                   
       MaintenanceWorkOrder.BreakDownRequestId   = @pBreakDownRequestId,                          
       MaintenanceWorkOrder.WOAssignmentId    = @pWOAssignmentId,                          
       MaintenanceWorkOrder.UserAreaId     = @pUserAreaId,                          
       MaintenanceWorkOrder.UserLocationId    = @pUserLocationId,                          
       MaintenanceWorkOrder.StandardTaskDetId   = @pStandardTaskDetId                          
         OUTPUT INSERTED.WorkOrderId INTO @Table                          
    FROM EngMaintenanceWorkOrderTxn      AS MaintenanceWorkOrder                          
    WHERE MaintenanceWorkOrder.WorkOrderId= @pWorkOrderId                           
      AND ISNULL(@pWorkOrderId,0)>0                          
                              
   SELECT WorkOrderId,                          
     MaintenanceWorkNo,                          
 [Timestamp],                          
     GuId                          
   FROM EngMaintenanceWorkOrderTxn                          
   WHERE WorkOrderId IN (SELECT ID FROM @Table)                          
                          
                              
    if @ishistory=1                          
    begin                          
    INSERT INTO EngMaintenanceWorkOrderStatusHistory(CustomerId,FacilityId,ServiceId,WorkOrderId,Status,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)                          
    SELECT CustomerId,FacilityId,ServiceId,WorkOrderId,WorkOrderStatus,@pUserId,GETDATE(),GETUTCDATE(),@pUserId,GETDATE(),GETUTCDATE()  FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId = @pWorkOrderId                          
   end                          
                          
                          
---------- Notification Alerts------------                          
                          
IF(ISNULL(@mMaintenanceWorkType,0)=273 AND ISNULL(@pMaintenanceWorkType,0)=270 )                          
BEGIN                          
 IF NOT EXISTS (SELECT 1 FROM QueueWebtoMobile WHERE TableName='EngMaintenanceWorkOrderTxn' AND Tableprimaryid=@pWorkOrderId AND UserId=(SELECT COALESCE(@pRequestorStaffId,@pUserId,@mAssignee,@pEngineerStaffId)))                          
 BEGIN                          
  SELECT @mDateFmt = b.FieldValue                            
  FROM FMConfigCustomerValues a                           
    INNER JOIN FMLovMst b on a.ConfigKeyLovId=b.LovId                          
  WHERE A.KeyName='DATE'                          
    AND CustomerId = @pCustomerId                          
                          
  IF (@mDateFmt='DD-MMM-YYYY')                          
   BEGIN                          
    SET @mDateFmtValue = REPLACE(CONVERT(VARCHAR, GETDATE(), 6),' ','-')                          
   END                          
  ELSE IF (@mDateFmt='DD/MMM/YYYY')                          
   BEGIN                          
    SET @mDateFmtValue = REPLACE(CONVERT(VARCHAR, GETDATE(), 6),' ','/')                          
   END                          
                          
  INSERT INTO QueueWebtoMobile (  TableName,                          
            Tableprimaryid,                          
            UserId                          
          )                          
      SELECT 'EngMaintenanceWorkOrderTxn',                          
        @pWorkOrderId,                          
        COALESCE(@pRequestorStaffId,@pUserId,@mAssignee,@pEngineerStaffId)                          
                          
                          
  INSERT INTO FEAcknowledge( ScreenName,                          
         Documentid,                          
         DocumentNo,                          
         Description,                          
         Userid,                          
   Remarks,                          
         Acknowledge,                          
         Signatureimage                          
         ) OUTPUT INSERTED.AcknowledgeId INTO @TableAcknowledge                          
      SELECT 'Unscheduled Work Order',                          
        @pWorkOrderId,                          
        @mMaintenanceWorkNo,                          
        'The following work order - ' + @mMaintenanceWorkNo +' work order type  has been changed from Break down to Corrective',                          
        COALESCE(@pRequestorStaffId,@pUserId,@mAssignee,@pEngineerStaffId),                          
        null,                          
        null,                          
        null                           
                                
  INSERT INTO QueueWebtoMobile (  TableName,                          
            Tableprimaryid,                          
            UserId                          
          )                          
      SELECT 'FEAcknowledge',                          
        ID,                          
        COALESCE(@pRequestorStaffId,@pUserId,@mAssignee,@pEngineerStaffId)                          
      FROM @TableAcknowledge                          
                          
 END                          
END                             
                          
                          
                          
                          
--END                           
-- ELSE                          
--  BEGIN                          
-- SELECT WorkOrderId,                          
--       [Timestamp],                          
--       'Record Modified. Please Re-Select' ErrorMessage                          
       --GuId                          
--       FROM  EngMaintenanceWorkOrderTxn                          
--       WHERE WorkOrderId =@pWorkOrderId                          
--  END                          
END                          
                          
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
GO
