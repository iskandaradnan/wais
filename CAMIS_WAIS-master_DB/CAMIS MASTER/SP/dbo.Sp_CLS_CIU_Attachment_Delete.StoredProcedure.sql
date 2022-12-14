USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_CIU_Attachment_Delete]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- select * from CLS_ChemicalInUseAttachment
CREATE PROC [dbo].[Sp_CLS_CIU_Attachment_Delete]
		@AttachmentId INT		

AS
BEGIN
SET NOCOUNT ON; 

BEGIN TRY
		IF(@AttachmentId = 0)
		BEGIN
			DELETE CLS_ChemicalInUseAttachment WHERE AttachmentId = @AttachmentId 
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
		Error_Procedure() as 'Sp_CLS_CIU_Attachment_Delete',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH 
END
GO
