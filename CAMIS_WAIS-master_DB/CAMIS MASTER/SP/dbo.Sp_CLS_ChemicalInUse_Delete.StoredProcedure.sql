USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_ChemicalInUse_Delete]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- select * from CLS_ChemicalInUseAttachment
CREATE PROC [dbo].[Sp_CLS_ChemicalInUse_Delete]
		@ChemicalInUseId INT		

AS
BEGIN
SET NOCOUNT ON; 

BEGIN TRY
		--IF(@ChemicalInUseId = 0)
		BEGIN
			DELETE CLS_ChemicalInUseChemicals WHERE ChemicalInUseId = @ChemicalInUseId 
			DELETE CLS_ChemicalInUse WHERE  ChemicalId = @ChemicalInUseId 
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
		Error_Procedure() as 'Sp_CLS_ChemicalInUse_Delete',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH 
END
GO
