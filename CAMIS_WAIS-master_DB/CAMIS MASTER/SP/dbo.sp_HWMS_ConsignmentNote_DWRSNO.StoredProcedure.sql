USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_ConsignmentNote_DWRSNO]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_HWMS_ConsignmentNote_DWRSNO]  
AS  
BEGIN  
SET NOCOUNT ON;   
BEGIN TRY  
  SELECT  DWRId, DWRNo FROM HWMS_DailyWeighingRecord  where ConsignmentNo is null

   

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
  Error_Procedure() as 'sp_HWMS_ConsignmentNote_DWRSNO',    
  Error_Severity() as ErrorSeverity,    
  Error_State() as ErrorState,    
  GETDATE () as DateErrorRaised     
END CATCH   
END
GO
