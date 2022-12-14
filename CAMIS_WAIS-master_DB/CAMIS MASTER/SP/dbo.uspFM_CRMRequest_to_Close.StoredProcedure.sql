USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequest_to_Close]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create PROCEDURE  [dbo].[uspFM_CRMRequest_to_Close]   
 @pCRMRequestId        INT    
 AS                                                    
      
BEGIN TRY     
DECLARE @mTRANSCOUNT INT = @@TRANCOUNT      
-- Default Values      
 update CRMRequest set RequestStatus=142 where CRMRequestId= @pCRMRequestId

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
     throw;      
      
END CATCH
GO
