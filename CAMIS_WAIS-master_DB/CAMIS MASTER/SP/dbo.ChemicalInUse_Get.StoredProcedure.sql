USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[ChemicalInUse_Get]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--- exec [dbo].[ChemicalInUse_Get] 35
CREATE PROC [dbo].[ChemicalInUse_Get]
(
	@Id INT
)
	
AS 
BEGIN
SET NOCOUNT ON
BEGIN TRY
	
	--SELECT ChemicalTableId, Category, AreaofApplication, ChemicalName, KMMNo,Properties, Status ,EffectiveDate FROM CLS_ChemicalInUseTable WHERE ChemicalTableId = @Id
		SELECT * FROM CLS_ChemicalInUse where  ChemicalId =  @Id

		select * from CLS_ChemicalInUseTable where  ChemicalId = @Id
		
		--SELECT DocumentNo,Remarks,Date,  Category, AreaofApplication, ChemicalName, KMMNo,Properties, Status ,EffectiveDate
		--FROM 
		--CLS_ChemicalInUse 
		--INNER JOIN  CLS_ChemicalInUseTable ON  CLS_ChemicalInUse.ChemicalId = CLS_ChemicalInUseTable.ChemicalId Where CLS_ChemicalInUseTable.ChemicalId=@Id
	
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
		Error_Procedure() as 'ChemicalInUse_Get',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH
END
GO
