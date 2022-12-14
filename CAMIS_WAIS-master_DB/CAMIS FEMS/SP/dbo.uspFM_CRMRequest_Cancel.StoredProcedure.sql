USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequest_Cancel]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
/*========================================================================================================      
Application Name : UETrack-BEMS                    
Version    : 1.0      
Procedure Name  : uspFM_CRMRequest_Cancel      
Description   : If Request already exists then update else insert.      
Authors    : Dhilip V      
Date    : 23-April-2018      
-----------------------------------------------------------------------------------------------------------      
      
Unit Test:      
EXEC [uspFM_CRMRequest_Cancel] @pCRMRequestId =1 ,@pUserId =2      
SELECT * FROM CRMRequest      
-----------------------------------------------------------------------------------------------------------      
Version History       
-----:------------:---------------------------------------------------------------------------------------      
Init :  Date       : Details      
========================================================================================================*/      
      
CREATE PROCEDURE  [dbo].[uspFM_CRMRequest_Cancel]      
      
   @pCRMRequestId     INT,      
   @pUserId      INT      = NULL,    
   @pRemarks VARCHAR(MAX)    
         
AS                                                    
      
BEGIN TRY      
      
 DECLARE @mTRANSCOUNT INT = @@TRANCOUNT      
      
 BEGIN TRANSACTION      
      
-- Paramter Validation       
      
 SET NOCOUNT ON;      
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;      
      
-- Declaration      
       
 DECLARE @Table TABLE (ID INT)      
      
-- Default Values      
      
      
-- Execution      
      
       
 UPDATE CRMRequest SET RequestStatus = 143,      
       ModifiedBy  = @pUserId,      
       ModifiedDate = GETDATE(),      
       ModifiedDateUTC = GETUTCDATE()  ,    
    Remarks=@pRemarks    
 WHERE CRMRequestId = @pCRMRequestId      
     update CRMRequestRemarksHistory set Remarks=@pRemarks where CRMRequestId=@pCRMRequestId  
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
