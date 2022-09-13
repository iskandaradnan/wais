USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_ChemicalName]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_CLS_ChemicalName]
AS
BEGIN
SET NOCOUNT ON; 
BEGIN TRY
		SELECT ChemicalName FROM CLS_ApprovedChemicalList
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
		Error_Procedure() as 'Sp_CLS_ChemicalName',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH 
END
GO
