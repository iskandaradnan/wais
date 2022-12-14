USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequest_Update_mobile]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/*========================================================================================================  
Application Name : UETrack-BEMS                
Version    : 1.0  
Procedure Name  : uspFM_CRMRequest_Update  
Description   : If Request already exists then update else insert.  
Authors    : Balaji M S  
Date    : 05-April-2018  
-----------------------------------------------------------------------------------------------------------  
  
Unit Test:  
  
  
EXEC [uspFM_CRMRequest_Update] @pCRMRequestId=1  
SELECT * FROM CRMRequest  
SELECT * FROM CRMRequestDet  
-----------------------------------------------------------------------------------------------------------  
Version History   
-----:------------:---------------------------------------------------------------------------------------  
Init :  Date       : Details  
========================================================================================================*/  
  
CREATE PROCEDURE  [dbo].[uspFM_CRMRequest_Update_mobile]  
  
   @pCRMRequestId     INT,  
   @pUserId      INT      = NULL,  
   @pFlag       NVARCHAR(100) = NULL,  
   @pRemarks      NVARCHAR(100) = NULL,  
   @pAssigneeId     INT     = NULL,  
   @RequestType     Int     = NULL  
      
AS                                                
  
BEGIN TRY  
  
 DECLARE @mTRANSCOUNT INT = @@TRANCOUNT  
 BEGIN TRANSACTION  
  
-- Paramter Validation   
  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
-- Declaration  
   
 DECLARE @Table TABLE (ID INT)  
 declare   @TableNotification table (id int, UserId int) 
 declare   @TableNotification1 table (id int, UserId int)  
