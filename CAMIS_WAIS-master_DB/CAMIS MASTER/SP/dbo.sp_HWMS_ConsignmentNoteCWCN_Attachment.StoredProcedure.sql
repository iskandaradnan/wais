USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_ConsignmentNoteCWCN_Attachment]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_HWMS_ConsignmentNoteCWCN_Attachment](
	
		@AttachmentId int,
		@ConsignmentId int,
		@FileType nvarchar(500),
		@FileName nvarchar(500),
		@AttachmentName nvarchar(500) =Null,
		@FilePath  nvarchar(500),
		@IsDeleted bit)
AS
BEGIN
SET NOCOUNT ON; 
BEGIN TRY
      IF(EXISTS(SELECT 1 FROM HWMS_ConsignmentNoteCWCN_Attachment WHERE AttachmentId = @AttachmentId AND ConsignmentId = @ConsignmentId ))
	  BEGIN
			UPDATE HWMS_ConsignmentNoteCWCN_Attachment SET [FileType] = @FileType, [FileName] = @FileName, 
			AttachmentName = isNull(@AttachmentName, AttachmentName), FilePath = @FilePath, [isDeleted] = CAST(@IsDeleted AS INT) 
			WHERE AttachmentId = @AttachmentId AND [ConsignmentId] = @ConsignmentId
		END	
		ELSE
		BEGIN
			 INSERT INTO HWMS_ConsignmentNoteCWCN_Attachment (ConsignmentId,FileType,FileName,AttachmentName,FilePath,IsDeleted) 
			 VALUES ( @ConsignmentId, @FileType, @FileName, @AttachmentName, @FilePath , CAST(@IsDeleted AS INT)) 
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
		Error_Procedure() as 'sp_HWMS_ConsignmentNoteCWCN_Attachment',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH 
END
GO
