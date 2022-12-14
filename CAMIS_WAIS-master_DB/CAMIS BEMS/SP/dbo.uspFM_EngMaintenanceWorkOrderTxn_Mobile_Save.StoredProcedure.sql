USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMaintenanceWorkOrderTxn_Mobile_Save]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================  
Application Name : UETrack-BEMS                
Version    : 1.0  
Procedure Name  : uspFM_EngMaintenanceWorkOrderTxn_Save  
Description   : If Maintenance Work Order already exists then update else insert.  
Authors    : Balaji M S  
Date    : 09-April-2018  
-----------------------------------------------------------------------------------------------------------  
  
Unit Test:  
 
DECLARE @EngMaintenanceWorkOrderTxn_Mobile  [dbo].[udt_EngMaintenanceWorkOrderTxn_Mobile]  
INSERT INTO @EngMaintenanceWorkOrderTxn_Mobile([WorkOrderId],[CustomerId],[FacilityId],[ServiceId],[AssetId],[MaintenanceDetails],[MaintenanceWorkCategory],[MaintenanceWorkType],  
[TypeOfWorkOrder],[QRCode],[MaintenanceWorkDateTime],[TargetDateTime],[EngineerStaffId],[RequestorStaffId],[WorkOrderPriority],[Image1FMDocumentId],[Image2FMDocumentId],  
[Image3FMDocumentId],[PlannerId],[WorkGroupId],[WorkOrderStatus],[PlannerHistoryId],[Remarks],[BreakDownRequestId],[WOAssignmentId],[UserAreaId],[UserLocationId],  
[StandardTaskDetId],[UserId],MOBILEGUID)  
values (0,10,10,2,58,'input from mobile',188,83,34,null,getdate(),null,17,17,67,null,null,null,null,1,192,null,'mob app',null,null,null,null,null,1,NEWID()),  
(0,1,1,2,1,'input from mobile',188,83,34,null,getdate(),null,1,1,67,null,null,null,null,1,192,null,'mob app',null,null,null,null,null,1,NEWID())  
  
exec uspFM_EngMaintenanceWorkOrderTxn_Mobile_Save @EngMaintenanceWorkOrderTxn_Mobile=@EngMaintenanceWorkOrderTxn_Mobile,@pMaintenanceWorkNo=null  
  
select * from EngMaintenanceWorkOrderTxn  
select * from EngStockAdjustmentTxndET  
select * from ErrorLog  
  
  
-----------------------------------------------------------------------------------------------------------  
Version History   
-----:------------:---------------------------------------------------------------------------------------  
Init :  Date       : Details  
========================================================================================================*/  
  
CREATE PROCEDURE  [dbo].[uspFM_EngMaintenanceWorkOrderTxn_Mobile_Save]  
    
  @EngMaintenanceWorkOrderTxn_Mobile  [dbo].[udt_EngMaintenanceWorkOrderTxn_Mobile]   READONLY,  
  @pMaintenanceWorkNo NVARCHAR(100) = NULL  
  
AS                                                
  
BEGIN TRY  
  
 DECLARE @mTRANSCOUNT INT = @@TRANCOUNT  
  
 BEGIN TRANSACTION  
  
-- Paramter Validation   
  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
-- Declaration  
    
   
 declare @Table2 TABLE (ID INT)  
 declare @TableNotification table (ID INT,UserId int)  
  
 DECLARE @Table TABLE (ID INT, MaintenanceWorkNo Nvarchar(500),userid int)   
  
 DECLARE @PrimaryKeyId  INT  
 DECLARE @TotalRecords INT  
 DECLARE @pTotalPage  NUMERIC(24,2)  
 DECLARE @mLoopStart INT =1,@mLoopLimit INT  
 DECLARE @pOutParam NVARCHAR(50)   
