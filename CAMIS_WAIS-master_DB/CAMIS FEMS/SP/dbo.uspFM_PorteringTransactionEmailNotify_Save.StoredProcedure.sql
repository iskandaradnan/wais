USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_PorteringTransactionEmailNotify_Save]    Script Date: 20-09-2021 16:56:53 ******/
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

EXEC [uspFM_EngAssetWarrantyEmailNotify_Save]

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


CREATE PROCEDURE [dbo].[uspFM_PorteringTransactionEmailNotify_Save]

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

	SELECT	A.LoanerTestEquipmentBookingId,
			A.AssetId,
			B.AssetNo,
			A.FacilityId,
			A.CustomerId
	INTO	#TempEngLoanerTestEquipmentBookingTxn
	FROM	EngLoanerTestEquipmentBookingTxn A LEFT JOIN EngAsset B ON A.AssetId = B.AssetId
	WHERE	 DATEDIFF(DD,BookingEnd,GETDATE()) >= 7
			AND A.IsMailSent=0

	SELECT	DISTINCT IDENTITY(INT,1,1) AS ID,
			FacilityId,
			CustomerId
	INTO	#TempFacility
	FROM	#TempEngLoanerTestEquipmentBookingTxn


	SELECT	DISTINCT 
			FacilityId,
			CustomerId,
			STUFF((SELECT ',' + RTRIM(Email ) FROM UMUserRegistration a where A.UserTypeId=1 AND a.FacilityId=b.FacilityId FOR XML PATH('')),1,1,'') AS Email
	INTO	#TempUserEmails
	FROM	UMUserRegistration b
	WHERE B.UserTypeId=1
	

	ALTER TABLE #TempUserEmails ADD ID INT 
	ALTER TABLE #TempEngLoanerTestEquipmentBookingTxn ADD ID INT 

	SELECT  ROW_NUMBER() OVER (ORDER BY FacilityId) AS ID,FacilityId INTO #ID from #TempUserEmails
	SELECT  ROW_NUMBER() OVER (ORDER BY AssetId) AS ID,LoanerTestEquipmentBookingId INTO #TCID from #TempEngLoanerTestEquipmentBookingTxn

	UPDATE A SET A.ID=B.ID FROM #TempUserEmails A INNER JOIN #ID B ON A.FacilityId=B.FacilityId
	UPDATE A SET A.ID=B.ID FROM #TempEngLoanerTestEquipmentBookingTxn A INNER JOIN #TCID B ON A.LoanerTestEquipmentBookingId=B.LoanerTestEquipmentBookingId

	SELECT @mTemplateDef=Definition FROM NotificationTemplate WHERE NotificationTemplateId=21


	SELECT @mLoopLimit	=	COUNT(1) FROM #TempEngLoanerTestEquipmentBookingTxn
	WHILE (@mLoopStart<=@mLoopLimit)
	BEGIN

		SET @mTemplateDef = (select replace(@mTemplateDef,'{0}',AssetNo) from #TempEngLoanerTestEquipmentBookingTxn where ID=@mLoopStart)
		SET @mTemplateDef = (select replace(@mTemplateDef,'{1}','7') from #TempEngLoanerTestEquipmentBookingTxn where ID=@mLoopStart )
	
		UPDATE EngLoanerTestEquipmentBookingTxn SET IsMailSent=1 WHERE LoanerTestEquipmentBookingId IN (SELECT LoanerTestEquipmentBookingId FROM #TempEngLoanerTestEquipmentBookingTxn WHERE ID=@mLoopStart)

		SET @mCustomerId	= (SELECT CustomerId FROM #TempEngLoanerTestEquipmentBookingTxn WHERE ID=@mLoopStart)
		SET @mFacilityId	= (SELECT FacilityId FROM #TempEngLoanerTestEquipmentBookingTxn WHERE ID=@mLoopStart)	
		SET @mToIds			= (SELECT TOP 1 Email FROM #TempUserEmails WHERE FacilityId IN (SELECT FacilityId FROM #TempEngLoanerTestEquipmentBookingTxn WHERE ID = @mLoopStart ))
		SET @mCcIds			= ''
		SET @mBccIds		= NULL
		SET @mReplyIds		= NULL		
		SET @mSubject		= 'Asset Warranty End Date Status'		
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


END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW;

END CATCH
SET NOCOUNT OFF
END
GO
