USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_Consignment_TreatmentPlantData]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  proc [dbo].[sp_HWMS_Consignment_TreatmentPlantData]      
  (@TreatmentPlantId nvarchar(50))      
AS      
BEGIN      
SET NOCOUNT ON;       
BEGIN TRY      
  SELECT B.FieldValue AS Ownership FROM HWMS_TreatementPlant A      
  LEFT JOIN FMLovMst B ON A.Ownership = B.LovId      
  WHERE TreatmentPlantId = @TreatmentPlantId      
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
  Error_Procedure() as 'sp_HWMS_Consignment_TreatmentPlantData',        
  Error_Severity() as ErrorSeverity,        
  Error_State() as ErrorState,        
  GETDATE () as DateErrorRaised         
END CATCH       
END
GO
