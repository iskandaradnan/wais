USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngTrainingScheduleFeedbackTxn_GetById]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngTrainingScheduleFeedbackTxn_GetById
Description			: To Get Training Schedule Feedback Details
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngTrainingScheduleFeedbackTxn_GetById] @pTrainingScheduleId=38
SELECT * FROM EngTrainingScheduleFeedbackTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngTrainingScheduleFeedbackTxn_GetById]                           

  @pTrainingScheduleId					INT 
AS                                              

BEGIN TRY


	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF(ISNULL(@pTrainingScheduleId,0) = 0) RETURN

	SELECT	TrainingFeedback.TrainingFeedbackId,
			TrainingFeedback.CustomerId,
			TrainingFeedback.FacilityId,
			TrainingFeedback.ServiceId,
			TrainingFeedback.TrainingScheduleId,
			Curriculum1,
			Curriculum2,
			Curriculum3,
			Curriculum4,
			Curriculum5,
			CourseIntructors1,
			CourseIntructors2,
			CourseIntructors3,
			TrainingDelivery1,
			TrainingDelivery2,
			TrainingDelivery3,
			Recommendation,
			TrainingFeedback.Timestamp
	FROM	EngTrainingScheduleFeedbackTxn			AS	TrainingFeedback	WITH(NOLOCK)
			INNER JOIN EngTrainingScheduleTxn		AS	Training			WITH(NOLOCK)	ON	TrainingFeedback.TrainingScheduleId	=	Training.TrainingScheduleId
	WHERE	TrainingFeedback.TrainingScheduleId	=	@pTrainingScheduleId
	ORDER BY TrainingFeedback.ModifiedDate DESC
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
