USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_FMDocument_Save]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_MstStaff_Save
Description			: If staff already exists then update else insert.
Authors				: Dhilip V
Date				: 02-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_FMDocument_Save @pDocumentId=1,@pCustomerId=1,@pFacilityId=1,@pGuId='21B4CF39-E9AC-4B36-8E36-12003096024F',@pDocumentNo='DOC101',@pDocumentTitle='Test1',@pDocumentDescription='DocumentUpload',
@pDocumentCategory=1,@pDocumentCategoryOthers=NULL,@pDocumentExtension='pdf',@pMajorVersion=1,@pMinorVersion=NULL,@pFileType=1,@pFileName='Test',@pScreenId=1,@pUploadedBy=1,@pModifiedBy=1


EXEC uspFM_FMDocument_Save @pDocumentId=1,@pCustomerId=1,@pFacilityId=1,@pDocumentNo='DOC101',@pDocumentTitle='Test1',@pDocumentDescription='DocumentUpload',
@pDocumentCategory=1,@pDocumentCategoryOthers=NULL,@pDocumentExtension='pdf',@pMajorVersion=1,@pMinorVersion=NULL,@pFileType=1,@pFileName='Test',@pScreenId=1,@pUploadedBy=1,@pModifiedBy=1

DECLARE @pFMDocument	AS	[dbo].[udt_FMDocument] 
INSERT INTO @pFMDocument (DocumentId,GuId,CustomerId,FileName) VALUES (1,'21B4CF39-E9AC-4B36-8E36-12003096024F',1, 'Mark')  

EXECUTE [uspFM_FMDocument_Save] @pFMDocument   
select * from fmdocument
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_FMDocument_Save]
	@pFMDocument	[dbo].[udt_FMDocument] READONLY,
	@pDocumentId	INT	=	NULL
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)

-- Default Values


-- Execution

   

	--IF EXISTS (SELECT 1 FROM FMDocument WITH(NOLOCK) WHERE DocumentId=(SELECT DocumentId FROM @pFMDocument ))
	--	BEGIN

			UPDATE Doc SET	Doc.[GuId]					=	udtDoc.[GuId],				
							Doc.CustomerId				=	udtDoc.CustomerId,
							Doc.FacilityId				=	udtDoc.FacilityId,				
							Doc.DocumentNo				=	udtDoc.DocumentNo,				
							Doc.DocumentTitle			=	udtDoc.DocumentTitle,
							Doc.DocumentDescription		=	udtDoc.DocumentDescription,
							Doc.DocumentCategory		=	udtDoc.DocumentCategory,
							Doc.DocumentCategoryOthers	=	udtDoc.DocumentCategoryOthers,
							Doc.DocumentExtension		=	udtDoc.DocumentExtension,
							Doc.MajorVersion			=	udtDoc.MajorVersion,			
							Doc.MinorVersion			=	udtDoc.MinorVersion	,		
							Doc.FileType				=	udtDoc.FileType,				
							Doc.FileName				=	udtDoc.FileName,				
							Doc.FilePath				=	udtDoc.FilePath,				
							Doc.ScreenId				=	udtDoc.ScreenId,				
							Doc.Remarks					=	udtDoc.Remarks,					
							Doc.ModifiedBy				=	udtDoc.UserId,				
							Doc.ModifiedDate			=	GETDATE(),			
							Doc.ModifiedDateUTC			=	GETUTCDATE()	,
							Doc.DocumentGuId	=		udtDoc.DocumentGuId
							OUTPUT INSERTED.DocumentId INTO @Table		
					FROM	FMDocument	AS	Doc WITH(NOLOCK)
							INNER JOIN	@pFMDocument	AS	udtDoc	ON	Doc.DocumentId	=	udtDoc.DocumentId
					WHERE	ISNULL(udtDoc.DocumentId,0)>0

			SELECT	DocumentId, 
					[Timestamp] 
			FROM	FMDocument WITH(NOLOCK)
			WHERE	DocumentId	IN	(SELECT ID FROM @Table)

	--	END

	--ELSE

	--	BEGIN

			INSERT INTO FMDocument(	GuId,
									CustomerId,
									FacilityId,
									DocumentNo,
									DocumentTitle,
									DocumentDescription,
									DocumentCategory,
									DocumentCategoryOthers,
									DocumentExtension,
									MajorVersion,
									MinorVersion,
									FileType,
									FileName,
									FilePath,
									ScreenId,
									Remarks,
									UploadedBy,
									UploadedDate,
									UploadedDateUTC,
									ModifiedBy,
									ModifiedDate,
									ModifiedDateUTC,
									DocumentGuId
								)	OUTPUT INSERTED.DocumentId INTO @Table
								SELECT	GuId,
										CustomerId,
										FacilityId,
										DocumentNo,
										DocumentTitle,
										DocumentDescription,
										DocumentCategory,
										DocumentCategoryOthers,
										DocumentExtension,
										MajorVersion,
										MinorVersion,
										FileType,
										FileName,
										FilePath,
										ScreenId,
										Remarks,
										UserId,
										GETDATE(),
										GETUTCDATE(),
										UserId,
										GETDATE(),
										GETUTCDATE(),
										DocumentGuId
								FROM	@pFMDocument	udtDoc
								WHERE	ISNULL(udtDoc.DocumentId,0)=0
		--END

		SELECT	DocumentId, 
				[Timestamp] 
		FROM	FMDocument WITH(NOLOCK)
		WHERE	DocumentId IN (SELECT ID FROM @Table)

	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT TRANSACTION
        END   


END TRY

BEGIN CATCH

	IF @mTRANSCOUNT = 0
        BEGIN
            ROLLBACK TRAN
        END

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
