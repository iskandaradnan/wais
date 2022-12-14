USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_CWRecordSheet_Get]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--- exec [dbo].[ChemicalInUse_Get] 35  
CREATE PROC [dbo].[Sp_HWMS_CWRecordSheet_Get]  
  
@Id INT  
   
AS   
BEGIN  
SET NOCOUNT ON  
BEGIN TRY   
 SELECT * FROM HWMS_CWRecordSheet_Save WHERE  CWRecordSheetId =  @Id    
 SELECT * FROM HWMS_CWRS_CollectionDetails_Save WHERE  CWRecordSheetId = @Id AND [isDeleted]=0  
 SELECT * FROM HWMS_CWRecordSheet_Attachment WHERE  CWRecordSheetId = @Id AND [isDeleted]=0  


      
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
  Error_Procedure() as 'Sp_HWMS_CWRecordSheet_Get',    
  Error_Severity() as ErrorSeverity,    
  Error_State() as ErrorState,    
  GETDATE () as DateErrorRaised     
END CATCH  
END
GO
