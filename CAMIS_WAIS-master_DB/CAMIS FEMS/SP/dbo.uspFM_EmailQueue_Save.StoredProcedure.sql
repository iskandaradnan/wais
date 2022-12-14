USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EmailQueue_Save]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EmailQueue_Save
Description			: Get the staff details by passing the staffId.
Authors				: Dhilip V
Date				: 12-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC uspFM_EmailQueue_Save @pEmailQueueId =0 ,@pCustomerId = 1,@pFacilityId = 1,@pToIds =1 ,@pCcIds =1 ,@pBccIds =1 ,@pReplyIds =1 ,@pSubject = 'DD',
@pEmailTemplateId =1 ,@pTemplateVars ='DD' ,@pContentBody ='DD' ,@pSendAsHtml =1 ,@pPriority =1 ,@pStatus =1 ,@pTypeId =1 ,@pGroupId = 1 ,
@pQueuedBy =1 ,@pSubjectVars ='DD' ,@pUserId=1
SELECT * FROM EmailQueue
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/


CREATE PROCEDURE [dbo].[uspFM_EmailQueue_Save]
	@pEmailQueueId			[INT]				=	NULL,
	@pCustomerId			[INT]				=	NULL,
	@pFacilityId			[INT]		 		=	NULL,
	@pToIds					[NVARCHAR] (4000)	=	NULL,
	@pCcIds					[NVARCHAR] (4000)	=	NULL,
	@pBccIds				[NVARCHAR] (4000)	=	NULL,
	@pReplyIds				[NVARCHAR] (4000)	=	NULL,
	@pSubject				[NVARCHAR] (250)	=	NULL,
	@pEmailTemplateId		[INT]		 		=	NULL,
	@pTemplateVars			[NVARCHAR] (4000)	=	NULL,
	@pContentBody			[NVARCHAR] (4000)	=	NULL,
	@pSendAsHtml			[BIT]		 		=	NULL,
	@pPriority				[INT]		 		=	NULL,
	@pStatus				[INT]		 		=	NULL,
	@pTypeId				[INT]		 		=	NULL,
	@pGroupId				[INT]		 		=	NULL,
	--@pQueuedOn				[DATETIME]	 		=	NULL,
	@pQueuedBy				[NVARCHAR] (100)	=	NULL,
	--@pSentOn				[DATETIME]	 		=	NULL,
	--@pFailedOn				[DATETIME]	 		=	NULL,
	--@pFailCount				[INT]		 		=	NULL,
	@pSubjectVars			[NVARCHAR] (4000) 	=	NULL,
	--@pDataSource			[INT]		 		=	NULL,
	--@pSourceIp				[NVARCHAR] (100)	=	NULL,
	@pUserId				[INT]		 		=	NULL
AS 


BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY

	DECLARE @Table TABLE (ID INT)


	IF(ISNULL(@pEmailQueueId,0)=0)

	BEGIN

		INSERT INTO  EmailQueue (	CustomerId,
									FacilityId,
									ToIds,
									CcIds,
									BccIds,
									ReplyIds,
									Subject,
									EmailTemplateId,
									TemplateVars,
									ContentBody,
									SendAsHtml,
									Priority,
									Status,
									TypeId,
									GroupId,
									QueuedOn,
									QueuedBy,
									--SentOn,
									--FailedOn,
									--FailCount,
									SubjectVars,
									--DataSource,
									--SourceIp,
									CreatedBy,
									CreatedDate,
									CreatedDateUTC,
									ModifiedBy,
									ModifiedDate,
									ModifiedDateUTC
									)
								OUTPUT INSERTED.EmailQueueId INTO @Table
							VALUES	(	@pCustomerId,
										@pFacilityId,
										@pToIds,
										@pCcIds,
										@pBccIds,
										@pReplyIds,
										@pSubject,
										@pEmailTemplateId,
										@pTemplateVars,
										@pContentBody,
										@pSendAsHtml,
										@pPriority,
										@pStatus,
										@pTypeId,
										@pGroupId,
										GETDATE(),
										@pQueuedBy,
										--@pSentOn,
										--@pFailedOn,
										--@pFailCount,
										@pSubjectVars,
										--@pDataSource,
										--@pSourceIp,
										@pUserId,
										GETDATE(),
										GETUTCDATE(),
										@pUserId,
										GETDATE(),
										GETUTCDATE()
									)

					SELECT	EmailQueueId,
							Timestamp,
							'' ErrorMessage
					FROM	EmailQueue
					WHERE	EmailQueueId IN (SELECT ID FROM @Table)
		END
		ELSE
		BEGIN
			
				UPDATE EmailQueue SET	CustomerId			=	@pCustomerId,
										FacilityId			=	@pFacilityId,
										ToIds				=	@pToIds,
										CcIds				=	@pCcIds,
										BccIds				=	@pBccIds,
										ReplyIds			=	@pReplyIds,
										Subject				=	@pSubject,
										EmailTemplateId		=	@pEmailTemplateId,
										TemplateVars		=	@pTemplateVars,
										ContentBody			=	@pContentBody,
										SendAsHtml			=	@pSendAsHtml,
										Priority			=	@pPriority,
										Status				=	@pStatus,
										TypeId				=	@pTypeId,
										GroupId				=	@pGroupId,
										QueuedOn			=	GETDATE(),
										QueuedBy			=	@pQueuedBy,
										--SentOn				=	@pSentOn,
										--FailedOn			=	@pFailedOn,
										--FailCount			=	@pFailCount,
										SubjectVars			=	@pSubjectVars,
										--DataSource			=	@pDataSource,
										--SourceIp			=	@pSourceIp,
										ModifiedBy			=	@pUserid,
										ModifiedDate		=	GETDATE(),
										ModifiedDateUTC		=	GETUTCDATE()
							WHERE	EmailQueueId	=	@pEmailQueueId

					SELECT	EmailQueueId,
							Timestamp,
							'' ErrorMessage
					FROM	EmailQueue
					WHERE	EmailQueueId	=	@pEmailQueueId

			END

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW;

END CATCH
SET NOCOUNT OFF
END
GO
