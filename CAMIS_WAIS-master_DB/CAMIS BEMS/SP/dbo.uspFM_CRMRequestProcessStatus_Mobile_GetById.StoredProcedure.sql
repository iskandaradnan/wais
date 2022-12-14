USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequestProcessStatus_Mobile_GetById]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_CRMRequestProcessStatus_GetById
Description			: To Get the CRMRequest	ProcessStatus
Authors				: Dhilip V
Date				: 30-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_CRMRequestProcessStatus_Mobile_GetById] @pCRMRequestWOId=85

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_CRMRequestProcessStatus_Mobile_GetById]                           

  @pCRMRequestWOId			INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	IF(ISNULL(@pCRMRequestWOId,0) = 0) RETURN

	SELECT	CRMStatus.CRMProcessStatusId,
			CRMWO.CRMWorkOrderNo,
			LovStatus.FieldValue		AS	Status,
			UMUser.StaffName			AS	DoneBy,
			Designation.Designation		AS	DoneByDesignation,
			DoneDate,
			Staff.StaffName				AS ReAssignedStaff
	FROM	CRMRequestProcessStatus				AS	CRMStatus	WITH(NOLOCK)
			INNER JOIN CRMRequestWorkOrderTxn	AS	CRMWO		WITH(NOLOCK) ON CRMStatus.CRMRequestWOId	=	CRMWO.CRMRequestWOId
			INNER JOIN FMLovMst					AS	LovStatus	WITH(NOLOCK) ON CRMStatus.Status			=	LovStatus.LovId
			LEFT JOIN UMUserRegistration		AS	UMUser		WITH(NOLOCK) ON CRMStatus.DoneBy			=	UMUser.UserRegistrationId
			LEFT JOIN UserDesignation			AS	Designation	WITH(NOLOCK) ON UMUser.UserDesignationId	=	Designation.UserDesignationId
			LEFT JOIN UMUserRegistration		AS	Staff		WITH(NOLOCK) ON CRMStatus.AssignedUserId	=	Staff.UserRegistrationId
	WHERE	CRMStatus.CRMRequestWOId	=	@pCRMRequestWOId
	ORDER BY LovStatus.LovId	DESC

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
