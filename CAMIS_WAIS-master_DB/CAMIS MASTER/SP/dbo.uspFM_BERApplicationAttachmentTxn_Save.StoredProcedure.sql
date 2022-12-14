USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BERApplicationAttachmentTxn_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetTypeCode_Save
Description			: Insert/update the typecode details
Authors				: Dhilip V
Date				: 19-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

DECLARE @pFMDocument					[dbo].[udt_FMDocument]
INSERT INTO @pFMDocument ([DocumentId],[GuId],[CustomerId],[FacilityId],[DocumentNo],[DocumentTitle],[DocumentDescription],[DocumentCategory],[DocumentCategoryOthers],
[DocumentExtension],[MajorVersion],[MinorVersion],[FileType],[FilePath],[FileName],[UploadedDateUTC],[ScreenId],[Remarks],[UserId]) 
VALUES (0,NEWID(),1,1,'4849846465+4','_04_May_2018 (2).xls','_04_May_2018 (2).xls',0,NULL,NULL,0,0,2,'add36ada-2c9f-494c-9914-b1e55fe1cacf_',
'c0e5d5ee-60a7-4c77-86a1-541611fdea71__05_May_2018.xls','2018-05-10 19:38:41.797',1,'rEMARKS',2),
(0,NEWID(),1,1,'4849846465+4','_04_May_2018 (2).xls','_04_May_2018 (2).xls',0,NULL,NULL,0,0,2,'add36ada-2c9f-494c-9914-b1e55fe1cacf_',
'c0e5d5ee-60a7-4c77-86a1-541611fdea71__05_May_2018.xls','2018-05-10 19:38:41.797',1,'rEMARKS',2),
(0,NEWID(),1,1,'4849846465+4','_04_May_2018 (2).xls','_04_May_2018 (2).xls',0,NULL,NULL,0,0,2,'add36ada-2c9f-494c-9914-b1e55fe1cacf_',
'c0e5d5ee-60a7-4c77-86a1-541611fdea71__05_May_2018.xls','2018-05-10 19:38:41.797',1,'rEMARKS',2) 

EXEC [uspFM_BERApplicationAttachmentTxn_Save] @pFMDocument
,@pCustomerId=1,@pFacilityId=1,@pServiceId=2,@pApplicationId=1,@pAttachedBy=2,@pUserId=2

DECLARE @pFMDocument					[dbo].[udt_FMDocument]
INSERT INTO @pFMDocument ([DocumentId],[GuId],[CustomerId],[FacilityId],[DocumentNo],[DocumentTitle],[DocumentDescription],[DocumentCategory],[DocumentCategoryOthers],
[DocumentExtension],[MajorVersion],[MinorVersion],[FileType],[FilePath],[FileName],[UploadedDateUTC],[ScreenId],[Remarks],[UserId]) 
VALUES (80,NEWID(),1,1,'fILEnAME8','_04_May_2018 (2).xls','_04_May_2018 (2).xls',0,NULL,NULL,0,0,2,'add36ada-2c9f-494c-9914-b1e55fe1cacf_',
'fILENAME1.xls','2018-05-10 19:38:41.797',1,'rEMARKS',2)


EXEC [uspFM_BERApplicationAttachmentTxn_Save] @pFMDocument
,@pCustomerId=1,@pFacilityId=1,@pServiceId=2,@pApplicationId=1,@pAttachedBy=2,@pUserId=2



SELECT * FROM EngAssetTypeCode
SELECT * FROM EngAssetTypeCodeFlag
SELECT * FROM EngAssetTypeCodeAddSpecification
SELECT * FROM EngAssetTypeCodeVariationRate

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_BERApplicationAttachmentTxn_Save]
		@pFMDocument						[dbo].[udt_FMDocument]		 READONLY,
		@pCustomerId						INT,
		@pFacilityId						INT,
		@pServiceId							INT,
		@pApplicationId						INT,
		@pAttachedBy						INT,
        @pUserId			   	            INT							=	NULL

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)	
	DECLARE @pFMDocuments	[dbo].[udt_FMDocument]	
	DECLARE @Table1 TABLE (ID INT)	
	DECLARE	@PrimaryKeyId	 INT




--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

