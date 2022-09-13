USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Attachment_GetById]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_Attachment_GetById
Description			: Attachment Get
Authors				: Dhilip V
Date				: 28-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_Attachment_GetById] @pDocumentGuId='d8fa1e22-8d3b-445a-8d86-376bf153fc61'

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_Attachment_GetById]                           

	
	@pDocumentGuId	NVARCHAR(500)

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


    SELECT	FMDoc.DocumentId				AS DocumentId,
			FMDoc.FilePath					AS FilePath,
			FMDoc.FileName					AS [FileName],
			FMDoc.DocumentTitle				AS DocumentTitle,
			FMDoc.DocumentNo				AS DocumentNo,
			FMDoc.FileType					AS FileType,
			FileType.FileType				AS FileTypeValue,
			FMDoc.DocumentExtension 		AS DocumentExtension,
			FMDoc.DocumentDescription		AS DocumentDescription, 
			FMDoc.MajorVersion				AS MajorVersion, 
			FMDoc.MinorVersion				AS MinorVersion, 
			FMDoc.GuId                      AS [GuId],
			DocumentGuId
 	FROM	FMDocument			AS	FMDoc			WITH(NOLOCK)
			LEFT JOIN	FMDocumentFileType	AS	FileType		WITH(NOLOCK)	ON FMDoc.FileType			=	FileType.FileTypeId
	WHERE	FMDoc.DocumentGuId = @pDocumentGuId
			AND FMDoc.Remarks IS NULL

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
