USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_SparePartsAttachment_Save]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_SparePartsAttachment_Save
Description			: Insert/update the Attachment
Authors				: Dhilip V
Date				: 14-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

DECLARE @pFMDocument					[dbo].[udt_FMDocument]
INSERT INTO @pFMDocument ([DocumentId],[GuId],[CustomerId],[FacilityId],[DocumentNo],[DocumentTitle],[DocumentDescription],[DocumentCategory],[DocumentCategoryOthers],
[DocumentExtension],[MajorVersion],[MinorVersion],[FileType],[FilePath],[FileName],[UploadedDateUTC],[ScreenId],[Remarks],[UserId]) 
VALUES (0,NEWID(),1,1,'fILEnAME8','_04_May_2018 (2).xls','_04_May_2018 (2).xls',0,NULL,NULL,0,0,2,'add36ada-2c9f-494c-9914-b1e55fe1cacf_',
'fILENAME1.xls','2018-05-10 19:38:41.797',1,'i4',2)

EXEC [uspFM_SparePartsAttachment_Save] @pFMDocument=@pFMDocument,@pGuId=NULL,@pUserId=2

SELECT * FROM FMDocument

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_SparePartsAttachment_Save]
		@pFMDocument			[dbo].[udt_FMDocument]		 READONLY,
		@pGuId					NVARCHAR(500) = NULL,
        @pUserId			   	INT	=	NULL

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)	
	DECLARE @Table1 TABLE (ID INT)	
	DECLARE	@PrimaryKeyId	 INT,@pSparePartsId				INT





					--DELETE FMDocument WHERE DocumentGuId IN (SELECT DISTINCT DocumentGuId FROM @pFMDocument)

	SET	@pSparePartsId		=  (SELECT top 1 SparePartsId FROM EngSpareParts WHERE GuId IN (SELECT DISTINCT DocumentGuId FROM @pFMDocument))

					SELECT	IDENTITY(INT,1,1) AS ID,
							MajorVersion,
							@pSparePartsId	AS SparePartsId,
							DocumentId,
							FileType,
							[FileName],
							FilePath,
							GuId,
							DocumentGuId,
							CAST(NULL AS NVARCHAR(100)) AS Flag,
							Remarks
					INTO	#TempAssetDoc
					FROM @pFMDocument
					--WHERE ISNULL(DocumentId,0) =0

DECLARE @mDocumentGuId 	TABLE  (mGuId NVARCHAR(500),Documentid int )
	


	--IF((SELECT COUNT(*) FROM @pFMDocument WHERE DocumentId=0)>0)
		
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
								)	OUTPUT INSERTED.DocumentId INTO @Table1
							SELECT	DISTINCT GuId,
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
							--WHERE	GuId NOT IN (SELECT GuId FROM @mDocumentGuId)

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

