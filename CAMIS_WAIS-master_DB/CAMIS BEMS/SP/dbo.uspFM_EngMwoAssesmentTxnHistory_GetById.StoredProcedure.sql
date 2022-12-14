USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMwoAssesmentTxnHistory_GetById]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngMwoAssesmentTxnHistory_GetById
Description			: To Get the work order Assesment History
Authors				: Dhilip V
Date				: 20-Aug-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngMwoAssesmentTxnHistory_GetById] @pAssesmentId=85

SELECT * FROM EngMwoAssesmentTxn
SELECT * FROM EngMwoAssesmentFeedbackHistory
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngMwoAssesmentTxnHistory_GetById]                           

  @pAssesmentId			INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	SELECT	AssesmentHistoryId,
			FeedbackHistory.AssesmentId,
			FeedbackHistory.FeedBack,
			FeedbackHistory.ResponseDateTime,
			FeedbackHistory.ResponseDuration,
			UMUser.StaffName			AS	DoneBy,
			Designation.Designation		AS	DoneByDesignation,
			DoneDate
	FROM	EngMwoAssesmentFeedbackHistory		AS	FeedbackHistory	WITH(NOLOCK)
			INNER JOIN EngMwoAssesmentTxn		AS	MwoAssesment		WITH(NOLOCK) ON FeedbackHistory.AssesmentId	=	MwoAssesment.AssesmentId
			LEFT JOIN UMUserRegistration		AS	UMUser		WITH(NOLOCK) ON FeedbackHistory.DoneBy			=	UMUser.UserRegistrationId
			LEFT JOIN UserDesignation			AS	Designation	WITH(NOLOCK) ON UMUser.UserDesignationId	=	Designation.UserDesignationId
	WHERE	FeedbackHistory.AssesmentId	=	@pAssesmentId

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
