USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_CRMRequestAssessment_GetById]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_CRMRequestAssessment_GetById
Description			: To Get the data from table EngMwoAssesmentTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_CRMRequestAssessment_GetById] @pCRMRequestWOId=3,@pUserId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_CRMRequestAssessment_GetById]                           
  @pUserId				INT	=	NULL,
  @pCRMRequestWOId		INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	IF(ISNULL(@pCRMRequestWOId,0) = 0) RETURN


	SELECT	CRMAssesment.CRMAssesmentId							AS CRMAssesmentId,
			CRMAssesment.CustomerId								AS CustomerId,
			CRMAssesment.FacilityId								AS FacilityId,
			CRMAssesment.ServiceId								AS ServiceId,
			ServiceKey.ServiceKey								AS ServiceValue,
			CRMAssesment.CRMRequestWOId							AS CRMRequestWOId,
			CRMMaintenanceWorkOrder.CRMWorkOrderNo				AS CRMWorkOrderNo,
			CRMMaintenanceWorkOrder.CRMWorkOrderDateTime		AS CRMWorkOrderDateTime,
			CRMAssesment.UserId									AS StaffMasterId,
			--StaffMasterId.StaffEmployeeId						AS StaffMasterId,
			StaffMasterId.StaffName								AS StaffName,
			StaffDesignation.Designation						AS StaffDesignation,
			CRMAssesment.FeedBack								AS FeedBack,
			CRMAssesment.AssessmentStartDateTime				AS AssessmentStartDateTime,
			CRMAssesment.AssessmentStartDateTimeUTC				AS AssessmentStartDateTimeUTC,
			CRMAssesment.AssessmentEndDateTime					AS AssessmentEndDateTime,
			CRMAssesment.AssessmentEndDateTimeUTC				AS AssessmentEndDateTimeUTC,
			CRMAssesment.ResponseDuration						AS ResponseDuration,
			CRMAssesment.[Timestamp]							AS [Timestamp],
			CRMMaintenanceWorkOrder.Status,
			Status.FieldValue									AS StatusValue
	FROM	CRMRequestAssessment								AS CRMAssesment
			INNER JOIN	CRMRequestWorkOrderTxn					AS CRMMaintenanceWorkOrder			WITH(NOLOCK)			on CRMAssesment.CRMRequestWOId		= CRMMaintenanceWorkOrder.CRMRequestWOId
			INNER JOIN  MstService								AS ServiceKey						WITH(NOLOCK)			on CRMAssesment.ServiceId			= ServiceKey.ServiceId
			LEFT  JOIN  UMUserRegistration						AS StaffMasterId					WITH(NOLOCK)			on CRMAssesment.UserId				= StaffMasterId.UserRegistrationId
			LEFT  JOIN  UserDesignation							AS StaffDesignation					WITH(NOLOCK)			on StaffMasterId.UserDesignationId	= StaffDesignation.UserDesignationId
			LEFT  JOIN  FMLovMst								AS Status							WITH(NOLOCK)			on CRMMaintenanceWorkOrder.Status	= Status.LovId
	WHERE	CRMAssesment.CRMRequestWOId = @pCRMRequestWOId
	ORDER BY CRMAssesment.ModifiedDate ASC



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
