USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_CorrectiveActionReport_Get]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Sp_CLS_CorrectiveActionReport_Get]

 @CARId INT
 	
AS 
BEGIN
SET NOCOUNT ON
BEGIN TRY
	BEGIN	
	SELECT * FROM CLS_CorrectiveActionReport WHERE  CARId =  @CARId
	SELECT * FROM CLS_CARActivityTxn WHERE  CARId = @CARId AND [isDeleted] = 0
	SELECT * FROM [CLS_CARAttachments] WHERE  CARId = @CARId AND [isDeleted] = 0	
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
		Error_Procedure() as 'Sp_CLS_CorrectiveActionReport_Get',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH
END
GO