-- Default Values  
  
  
-- Execution  
  
  IF (@pFlag='Approve') and  @RequestType= 374  
  BEGIN  
  
  UPDATE CRMRequest SET RequestStatus =142,   --Obsolete  
        ModifiedBy = @pUserId,  
        ModifiedDate = getdate(),  
        ModifiedDateUTC=GETUTCDATE(),  
        StatusValue = 'Closed'  
  WHERE CRMRequestId = @pCRMRequestId   
  
  UPDATE CRMRequest SET AssigneeId = @pAssigneeId           
  WHERE CRMRequestId = @pCRMRequestId   
  
  SELECT * INTO #AssetResultSet FROM EngAsset WHERE Model = (SELECT ModelId FROM CRMRequest WHERE CRMRequestId = @pCRMRequestId AND TypeOfRequest = 374)  
  AND Manufacturer =  (SELECT ManufacturerId FROM CRMRequest WHERE CRMRequestId = @pCRMRequestId AND TypeOfRequest = 374 )  
  
  UPDATE B SET B.AssetWorkingStatus = 374 FROM #AssetResultSet A INNER JOIN EngAsset B ON A.AssetId = B.AssetId  
  
  
  IF NOT EXISTS (SELECT * FROM CRMRequestRemarksHistory WHERE CRMRequestId = @pCRMRequestId AND RequestStatusValue='Closed' AND Remarks = @pRemarks)  
  
  BEGIN  
 INSERT INTO CRMRequestRemarksHistory ( CRMRequestId  
           ,Remarks  
           ,DoneBy  
           ,DoneDate  
           ,DoneDateUTC  
           ,RequestStatus  
           ,RequestStatusValue  
           ,CreatedBy  
           ,CreatedDate  
           ,CreatedDateUTC  
           ,ModifiedBy  
           ,ModifiedDate  
           ,ModifiedDateUTC  
          )  
        VALUES ( @pCRMRequestId,  
           @pRemarks,  
           @pUserId,  
           GETDATE(),  
           GETUTCDATE(),  
           142,  
           @pFlag,  
           @pUserId,  
           GETDATE(),  
           GETUTCDATE(),  
           @pUserId,  
           GETDATE(),  
           GETUTCDATE()  
          )  
  END  
  
  
  SELECT CRMRequestId,  
    @pFlag AS Flag,  
    [Timestamp]  
  FROM CRMRequest   
  WHERE CRMRequestId = @pCRMRequestId  
     
  END  
  ELSE IF (@pFlag='Reject')  
 BEGIN  
  UPDATE CRMRequest SET RequestStatus =142,  
        ModifiedBy = @pUserId,  
        ModifiedDate = getdate(),  
        ModifiedDateUTC=GETUTCDATE(),  
        StatusValue = 'Reject'  
  WHERE CRMRequestId = @pCRMRequestId   
  
    
    
   
      
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
    SELECT Requester,  
   RequestNo +' CRM Request has been Rejected',  
   'CRM Request Rejected' AS Remarks,  
   @pUserId,  
   GETDATE(),  
   GETUTCDATE(),  
   @pUserId,  
   GETDATE(),  
   GETUTCDATE(),  
   'CRMRequestStatus',  
   GuId,  
   1  
   from CRMRequest WHERE CRMRequestId = @pCRMRequestId   
    --FROM #Temp  
        
     INSERT INTO QueueWebtoMobile (  TableName,  
      Tableprimaryid,  
      UserId  
       )  
      SELECT 'FENotification',  
     ID,  
     UserId  
      FROM @TableNotification  
  
  
  
  
   
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
        )  
    SELECT   
  
       A.CustomerId,  
       A.FacilityId,  
          A.Requester,  
       A.RequestNo+' CRM Request has been Rejected',  
       'CRM Request Rejected' AS Remarks,  
       '/bems/crmrequest?id=' + cast(A.CRMRequestId as varchar(500)),  
       1,  
       a.Requester,  
       GETDATE(),  
       GETUTCDATE(),  
       a.Requester,  
       GETDATE(),  
       GETUTCDATE(),  
       GETDATE(),  
       0  
   from CRMRequest a WHERE CRMRequestId = @pCRMRequestId   
       
  
  IF NOT EXISTS (SELECT * FROM CRMRequestRemarksHistory WHERE CRMRequestId = @pCRMRequestId AND RequestStatusValue='Reject' AND Remarks = @pRemarks)  
  
  BEGIN  
 INSERT INTO CRMRequestRemarksHistory ( CRMRequestId  
           ,Remarks  
           ,DoneBy  
           ,DoneDate  
           ,DoneDateUTC  
           ,RequestStatus  
           ,RequestStatusValue  
           ,CreatedBy  
           ,CreatedDate  
           ,CreatedDateUTC  
           ,ModifiedBy  
           ,ModifiedDate  
           ,ModifiedDateUTC  
          )  
        VALUES ( @pCRMRequestId,  
           @pRemarks,  
           @pUserId,  
           GETDATE(),  
           GETUTCDATE(),  
           142,  
           @pFlag,  
           @pUserId,  
           GETDATE(),  
           GETUTCDATE(),  
           @pUserId,  
           GETDATE(),  
           GETUTCDATE()  
          )  
  END  
  
  SELECT CRMRequestId,  
    @pFlag AS Flag,  
    [Timestamp]  
  FROM CRMRequest   
  WHERE CRMRequestId = @pCRMRequestId  
   
 END  
  
 ELSE IF (@pFlag='Approve')  
 BEGIN  
  UPDATE CRMRequest SET RequestStatus =140,  
        ModifiedBy = @pUserId,  
        ModifiedDate = getdate(),  
        ModifiedDateUTC=GETUTCDATE(),  
        StatusValue = 'Approve'  
  WHERE CRMRequestId = @pCRMRequestId   
  
  UPDATE CRMRequest SET AssigneeId = @pAssigneeId           
  WHERE CRMRequestId = @pCRMRequestId   
  
  SELECT * INTO #AssetResultSet1 FROM EngAsset WHERE Model = (SELECT ModelId FROM CRMRequest WHERE CRMRequestId = @pCRMRequestId AND TypeOfRequest = 374)  
  AND Manufacturer =  (SELECT ManufacturerId FROM CRMRequest WHERE CRMRequestId = @pCRMRequestId AND TypeOfRequest = 374 )  
  
  UPDATE B SET B.AssetWorkingStatus = 374 FROM #AssetResultSet1 A INNER JOIN EngAsset B ON A.AssetId = B.AssetId  
  
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
    SELECT Requester,  
   RequestNo+' CRM Request has been Approved',  
   'CRM Request Approved' AS Remarks,  
   @pUserId,  
   GETDATE(),  
   GETUTCDATE(),  
   @pUserId,  
   GETDATE(),  
   GETUTCDATE(),  
   'CRMRequestStatus',  
   GuId,  
   1  
   from CRMRequest WHERE CRMRequestId = @pCRMRequestId   
    --FROM #Temp  
        
     INSERT INTO QueueWebtoMobile (  TableName,  
      Tableprimaryid,  
      UserId  
       )  
      SELECT 'FENotification',  
     ID,  
     UserId  
      FROM @TableNotification  
  
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
        )  
    SELECT   
  
       A.CustomerId,  
       A.FacilityId,  
          A.Requester,  
       A.RequestNo+' CRM Request has been Approved',  
       'CRM Request Approved' AS Remarks,  
       '/bems/crmrequest?id=' + cast(A.CRMRequestId as varchar(500)),  
       1,  
       a.Requester,  
       GETDATE(),  
       GETUTCDATE(),  
       a.Requester,  
       GETDATE(),  
       GETUTCDATE(),  
       GETDATE(),  
       0  
   from CRMRequest a WHERE CRMRequestId = @pCRMRequestId   
   
   IF (ISNULL(@pAssigneeId,0) != 0)
   BEGIN
   
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
    ) OUTPUT INSERTED.NotificationId,INSERTED.UserId INTO @TableNotification1  
    SELECT @pAssigneeId,  
   RequestNo+' CRM Request has been Approved and Assigned To You',  
   'CRM Request Approved' AS Remarks,  
   @pUserId,  
   GETDATE(),  
   GETUTCDATE(),  
   @pUserId,  
   GETDATE(),  
   GETUTCDATE(),  
   'CRMRequestStatus',  
   GuId,  
   1  
   from CRMRequest WHERE CRMRequestId = @pCRMRequestId   
    --FROM #Temp  
        
     INSERT INTO QueueWebtoMobile (  TableName,  
      Tableprimaryid,  
      UserId  
       )  
      SELECT 'FENotification',  
     ID,  
     UserId  
      FROM @TableNotification1  
  
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
        )  
    SELECT   
  
       A.CustomerId,  
       A.FacilityId,  
          A.Requester,  
       A.RequestNo+' CRM Request has been Approved and Assigned To You',  
       'CRM Request Approved' AS Remarks,  
       '/bems/crmrequest?id=' + cast(A.CRMRequestId as varchar(500)),  
       1,  
       a.Requester,  
       GETDATE(),  
       GETUTCDATE(),  
       a.Requester,  
       GETDATE(),  
       GETUTCDATE(),  
       GETDATE(),  
       0  
   from CRMRequest a WHERE CRMRequestId = @pCRMRequestId   
   END
    
  
  
  IF NOT EXISTS (SELECT * FROM CRMRequestRemarksHistory WHERE CRMRequestId = @pCRMRequestId AND RequestStatusValue='Approve' AND Remarks = @pRemarks)  
  
  BEGIN  
 INSERT INTO CRMRequestRemarksHistory ( CRMRequestId  
           ,Remarks  
           ,DoneBy  
           ,DoneDate  
           ,DoneDateUTC  
           ,RequestStatus  
           ,RequestStatusValue  
           ,CreatedBy  
           ,CreatedDate  
           ,CreatedDateUTC  
           ,ModifiedBy  
           ,ModifiedDate  
           ,ModifiedDateUTC  
          )  
        VALUES ( @pCRMRequestId,  
           @pRemarks,  
           @pUserId,  
           GETDATE(),  
           GETUTCDATE(),  
           140,  
           @pFlag,  
           @pUserId,  
           GETDATE(),  
           GETUTCDATE(),  
           @pUserId,  
           GETDATE(),  
           GETUTCDATE()  
          )  
  END  
  
  
  SELECT CRMRequestId,  
    @pFlag AS Flag,  
    [Timestamp]  
  FROM CRMRequest   
  WHERE CRMRequestId = @pCRMRequestId  
  
