USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_ChemicalNameData]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_CLS_ChemicalNameData]
		(@ChemicalId nvarchar(max))
AS
BEGIN
SET NOCOUNT ON; 
BEGIN TRY
		SELECT KKMNumber,Properties,Status,EffectiveFromDate FROM CLS_ApprovedChemicalList WHERE ChemicalId = @ChemicalId

		
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
		Error_Procedure() as 'Sp_CLS_ChemicalNameData',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH 
END
GO
