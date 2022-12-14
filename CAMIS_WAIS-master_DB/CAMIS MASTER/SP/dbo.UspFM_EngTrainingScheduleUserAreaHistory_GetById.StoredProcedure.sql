USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngTrainingScheduleUserAreaHistory_GetById]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngTrainingScheduleUserAreaHistory_GetById
Description			: To Get the UserArea details in popup
Authors				: Dhilip V
Date				: 21-Aug-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngTrainingScheduleUserAreaHistory_GetById] @pTrainingScheduleId=1

SELECT * FROM EngTrainingScheduleTxn
SELECT * FROM EngTrainingScheduleUserAreaHistory

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_EngTrainingScheduleUserAreaHistory_GetById]                           

  @pTrainingScheduleId		INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @TotalRecords INT
	DECLARE	@pTotalPage		NUMERIC(24,2)



	
   SELECT	TrainingScheduleAreaId,
			TrainingAreaHistory.TrainingScheduleId,
			TrainingAreaHistory.UserAreaId,
			UserArea.UserAreaCode,
			UserArea.UserAreaName,
			TrainingAreaHistory.Remarks
	FROM	EngTrainingScheduleTxn								AS TrainingSchedule
			INNER  JOIN	EngTrainingScheduleUserAreaHistory		AS TrainingAreaHistory		WITH(NOLOCK)	ON TrainingSchedule.TrainingScheduleId	= TrainingAreaHistory.TrainingScheduleId
			LEFT  JOIN  MstLocationUserArea						AS UserArea					WITH(NOLOCK)	ON TrainingAreaHistory.UserAreaId		= UserArea.UserAreaId
	WHERE	TrainingAreaHistory.TrainingScheduleId = @pTrainingScheduleId 
	ORDER BY TrainingAreaHistory.ModifiedDate DESC


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