END  
  
 ELSE IF (@pFlag='Verify')  
 BEGIN  
  UPDATE CRMRequest SET RequestStatus =142,  
        ModifiedBy = @pUserId,  
        ModifiedDate = getdate(),  
        ModifiedDateUTC=GETUTCDATE(),  
        StatusValue = 'Verify'  
  WHERE CRMRequestId = @pCRMRequestId   
  
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
    SELECT Requester,  
   RequestNo +' CRM Request Closed',   
   'CRM Request Closed' AS Remarks,  
   @pUserId,  
   GETDATE(),  
   GETUTCDATE(),  
   @pUserId,  
   GETDATE(),  
   GETUTCDATE(),  
   'CRMRequestStatus',  
   GuId,  
   1  
   from CRMRequest WHERE CRMRequestId = @pCRMRequestId   
    --FROM #Temp  
        
     INSERT INTO QueueWebtoMobile (  TableName,  
      Tableprimaryid,  
      UserId  
       )  
      SELECT 'FENotification',  
     ID,  
     UserId  
      FROM @TableNotification  
  
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
        )  
    SELECT   
  
       A.CustomerId,  
       A.FacilityId,  
          A.Requester,  
       A.RequestNo +' CRM Request Closed',  
       'CRM Request Closed' AS Remarks,  
       '/bems/crmrequest?id=' + cast(A.CRMRequestId as varchar(500)),  
       1,  
       a.Requester,  
       GETDATE(),  
       GETUTCDATE(),  
       a.Requester,  
       GETDATE(),  
       GETUTCDATE(),  
       GETDATE(),  
       0  
   from CRMRequest a WHERE CRMRequestId = @pCRMRequestId   
       
  
  IF NOT EXISTS (SELECT * FROM CRMRequestRemarksHistory WHERE CRMRequestId = @pCRMRequestId AND RequestStatusValue='Verify' AND Remarks = @pRemarks)  
  
  BEGIN  
 INSERT INTO CRMRequestRemarksHistory ( CRMRequestId  
           ,Remarks  
           ,DoneBy  
           ,DoneDate  
           ,DoneDateUTC  
           ,RequestStatus  
           ,RequestStatusValue  
           ,CreatedBy  
           ,CreatedDate  
           ,CreatedDateUTC  
           ,ModifiedBy  
           ,ModifiedDate  
           ,ModifiedDateUTC  
          )  
        VALUES ( @pCRMRequestId,  
           @pRemarks,  
           @pUserId,  
           GETDATE(),  
           GETUTCDATE(),  
           142,  
           @pFlag,  
           @pUserId,  
           GETDATE(),  
           GETUTCDATE(),  
           @pUserId,  
           GETDATE(),  
           GETUTCDATE()  
          )  
  END  
  
  
  SELECT CRMRequestId,  
    @pFlag AS Flag,  
    [Timestamp]  
  FROM CRMRequest   
  WHERE CRMRequestId = @pCRMRequestId  
  
  
