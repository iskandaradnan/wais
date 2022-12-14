USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Attachment_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_Attachment_Save
Description			: Insert/update the Attachment
Authors				: Dhilip V
Date				: 28-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

DECLARE @pFMDocument					[dbo].[udt_FMDocument]
INSERT INTO @pFMDocument ([DocumentId],[GuId],[CustomerId],[FacilityId],[DocumentNo],[DocumentTitle],[DocumentDescription],[DocumentCategory],[DocumentCategoryOthers],
[DocumentExtension],[MajorVersion],[MinorVersion],[FileType],[FilePath],[FileName],[UploadedDateUTC],[ScreenId],[Remarks],[UserId]) 
VALUES (0,NEWID(),1,1,'fILEnAME8','_04_May_2018 (2).xls','_04_May_2018 (2).xls',0,NULL,NULL,0,0,2,'add36ada-2c9f-494c-9914-b1e55fe1cacf_',
'fILENAME1.xls','2018-05-10 19:38:41.797',1,null,2),
(0,NEWID(),1,1,'fILEnAME8','_04_May_2018 (2).xls','_04_May_2018 (2).xls',0,NULL,NULL,0,0,2,'add36ada-2c9f-494c-9914-b1e55fe1cacf_',
'fILENAME1.xls','2018-05-10 19:38:41.797',1,null,2)
SELECT COUNT(*) FROM  @pFMDocument GROUP BY LTRIM(RTRIM(FileName)) HAVING COUNT(FileName)>1
select * from @pFMDocument


EXEC [uspFM_Attachment_Save] @pFMDocument=@pFMDocument,@pGuId=NULL,@pUserId=2

SELECT * FROM FMDocument

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_Attachment_Save]
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
	DECLARE	@PrimaryKeyId	 INT,@pAssetId				INT




--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------




IF((SELECT COUNT(*) FROM @pFMDocument WHERE Remarks IS NULL)>0)

begin



	IF EXISTS ((SELECT 1 FROM  @pFMDocument GROUP BY LTRIM(RTRIM(ISNULL(DocumentTitle,''))) HAVING COUNT(*)>1))
	BEGIN
					SELECT	0	DocumentId,
					CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS [Timestamp],
					'File Name should be unique' AS	ErrorMessage 
	END

	ELSE IF EXISTS (	SELECT 1 
						FROM FMDocument WITH(NOLOCK) 
						WHERE	FileName IN	(SELECT DocumentTitle FROM  @pFMDocument WHERE DocumentId=0)
						AND	DocumentGuId IN (SELECT DISTINCT DocumentGuId FROM @pFMDocument)
					)
	BEGIN
			SELECT	0	DocumentId,
					CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS [Timestamp],
					'File Name should be unique' AS	ErrorMessage 
	END


	ELSE 
	BEGIN
	IF((SELECT COUNT(*) FROM @pFMDocument WHERE DocumentId=0)>0)
		
		BEGIN

					IF ((	SELECT COUNT(*) FROM  @pFMDocument GROUP BY LTRIM(RTRIM(DocumentTitle)) HAVING COUNT(*)>1)>1)
	BEGIN
					SELECT	0	DocumentId,
					CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS [Timestamp],
					'File Name should be unique' AS	ErrorMessage 
	END

	else
	begin


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



				SELECT	DocumentId,
						[Timestamp],
						'' AS	ErrorMessage 
				FROM	FMDocument
				WHERE	DocumentId IN (SELECT ID FROM @Table)

		END
		end

	ELSE 