--;WITH CTE 
--AS
--(SELECT DocumentId,GuId,ROW_NUMBER() OVER (PARTITION BY DocumentGuId,Remarks ORDER BY DocumentId DESC) RNK FROM FMDocument
--WHERE DocumentGuId IN (SELECT DISTINCT DocumentGuId FROM @pFMDocument)
--)
--INSERT INTO @mDocumentGuId (Documentid,mGuId)
--SELECT DocumentId,GuId FROM CTE WHERE DocumentId<>0 AND RNK>1;

							--DELETE FMDocument WHERE DocumentId IN (SELECT DISTINCT DocumentId FROM @mDocumentGuId WHERE DocumentId<>0)

					SELECT	MajorVersion,
							@pSparePartsId	AS SparePartsId,
							DocumentId,
							FileType,
							[FileName],
							FilePath,
							GuId,
							DocumentGuId
					INTO	#TempAssetDocInsert
					FROM FMDocument where DocumentId in (SELECT ID FROM @Table1)

					SELECT DocumentId,
						 [Timestamp],
						'' AS	ErrorMessage 
					FROM FMDocument where DocumentId in (SELECT ID FROM @Table1)
				

				UPDATE A SET A.DocumentId	=	B.DocumentId,
								A.Flag = 'U'
				FROM	#TempAssetDoc A 
						INNER JOIN #TempAssetDocInsert B ON A.GuId	=	B.GuId

				UPDATE EngSpareParts SET VideoDocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='v7'  AND Flag = 'U' )  WHERE SparePartsId = @pSparePartsId
				UPDATE EngSpareParts SET Image1DocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i1'  AND Flag = 'U' )  WHERE SparePartsId = @pSparePartsId
				UPDATE EngSpareParts SET Image2DocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i2'  AND Flag = 'U' )  WHERE SparePartsId = @pSparePartsId
				UPDATE EngSpareParts SET Image3DocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i3'  AND Flag = 'U' )  WHERE SparePartsId = @pSparePartsId
				UPDATE EngSpareParts SET Image4DocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i4'  AND Flag = 'U' )  WHERE SparePartsId = @pSparePartsId
				UPDATE EngSpareParts SET Image5DocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i5'  AND Flag = 'U' )  WHERE SparePartsId = @pSparePartsId
				UPDATE EngSpareParts SET Image6DocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i6'  AND Flag = 'U' )  WHERE SparePartsId = @pSparePartsId

				SELECT	SparePartsId,
						[Timestamp],
						'' AS	ErrorMessage 
				FROM	EngSpareParts
				WHERE	SparePartsId IN (SELECT DISTINCT SparePartsId FROM #TempAssetDoc)

	/*

	ELSE 


-------------------------------------------------------------------- UPDATE STATEMENT ----------------------------------------------------

------1.EngAsset

			

		BEGIN
		 
		 	
			    UPDATE Document SET										
											
									Document.[DocumentNo]						= DocumentType.[DocumentNo],		
									Document.[DocumentTitle]					= DocumentType.[DocumentTitle],
									Document.[DocumentDescription]				= DocumentType.[DocumentDescription],	
									Document.[DocumentCategory]					= DocumentType.[DocumentCategory],		
									Document.[DocumentCategoryOthers]			= DocumentType.[DocumentCategoryOthers],
									Document.[DocumentExtension]				= DocumentType.[DocumentExtension],		
									Document.[MajorVersion]						= DocumentType.[MajorVersion],			
									Document.[MinorVersion]						= DocumentType.[MinorVersion],			
									Document.[FileType]							= DocumentType.[FileType],				
									Document.[FilePath]							= DocumentType.[FilePath],				
									Document.[FileName]							= DocumentType.[FileName],				
									Document.[UploadedDateUTC]					= DocumentType.[UploadedDateUTC],		
									Document.[ScreenId]							= DocumentType.[ScreenId],				
									Document.[Remarks]							= DocumentType.[Remarks],				
									Document.ModifiedBy							= @pUserId,			
									Document.ModifiedDate						= GETDATE(),		
									Document.ModifiedDateUTC					= GETUTCDATE()	,
									Document.DocumentGuId = DocumentType.DocumentGuId
									OUTPUT INSERTED.DocumentId INTO @Table
					FROM	FMDocument AS Document 
							INNER JOIN @pFMDocument AS DocumentType ON Document.DocumentId	=	DocumentType.DocumentId
					WHERE ISNULL(DocumentType.DocumentId,0)>0

					SELECT	MajorVersion,
							@pSparePartsId	AS AssetId,
							DocumentId,
							FileType,
							[FileName],
							FilePath,
							GuId,
							DocumentGuId
					INTO	#TempAssetDocUp
					FROM FMDocument where DocumentId in (SELECT ID FROM @Table)

					SELECT DocumentId,
						 [Timestamp],
						'' AS	ErrorMessage 
					FROM FMDocument where DocumentId in (SELECT ID FROM @Table1)

				UPDATE A SET A.DocumentId	=	B.DocumentId,
								A.Flag = 'U'
				FROM	#TempAssetDoc A 
						INNER JOIN #TempAssetDocUP B ON A.GuId	=	B.GuId

				UPDATE EngSpareParts SET VideoDocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='v7'  AND Flag = 'U' )  WHERE SparePartsId = @pSparePartsId
				UPDATE EngSpareParts SET Image1DocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i1'  AND Flag = 'U' )  WHERE SparePartsId = @pSparePartsId
				UPDATE EngSpareParts SET Image2DocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i2'  AND Flag = 'U' )  WHERE SparePartsId = @pSparePartsId
				UPDATE EngSpareParts SET Image3DocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i3'  AND Flag = 'U' )  WHERE SparePartsId = @pSparePartsId
				UPDATE EngSpareParts SET Image4DocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i4'  AND Flag = 'U' )  WHERE SparePartsId = @pSparePartsId
				UPDATE EngSpareParts SET Image5DocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i5'  AND Flag = 'U' )  WHERE SparePartsId = @pSparePartsId
				UPDATE EngSpareParts SET Image6DocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i6'  AND Flag = 'U' )  WHERE SparePartsId = @pSparePartsId

				
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
								)	OUTPUT INSERTED.DocumentId INTO @Table1
								SELECT	udtDoc.GuId,
										udtDoc.CustomerId,
										udtDoc.FacilityId,
										udtDoc.DocumentNo,
										udtDoc.DocumentTitle,
										udtDoc.DocumentDescription,
										udtDoc.DocumentCategory,
										udtDoc.DocumentCategoryOthers,
										udtDoc.DocumentExtension,
										udtDoc.MajorVersion,
										udtDoc.MinorVersion,
										udtDoc.FileType,
										udtDoc.FileName,
										udtDoc.FilePath,
										udtDoc.ScreenId,
										udtDoc.Remarks,
										udtDoc.UserId,
										GETDATE(),
										GETUTCDATE(),
										udtDoc.UserId,
										GETDATE(),
										GETUTCDATE(),
										udtDoc.DocumentGuId
								FROM	@pFMDocument	udtDoc INNER JOIN FMDocument AS Doc ON udtDoc.DocumentGuId	=	Doc.DocumentGuId
								WHERE	ISNULL(udtDoc.DocumentId,0)=0

				
					SELECT	MajorVersion,
							@pSparePartsId	AS AssetId,
							DocumentId,
							FileType,
							[FileName],
							FilePath,
							GuId,
							DocumentGuId
					INTO	#TempAssetDocUp1
					FROM FMDocument where DocumentId in (SELECT ID FROM @Table)


				UPDATE A SET A.DocumentId	=	B.DocumentId,
								A.Flag = 'U'
				FROM	#TempAssetDoc A 
						INNER JOIN #TempAssetDocUP1 B ON A.GuId	=	B.GuId

				UPDATE EngSpareParts SET VideoDocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='v7'  AND Flag = 'U' )  WHERE SparePartsId = @pSparePartsId
				UPDATE EngSpareParts SET Image1DocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i1'  AND Flag = 'U' )  WHERE SparePartsId = @pSparePartsId
				UPDATE EngSpareParts SET Image2DocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i2'  AND Flag = 'U' )  WHERE SparePartsId = @pSparePartsId
				UPDATE EngSpareParts SET Image3DocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i3'  AND Flag = 'U' )  WHERE SparePartsId = @pSparePartsId
				UPDATE EngSpareParts SET Image4DocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i4'  AND Flag = 'U' )  WHERE SparePartsId = @pSparePartsId
				UPDATE EngSpareParts SET Image5DocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i5'  AND Flag = 'U' )  WHERE SparePartsId = @pSparePartsId
				UPDATE EngSpareParts SET Image6DocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i6'  AND Flag = 'U' )  WHERE SparePartsId = @pSparePartsId



				SELECT	AssetId,
						[Timestamp],
						'' AS	ErrorMessage 
				FROM	EngAsset
				WHERE	AssetId IN (SELECT DISTINCT AssetId FROM #TempAssetDoc)

		END


END
*/

	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT
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
		   );
THROW;
END CATCH
GO