DECLARE @MaintenanceWorkCategory INT   
--SET @MaintenanceWorkCategory = (SELECT MaintenanceWorkCategory FROM @EngMaintenanceWorkOrderTxn_Mobile)  
 DECLARE @mMonth INT,@mYear INT  
 DECLARE @MaintenanceWorkDateTime DATETIME, @mDefaultkey NVARCHAR(100)  
   
 DECLARE @pCustomerId INT  
 DECLARE @pFacilityId INT  
 IF(@MaintenanceWorkDateTime IS NULL)  
 BEGIN  
 SET @MaintenanceWorkDateTime = GETUTCDATE() --(SELECT [dbo].[udf_GetMalaysiaDateTime] (GETDATE()))  
 END  
 -- SET @MaintenanceWorkDateTime = (SELECT [dbo].[udf_GetMalaysiaDateTime] (GETDATE())) --(SELECT MaintenanceWorkDateTime FROM @EngMaintenanceWorkOrderTxn_Mobile)  
   
 --SET @pCustomerId = (SELECT CustomerId FROM @EngMaintenanceWorkOrderTxn_Mobile)  
 --SET @pFacilityId = (SELECT FacilityId FROM @EngMaintenanceWorkOrderTxn_Mobile)  
 --SET @mMonth = MONTH(@MaintenanceWorkDateTime)  
 --SET @mYear = YEAR(@MaintenanceWorkDateTime)  
  
