USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_AssetWarrantyEndDateRenewalNotice_Job]    Script Date: 20-09-2021 17:05:51 ******/
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
EXEC [uspFM_AssetWarrantyEndDateRenewalNotice_Job]
SELECT * FROM FMLovMst
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_AssetWarrantyEndDateRenewalNotice_Job] 
  

AS                                              

BEGIN TRY

	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

IF EXISTS (SELECT 1 FROM EngAsset A INNER JOIN MstLocationFacility B ON A.FacilityId = B.FacilityId WHERE CAST(WarrantyEndDate AS DATE) = DATEADD(DD,ISNULL(B.WarrantyRenewalNoticeDays,0),CAST(GETDATE() AS DATE)))
BEGIN

SELECT A.*,B.FacilityCode,B.FacilityName INTO #ResultSet FROM EngAsset A INNER JOIN MstLocationFacility B ON A.FacilityId = B.FacilityId WHERE CAST(WarrantyEndDate AS DATE) =  DATEADD(DD,ISNULL(B.WarrantyRenewalNoticeDays,0),CAST(GETDATE() AS DATE))



SELECT			CARTXN.CustomerId,
				CARTXN.FacilityId,	
				STUFF((SELECT '<tr><td>' + CAST(t.FacilityCode AS VARCHAR(max)) 
				+'</td><td>'+ CAST(t.FacilityName AS VARCHAR(max)) +'</td><td>'+ CAST(t.AssetNo AS VARCHAR(max)) +'</td><td>'+CAST(t.AssetDescription AS VARCHAR(max)) +'</td><td>'+FORMAT(CAST(t.WarrantyEndDate AS date),'dd-MMM-yyyy') +'</td></tr>'
				FROM #ResultSet t
				WHERE CARTXN.CustomerId = t.CustomerId and CARTXN.FacilityId=t.FacilityId
				FOR XML PATH(''), TYPE).value ('.','NVARCHAR(MAX)'),1,0,' ')	as AssetInfo,
				
				STUFF((SELECT distinct ', ' + CAST(t1.Email AS VARCHAR(max)) [text()]
				FROM UMUserRegistration t1 with (nolock)
				INNER JOIN UMUserLocationMstDet T2  with (nolock)  ON T1.UserRegistrationId = T2.UserRegistrationId
				INNER JOIN MstLocationFacility  T3  with (nolock)  ON T2.FacilityId = T3.FacilityId
				WHERE CARTXN.CustomerId = t3.CustomerId and CARTXN.FacilityId=t2.FacilityId
				and T1.UserDesignationId = 3 and T1.Email is not null
				FOR XML PATH(''), TYPE).value ('.','NVARCHAR(MAX)'),1,2,' ')	as FacilityManagerEmail
				into #ResultSet_FacilityManager
		FROM	#ResultSet								AS CARTXN						
		group by CARTXN.CustomerId,
				CARTXN.FacilityId



INSERT INTO EmailQueue(CustomerId,FacilityId,ToIds,CcIds,BccIds,ReplyIds,Subject,EmailTemplateId,TemplateVars,ContentBody,SendAsHtml,
Priority,Status,TypeId,GroupId,QueuedOn,QueuedBy,SubjectVars,DataSource,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)
SELECT A.CustomerId,A.FacilityId,A.FacilityManagerEmail,NULL,NULL,NULL,b.Subject,B.NotificationTemplateId,'',REPLACE(B.Definition,'{0}',A.AssetInfo),1,1,1,NULL,NULL,GETDATE(),
NULL,'',0,1,GETDATE(),GETUTCDATE(),1,GETDATE(),GETUTCDATE() FROM #ResultSet_FacilityManager A, NotificationTemplate B
WHERE B.NotificationTemplateId = 31 




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
