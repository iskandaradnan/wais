USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_ChemicalInUseTable]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CLS_ChemicalInUseTable](

		@Category nvarchar(50),
		@AreaOfApplication nvarchar(50),
		@ChemicalName nvarchar(50),
		@KMMNo nvarchar(50),
		@Properties nvarchar(50),
		@Status INT,
		@EffectiveDate DATE,
		@ChemicalId INT
		)
AS
BEGIN
SET NOCOUNT ON; 
		BEGIN TRY
		--IF(@ChemicalId = 0)
		BEGIN
		INSERT INTO CLS_ChemicalInUseTable VALUES(@Category,@AreaOfApplication,@ChemicalName,@KMMNo,@Properties,@Status,@EffectiveDate,@ChemicalId)
		END
		--ELSE
		--BEGIN
		----UPDATE
		--UPDATE CLS_ChemicalInUseTable SET Category = @Category, AreaOfApplication = @AreaOfApplication,ChemicalName=@ChemicalName
	 --   WHERE ChemicalId=@ChemicalId
		--END
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
		Error_Procedure() as 'SP_CLS_ChemicalInUseTable',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH 
end
GO