SELECT * INTO #TEMPResultWo FROM @EngMaintenanceWorkOrderTxn_Mobile  
SELECT * FROM #TEMPResultWo  
ALTER TABLE #TEMPResultWo ADD MaintenanceWorkNo NVARCHAR(100)  
ALTER TABLE #TEMPResultWo ADD SWOid INT IDENTITY(1,1) NOT NULL  
  
 SELECT @mLoopLimit = COUNT(1) FROM #TEMPResultWo  
 WHILE (@mLoopStart<=@mLoopLimit)  
 BEGIN  
 SET @MaintenanceWorkCategory = (SELECT MaintenanceWorkCategory FROM #TEMPResultWo WHERE SWOid=@mLoopStart)  
 SET @pCustomerId = (SELECT CustomerId FROM #TEMPResultWo WHERE SWOid=@mLoopStart )  
 SET @pFacilityId = (SELECT FacilityId FROM #TEMPResultWo WHERE SWOid=@mLoopStart)  
 SET @mMonth = (SELECT MONTH(MaintenanceWorkDateTime) FROM #TEMPResultWo WHERE SWOid=@mLoopStart)  
 SET @mYear = (SELECT YEAR(MaintenanceWorkDateTime) FROM #TEMPResultWo WHERE SWOid=@mLoopStart)  
 IF(@MaintenanceWorkCategory = 188)  
 BEGIN  
  IF EXISTS (SELECT 1 FROM EngContractOutRegisterDet WHERE AssetId IN (SELECT DISTINCT AssetId FROM #TEMPResultWo WHERE SWOid=@mLoopStart))  
   BEGIN  
    SET @mDefaultkey='CWO'  
   END  
   ELSE  
   BEGIN  
    SET @mDefaultkey='WWO'  
   END  
 EXEC [uspFM_GenerateDocumentNumber] @pFlag='EngMaintenanceWorkOrderTxn',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey=@mDefaultkey,@pModuleName=NULL,@pMonth=05,@pYear=2019,@pOutParam=@pOutParam OUTPUT  
 SELECT @pMaintenanceWorkNo=@pOutParam  
 END  
 IF(@MaintenanceWorkCategory = 187)  
 BEGIN  
 EXEC [uspFM_GenerateDocumentNumber] @pFlag='EngMaintenanceWorkOrderTxn',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey='SWO',@pModuleName='BEMS',@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT  
 SELECT @pMaintenanceWorkNo=@pOutParam  
 END  
  UPDATE #TEMPResultWo SET MaintenanceWorkNo = @pMaintenanceWorkNo WHERE SWOid = @mLoopStart  
 SET @mLoopStart = @mLoopStart+1  
 END  
  
  
--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------  
  
--//1.FMLovMst  
  
   --IF EXISTS( SELECT 1 FROM @EngMaintenanceWorkOrderTxn_Mobile WHERE WorkOrderId = NULL OR WorkOrderId =0)  
   if(1=1)  
  
   
  
BEGIN  
  
  
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
       MobileGuid,  
       WOImage,  
       WOVideo,  
       AssigneeLovId  
      ) OUTPUT INSERTED.WorkOrderId,INSERTED.MaintenanceWorkNo,inserted.CreatedBy INTO @Table         
  
   SELECT   
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
       EngineerStaffId,  
       RequestorStaffId,  
       WorkOrderPriority,  
       Image1FMDocumentId,  
       Image2FMDocumentId,  
       Image3FMDocumentId,  
       PlannerId,  
       1 as WorkGroupId,  
       192 as WorkOrderStatus,  
       PlannerHistoryId,  
       Remarks,   
       UserId,     
       GETDATE(),   
       GETDATE(),  
       UserId,   
       GETDATE(),   
       GETDATE(),  
       BreakDownRequestId,  
       WOAssignmentId,  
       UserAreaId,  
       UserLocationId,  
       StandardTaskDetId,  
       MobileGuid,  
       WOImage,  
       WOVideo,  
       330  
      FROM    #TEMPResultWo  
      --WHERE (WorkOrderId =0 or WorkOrderId = null)  
  
  
   SELECT WorkOrderId,MaintenanceWorkNo,  
     [Timestamp]  
   FROM EngMaintenanceWorkOrderTxn  
   WHERE WorkOrderId IN (SELECT ID FROM @Table)  
  
  
      SELECT NotificationDeliveryId,  
   NotificationTemplateId,  
   UserRoleId,  
   UserRegistrationId,  
   FacilityId  
 INTO #Notification  
 FROM NotificationDeliveryDet  
 WHERE NotificationTemplateId = 17  
  
   
   
 SELECT distinct A.UserRegistrationId,  
   b.FacilityId,  
   b.CustomerId    
  INTO #TempUserEmails_all  
 FROM UMUserRegistration AS A   
   INNER JOIN UMUserLocationMstDet AS B ON A.UserRegistrationId = B.UserRegistrationId  
 WHERE B.UserRoleId IN (SELECT DISTINCT UserRoleId FROM #Notification)  
 AND B.FacilityId = @pFacilityId  
 --IN (SELECT DISTINCT FacilityId FROM #Notification)  
   
   
   
  
  
     INSERT INTO WebNotification ( CustomerId,  
           FacilityId,  
           UserId,  
           NotificationAlerts,  
           Remarks,  
           HyperLink,  
           IsNew,  
           CreatedBy,  
           CreatedDate,  
           CreatedDateUTC,  
           ModifiedBy,  
           ModifiedDate,  
           ModifiedDateUTC ,  
           NotificationDateTime,  
           IsNavigate                                                                                                                    
          )OUTPUT INSERTED.NotificationId INTO @Table2  
  
          select  A.CustomerId,  
            A.FacilityId,  
            A.UserRegistrationId,  
            isnull((select top 1 MaintenanceWorkNo from @Table ),'')+ '' + ' - UnScheduled Work Order has been generated',  
            ''  ,  
             '/bems/unscheduledworkorder?id=' + cast(isnull((select top 1 ID from @Table ),'')as varchar(500))  ,  
            1  ,  
            isnull((select top 1 userid from @Table ),'') ,   
            GETDATE(),           
            GETUTCDATE(),  
            isnull((select top 1 userid from @Table ),''),  
            GETDATE(),  
            GETUTCDATE() ,  
            GETDATE(),  
            0   
          from #TempUserEmails_all a  
  
  
  
  
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
         SingleRecord  
        ) OUTPUT INSERTED.NotificationId,INSERTED.UserId INTO @TableNotification  
        SELECT UserRegistrationId,  
       isnull((select top 1 MaintenanceWorkNo from @Table ),'')+ '' + ' - UnScheduled Work Order has been generated',  
       '',  
         isnull((select top 1 userid from @Table ),''),  
       GETDATE(),  
       GETUTCDATE(),  
         isnull((select top 1 userid from @Table ),''),  
       GETDATE(),  
       GETUTCDATE(),  
       'UnScheduledWorkOrder',  
       (select top 1 ID from @Table),  
       1  
        FROM #TempUserEmails_all  
        
       INSERT INTO QueueWebtoMobile (  TableName,  
        Tableprimaryid,  
        UserId  
         )  
        SELECT 'FENotification',  
       ID,  
       UserId  
        FROM @TableNotification  
  
  
  
  
         
  
END  
  
ELSE   
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------  
  
--1.FMLovMst UPDATE  
  
     
  
BEGIN  
   --DECLARE @mTimestamp varbinary(200);  
   --SELECT @mTimestamp = Timestamp FROM EngMaintenanceWorkOrderTxn   
   --WHERE WorkOrderId = @pWorkOrderId  
     
   --IF(@mTimestamp= @pTimestamp)  
   --BEGIN  
     UPDATE  MaintenanceWorkOrder SET    
       MaintenanceWorkOrder.CustomerId     = MaintenanceWorkOrderudt.CustomerId,  
       MaintenanceWorkOrder.FacilityId     = MaintenanceWorkOrderudt.FacilityId,  
       MaintenanceWorkOrder.ServiceId     = MaintenanceWorkOrderudt.ServiceId,  
       MaintenanceWorkOrder.AssetId     = MaintenanceWorkOrderudt.AssetId,  
       MaintenanceWorkOrder.MaintenanceDetails   = MaintenanceWorkOrderudt.MaintenanceDetails,  
       MaintenanceWorkOrder.MaintenanceWorkCategory = MaintenanceWorkOrderudt.MaintenanceWorkCategory,  
       MaintenanceWorkOrder.MaintenanceWorkType  = MaintenanceWorkOrderudt.MaintenanceWorkType,  
       MaintenanceWorkOrder.TypeOfWorkOrder   = MaintenanceWorkOrderudt.TypeOfWorkOrder,  
       MaintenanceWorkOrder.QRCode      = MaintenanceWorkOrderudt.QRCode,  
       MaintenanceWorkOrder.EngineerUserId    = MaintenanceWorkOrderudt.EngineerStaffId,  
       MaintenanceWorkOrder.RequestorUserId   = MaintenanceWorkOrderudt.RequestorStaffId,  
       MaintenanceWorkOrder.WorkOrderPriority   = MaintenanceWorkOrderudt.WorkOrderPriority,  
       MaintenanceWorkOrder.Image1FMDocumentId   = MaintenanceWorkOrderudt.Image1FMDocumentId,  
       MaintenanceWorkOrder.Image2FMDocumentId   = MaintenanceWorkOrderudt.Image2FMDocumentId,  
       MaintenanceWorkOrder.Image3FMDocumentId   = MaintenanceWorkOrderudt.Image3FMDocumentId,  
       MaintenanceWorkOrder.WorkGroupId    = MaintenanceWorkOrderudt.WorkGroupId,  
       MaintenanceWorkOrder.WorkOrderStatus   = MaintenanceWorkOrderudt.WorkOrderStatus,  
       MaintenanceWorkOrder.PlannerHistoryId   = MaintenanceWorkOrderudt.PlannerHistoryId,  
       MaintenanceWorkOrder.Remarks     = MaintenanceWorkOrderudt.Remarks,  
       MaintenanceWorkOrder.ModifiedBy     = MaintenanceWorkOrderudt.UserId,  
       MaintenanceWorkOrder.ModifiedDate    = GETDATE(),  
       MaintenanceWorkOrder.ModifiedDateUTC   = GETUTCDATE(),  
       MaintenanceWorkOrder.BreakDownRequestId   = MaintenanceWorkOrderudt.BreakDownRequestId,  
       MaintenanceWorkOrder.WOAssignmentId    = MaintenanceWorkOrderudt.WOAssignmentId,  
       MaintenanceWorkOrder.UserAreaId     = MaintenanceWorkOrderudt.UserAreaId,  
       MaintenanceWorkOrder.UserLocationId    = MaintenanceWorkOrderudt.UserLocationId,  
       MaintenanceWorkOrder.StandardTaskDetId   = MaintenanceWorkOrderudt.StandardTaskDetId,  
       MaintenanceWorkOrder.MobileGuid     = MaintenanceWorkOrderudt.MobileGuid,  
       MaintenanceWorkOrder.WOImage     = MaintenanceWorkOrderudt.WOImage,  
       MaintenanceWorkOrder.WOVideo     = MaintenanceWorkOrderudt.WOVideo           
    FROM EngMaintenanceWorkOrderTxn      AS MaintenanceWorkOrder  
    inner join @EngMaintenanceWorkOrderTxn_Mobile           AS MaintenanceWorkOrderudt  on MaintenanceWorkOrder.WorkOrderId = MaintenanceWorkOrderudt.WorkOrderId  
    WHERE ISNULL(MaintenanceWorkOrderudt.WorkOrderId,0)>0  
      
  
   --SELECT WorkOrderId,  
   --  [Timestamp]  
   --FROM EngMaintenanceWorkOrderTxn  
   --WHERE WorkOrderId IN (SELECT ID FROM @Table)  
  
--END     
-- ELSE  
--  BEGIN  
--       SELECT WorkOrderId,  
--       [Timestamp],  
--       'Record Modified. Please Re-Select' ErrorMessage  
--       FROM  EngMaintenanceWorkOrderTxn  
--       WHERE WorkOrderId =@pWorkOrderId  
--  END  
  
PRINT 'Not Updated'  
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
  
  
  
----------------------------------------------------------------------------UDT--------------------------------------------------------  
  
--DROP PROC uspFM_EngMaintenanceWorkOrderTxn_Mobile_Save  
--DROP TYPE udt_EngMaintenanceWorkOrderTxn_Mobile  
  
--CREATE TYPE [dbo].[udt_EngMaintenanceWorkOrderTxn_Mobile] AS TABLE (  
--  WorkOrderId      INT     NULL,  
--  CustomerId      INT     NULL,  
--  FacilityId      INT     NULL,  
--  ServiceId      INT     NULL,  
--  AssetId       INT     NULL,  
--  MaintenanceDetails    NVARCHAR(1000)  NULL,  
--  MaintenanceWorkCategory   INT     NULL,  
--  MaintenanceWorkType    INT     NULL,  
--  TypeOfWorkOrder     INT     NULL,  
--  QRCode       VARBINARY(1000)  NULL,  
--  MaintenanceWorkDateTime   DATETIME   NULL,  
--  TargetDateTime     DATETIME   NULL,  
--  EngineerStaffId     INT     NULL,  
--  RequestorStaffId    INT     NULL,  
--  WorkOrderPriority    INT     NULL,  
--  Image1FMDocumentId    INT     NULL,  
--  Image2FMDocumentId    INT     NULL,  
--  Image3FMDocumentId    INT     NULL,  
--  PlannerId      INT     NULL,  
--  WorkGroupId      INT     NULL,  
--  WorkOrderStatus     INT     NULL,  
--  PlannerHistoryId    INT     NULL,  
--  Remarks       NVARCHAR(1000)  NULL,  
--  BreakDownRequestId    INT     NULL,  
--  WOAssignmentId     INT     NULL,  
--  UserAreaId      INT     NULL,  
--  UserLocationId     INT     NULL,  
--  StandardTaskDetId    INT     NULL,  
--  UserId       INT     NULL,  
--  MobileGuid      NVARCHAR(MAX)  NULL,  
--  WOImage       VARBINARY(MAX)  NULL,  
--  WOVideo       VARBINARY(MAX)  NULL  
--)
GO
