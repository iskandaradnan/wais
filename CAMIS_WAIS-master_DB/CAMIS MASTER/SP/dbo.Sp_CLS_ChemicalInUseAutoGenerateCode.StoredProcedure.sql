USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_ChemicalInUseAutoGenerateCode]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Sp_CLS_ChemicalInUseAutoGenerateCode]
AS
BEGIN
SET NOCOUNT ON; 
BEGIN TRY


DECLARE @RecordNumber VARCHAR(50) 
SET @RecordNumber = '000001'


SELECT TOP 1 @RecordNumber = DocumentNo FROM CLS_ChemicalInUse order by ChemicalId desc

SELECT  'WAC/CIU/' + convert(varchar(7), getdate() , 111) + '/' + REPLICATE('0', 6-LEN(convert(int, SUBSTRING(@RecordNumber, 20, 30))))
		+ CONVERT(varchar, convert(int, SUBSTRING(@RecordNumber, 20, 30) + 1)) as DocumentNo  


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
		Error_Procedure() as 'Sp_CLS_ChemicalInUseAutoGenerateCode',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  
		END CATCH 
END
GO
