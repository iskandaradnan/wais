USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_CRMRequestCompletionInfo_Mobile_GetById]    Script Date: 20-09-2021 16:56:52 ******/
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
EXEC [UspFM_CRMRequestCompletionInfo_Mobile_GetById] @pAssignedUserId=35,@pUserId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_CRMRequestCompletionInfo_Mobile_GetById]                           
  @pUserId				INT	=	NULL,
  @pAssignedUserId		INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	IF(ISNULL(@pAssignedUserId,0) = 0) RETURN


	SELECT	CRMRequestCompletion.CRMCompletionInfoId			AS CRMCompletionInfoId,
			CRMRequestCompletion.CustomerId						AS CustomerId,
			CRMRequestCompletion.FacilityId						AS FacilityId,
			CRMRequestCompletion.ServiceId						AS ServiceId,
			ServiceKey.ServiceKey								AS ServiceValue,
			CRMRequestCompletion.CRMRequestWOId					AS CRMRequestWOId,
			CRMMaintenanceWorkOrder.CRMWorkOrderNo				AS CRMWorkOrderNo,
			CRMMaintenanceWorkOrder.CRMWorkOrderDateTime		AS CRMWorkOrderDateTime,
			CRMRequestCompletion.StartDateTime					AS StartDateTime,
			CRMRequestCompletion.StartDateTimeUTC				AS StartDateTimeUTC,
			CRMRequestCompletion.EndDateTime					AS EndDateTime,
			CRMRequestCompletion.EndDateTimeUTC					AS EndDateTimeUTC,
			CRMRequestCompletion.HandoverDateTime				AS HandoverDateTime,
			CRMRequestCompletion.HandoverDateTimeUTC			AS HandoverDateTimeUTC,
			CRMRequestCompletion.HandoverDelay					AS HandoverDelay,
			CRMRequestCompletion.AcceptedBy						AS AcceptedBy,
			--StaffMasterId.StaffEmployeeId						AS StaffEmployeeId,
			StaffMasterId.StaffName								AS StaffName,
			CRMRequestCompletion.[Signature]					AS [Signature],
			CRMRequestCompletion.Remarks						AS Remarks,
			CRMRequestCompletion.CompletedBy					AS CompletedBy,
			CompletedBy.StaffName								AS CompletedByValue,
			CompletedByDesignation.Designation					AS CompletedbyDesignation,
			CRMRequestCompletion.CompletedbyRemarks				AS CompletedbyRemarks,
			CRMRequestCompletion.[Timestamp]					AS [Timestamp],
			CRMMaintenanceWorkOrder.Status
	FROM	CRMRequestCompletionInfo							AS CRMRequestCompletion
			INNER JOIN	CRMRequestWorkOrderTxn					AS CRMMaintenanceWorkOrder			WITH(NOLOCK)	ON CRMRequestCompletion.CRMRequestWOId		= CRMMaintenanceWorkOrder.CRMRequestWOId
			INNER JOIN  MstService								AS ServiceKey						WITH(NOLOCK)	ON CRMRequestCompletion.ServiceId			= ServiceKey.ServiceId
			LEFT  JOIN  UMUserRegistration						AS StaffMasterId					WITH(NOLOCK)	ON CRMRequestCompletion.AcceptedBy			= StaffMasterId.UserRegistrationId
			LEFT  JOIN  UserDesignation							AS StaffDesignation					WITH(NOLOCK)	ON StaffMasterId.UserDesignationId			= StaffDesignation.UserDesignationId
			LEFT  JOIN  UMUserRegistration						AS CompletedBy						WITH(NOLOCK)	ON CRMRequestCompletion.CompletedBy			= CompletedBy.UserRegistrationId
			LEFT  JOIN  UserDesignation							AS CompletedByDesignation			WITH(NOLOCK)	ON CompletedBy.UserDesignationId			= CompletedByDesignation.UserDesignationId
	WHERE	CRMMaintenanceWorkOrder.AssignedUserId = @pAssignedUserId
	ORDER BY CRMRequestCompletion.ModifiedDate ASC



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
