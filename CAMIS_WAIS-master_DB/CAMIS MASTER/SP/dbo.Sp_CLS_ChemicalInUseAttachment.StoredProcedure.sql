USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_ChemicalInUseAttachment]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- select * from CLS_ChemicalInUseAttachment
CREATE PROC [dbo].[Sp_CLS_ChemicalInUseAttachment]
		@AttachmentId NVARCHAR(6),
		@ChemicalId int,
		@FileType nvarchar(500),
		@FileName nvarchar(500),
		@AttachmentName nvarchar(500) = NULL,
		@FilePath  nvarchar(500),
		@IsDeleted bit

AS
BEGIN
SET NOCOUNT ON; 
BEGIN TRY
		IF(EXISTS(SELECT 1 FROM CLS_ChemicalInUseAttachment WHERE AttachmentId = @AttachmentId AND ChemicalInUseId = @ChemicalId ))
		BEGIN
			UPDATE CLS_ChemicalInUseAttachment SET FileType = @FileType, [FileName] = @FileName, 
			AttachmentName = isNull(@AttachmentName, AttachmentName), FilePath = @FilePath, [isDeleted] = CAST(@IsDeleted AS INT) 
			WHERE AttachmentId = @AttachmentId AND ChemicalInUseId = @ChemicalId
		END	
		ELSE
		BEGIN
			 INSERT INTO CLS_ChemicalInUseAttachment VALUES ( @ChemicalId, @FileType, @FileName,
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
		Error_Procedure() as 'Sp_CLS_ChemicalInUseAttachment',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH 
END
GO
