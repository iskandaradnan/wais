USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_FMDocument_GetById]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_FMDocument_GetById
Description			: Get the attachment details by passing the DocumentId.
Authors				: Dhilip V
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_FMDocument_GetById  @pDocumentId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_FMDocument_GetById]                           
  @pDocumentId		INT
AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


-- Default Values


-- Execution


	IF(ISNULL(@pDocumentId,0) = 0) RETURN

    SELECT	Document.CustomerId,
			Document.FacilityId,
			Document.DocumentId,
			Document.GuId,
			Document.DocumentNo,
			Document.DocumentDescription,
			Document.DocumentCategory,
			DocumentCategoryOthers,
			DocumentExtension,
			MajorVersion,
			MinorVersion,
			Document.FilePath,
			Document.FileName,
			Document.FileType,
			FileType.FileType AS FileTypeName,
			ScreenId,
			Document.Remarks,
			UploadedBy,
			UMUser.StaffName	as UploadedByName,
			UploadedDate,
			Document.ModifiedBy,
			ModifiedBy.StaffName	as ModifiedByName,
			Document.[Timestamp]               AS [Timestamp]
 	FROM	FMDocument								AS	Document		WITH(NOLOCK)	
			LEFT JOIN  FMDocumentFileType			AS	FileType		WITH(NOLOCK)	ON Document.FileType				=	FileType.FileTypeId
			LEFT JOIN  UMUserRegistration			AS	UMUser			WITH(NOLOCK)	ON Document.UploadedBy				=	UMUser.UserRegistrationId
			LEFT JOIN  UMUserRegistration			AS	ModifiedBy		WITH(NOLOCK)	ON Document.UploadedBy			=	ModifiedBy.UserRegistrationId
	WHERE	Document.DocumentId = @pDocumentId 

END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
