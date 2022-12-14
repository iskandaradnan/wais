USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_ResetInvalidAttempts_Save]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_ResetInvalidAttempts_Save
Description			: Reset invalid attempts for given user.
Authors				: Dhilip V
Date				: 16-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_ResetInvalidAttempts_Save @pUserRegistrationId=11

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_ResetInvalidAttempts_Save]
		
		@pUserRegistrationId	INT

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

			UPDATE	UMUserRegistration	SET	InvalidAttempts			 = 0,
											InvalidAttemptDateTime	 =NULL,
											InvalidAttemptDateTimeUTC=NULL,
											IsBlocked				 =	0
										WHERE	UserRegistrationId	=	@pUserRegistrationId


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
		   )

END CATCH
GO