-------------------------------------------------------------------- UPDATE STATEMENT ----------------------------------------------------


			

		BEGIN
		 
	IF EXISTS (	SELECT 1 
				FROM FMDocument WITH(NOLOCK) 
				WHERE	FileName IN	(SELECT FileName FROM  @pFMDocument WHERE DocumentId=0)
						AND	DocumentGuId IN (SELECT DISTINCT DocumentGuId FROM @pFMDocument)
				)
	BEGIN
			SELECT	0	DocumentId,
					CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS [Timestamp],
					'File Name should be unique' AS	ErrorMessage 

		--SELECT @pErrorMessage AS pErrorMessage
	END

	ELSE 
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
									Document.DocumentGuId	=	DocumentType.DocumentGuId
									OUTPUT INSERTED.DocumentId INTO @Table
					FROM	FMDocument AS Document 
							INNER JOIN @pFMDocument AS DocumentType ON Document.DocumentId	=	DocumentType.DocumentId
					WHERE ISNULL(DocumentType.DocumentId,0)>0


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


				SELECT	DocumentId,
						[Timestamp],
						'' AS	ErrorMessage 
				FROM	FMDocument
				WHERE	DocumentId IN (SELECT ID FROM @Table)
						OR DocumentId IN (SELECT ID FROM @Table1)
END
		END

	END
END

-----------------------------------------------------------Asset Image -------------------------------------------

ELSE
BEGIN

	IF EXISTS (	SELECT 1 
				FROM FMDocument WITH(NOLOCK) 
				WHERE	FileName IN	(SELECT FileName FROM  @pFMDocument WHERE DocumentId=0)
						AND	DocumentGuId IN (SELECT DISTINCT DocumentGuId FROM @pFMDocument)
				)
	BEGIN
			SELECT	0	DocumentId,
					CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS [Timestamp],
					'File Name should be unique' AS	ErrorMessage 

		--SELECT @pErrorMessage AS pErrorMessage
	END



	ELSE
	BEGIN

	DECLARE @mDocumentGuId 	TABLE  (mGuId NVARCHAR(500),Documentid int )
	
	DELETE FMDocument WHERE DocumentGuId IN (SELECT DISTINCT DocumentGuId FROM @pFMDocument)


	SET	@pAssetId		=  (SELECT top 1 AssetId FROM EngAsset WHERE GuId IN (SELECT DISTINCT DocumentGuId FROM @pFMDocument))

					SELECT	IDENTITY(INT,1,1) AS ID,
							MajorVersion,
							@pAssetId	AS AssetId,
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
							--WHERE	ISNULL(udtDoc.DocumentId,0)=0

	;WITH CTE 
	AS
	(	SELECT	DocumentId,
				GuId,
				ROW_NUMBER() OVER (PARTITION BY Remarks ORDER BY DocumentId DESC) RNK 
		FROM FMDocument
		WHERE DocumentGuId IN (SELECT DISTINCT DocumentGuId FROM @pFMDocument)
	)
	INSERT INTO @mDocumentGuId (Documentid,mGuId)
	SELECT DocumentId,GuId FROM CTE WHERE DocumentId<>0 AND RNK>1;

		DELETE FMDocument WHERE DocumentId IN (SELECT DISTINCT DocumentId FROM @mDocumentGuId)
					
		SELECT	MajorVersion,
				@pAssetId	AS AssetId,
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

		UPDATE EngAsset SET VedioFMDocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='v7'  AND Flag = 'U' )  WHERE AssetId = @pAssetId
		UPDATE EngAsset SET Image1FMDocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i1'  AND Flag = 'U' )  WHERE AssetId = @pAssetId
		UPDATE EngAsset SET Image2FMDocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i2'  AND Flag = 'U' )  WHERE AssetId = @pAssetId
		UPDATE EngAsset SET Image3FMDocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i3'  AND Flag = 'U' )  WHERE AssetId = @pAssetId
		UPDATE EngAsset SET Image4FMDocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i4'  AND Flag = 'U' )  WHERE AssetId = @pAssetId
		UPDATE EngAsset SET Image5FMDocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i5'  AND Flag = 'U' )  WHERE AssetId = @pAssetId
		UPDATE EngAsset SET Image6FMDocumentId	= (SELECT DocumentId FROM #TempAssetDoc WHERE Remarks='i6'  AND Flag = 'U' )  WHERE AssetId = @pAssetId

		SELECT	AssetId,
				[Timestamp],
				'' AS	ErrorMessage 
		FROM	EngAsset
		WHERE	AssetId IN (SELECT DISTINCT AssetId FROM #TempAssetDoc)

	END

END
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
