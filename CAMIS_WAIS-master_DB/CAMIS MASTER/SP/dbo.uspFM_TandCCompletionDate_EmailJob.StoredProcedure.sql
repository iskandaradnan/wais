USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_TandCCompletionDate_EmailJob]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------






/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_TandCCompletionDate_EmailJob
Description			: To Get the data from table EngStockUpdateRegisterTxn using the Primary Key id
Authors				:
Date				: 
-----------------------------------------------------------------------------------------------------------

Unit Test:
exec uspFM_TandCCompletionDate_EmailJob
select * from EmailQueue  where  [TemplateVars]  like '%TC/PAN101/000045%'
--delete from EmailQueue  where emailqueueid=3531
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_TandCCompletionDate_EmailJob] 
  

AS


BEGIN TRY

	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



	SELECT	NotificationDeliveryId,
			NotificationTemplateId,
			UserRoleId,
			UserRegistrationId,
			FacilityId
	INTO	#Notification
	FROM	NotificationDeliveryDet
	WHERE	NotificationTemplateId = 54

	ALTER TABLE #Notification ADD ID INT 


	SELECT  ROW_NUMBER() OVER (ORDER BY NotificationDeliveryId) AS ID,NotificationDeliveryId INTO #ID from #Notification


	UPDATE A SET A.ID=B.ID FROM #Notification A INNER JOIN #ID B ON A.NotificationDeliveryId=B.NotificationDeliveryId

	
	SELECT	DISTINCT
		IDENTITY(INT ,1,1) AS ID,
		b.FacilityId,
		b.CustomerId,
		ltrim(rtrim(Email)) as EMAIL		
		INTO	#TempUserEmails_all
	FROM	UMUserRegistration AS A	
			INNER JOIN UMUserLocationMstDet AS B ON A.UserRegistrationId = B.UserRegistrationId
	WHERE	B.UserRoleId	IN (SELECT DISTINCT UserRoleId FROM #Notification)
	--AND B.FacilityId	= @pFacilityId
	--IN (SELECT DISTINCT FacilityId FROM #Notification)
	
	
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
		CAST(STUFF((SELECT ',' + RTRIM(AA.Email ) FROM #TempUserEmails_all AA where A.FacilityId = AA.FacilityId and A.CustomerId = AA.CustomerId -- AA.FacilityId=b.FacilityId 
		FOR XML PATH('')),1,1,'') AS nvarchar(MAX)) AS Email
	
	 from #TempUserEmails_all a) a



	SELECT	TestingandCommissioningId,
			TandCDocumentNo,
			FacilityId,
			CustomerId,
			CustomerRepresentativeUserId,
			FacilityRepresentativeUserId,
			isnull((select email from  UMUserRegistration u where u.UserRegistrationId=c.CustomerRepresentativeUserId ) ,'') +','
			+isnull((select email from UMUserRegistration u where u.UserRegistrationId=c.FacilityRepresentativeUserId ) ,'') 
			as email,
			format(c.RequiredCompletionDate,'dd-MMM-yyyy') as  RequiredCompletionDate
			into #EngTestingandCommissioningTxn
	FROM	EngTestingandCommissioningTxn c
	WHERE	TandCStatus =285
			AND DATEDIFF(DD,RequiredCompletionDate,GETDATE()) = 7	




INSERT INTO EmailQueue(CustomerId,FacilityId,ToIds,CcIds,BccIds,ReplyIds,Subject,EmailTemplateId,TemplateVars,ContentBody,SendAsHtml,Priority,Status,TypeId,GroupId,
	QueuedOn,QueuedBy,SubjectVars,DataSource,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)
	SELECT A.CustomerId,A.FacilityId,isnull(A.email,'')+','+isnull(c.Email,'') as Email,null,NULL,NULL,b.Subject,B.NotificationTemplateId,
	A.TandCDocumentNo,
	REPLACE(REPLACE([Definition],'{0}',A.TandCDocumentNo),'{1}',isnull(a.RequiredCompletionDate,'7 days')),1,1,1,NULL,NULL,GETDATE(),
	NULL,'',0,1,GETDATE(),GETUTCDATE(),1,GETDATE(),GETUTCDATE() FROM #EngTestingandCommissioningTxn A cross join  NotificationTemplate B
	left join #TempUserEmails c on a.CustomerId= c.CustomerId	 and a.FacilityId = c.FacilityId
	WHERE B.NotificationTemplateId = 54	
	and  not exists (select 1 from EmailQueue e  where  e.EmailTemplateId = 54	and  TemplateVars =a.TandCDocumentNo)
	and len(isnull(a.email,''))>5

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
