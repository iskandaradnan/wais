USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_TreatmetPlant_Get]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Sp_HWMS_TreatmetPlant_Get]
(
	@Id INT
)
	
AS 
BEGIN
SET NOCOUNT ON
BEGIN TRY	
		SELECT * FROM HWMS_TreatementPlant WHERE  TreatmentPlantId =  @Id						
		SELECT * FROM HWMS_TreatementPlant_DisposalType WHERE  TreatmentPlantId = @Id AND [isDeleted]=0	
		SELECT * FROM HWMS_TreatementPlant_LicenseDetail WHERE  TreatmentPlantId = @Id	AND [isDeleted]=0	
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
		Error_Procedure() as 'Sp_HWMS_TreatmetPlant_Get',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH
END




GO
