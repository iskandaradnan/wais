USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_ConsignmentNoteOSWCN_Delete]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[sp_HWMS_ConsignmentNoteOSWCN_Delete]
		@ConsignOSWCNId INT		

AS
BEGIN
SET NOCOUNT ON; 

BEGIN TRY
		
		BEGIN
			DELETE HWMS_ConsignmentNoteOSWCNTable WHERE ConsignOSWCNId = @ConsignOSWCNId 
			--DELETE HWMS_ConsignmentNoteOSWCN WHERE  ConsignOSWCNId = @ConsignOSWCNId 
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
		Error_Procedure() as 'sp_HWMS_ConsignmentNoteOSWCN_Delete',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH 
END
GO
