USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_QualityCauseMaster_Save_Failure]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- SELECT * FROM CLS_QualityCauseMasterTxn_Failure  
CREATE procedure [dbo].[SP_CLS_QualityCauseMaster_Save_Failure]  
@QualityCauseMasterId INT,  
@QualityId INT,  
@FailureType varchar(50),  
@FailureRootCauseCode varchar(500),  
@Details varchar(50) =null,  
@Status int,  
@IsDeleted bit  
  
AS  
BEGIN  
SET NOCOUNT ON;  
  
BEGIN TRY  
  
  
  IF(@QualityId = 0)  
  BEGIN  
   IF(EXISTS(SELECT 1 FROM CLS_QualityCauseMasterTxn_Failure WHERE [FailureRootCauseCode] =  @FailureRootCauseCode))  
   BEGIN  
    SELECT -1 AS QualityId  
   END  
   ELSE  
   BEGIN  
     INSERT INTO CLS_QualityCauseMasterTxn_Failure  
     ( [FailureType], [FailureRootCauseCode], [Details], [Status], [isDeleted], [QualityCauseId] )   
     values( @FailureType, @FailureRootCauseCode, @Details, @Status, CAST(@IsDeleted AS INT), @QualityCauseMasterId )  
                                                
     select @@Identity as QualityId
   END  
  END  
  ELSE  
  BEGIN  
   UPDATE CLS_QualityCauseMasterTxn_Failure SET [FailureType] = @FailureType, [FailureRootCauseCode] = @FailureRootCauseCode,  [Details] = @Details, [Status] = @Status,  [isDeleted] = CAST(@IsDeleted AS INT)   
   WHERE  QualityId = @QualityId and [QualityCauseId] = @QualityCauseMasterId  
  
   SELECT @QualityId AS QualityId  
  END  
  
     
END TRY  
BEGIN CATCH  
INSERT INTO ExceptionLog ( ErrorLine, ErrorMessage, ErrorNumber, ErrorProcedure, ErrorSeverity, ErrorState, DateErrorRaised )  
SELECT  
ERROR_LINE () as ErrorLine,  
Error_Message() as ErrorMessage,  
Error_Number() as ErrorNumber,  
Error_Procedure() as 'SP_CLS_QualityCauseMasterSave',  
Error_Severity() as ErrorSeverity,  
Error_State() as ErrorState,  
GETDATE () as DateErrorRaised  
  
SELECT 'Error occured while inserting'  
END CATCH  
END
GO