END  
  
 ELSE IF (@pFlag='Clarify')  
 BEGIN  
  UPDATE CRMRequest SET RequestStatus =139,  
        ModifiedBy = @pUserId,  
        ModifiedDate = getdate(),  
        ModifiedDateUTC=GETUTCDATE(),  
        StatusValue = 'Clarify'  
  WHERE CRMRequestId = @pCRMRequestId   
  
  
  
  
  IF NOT EXISTS (SELECT * FROM CRMRequestRemarksHistory WHERE CRMRequestId = @pCRMRequestId AND RequestStatusValue='Clarify' AND Remarks = @pRemarks)  
  
 BEGIN  
 INSERT INTO CRMRequestRemarksHistory ( CRMRequestId  
           ,Remarks  
           ,DoneBy  
           ,DoneDate  
           ,DoneDateUTC  
           ,RequestStatus  
           ,RequestStatusValue  
           ,CreatedBy  
           ,CreatedDate  
           ,CreatedDateUTC  
           ,ModifiedBy  
           ,ModifiedDate  
           ,ModifiedDateUTC  
          )  
        VALUES ( @pCRMRequestId,  
           @pRemarks,  
           @pUserId,  
           GETDATE(),  
           GETUTCDATE(),  
           139,  
           @pFlag,  
           @pUserId,  
           GETDATE(),  
           GETUTCDATE(),  
           @pUserId,  
           GETDATE(),  
           GETUTCDATE()  
          )  
  END  
  
  SELECT CRMRequestId,  
    @pFlag AS Flag,  
    [Timestamp]  
  FROM CRMRequest   
  WHERE CRMRequestId = @pCRMRequestId  
  
END  
  
 IF @mTRANSCOUNT = 0  
        BEGIN  
            COMMIT TRANSACTION  
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
