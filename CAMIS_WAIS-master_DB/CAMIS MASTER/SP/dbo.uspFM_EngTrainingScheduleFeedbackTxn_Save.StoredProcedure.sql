USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngTrainingScheduleFeedbackTxn_Save]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngTrainingScheduleFeedbackTxn_Save
Description			: Training Schedule Feedback details save.
Authors				: Dhilip V
Date				: 08-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC [uspFM_EngTrainingScheduleFeedbackTxn_Save] @pTrainingFeedbackId=0,@pCustomerId=1,@pFacilityId=1,@pServiceId=2,@pTrainingScheduleId=38,
@pCurriculum1=1,@pCurriculum2=1,@pCurriculum3=1,@pCurriculum4=1,@pCurriculum5=1,@pCourseIntructors1=1,@pCourseIntructors2=1,@pCourseIntructors3=1,@pTrainingDelivery1=1,
@pTrainingDelivery2=1,@pTrainingDelivery3=1,@pRecommendation='',@pUserId=1,@pTimestamp=null

SELECT * FROM EngTrainingScheduleTxn
SELECT * FROM EngTrainingScheduleFeedbackTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngTrainingScheduleFeedbackTxn_Save]
		@pTrainingFeedbackId	INT,
		@pCustomerId			INT,
		@pFacilityId			INT,
		@pServiceId				INT,
		@pTrainingScheduleId	INT,
		@pCurriculum1			INT				=	NULL,
		@pCurriculum2			INT				=	NULL,
		@pCurriculum3			INT				=	NULL,
		@pCurriculum4			INT				=	NULL,
		@pCurriculum5			INT				=	NULL,
		@pCourseIntructors1		INT				=	NULL,
		@pCourseIntructors2		INT				=	NULL,
		@pCourseIntructors3		INT				=	NULL,
		@pTrainingDelivery1		INT				=	NULL,
		@pTrainingDelivery2		INT				=	NULL,
		@pTrainingDelivery3		INT				=	NULL,
		@pRecommendation		NVARCHAR(500)	=	NULL,
		@pUserId				INT				= NULL,
		@pTimestamp				VARBINARY(200)	=	NULL

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)


-- Default Values


-- Execution

    IF(ISNULL(@pTrainingFeedbackId,0)=0 OR @pTrainingFeedbackId='')

	BEGIN


		   INSERT INTO EngTrainingScheduleFeedbackTxn(	CustomerId,
														FacilityId,
														ServiceId,
														TrainingScheduleId,
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
														CreatedBy,
														CreatedDate,
														CreatedDateUTC,
														ModifiedBy,
														ModifiedDate,
														ModifiedDateUTC
													 )	OUTPUT INSERTED.TrainingFeedbackId INTO @Table
							 VALUES					(	@pCustomerId,		
														@pFacilityId,			
														@pServiceId,			
														@pTrainingScheduleId,
														@pCurriculum1,
														@pCurriculum2,		
														@pCurriculum3,		
														@pCurriculum4,		
														@pCurriculum5,		
														@pCourseIntructors1,	
														@pCourseIntructors2,		
														@pCourseIntructors3,		
														@pTrainingDelivery1,		
														@pTrainingDelivery2,		
														@pTrainingDelivery3,		
														@pRecommendation,	
														@pUserId,											
														GETDATE(), 
														GETUTCDATE(),
														@pUserId,													
														GETDATE(), 
														GETUTCDATE()
													)


			   	   SELECT				TrainingFeedbackId,
										[Timestamp],
										''	ErrorMessage
				   FROM					EngTrainingScheduleFeedbackTxn
				   WHERE				TrainingFeedbackId IN (SELECT ID FROM @Table)
	
		
		END

		
			
  ELSE

	  BEGIN
	--			DECLARE @mTimestamp varbinary(200);
	--			SELECT	@mTimestamp = Timestamp FROM	EngTrainingScheduleFeedbackTxn 
	--			WHERE	TrainingFeedbackId	=	@pTrainingFeedbackId

	--			IF (@mTimestamp=@pTimestamp)
				
	--BEGIN
				UPDATE EngTrainingScheduleFeedbackTxn SET	CustomerId			=	@pCustomerId,
															FacilityId			=	@pFacilityId,
															ServiceId			=	@pServiceId,
															TrainingScheduleId	=	@pTrainingScheduleId,
															Curriculum1			=	@pCurriculum1,
															Curriculum2			=	@pCurriculum2,
															Curriculum3			=	@pCurriculum3,
															Curriculum4			=	@pCurriculum4,
															Curriculum5			=	@pCurriculum5,
															CourseIntructors1	=	@pCourseIntructors1,
															CourseIntructors2	=	@pCourseIntructors2,
															CourseIntructors3	=	@pCourseIntructors3,
															TrainingDelivery1	=	@pTrainingDelivery1,
															TrainingDelivery2	=	@pTrainingDelivery2,
															TrainingDelivery3	=	@pTrainingDelivery3,
															Recommendation		=	@pRecommendation,
															ModifiedBy			=	@pUserId,
															ModifiedDate		=	GETDATE(),
															ModifiedDateUTC		=	GETUTCDATE()
											WHERE	TrainingFeedbackId	=	@pTrainingFeedbackId

   --     END   
		
			--	ELSE
			--BEGIN
				SELECT	TrainingFeedbackId,
						[Timestamp],							
						'Record Modified. Please Re-Select' AS ErrorMessage
				FROM	EngTrainingScheduleFeedbackTxn
				WHERE	TrainingFeedbackId =@pTrainingScheduleId
			--END

END

			  


	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT TRANSACTION
        END   


END TRY

BEGIN CATCH

	IF @mTRANSCOUNT = 0
        BEGIN
            ROLLBACK TRAN
        END

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
