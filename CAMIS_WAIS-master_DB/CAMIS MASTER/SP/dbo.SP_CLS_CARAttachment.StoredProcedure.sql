USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_CARAttachment]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_CLS_CARAttachment]

    @AttachmentId nvarchar(20),	
	@CARId int,
	@FileType nvarchar(500),
	@FileName nvarchar(500),
	@AttachmentName nvarchar(500) = NULL,
	@FilePath  nvarchar(500),
	@IsDeleted bit


AS
BEGIN
SET NOCOUNT ON; 

BEGIN TRY
		IF(EXISTS(SELECT 1 FROM CLS_CARAttachments WHERE AttachmentId = @AttachmentId AND [CARId] = @CARId ))
		BEGIN
			UPDATE CLS_CARAttachments SET FileType = @FileType, [FileName] = @FileName, 
			AttachmentName = isNull(@AttachmentName, AttachmentName), FilePath = @FilePath, [isDeleted] = CAST(@IsDeleted AS INT) 
			WHERE AttachmentId = @AttachmentId AND [CARId] = @CARId
		END	
		ELSE
		BEGIN
			 INSERT INTO CLS_CARAttachments
			 (  [CARId], [FileType], [FileName], [AttachmentName], [FilePath], [isDeleted] ) 
			  VALUES ( @CARId, @FileType, @FileName,
			 @AttachmentName, @FilePath , CAST(@IsDeleted AS INT)) 
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
	Error_Procedure() as 'SP_CLS_CARAttachment',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  

END CATCH
end
GO
