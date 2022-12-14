USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_QAPCarTxnTargetDate_Job]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_FMLovMst_GetById
Description			: To Get the data from table EngStockUpdateRegisterTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_QAPCarTxnTargetDate_Job
SELECT * FROM FMLovMst
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_QAPCarTxnTargetDate_Job] 
  

AS


BEGIN TRY

	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

IF EXISTS (SELECT 1 FROM QAPCarTxn WHERE CAST(CARTargetDate AS DATE)  = Cast(CONVERT(DATE, GETDATE() +7) as DATE)
)
BEGIN

	SELECT CARTXN.CarId,
				CARTXN.CustomerId,
				CARTXN.FacilityId,
				CARTXN.ServiceId,
				CARTXN.CARNumber,
				CARTXN.CARTargetDate,
				CARTXN.ASSIGNEDUSERID
		 INTO #ResultSet FROM QAPCarTxn CARTXN WHERE CAST(CARTargetDate AS DATE) = Cast(CONVERT(DATE, GETDATE() +7) as DATE)



	ALTER TABLE #ResultSet ADD TemPlateVars nvarchar(max)

		SELECT	CARTXN.CarId,
				CARTXN.CustomerId,
				CARTXN.FacilityId,
				CARTXN.ServiceId,
				CARTXN.CARNumber,
				CARTXN.CARTargetDate,
				ASSIGNEDUSERID.UserRegistrationId,
				ASSIGNEDUSERID.StaffName AS AssignedStaffName,
				ASSIGNEDUSERID.Email AS AssignedEmailId
		INTO    #EmailIdResult 
		FROM	#ResultSet								            AS CARTXN
				INNER  JOIN  UMUserRegistration						AS ASSIGNEDUSERID					WITH(NOLOCK)			on CARTXN.ASSIGNEDUSERID						= ASSIGNEDUSERID.UserRegistrationId


if not exists (select 1 from EmailQueue where EmailTemplateId = 26 and 	cast(QueuedOn	 as date) = cast( getdate() as date))
begin

	INSERT INTO EmailQueue(CustomerId,FacilityId,ToIds,CcIds,BccIds,ReplyIds,Subject,EmailTemplateId,TemplateVars,ContentBody,SendAsHtml,Priority,Status,TypeId,GroupId,
	QueuedOn,QueuedBy,SubjectVars,DataSource,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)
	SELECT A.CustomerId,A.FacilityId,C.AssignedEmailId,NULL,NULL,NULL,b.Subject,B.NotificationTemplateId,
	isnull(C.AssignedStaffName+','+CAST(FORMAT(A.CARTargetDate,'dd-MMM-yyyy')AS NVARCHAR(100))+','+A.CARNumber,''),
	REPLACE(REPLACE(REPLACE([Definition],'{2}',A.CARNumber),'{1}', CAST(FORMAT(A.CARTargetDate,'dd-MMM-yyyy')AS NVARCHAR(100))),'{0}',C.AssignedStaffName),1,1,1,NULL,NULL,GETDATE(),
	NULL,'',0,1,GETDATE(),GETUTCDATE(),1,GETDATE(),GETUTCDATE() FROM #ResultSet A, NotificationTemplate B,
	#EmailIdResult C
	WHERE B.NotificationTemplateId = 26
END

if not exists (select 1 from EmailQueue where EmailTemplateId = 27 and 	cast(QueuedOn	 as date) = cast( getdate() as date))
begin

	SELECT		CARTXN.CustomerId,
				CARTXN.FacilityId,	
				STUFF((SELECT '<tr><td>' + CAST(t.CARNumber AS VARCHAR(max)) +'</td><td>'+ CAST(FORMAT(t.CARTargetDate,'dd-MMM-yyyy')AS NVARCHAR(100)) +'</td></tr>'
				FROM #ResultSet t
				WHERE CARTXN.CustomerId = t.CustomerId and CARTXN.FacilityId=t.FacilityId
				FOR XML PATH(''), TYPE).value ('.','NVARCHAR(MAX)'),1,0,' ')	as CARNumber,

				--STUFF((SELECT ', ' + CAST(FORMAT(t.CARTargetDate,'dd-MMM-yyyy')AS NVARCHAR(100)) [text()]
				--FROM #ResultSet t
				--WHERE CARTXN.CustomerId = t.CustomerId and CARTXN.FacilityId=t.FacilityId
				--FOR XML PATH(''), TYPE).value ('.','NVARCHAR(MAX)'),1,2,' ')	as CARTargetDate,	
				STUFF((SELECT distinct ', ' + CAST(t1.Email AS VARCHAR(max)) [text()]
				FROM UMUserRegistration t1 with (nolock)
				INNER JOIN UMUserLocationMstDet T2  with (nolock)  ON T1.UserRegistrationId = T2.UserRegistrationId
				INNER JOIN MstLocationFacility  T3  with (nolock)  ON T2.FacilityId = T3.FacilityId
				WHERE CARTXN.CustomerId = t3.CustomerId and CARTXN.FacilityId=t2.FacilityId
				and UserDesignationId = 3 and Email is not null
				FOR XML PATH(''), TYPE).value ('.','NVARCHAR(MAX)'),1,2,' ')	as FacilityManagerEmail
				into #ResultSet_FacilityManager
		FROM	#ResultSet								AS CARTXN						
		group by CARTXN.CustomerId,
				CARTXN.FacilityId
				
	INSERT INTO EmailQueue(CustomerId,FacilityId,ToIds,CcIds,BccIds,ReplyIds,Subject,EmailTemplateId,TemplateVars,ContentBody,SendAsHtml,Priority,Status,TypeId,GroupId,
	QueuedOn,QueuedBy,SubjectVars,DataSource,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)
	SELECT A.CustomerId,A.FacilityId,A.FacilityManagerEmail,NULL,NULL,NULL,b.Subject,B.NotificationTemplateId,'',
	REPLACE([Definition],'{0}',A.CARNumber),1,1,1,NULL,NULL,GETDATE(),
	NULL,'',0,1,GETDATE(),GETUTCDATE(),1,GETDATE(),GETUTCDATE() 
	FROM #ResultSet_FacilityManager A ,  NotificationTemplate B  
	WHERE B.NotificationTemplateId = 27

END

END

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
