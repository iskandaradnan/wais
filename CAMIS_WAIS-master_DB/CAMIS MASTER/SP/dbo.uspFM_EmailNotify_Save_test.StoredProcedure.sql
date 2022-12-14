USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EmailNotify_Save_test]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EmailNotify_Save
Description			: Get the staff details by passing the staffId.
Authors				: Dhilip V
Date				: 12-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC uspFM_EmailNotify_Save @pEmailTemplateId=24,@pToEmailIds='sayamsunder.n@gmail.com',@pSubject='',@pPriority=1,@pSendAsHtml=1,@pSubjectVars='',@pTemplateVars='DD,250,DD'


EXEC uspFM_EmailNotify_Save_test @pEmailTemplateId= 24, @pToEmailIds='sayamsunder.n@changepond.com',@pSubject= null ,@pPriority=1,@pSendAsHtml=1,@pSubjectVars='',@pTemplateVars='DD,250,DD'

SELECT * FROM EmailQueue


exec uspFM_EmailNotify_Save_test  

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/


CREATE PROCEDURE [dbo].[uspFM_EmailNotify_Save_test]
	@pEmailTemplateId		[INT]		 		=	NULL,
	@pToEmailIds			[NVARCHAR] (max)	=	NULL,
	@pSubject				[NVARCHAR] (max)	=	NULL,	
	@pPriority				[INT]		 		=	NULL,
	@pSendAsHtml			[BIT]		 		=	NULL,
	@pSubjectVars			[NVARCHAR] (max) 	=	NULL,
	@pTemplateVars 			[NVARCHAR] (max) 	=	NULL
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
	WHERE	NotificationTemplateId = @pEmailTemplateId

	ALTER TABLE #Notification ADD ID INT 


	SELECT  ROW_NUMBER() OVER (ORDER BY NotificationDeliveryId) AS ID,NotificationDeliveryId INTO #ID from #Notification


	UPDATE A SET A.ID=B.ID FROM #Notification A INNER JOIN #ID B ON A.NotificationDeliveryId=B.NotificationDeliveryId

	
	SELECT	DISTINCT
		IDENTITY(INT ,1,1) AS ID,
		A.FacilityId,
		A.CustomerId,
		ltrim(rtrim(Email)) as EMAIL		
		INTO	#TempUserEmails_all
	FROM	UMUserRegistration AS A	
			INNER JOIN UMUserLocationMstDet AS B ON A.UserRegistrationId = B.UserRegistrationId
	WHERE	B.UserRoleId	IN (SELECT DISTINCT UserRoleId FROM #Notification)
	AND B.FacilityId	IN (SELECT DISTINCT FacilityId FROM #Notification)
	
	
	select IDENTITY(INT ,1,1) AS ID,
		FacilityId,
		CustomerId,
		Email
	INTO	#TempUserEmails
	from 
	
	(
	select
	distinct
		A.FacilityId,
		A.CustomerId,
		CAST(STUFF((SELECT ',' + RTRIM(AA.Email ) FROM #TempUserEmails_all AA where A.FacilityId = AA.FacilityId and A.FacilityId = AA.CustomerId -- AA.FacilityId=b.FacilityId 
		FOR XML PATH('')),1,1,'') AS nvarchar(MAX)) AS Email
	
	 from #TempUserEmails_all a) a

	

--		SELECT	DISTINCT
--		IDENTITY(INT ,1,1) AS ID,
--		A.FacilityId,
--		A.CustomerId,
--		CAST(STUFF((SELECT ',' + RTRIM(Email ) FROM UMUserRegistration AA where AA.UserRegistrationId = A.UserRegistrationId -- AA.FacilityId=b.FacilityId 
--		FOR XML PATH('')),1,1,'') AS nvarchar(MAX)) AS Email
--INTO	#TempUserEmails
--	FROM	UMUserRegistration AS A	
--			INNER JOIN UMUserLocationMstDet AS B ON A.UserRegistrationId = B.UserRegistrationId
--	WHERE	B.UserRoleId	IN (SELECT DISTINCT UserRoleId FROM #Notification)
--			AND B.FacilityId	IN (SELECT DISTINCT FacilityId FROM #Notification)

	

	SELECT	DISTINCT
			IDENTITY(INT ,1,1) AS ID,
			A.FacilityId,
			A.CustomerId,
			CAST(STUFF((SELECT ',' + RTRIM(Email ) FROM UMUserRegistration AA where  AA.UserRegistrationId=A.UserRegistrationId FOR XML PATH('')),1,1,'') AS nvarchar(MAX)) AS Email
	INTO	#TempUserEmailsUser
	FROM	UMUserRegistration AS A	
			INNER JOIN UMUserLocationMstDet AS B ON A.UserRegistrationId = B.UserRegistrationId
	WHERE	B.UserRegistrationId	IN (SELECT DISTINCT UserRegistrationId FROM #Notification)
			AND B.FacilityId	IN (SELECT DISTINCT FacilityId FROM #Notification)

	IF NOT EXISTS (SELECT * FROM #TempUserEmails)
		BEGIN
			INSERT INTO #TempUserEmails (FacilityId,CustomerId,Email)
			select DISTINCT 0,0,@pToEmailIds
			--SELECT DISTINCT A.FacilityId,A.CustomerId,A.Email FROM UMUserRegistration A INNER JOIN (SELECT Item FROM SplitString (@pToEmailIds,',')) B ON A.Email=B.Item

		END

	IF EXISTS (SELECT * FROM #TempUserEmailsUser)
		BEGIN
			UPDATE A SET A.Email	=	A.Email + ',' + B.Email
			FROM #TempUserEmails A INNER JOIN #TempUserEmailsUser B ON A.FacilityId = B.FacilityId

			IF ((SELECT COUNT(*) FROM #TempUserEmailsUser WHERE FacilityId =0)>0 )
			BEGIN
				INSERT INTO #TempUserEmails (FacilityId,CustomerId,Email)
				select DISTINCT 0,0,Email FROM #TempUserEmailsUser WHERE FacilityId IS NULL
			END
		END
		
		
	SET @pToEmailIds =NULLIF(@pToEmailIds,'')
	IF EXISTS (SELECT Item FROM SplitString (@pToEmailIds,','))
	BEGIN

			UPDATE #TempUserEmails SET Email	=	isnull(Email,'') + ',' + @pToEmailIds

			select distinct a.id,  rtrim(ltrim(c.Item)) as Email into #TempUserEmails1 from #TempUserEmails a
			cross apply (select Item from SplitString(email,',')  ) c
			where len(rtrim(ltrim(c.Item)))>0


			select distinct a.id,
			CAST(STUFF((SELECT ',' + RTRIM(Email ) FROM #TempUserEmails1 AA where  AA.id=a.id FOR XML PATH('')),1,1,'') AS nvarchar(MAX)) AS Email		  
			into #TempUserEmails2
			from #TempUserEmails1 a

					
		 	UPDATE a SET Email	=	b.Email
			from  #TempUserEmails a
			join #TempUserEmails2 b on a.ID = b.ID

					
		 --select  CAST(STUFF((SELECT ',' + RTRIM(Email ) 
		 --FROM #TempUserEmails1 AA where  AA.id=b.id FOR XML PATH('')),1,1,'') AS nvarchar(MAX)) AS Email
		 
		  
		--select  email from 
		--#TempUserEmails a  
		--outer apply (select  CAST(STUFF((SELECT ',' + (SELECT distinct  ltrim(rtrim(Item)) FROM SplitString (email,',')) FOR XML PATH('')),1,1,'') AS nvarchar(MAX)) 
		--from #TempUserEmails b where a.id=b.id)  
	
		
		--select * from ltrim(rtrim(Item)) FROM SplitString (email,',')
	--select  email from #TempUserEmails a  


	--		select (select   CAST(STUFF((SELECT ',' + (SELECT distinct  ltrim(rtrim(Item)) FROM SplitString (email,','))FOR XML PATH('')),1,1,'') AS nvarchar(MAX)) from #TempUserEmails b where a.id=b.id) email from 
	--		#TempUserEmails a
			
	--	return
			--UPDATE A SET Email	=	CAST(STUFF((SELECT  ',' + (SELECT distinct  ltrim(rtrim(Item)) FROM SplitString (email,','))  FOR XML PATH('')),1,1,'') AS nvarchar(MAX)) 
			--from #TempUserEmails A
			
		

		--	CAST(STUFF((SELECT ',' + RTRIM(Email ) FROM UMUserRegistration AA where  AA.FacilityId=b.FacilityId FOR XML PATH('')),1,1,'') AS nvarchar(MAX)) AS Email

	END

	


	SELECT @mTemplateDef = Definition FROM NotificationTemplate WHERE NotificationTemplateId=@pEmailTemplateId
	SELECT @mSubject = Subject  FROM NotificationTemplate WHERE NotificationTemplateId=@pEmailTemplateId




	SELECT @mLoopLimit	=	COUNT(1) FROM #TempUserEmails
	WHILE (@mLoopStart<=@mLoopLimit)
	BEGIN

		SET @mSubject = (select REPLACE(@mSubject,'{0}',ISNULL((SELECT item FROM dbo.SplitString(@pSubjectVars,',') where id=1),'')))
		SET @mSubject = (select REPLACE(@mSubject,'{1}',ISNULL((SELECT item FROM dbo.SplitString(@pSubjectVars,',') where id=2),'')))
		SET @mSubject = (select REPLACE(@mSubject,'{2}',ISNULL((SELECT item FROM dbo.SplitString(@pSubjectVars,',') where id=3),'')))
		SET @mSubject = (select REPLACE(@mSubject,'{3}',ISNULL((SELECT item FROM dbo.SplitString(@pSubjectVars,',') where id=4),'')))
		SET @mSubject = (select REPLACE(@mSubject,'{4}',ISNULL((SELECT item FROM dbo.SplitString(@pSubjectVars,',') where id=5),'')))
		SET @mSubject = (select REPLACE(@mSubject,'{5}',ISNULL((SELECT item FROM dbo.SplitString(@pSubjectVars,',') where id=6),'')))
		SET @mSubject = (select REPLACE(@mSubject,'{6}',ISNULL((SELECT item FROM dbo.SplitString(@pSubjectVars,',') where id=7),'')))
		SET @mSubject = (select REPLACE(@mSubject,'{7}',ISNULL((SELECT item FROM dbo.SplitString(@pSubjectVars,',') where id=8),'')))
		SET @mSubject = (select REPLACE(@mSubject,'{8}',ISNULL((SELECT item FROM dbo.SplitString(@pSubjectVars,',') where id=9),'')))
		SET @mSubject = (select REPLACE(@mSubject,'{9}',ISNULL((SELECT item FROM dbo.SplitString(@pSubjectVars,',') where id=10),'')))


		SET @mTemplateDef = (select REPLACE(@mTemplateDef,'{0}',ISNULL((SELECT item FROM dbo.SplitString(@pTemplateVars,',') where id=1),'')))
		SET @mTemplateDef = (select REPLACE(@mTemplateDef,'{1}',ISNULL((SELECT item FROM dbo.SplitString(@pTemplateVars,',') where id=2),'')))
		SET @mTemplateDef = (select REPLACE(@mTemplateDef,'{2}',ISNULL((SELECT item FROM dbo.SplitString(@pTemplateVars,',') where id=3),'')))
		SET @mTemplateDef = (select REPLACE(@mTemplateDef,'{3}',ISNULL((SELECT item FROM dbo.SplitString(@pTemplateVars,',') where id=4),'')))
		SET @mTemplateDef = (select REPLACE(@mTemplateDef,'{4}',ISNULL((SELECT item FROM dbo.SplitString(@pTemplateVars,',') where id=5),'')))
		SET @mTemplateDef = (select REPLACE(@mTemplateDef,'{5}',ISNULL((SELECT item FROM dbo.SplitString(@pTemplateVars,',') where id=6),'')))
		SET @mTemplateDef = (select REPLACE(@mTemplateDef,'{6}',ISNULL((SELECT item FROM dbo.SplitString(@pTemplateVars,',') where id=7),'')))
		SET @mTemplateDef = (select REPLACE(@mTemplateDef,'{7}',ISNULL((SELECT item FROM dbo.SplitString(@pTemplateVars,',') where id=8),'')))
		SET @mTemplateDef = (select REPLACE(@mTemplateDef,'{8}',ISNULL((SELECT item FROM dbo.SplitString(@pTemplateVars,',') where id=9),'')))
		SET @mTemplateDef = (select REPLACE(@mTemplateDef,'{9}',ISNULL((SELECT item FROM dbo.SplitString(@pTemplateVars,',') where id=10),'')))
		
		SET @mCustomerId		= (SELECT CustomerId FROM #TempUserEmails WHERE ID=@mLoopStart)
		SET @mFacilityId		= (SELECT FacilityId FROM #TempUserEmails WHERE ID=@mLoopStart)	
		SET @mToIds				= (SELECT TOP 1 Email FROM #TempUserEmails WHERE ID = @mLoopStart )
		SET @mCcIds				= ''
		SET @mBccIds			= NULL
		SET @mReplyIds			= NULL		
		SET @mSubject			= @mSubject		
		SET @mEmailTemplateId	= @pEmailTemplateId	
		SET @mTemplateVars		= @pTemplateVars
		SET @mContentBody		= @mTemplateDef	
		SET @mSendAsHtml		= @pSendAsHtml		
		SET @mPriority			= @pSendAsHtml		
		SET @mStatus			= 1		
		SET @mTypeId			= NULL			
		SET @mGroupId			= NULL
		SET @mQueuedBy			= 1
		SET @mSubjectVars		= ''		
		SET @mUserId			= 1		
		
	


		EXEC uspFM_EmailQueue_Save @pEmailQueueId =0 ,@pCustomerId = @mCustomerId,@pFacilityId = @mFacilityId,@pToIds =@mToIds ,@pCcIds =@mCcIds ,@pBccIds =@mBccIds ,@pReplyIds =@mReplyIds ,@pSubject = @mSubject,
		@pEmailTemplateId =@mEmailTemplateId ,@pTemplateVars =@mTemplateVars ,@pContentBody =@mContentBody ,@pSendAsHtml = @mSendAsHtml ,@pPriority = @mPriority ,@pStatus =@mStatus ,@pTypeId = @mTypeId ,@pGroupId = @mGroupId ,
		@pQueuedBy = @mGroupId ,@pSubjectVars = @mSubjectVars ,@pUserId= @mUserId

	SET @mLoopStart	=	@mLoopStart+1
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
