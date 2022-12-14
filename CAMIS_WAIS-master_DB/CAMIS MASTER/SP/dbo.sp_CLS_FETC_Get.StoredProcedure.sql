USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_CLS_FETC_Get]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_CLS_FETC_Get]      
(      
 @Id INT      
)      
       
AS       
BEGIN      
SET NOCOUNT ON      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
BEGIN TRY      
       
 SELECT FETCId, ItemCode, ItemDescription, ItemType, Quantity , Status ,EffectiveFrom,EffectiveTo FROM CLS_FETC WHERE FETCId = @Id      
      
 SELECT * FROM CLS_FETC_Attachment WHERE FETCId = @Id AND isDeleted = 0      
       
END TRY      
BEGIN CATCH      
      
INSERT INTO ExceptionLog (        
  ErrorLine, ErrorMessage, ErrorNumber,        
  ErrorProcedure, ErrorSeverity, ErrorState,        
  DateErrorRaised        
  )        
  SELECT        
  ERROR_LINE () as ErrorLine,        
  Error_Message() as ErrorMessage,        
  Error_Number() as ErrorNumber,        
  Error_Procedure() as 'sp_CLS_FETC_Get',        
  Error_Severity() as ErrorSeverity,        
  Error_State() as ErrorState,        
  GETDATE () as DateErrorRaised         
      
END CATCH      
SET NOCOUNT OFF      
END 
GO
