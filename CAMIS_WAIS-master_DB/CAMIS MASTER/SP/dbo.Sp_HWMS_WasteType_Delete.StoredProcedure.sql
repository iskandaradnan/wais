USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_WasteType_Delete]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[Sp_HWMS_WasteType_Delete]
		@WasteId INT		

AS
BEGIN
SET NOCOUNT ON; 

BEGIN TRY
		--IF(@ChemicalInUseId = 0)
		BEGIN
			DELETE HWMS_WasteType_WasteCode WHERE WasteId = @WasteId
			--DELETE CLS_ChemicalInUse WHERE  ChemicalId = @ChemicalInUseId 
		END
		
		

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
		Error_Procedure() as 'Sp_HWMS_WasteType_Delete',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH 
END
GO
