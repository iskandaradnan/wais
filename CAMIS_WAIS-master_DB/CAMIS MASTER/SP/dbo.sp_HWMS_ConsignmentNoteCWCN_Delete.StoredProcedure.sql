USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_ConsignmentNoteCWCN_Delete]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_HWMS_ConsignmentNoteCWCN_Delete]
		@ConsignmentId INT		

AS
BEGIN
SET NOCOUNT ON; 

BEGIN TRY
		
		BEGIN
			DELETE HWMS_ConsignmentNoteCWCN_DWRNo WHERE ConsignmentId = @ConsignmentId 
			DELETE HWMS_ConsignmentNoteCWCN WHERE  ConsignmentId = @ConsignmentId 
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
		Error_Procedure() as 'sp_HWMS_ConsignmentNoteCWCN_Delete',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH 
END
GO
