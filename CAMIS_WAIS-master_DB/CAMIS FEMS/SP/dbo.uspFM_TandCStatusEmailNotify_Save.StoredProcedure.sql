USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_TandCStatusEmailNotify_Save]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_TandCStatusEmailNotify_Save
Description			: Get the staff details by passing the staffId.
Authors				: Dhilip V
Date				: 12-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC uspFM_TandCStatusEmailNotify_Save

	SELECT	TestingandCommissioningId,
			FacilityId,
			CustomerId
	FROM	EngTestingandCommissioningTxn
	WHERE	Status =285
			AND DATEDIFF(DD,TandCCompletedDate,GETDATE()) >= 30
SELECT * FROM EmailQueue
update EmailQueue set ToIds='dhilip.v@changepond.com' where EmailQueueId=62
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/


CREATE PROCEDURE [dbo].[uspFM_TandCStatusEmailNotify_Save]

AS 


BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY

	DECLARE @Table TABLE (ID INT)
	DECLARE @pEmailQueueId			[INT]				=	NULL,
	@mCustomerId			[INT]				=	NULL,
	@mFacilityId			[INT]		 		=	NULL,
	@mToIds					[NVARCHAR] (max)	=	NULL,
	@mCcIds					[NVARCHAR] (max)	=	NULL,
	@mBccIds				[NVARCHAR] (max)	=	NULL,
	@mReplyIds				[NVARCHAR] (max)	=	NULL,
	@mSubject				[NVARCHAR] (250)	=	NULL,
	@mEmailTemplateId		[INT]		 		=	NULL,
	@mTemplateVars			[NVARCHAR] (max)	=	NULL,
	@mContentBody			[NVARCHAR] (max)	=	NULL,
	@mSendAsHtml			[BIT]		 		=	NULL,
	@mPriority				[INT]		 		=	NULL,
	@mStatus				[INT]		 		=	NULL,
	@mTypeId				[INT]		 		=	NULL,
	@mGroupId				[INT]		 		=	NULL,
	@mQueuedBy				[NVARCHAR] (100)	=	NULL,
	@mSubjectVars			[NVARCHAR] (max) 	=	NULL,
	@mUserId				[INT]		 		=	NULL,
	@mTemplateDef			[NVARCHAR] (max)	=	NULL,
	@mLoopStart				INT =1,
	@mLoopLimit				INT


	SELECT	NotificationDeliveryId,
			NotificationTemplateId,
			UserRoleId,
			UserRegistrationId,
			FacilityId
	INTO	#Notification
	FROM	NotificationDeliveryDet
	WHERE	NotificationTemplateId = 3


	SELECT	TestingandCommissioningId,
			TandCDocumentNo,
			FacilityId,
			CustomerId
	INTO	#TempTandC
	FROM	EngTestingandCommissioningTxn
	WHERE	TandCStatus =285
			AND DATEDIFF(DD,TandCCompletedDate,GETDATE()) >= 23
			AND ISNULL(IsMailSent,0)=0

	SELECT	DISTINCT IDENTITY(INT,1,1) AS ID,
			FacilityId,
			CustomerId
	INTO	#TempFacility
	FROM	#TempTandC

	SELECT	DISTINCT
			IDENTITY(INT ,1,1) AS ID,
			A.FacilityId,
			A.CustomerId,
			CAST(STUFF((SELECT ',' + RTRIM(Email ) FROM UMUserRegistration AA where  AA.FacilityId=b.FacilityId FOR XML PATH('')),1,1,'') AS nvarchar(MAX)) AS Email
	INTO	#TempUserEmails
	FROM	UMUserRegistration AS A	
			INNER JOIN UMUserLocationMstDet AS B ON A.UserRegistrationId = B.UserRegistrationId
	WHERE	B.UserRoleId	IN (SELECT DISTINCT UserRoleId FROM #Notification)
			AND B.FacilityId	IN (SELECT DISTINCT FacilityId FROM #Notification)

	
	ALTER TABLE #TempTandC ADD ID INT 

	SELECT  ROW_NUMBER() OVER (ORDER BY TestingandCommissioningId) AS ID,TestingandCommissioningId INTO #TCID from #TempTandC

	UPDATE A SET A.ID=B.ID FROM #TempTandC A INNER JOIN #TCID B ON A.TestingandCommissioningId=B.TestingandCommissioningId

	SELECT @mTemplateDef=Definition FROM NotificationTemplate WHERE NotificationTemplateId=3


	SELECT @mLoopLimit	=	COUNT(1) FROM #TempTandC
	WHILE (@mLoopStart<=@mLoopLimit)
	BEGIN

		SET @mTemplateDef = (select replace(@mTemplateDef,'{0}',TandCDocumentNo) from #TempTandC where ID=@mLoopStart)
		SET @mTemplateDef = (select replace(@mTemplateDef,'{1}','7') from #TempTandC where ID=@mLoopStart )
	
		UPDATE EngTestingandCommissioningTxn SET IsMailSent=1 WHERE TestingandCommissioningId IN (SELECT TestingandCommissioningId FROM #TempTandC WHERE ID=@mLoopStart)

		SET @mCustomerId	= (SELECT CustomerId FROM #TempTandC WHERE ID=@mLoopStart)
		SET @mFacilityId	= (SELECT FacilityId FROM #TempTandC WHERE ID=@mLoopStart)	
		SET @mToIds			= (SELECT TOP 1 Email FROM #TempUserEmails WHERE FacilityId IN (SELECT FacilityId FROM #TempTandC WHERE ID = @mLoopStart ))
		SET @mCcIds			= ''
		SET @mBccIds		= NULL
		SET @mReplyIds		= NULL		
		SET @mSubject		= 'TandC Keep In View Status'		
		SET @mEmailTemplateId = 3	
		SET @mTemplateVars	= ''
		SET @mContentBody	= @mTemplateDef	
		SET @mSendAsHtml	=	1		
		SET @mPriority		=	1		
		SET @mStatus		=	1		
		SET @mTypeId		= NULL			
		SET @mGroupId		= NULL
		SET @mQueuedBy		= 1
		SET @mSubjectVars	= ''		
		SET @mUserId		= 1		
		
		EXEC uspFM_EmailQueue_Save @pEmailQueueId =0 ,@pCustomerId = @mCustomerId,@pFacilityId = @mFacilityId,@pToIds =@mToIds ,@pCcIds =@mCcIds ,@pBccIds =@mBccIds ,@pReplyIds =@mReplyIds ,@pSubject = @mSubject,
		@pEmailTemplateId =@mEmailTemplateId ,@pTemplateVars =@mTemplateVars ,@pContentBody =@mContentBody ,@pSendAsHtml = @mSendAsHtml ,@pPriority = @mPriority ,@pStatus =@mStatus ,@pTypeId = @mTypeId ,@pGroupId = @mGroupId ,
		@pQueuedBy = @mGroupId ,@pSubjectVars = @mSubjectVars ,@pUserId= @mUserId

	SET @mLoopStart	=	@mLoopStart+1
	END


	UPDATE EngTestingandCommissioningTxn	SET TandCStatus	=72,
			TandCFailedDate = GETDATE()
	WHERE	TandCStatus =285
			AND DATEDIFF(DD,TandCCompletedDate,GETDATE()) >= 30


END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW;

END CATCH
SET NOCOUNT OFF
END
GO
