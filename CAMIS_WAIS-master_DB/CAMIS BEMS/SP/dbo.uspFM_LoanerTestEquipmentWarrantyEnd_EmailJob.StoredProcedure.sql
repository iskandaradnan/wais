USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_LoanerTestEquipmentWarrantyEnd_EmailJob]    Script Date: 20-09-2021 17:05:52 ******/
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
exec uspFM_AssetWarrantyEndDate_EmailJob
select * from EmailQueue  where  [TemplateVars]  like '%TC/PAN101/000045%'
--delete from EmailQueue  where emailqueueid=3531
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_LoanerTestEquipmentWarrantyEnd_EmailJob] 
  

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
	WHERE	NotificationTemplateId = 68

		
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
	
	insert into #TempUserEmails_all
	SELECT	DISTINCT		
		b.FacilityId,
		b.CustomerId,
		ltrim(rtrim(Email)) as EMAIL
	FROM	UMUserRegistration AS A	
			INNER JOIN UMUserLocationMstDet AS B ON A.UserRegistrationId = B.UserRegistrationId
	

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



	SELECT	a.AssetId,
			--TandCDocumentNo,
			a.Assetno,
			a.FacilityId,
			a.CustomerId,
			CompanyStaffId,			
			isnull((select email from  UMUserRegistration u where u.UserRegistrationId=a.CompanyStaffId ) ,'') 		
			as email,
			format(a.warrantyEnddate,'dd-MMM-yyyy') as  warrantyEnddate
			into #EngAsset
	FROM	EngAsset A					
	WHERE	A.active =1
	and  isnull(a.IsLoaner,0) = 1
	AND DATEDIFF(DD,A.warrantyEnddate,GETDATE()) = 7	




INSERT INTO EmailQueue(CustomerId,FacilityId,ToIds,CcIds,BccIds,ReplyIds,Subject,EmailTemplateId,TemplateVars,ContentBody,SendAsHtml,Priority,Status,TypeId,GroupId,
	QueuedOn,QueuedBy,SubjectVars,DataSource,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)
	SELECT A.CustomerId,A.FacilityId,isnull(A.email,'')+','+isnull(c.Email,'') as Email,null,NULL,NULL,b.Subject,B.NotificationTemplateId,
	A.Assetno,
	REPLACE(REPLACE([Definition],'{0}',A.Assetno),'{1}',isnull(a.warrantyEnddate,'7 days')),1,1,1,NULL,NULL,GETDATE(),
	NULL,'',0,1,GETDATE(),GETUTCDATE(),1,GETDATE(),GETUTCDATE() FROM #EngAsset A cross join  NotificationTemplate B
	left join #TempUserEmails c on a.CustomerId= c.CustomerId	 and a.FacilityId = c.FacilityId
	WHERE B.NotificationTemplateId = 68	
	and  not exists (select 1 from EmailQueue e  where  e.EmailTemplateId = 68	and  TemplateVars =a.Assetno)
	and len(isnull(A.email,'')+','+isnull(c.Email,'') )>5



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
