USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngTrainingScheduleTxn_GetById]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngTrainingScheduleTxn_GetById
Description			: To Get the data from table EngMaintenanceWorkOrderTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngTrainingScheduleTxn_GetById] @pTrainingScheduleId=274,@pPageIndex=1,@pPageSize=5,@pUserId=1
SELECT * FROM EngTrainingScheduleTxn
SELECT * FROM EngTrainingScheduleFeedbackTxn
select * from EngTrainingScheduleUserAreaHistory
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngTrainingScheduleTxn_GetById]                           
  @pUserId					INT	=	NULL,
  @pTrainingScheduleId		INT,
  @pPageIndex				INT,
  @pPageSize				INT	

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @TotalRecords INT
	DECLARE	@pTotalPage		NUMERIC(24,2)
	DECLARE @TotalRecords1 INT
	DECLARE	@pTotalPage1		NUMERIC(24,2)
	DECLARE @pCustomerEmailId NVARCHAR(MAX)
	DECLARE @pFacilityEmailId NVARCHAR(MAX)
	DECLARE @pPresenterEmailId NVARCHAR(MAX)
	DECLARE @pCombineEmailId NVARCHAR(MAX)

	IF(ISNULL(@pTrainingScheduleId,0) = 0) RETURN

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
	WHERE	TrainingSchedule.TrainingScheduleId = @pTrainingScheduleId

	
	SET @pCustomerEmailId = (SELECT CustomerEmailId + ',' FROM #EmailIdResult FOR XML PATH(''))
	SET @pFacilityEmailId = (SELECT FacilityEmailId + ',' FROM #EmailIdResult FOR XML PATH(''))
	SET @pPresenterEmailId = (select email from EngTrainingScheduleTxn where TrainingScheduleId = @pTrainingScheduleId)
	SET @pCombineEmailId = @pCustomerEmailId + @pFacilityEmailId + @pPresenterEmailId

	declare @pCustomerId  varchar(500),@pFacilityid varchar(500), @alluserids varchar(500)

	SET @pCustomerId = (SELECT cast(CustomerUserId as varchar(50)) + ',' FROM #EmailIdResult FOR XML PATH(''))
	SET @pFacilityid = (SELECT  cast(FacilityUserId as varchar(50)) + ',' FROM #EmailIdResult FOR XML PATH(''))
	SET @alluserids = isnull(@pCustomerId,'')+',' + isnull(@pFacilityid,'')


	SELECT	@TotalRecords	=	COUNT(*)
	FROM	EngTrainingScheduleTxn								AS TrainingSchedule
			INNER JOIN	EngTrainingScheduleTxnDet				AS TrainingScheduleDet				WITH(NOLOCK)			on TrainingSchedule.TrainingScheduleId		= TrainingScheduleDet.TrainingScheduleId
			LEFT  JOIN  UMUserRegistration						AS ParticipantsUserId				WITH(NOLOCK)			on TrainingScheduleDet.ParticipantsUserId	= ParticipantsUserId.UserRegistrationId
			LEFT  JOIN  UserDesignation							AS Designation						WITH(NOLOCK)			on ParticipantsUserId.UserDesignationId		= Designation.UserDesignationId
			LEFT  JOIN  MstLocationUserArea						AS UserArea							WITH(NOLOCK)			on TrainingScheduleDet.UserAreaId			= UserArea.UserAreaId			
	WHERE	TrainingSchedule.TrainingScheduleId = @pTrainingScheduleId   

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPage = CEILING(@pTotalPage)

    SELECT	TrainingSchedule.TrainingScheduleId					AS TrainingScheduleId,
			TrainingSchedule.CustomerId							AS CustomerId,
			TrainingSchedule.FacilityId							AS FacilityId,
			Facility.FacilityCode								AS FacilityCode,		
			TrainingSchedule.ServiceId							AS ServiceId,
			ServiceKey.ServiceKey								AS ServiceKeyValue,
			TrainingSchedule.TrainingScheduleNo					AS TrainingScheduleNo,
			TrainingSchedule.TrainingDescription				AS TrainingDescription,
			TrainingSchedule.TrainingType						AS TrainingType,
			TrainingType.FieldValue								AS TrainingTypeValue,
			TrainingSchedule.PlannedDate						AS PlannedDate,
			TrainingSchedule.PlannedDateUTC						AS PlannedDateUTC,
			TrainingSchedule.[Year]								AS [Year],
			TrainingSchedule.[Quarter]							AS [Quarter],
			QuarterId.FieldValue								AS QuarterValue,
			TrainingSchedule.TrainingModule						AS TrainingModule,
			TrainingSchedule.MinimumNoOfParticipants			AS MinimumNoOfParticipants,
			TrainingSchedule.ActualDate							AS ActualDate,
			TrainingSchedule.ActualDateUTC						AS ActualDateUTC,
			TrainingSchedule.TrainingStatus						AS TrainingStatus,
			TrainingStatus.FieldValue							AS TrainingStatusValue,
			TrainingSchedule.TrainerSource						AS TrainerSource,
			TrainerSource.FieldValue							AS TrainerSourceValue,
			TrainingSchedule.TrainerStaffExperience				AS TrainerStaffExperience,
			--TrainingSchedule.TotalParticipants					AS TotalParticipants,
			ISNULL(@TotalRecords,0)	AS TotalParticipants,
			TrainingSchedule.Venue								AS Venue,
			TrainingSchedule.TrainingRescheduleDate				AS TrainingRescheduleDate,
			TrainingSchedule.TrainingRescheduleDateUTC			AS TrainingRescheduleDateUTC,
			--TrainingSchedule.OverallEffectiveness				AS OverallEffectiveness,
			CAST(TotEff.OverAllEff	AS numeric(24,2))			AS OverallEffectiveness,
			TrainingSchedule.Remarks							AS Remarks,
			TrainingSchedule.TrainerUserId						AS TrainerUserId,
			TrainingSchedule.TrainerUserName					AS TrainerUserName,
			TrainingSchedule.Designation						AS Designation,
			--TrainingScheduleDet.TrainingScheduleDetId			AS TrainingScheduleDetId,
			--TrainingScheduleDet.CustomerId						AS CustomerId,
			--TrainingScheduleDet.FacilityId						AS FacilityId,
			--TrainingScheduleDet.ServiceId						AS ServiceId,
			--TrainingScheduleDet.TrainingScheduleId				AS TrainingScheduleId,
			--TrainingScheduleDet.ParticipantsUserId				AS ParticipantsUserId,
			--ParticipantsUserId.StaffName						AS ParticipantsUserValue,
			--Designation.Designation								AS ParticipantsUserDesignationValue,
			--TrainingScheduleDet.UserAreaId						AS UserAreaId,
			--UserArea.UserAreaCode								AS UserAreaIdCode,
			--UserArea.UserAreaName								AS UserAreaIdName,
			--TrainingScheduleDet.Remarks							AS Remarks,
			TrainingSchedule.Timestamp							AS Timestamp,
			TrainingSchedule.GuId,
			ISNULL(IsConfirmed,0)								AS IsConfirmed,
			CASE WHEN TrainingSchedule.TrainingRescheduleDate IS NULL THEN 0
			ELSE 1
			END IsRescheduled,
			Email,
			NotificationDate,
			CAST(PlanDate.IsPlannedDate AS BIT) IsPlannedDate,
			@pCombineEmailId AS UserMailId,
			@alluserids as AllUserId
			--@TotalRecords										AS TotalRecords,
			--@pTotalPage											AS TotalPageCalc
	FROM	EngTrainingScheduleTxn								AS TrainingSchedule
			--LEFT  JOIN	EngTrainingScheduleTxnDet				AS TrainingScheduleDet				WITH(NOLOCK)			on TrainingSchedule.TrainingScheduleId		= TrainingScheduleDet.TrainingScheduleId
			INNER JOIN	MstLocationFacility						AS Facility							WITH(NOLOCK)			on TrainingSchedule.FacilityId		= Facility.FacilityId
			INNER JOIN  MstService								AS ServiceKey						WITH(NOLOCK)			on TrainingSchedule.ServiceId				= ServiceKey.ServiceId
			LEFT  JOIN  FMLovMst								AS TrainingType						WITH(NOLOCK)			on TrainingSchedule.TrainingType			= TrainingType.LovId
			LEFT  JOIN  FMLovMst								AS QuarterId						WITH(NOLOCK)			on TrainingSchedule.Quarter					= QuarterId.LovId
			LEFT  JOIN  FMLovMst								AS TrainingStatus					WITH(NOLOCK)			on TrainingSchedule.TrainingStatus			= TrainingStatus.LovId
			LEFT  JOIN  FMLovMst								AS TrainerSource					WITH(NOLOCK)			on TrainingSchedule.TrainerSource			= TrainerSource.LovId
			--LEFT  JOIN  UMUserRegistration						AS ParticipantsUserId				WITH(NOLOCK)			on TrainingScheduleDet.ParticipantsUserId	= ParticipantsUserId.UserRegistrationId
			--LEFT  JOIN  UserDesignation							AS Designation						WITH(NOLOCK)			on ParticipantsUserId.UserDesignationId		= Designation.UserDesignationId
			--LEFT  JOIN  MstLocationUserArea						AS UserArea							WITH(NOLOCK)			on TrainingScheduleDet.UserAreaId			= UserArea.UserAreaId
			OUTER APPLY (	SELECT TrainingScheduleId, (CAST(SUM(Curriculum1+Curriculum2+Curriculum3+Curriculum4+Curriculum5+CourseIntructors1+CourseIntructors2+CourseIntructors3+TrainingDelivery1+TrainingDelivery2+
							TrainingDelivery3) AS NUMERIC(24,2)) / 55.00 ) *  100.00 OverAllEff
							FROM EngTrainingScheduleFeedbackTxn AS Feedback WHERE TrainingSchedule.TrainingScheduleId	=	Feedback.TrainingScheduleId
							GROUP BY Feedback.TrainingScheduleId
						) TotEff
			OUTER APPLY (	SELECT	CASE WHEN CAST(PlannedDate AS DATE) < CAST(GETDATE() AS DATE) THEN 0
									ELSE 1 END AS IsPlannedDate
							FROM	EngTrainingScheduleTxn AS EngTrain where TrainingSchedule.TrainingScheduleId = EngTrain.TrainingScheduleId
						) PlanDate
	WHERE	TrainingSchedule.TrainingScheduleId = @pTrainingScheduleId 
	ORDER BY TrainingSchedule.ModifiedDate ASC



	
   SELECT	TrainingScheduleDetId,
			TrainingSchedule.TrainingScheduleId					AS TrainingScheduleId,
			TrainingSchedule.TrainingScheduleNo					AS TrainingScheduleNo,
			TrainingScheduleDet.ParticipantsUserId				AS ParticipantsUserId,
			ParticipantsUserId.StaffName						AS ParticipantsUserValue,
			Designation.Designation								AS ParticipantsUserDesignationValue,
			TrainingScheduleDet.UserAreaId						AS UserAreaId,
			UserArea.UserAreaCode								AS UserAreaIdCode,
			UserArea.UserAreaName								AS UserAreaIdName,
			TrainingScheduleDet.Remarks							AS Remarks,
			TrainingSchedule.IsConfirmed,
			@TotalRecords										AS TotalRecords,
			@pTotalPage											AS TotalPageCalc
	FROM	EngTrainingScheduleTxn								AS TrainingSchedule
			INNER  JOIN	EngTrainingScheduleTxnDet				AS TrainingScheduleDet				WITH(NOLOCK)			on TrainingSchedule.TrainingScheduleId		= TrainingScheduleDet.TrainingScheduleId
			LEFT  JOIN  UMUserRegistration						AS ParticipantsUserId				WITH(NOLOCK)			on TrainingScheduleDet.ParticipantsUserId	= ParticipantsUserId.UserRegistrationId
			LEFT  JOIN  UserDesignation							AS Designation						WITH(NOLOCK)			on ParticipantsUserId.UserDesignationId		= Designation.UserDesignationId
			LEFT  JOIN  MstLocationUserArea						AS UserArea							WITH(NOLOCK)			on TrainingScheduleDet.UserAreaId			= UserArea.UserAreaId
			
	WHERE	TrainingSchedule.TrainingScheduleId = @pTrainingScheduleId 
	ORDER BY TrainingSchedule.ModifiedDate ASC
	OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY


		SELECT	@TotalRecords1	=	COUNT(*)
	FROM	EngTrainingScheduleTxn								AS TrainingSchedule
			INNER JOIN	EngTrainingScheduleTxnDet				AS TrainingScheduleDet				WITH(NOLOCK)			on TrainingSchedule.TrainingScheduleId			= TrainingScheduleDet.TrainingScheduleId
			INNER JOIN  EngTrainingScheduleUserAreaHistory		AS UserAreaHistory					WITH(NOLOCK)			on TrainingSchedule.TrainingScheduleId			= UserAreaHistory.TrainingScheduleId			
			LEFT  JOIN  MstLocationUserArea						AS UserArea							WITH(NOLOCK)			on UserAreaHistory.UserAreaId					= UserArea.UserAreaId			
			LEFT  JOIN  UMUserRegistration						AS CustomerUserId					WITH(NOLOCK)			on UserArea.CustomerUserId						= CustomerUserId.UserRegistrationId
			LEFT  JOIN  UMUserRegistration						AS FacilityUserId					WITH(NOLOCK)			on UserArea.FacilityUserId						= FacilityUserId.UserRegistrationId
	WHERE	TrainingSchedule.TrainingScheduleId = @pTrainingScheduleId  

	SET @pTotalPage1 = CAST(@TotalRecords1 AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPage1 = CEILING(@pTotalPage1)

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
			FacilityUserId.Email AS FacilityEmailId,
			@TotalRecords1										AS TotalRecords,
			@pTotalPage1										AS TotalPageCalc
	FROM	EngTrainingScheduleTxn								AS TrainingSchedule
			LEFT  JOIN  EngTrainingScheduleUserAreaHistory		AS UserAreaHistory					WITH(NOLOCK)			on TrainingSchedule.TrainingScheduleId			= UserAreaHistory.TrainingScheduleId			
			LEFT  JOIN  MstLocationUserArea						AS UserArea							WITH(NOLOCK)			on UserAreaHistory.UserAreaId					= UserArea.UserAreaId			
			LEFT  JOIN  UMUserRegistration						AS CustomerUserId					WITH(NOLOCK)			on UserArea.CustomerUserId						= CustomerUserId.UserRegistrationId
			LEFT  JOIN  UMUserRegistration						AS FacilityUserId					WITH(NOLOCK)			on UserArea.FacilityUserId						= FacilityUserId.UserRegistrationId
	WHERE	TrainingSchedule.TrainingScheduleId = @pTrainingScheduleId
	ORDER BY TrainingSchedule.ModifiedDate ASC
	OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY  

END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
