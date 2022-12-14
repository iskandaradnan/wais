USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_CSWRecordSheet_WasteType]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[Sp_HWMS_CSWRecordSheet_WasteType]  
(  
 @WasteType nvarchar(50)  
 )  
AS    
BEGIN  
SET NOCOUNT ON;   
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
BEGIN TRY  
  
  
 SELECT WasteCode 
 FROM HWMS_WasteType_WasteCode  WC
 INNER JOIN HWMS_WasteType  WT ON WC.WasteTypeId = WT.WasteTypeId 
 where WT.WasteType=@WasteType  
  
  
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
  Error_Procedure() as 'Sp_HWMS_CSWRecordSheet_WasteType',    
  Error_Severity() as ErrorSeverity,    
  Error_State() as ErrorState,    
  GETDATE () as DateErrorRaised     
  
END CATCH  
SET NOCOUNT OFF  
END
GO
