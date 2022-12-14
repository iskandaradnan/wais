USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_Consignment_DWRSNOData]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_HWMS_Consignment_DWRSNOData]    
  @DWRId INT    
AS    
BEGIN    
SET NOCOUNT ON;     
BEGIN TRY    
           
  SELECT SUBSTRING( BinNos, 0 , LEN(BinNos)) AS BinNo, Weight FROM     
    (  SELECT  ( SELECT  CAST( BinNo AS VARCHAR ) + ', '  FROM HWMS_DailyWeighingRecordBinNo_Save  where DWRId = @DWRId and isDeleted = 0 FOR XML PATH('') )  AS BinNos,  Sum(Weight) AS  Weight from HWMS_DailyWeighingRecordBinNo_Save where DWRId = @DWRId and isDeleted = 0) A    
    
     
    
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
  Error_Procedure() as 'sp_HWMS_Consignment_DWRSNOData',      
  Error_Severity() as ErrorSeverity,      
  Error_State() as ErrorState,      
  GETDATE () as DateErrorRaised       
END CATCH     
END    
    
  
GO