--//1.EngAssetTypeCode


	IF((SELECT count(*) FROM @pFMDocuments WHERE DocumentId=0)>0)
		
		BEGIN

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

				declare @tempDocumentId int = (	SELECT	DocumentId FROM	FMDocument WITH(NOLOCK) WHERE	DocumentId IN (SELECT ID FROM @Table1))


				if object_id('#AttachmentInsertion') is not null
				drop table #AttachmentInsertion

				CREATE TABLE #AttachmentInsertion (CustomerId int,FacilityId int,ServiceId int,ApplicationId int,DocumentId int,FileType int,AttachedBy int,
				[FileName] nvarchar(250),GUID uniqueidentifier)
				
				insert into #AttachmentInsertion(DocumentId,FileType,[FileName],GUID)
				select DocumentId,FileType,[FileName],GuId from FMDocument where DocumentId in (SELECT ID FROM @Table1)

				UPDATE A SET  A.CustomerId = @pCustomerId,A.FacilityId = @pFacilityId,A.ServiceId = @pServiceId,A.ApplicationId = @pApplicationId
				,A.AttachedBy = @pAttachedBy FROM #AttachmentInsertion A 

				INSERT INTO BERApplicationAttachmentTxn
								(	
									CustomerId,
									FacilityId,
									ServiceId,
									ApplicationId,
									DocumentId,
									FileType,
									AttachedBy,
									FileName,
									CreatedBy,
									CreatedDate,
									CreatedDateUTC,
									ModifiedBy,
									ModifiedDate,
									ModifiedDateUTC
								)
				SELECT
									CustomerId,
									FacilityId,
									ServiceId,
									ApplicationId,
									DocumentId,
									FileType,
									AttachedBy,
									FileName,
									@pUserId,
									GETDATE(),
									GETDATE(),
									@pUserId,
									GETDATE(),
									GETDATE()

				FROM #AttachmentInsertion


				SELECT	DocumentId,
						[Timestamp],
						'' ErrorMsg 
				FROM	BERApplicationAttachmentTxn
				WHERE	DocumentId IN (SELECT ID FROM @Table)

		END


	ELSE 
-------------------------------------------------------------------- UPDATE STATEMENT ----------------------------------------------------

------1.EngAssetTypeCode

			

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
									Document.DocumentGuId	= DocumentType.DocumentGuId
									--OUTPUT INSERTED.DocumentId INTO @Table
					FROM	FMDocument AS Document 
							INNER JOIN @pFMDocument AS DocumentType ON Document.DocumentId	=	DocumentType.DocumentId
					WHERE ISNULL(DocumentType.DocumentId,0)>0

					UPDATE ApplicationAttachment SET										
	
									ApplicationAttachment.[FileType]			= DocumentType.[FileType],				
									ApplicationAttachment.[FileName]			= DocumentType.[FileName],				
									ApplicationAttachment.ModifiedBy			= @pUserId,			
									ApplicationAttachment.ModifiedDate			= GETDATE(),		
									ApplicationAttachment.ModifiedDateUTC		= GETUTCDATE()	
									--OUTPUT INSERTED.DocumentId INTO @Table
					FROM	BERApplicationAttachmentTxn AS ApplicationAttachment 
							INNER JOIN @pFMDocument AS DocumentType ON ApplicationAttachment.DocumentId	=	DocumentType.DocumentId
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
									ModifiedDateUTC
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
										GETUTCDATE()
								FROM	@pFMDocument	udtDoc
								WHERE	ISNULL(udtDoc.DocumentId,0)=0

				--declare @tempDocumentId1 int = (	SELECT	DocumentId FROM	FMDocument WITH(NOLOCK) WHERE	DocumentId IN (SELECT top 1 ID FROM @Table1))
			 
				if object_id('#AttachmentInsertions') is not null
				drop table #AttachmentInsertions
	           
				CREATE TABLE #AttachmentInsertions (CustomerId int,FacilityId int,ServiceId int,ApplicationId int,DocumentId int,FileType int,AttachedBy int,
				[FileName] nvarchar(250),GUID uniqueidentifier)
				
				insert into #AttachmentInsertions(DocumentId,FileType,[FileName],GUID)
				select DocumentId,FileType,[FileName],GuId from FMDocument where DocumentId in (SELECT ID FROM @Table1)

				UPDATE A SET  A.CustomerId = @pCustomerId,A.FacilityId = @pFacilityId,A.ServiceId = @pServiceId,A.ApplicationId = @pApplicationId
				,A.AttachedBy = @pAttachedBy FROM #AttachmentInsertions A 

				INSERT INTO BERApplicationAttachmentTxn
								(	
									CustomerId,
									FacilityId,
									ServiceId,
									ApplicationId,
									DocumentId,
									FileType,
									AttachedBy,
									FileName,
									CreatedBy,
									CreatedDate,
									CreatedDateUTC,
									ModifiedBy,
									ModifiedDate,
									ModifiedDateUTC
								)
				SELECT
									CustomerId,
									FacilityId,
									ServiceId,
									ApplicationId,
									DocumentId,
									FileType,
									AttachedBy,
									FileName,
									@pUserId,
									GETDATE(),
									GETDATE(),
									@pUserId,
									GETDATE(),
									GETDATE()

				FROM #AttachmentInsertions

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
