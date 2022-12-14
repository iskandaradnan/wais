USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_JiDetails_Attachment]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- select * from CLS_JIDetails_Attachment
CREATE procedure [dbo].[Sp_CLS_JiDetails_Attachment](
        @AttachmentId NVARCHAR(6),
		@DetailsId int,
		@FileType nvarchar(500),
		@FileName nvarchar(500),
		@AttachmentName nvarchar(500) = NULL,
		@FilePath  nvarchar(500),
		@IsDeleted bit
)
AS
BEGIN
SET NOCOUNT ON; 
BEGIN TRY
	
	
		IF(EXISTS(SELECT 1 FROM CLS_JIDetails_Attachment WHERE AttachmentId = @AttachmentId))
		BEGIN
			UPDATE CLS_JIDetails_Attachment SET FileType = @FileType, [FileName] = @FileName, 
			AttachmentName = ISNULL(@AttachmentName, AttachmentName), FilePath = @FilePath, [isDeleted] = CAST(@IsDeleted AS INT) 
			WHERE AttachmentId = @AttachmentId
		END	
		ELSE
		BEGIN
			 INSERT INTO CLS_JIDetails_Attachment(DetailsId,FileType,FileName,AttachmentName,FilePath,isDeleted) VALUES (@DetailsId, @FileType, @FileName,@AttachmentName, @FilePath , CAST(@IsDeleted AS INT)) 
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
		Error_Procedure() as 'Sp_CLS_JiDetails_Attachment',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH 
END
GO
