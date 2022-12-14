USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequest_RemarksHistry_GetById]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_CRMRequest_RemarksHistry_GetById
Description			: Get CRM Remarks history using mobile.
Authors				: karthick R
Date				: 04-Oct-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:


EXEC [uspFM_CRMRequest_RemarksHistry_GetById] @pCRMRequestId=19605

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_CRMRequest_RemarksHistry_GetById]

			@pCRMRequestId					INT			
				
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT
	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	SELECT	ROW_NUMBER() OVER(ORDER BY CRMRequestRemarksHistoryId ) SNo,
			CRMRequestRemarksHistoryId,
			CRMRequestId,
			RemarksHis.Remarks,
			RequestStatus,
			--RequestStatusValue,
			RequestStatus.FieldValue AS RequestStatusValue,
			UserReg.StaffName	DoneBy,
			--DoneDate
			DoneDate as DoneDate
	FROM	CRMRequestRemarksHistory	AS	RemarksHis 
			INNER JOIN UMUserRegistration AS UserReg on RemarksHis.DoneBy = UserReg.UserRegistrationId
			INNER JOIN	FMLovMst							AS RequestStatus		WITH(NOLOCK)	ON RemarksHis.RequestStatus		= RequestStatus.LovId
	WHERE	CRMRequestId	=	@pCRMRequestId
	order by RemarksHis.DoneDate 




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
