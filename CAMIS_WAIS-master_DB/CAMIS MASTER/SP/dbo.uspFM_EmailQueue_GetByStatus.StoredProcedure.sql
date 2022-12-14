USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EmailQueue_GetByStatus]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EmailQueue_GetByStatus
Description			: Status update for email fail.
Authors				: DHILIP V
Date				: 27-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EmailQueue_GetByStatus] @pStatus=1,@pPriority=NULL,@pRetrieveEmail=10,@pMyIp=null

SELECT * FROM EmailQueue
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/


CREATE PROCEDURE  [dbo].[uspFM_EmailQueue_GetByStatus]

	@pStatus		INT	=	NULL,
	@pPriority		INT	=	NULL,
	@pRetrieveEmail	INT,
	@pMyIp			NVARCHAR(100)	=	NULL

AS                                              

BEGIN TRY



-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)
	DECLARE @EmailQTable TABLE (ID INT)

-- Default Values

	INSERT INTO @Table 
	SELECT  EmailTemplateId 	
	FROM	EmailQueue 
	WHERE	Status	=	@pStatus
			AND Priority	=	@pPriority
	ORDER BY EmailQueueId ASC
	OFFSET 0   ROWS FETCH NEXT  @pRetrieveEmail  ROWS ONLY

	INSERT INTO @EmailQTable 
	SELECT  EmailQueueId 	
	FROM	EmailQueue 
	WHERE	Status	=	@pStatus
			AND Priority	=	@pPriority
	ORDER BY EmailQueueId ASC
	OFFSET 0   ROWS FETCH NEXT  @pRetrieveEmail  ROWS ONLY

-- Execution

	SELECT	EmailQueueId
			,CustomerId
			,FacilityId
			,ISNULL(ToIds	,'')   ToIds
			,ISNULL(CcIds	,'')   CcIds
			,ISNULL(BccIds	,'')   BccIds
			,ISNULL(ReplyIds,'')   ReplyIds
			,ISNULL(Subject	,'')   Subject
			,EmailTemplateId
			,ISNULL(TemplateVars,'')  TemplateVars
			,ISNULL(ContentBody,'')  ContentBody
			,SendAsHtml
			,Priority
			,Status
			,TypeId
			,GroupId
			,QueuedOn
			,QueuedBy
			,SentOn
			,FailedOn
			,ISNULL(FailCount,0) FailCount
			,ISNULL(SubjectVars,'') SubjectVars
			,DataSource
			,ISNULL(SourceIp,'') SourceIp
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,Timestamp
			,GuId
	FROM	EmailQueue 
	WHERE	Status	=	@pStatus
			AND Priority	=	@pPriority
	ORDER BY EmailQueueId ASC
	OFFSET 0   ROWS FETCH NEXT  @pRetrieveEmail  ROWS ONLY

--2



--3


	SELECT	EmailExclusionId
			,CustomerId
			,FacilityId
			,EmailTemplateId
			,ISNULL(EmailAddress,'') EmailAddress
			,Type
			,Status
			,ISNULL(Remarks,'') Remarks
			,Timestamp
	FROM	EmailExclusionList
	WHERE	EmailTemplateId IN (SELECT ID FROM @Table)


--4

	SELECT	EmailAttachmentId
			,EmailQueueId
			,ISNULL(AttachmentName,'') AttachmentName
			,ISNULL(AttachmentType,'') AttachmentType
			,Content
	FROM	EmailAttachment
	WHERE	EmailQueueId IN (SELECT DISTINCT ID FROM @EmailQTable)


	UPDATE EmailQueue SET	Status	=4,
							SourceIp		=	@pMyIp,
							ModifiedDate	=	GETDATE(),
							ModifiedDateUTC	=	GETUTCDATE()
				WHERE	EmailQueueId IN (SELECT DISTINCT ID FROM @EmailQTable)

								


END TRY

BEGIN CATCH



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
