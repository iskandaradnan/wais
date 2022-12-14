USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngTrainingScheduleTxn_Job]    Script Date: 20-09-2021 16:56:53 ******/
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
EXEC [uspFM_EngTrainingScheduleTxn_Job]
SELECT * FROM FMLovMst
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngTrainingScheduleTxn_Job] 
  

AS                                              

BEGIN TRY

	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

IF EXISTS (SELECT 1 FROM EngTrainingScheduleTxn WHERE CAST(NotificationDate AS DATE) = CAST(GETDATE() AS DATE))
BEGIN

SELECT * INTO #ResultSet FROM EngTrainingScheduleTxn WHERE CAST(NotificationDate AS DATE) = CAST(GETDATE() AS DATE) AND (IsMailSent =0 OR IsMailSent IS NULL)

ALTER TABLE #ResultSet ADD CombineEmailId nvarchar(max)
ALTER TABLE #ResultSet ADD TemPlateVars nvarchar(max)

	SELECT	UserAreaHistory.TrainingScheduleAreaId,
			UserAreaHistory.TrainingScheduleId,
			UserAreaHistory.UserAreaId,
			UserArea.UserAreaCode,
			UserArea.UserAreaName,
			UserArea.Remarks,
			UserArea.CustomerUserId,
			CustomerUserId.StaffName AS CustomerStaffName,
			CustomerUserId.Email AS CustomerEmailId,
			UserArea.FacilityUserId,
			FacilityUserId.StaffName AS FacilityStaffName,
			FacilityUserId.Email AS FacilityEmailId
	INTO    #EmailIdResult
	FROM	EngTrainingScheduleTxn								AS TrainingSchedule
			LEFT  JOIN  EngTrainingScheduleUserAreaHistory		AS UserAreaHistory					WITH(NOLOCK)			on TrainingSchedule.TrainingScheduleId			= UserAreaHistory.TrainingScheduleId			
			LEFT  JOIN  MstLocationUserArea						AS UserArea							WITH(NOLOCK)			on UserAreaHistory.UserAreaId					= UserArea.UserAreaId			
			LEFT  JOIN  UMUserRegistration						AS CustomerUserId					WITH(NOLOCK)			on UserArea.CustomerUserId						= CustomerUserId.UserRegistrationId
			LEFT  JOIN  UMUserRegistration						AS FacilityUserId					WITH(NOLOCK)			on UserArea.FacilityUserId						= FacilityUserId.UserRegistrationId
	WHERE UserAreaHistory.TrainingScheduleId IS NOT NULL

		SELECT  TrainingScheduleId
       ,STUFF((SELECT ', ' + CAST(CustomerEmailId AS VARCHAR(max)) [text()]
         FROM #EmailIdResult 
         WHERE TrainingScheduleId = t.TrainingScheduleId
         FOR XML PATH(''), TYPE)
        .value('.','NVARCHAR(MAX)'),1,2,' ') CustomerEmailId
		,STUFF((SELECT ', ' + CAST(FacilityEmailId AS VARCHAR(max)) [text()]
         FROM #EmailIdResult 
         WHERE TrainingScheduleId = t.TrainingScheduleId
         FOR XML PATH(''), TYPE)
        .value('.','NVARCHAR(MAX)'),1,2,' ') FacilityEmailId 
		into #EmailIdSeparation
		FROM #EmailIdResult t
		GROUP BY TrainingScheduleId

alter table #EmailIdSeparation add CombineEmailId nvarchar(max)

Update #EmailIdSeparation set CombineEmailId = CustomerEmailId+','+FacilityEmailId



UPDATE A SET A.CombineEmailId = B.CombineEmailId FROM #ResultSet A INNER JOIN #EmailIdSeparation B ON A.TrainingScheduleId = B.TrainingScheduleId
UPDATE #ResultSet SET TemPlateVars = CAST(FORMAT(NotificationDate,'dd-MMM-yyyy')AS NVARCHAR(100))+','+TrainingScheduleNo

INSERT INTO EmailQueue(CustomerId,FacilityId,ToIds,CcIds,BccIds,ReplyIds,Subject,EmailTemplateId,TemplateVars,ContentBody,SendAsHtml,Priority,Status,
TypeId,GroupId,QueuedOn,QueuedBy,SubjectVars,DataSource,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)
SELECT A.CustomerId,A.FacilityId,A.CombineEmailId,NULL,NULL,NULL,b.Subject,B.NotificationTemplateId,TemPlateVars,REPLACE(REPLACE(b.Definition,'{1}',A.TrainingScheduleNo),'{0}',FORMAT(A.NotificationDate,'dd-MMM-yyyy')),1,1,1,NULL,NULL,GETDATE(),
NULL,'',0,A.CreatedBy,GETDATE(),GETUTCDATE(),A.ModifiedBy,GETDATE(),GETUTCDATE() FROM #ResultSet A, NotificationTemplate B
WHERE B.NotificationTemplateId = 25 AND A.TrainingScheduleId IS NOT NULL AND A.CombineEmailId IS NOT NULL


UPDATE A SET A.IsMailSent =1 FROM EngTrainingScheduleTxn A INNER JOIN #ResultSet B ON A.TrainingScheduleId = B.TrainingScheduleId 


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
