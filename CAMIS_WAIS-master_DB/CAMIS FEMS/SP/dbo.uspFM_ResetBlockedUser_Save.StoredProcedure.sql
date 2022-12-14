USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_ResetBlockedUser_Save]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_ResetBlockedUser_Save
Description			: If staff already exists then update else insert.
Authors				: Dhilip V
Date				: 17-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_ResetBlockedUser_Save  @pUserRegistrationId=,@pInvalidAttempts=NULL,@pInvalidAttemptDateTime=GETDATE(),@pIsBlocked=0

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_ResetBlockedUser_Save]

	@pUserRegistrationId			INT,                     
	@pInvalidAttempts				INT,
	@pInvalidAttemptDateTime		DATETIME,
	@pIsBlocked						BIT

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	--DECLARE @Table TABLE (ID INT)

-- Default Values


-- Execution

   

	IF (ISNULL(@pUserRegistrationId,0)>0)
		BEGIN
			UPDATE UMUserRegistration SET	InvalidAttempts	=	@pInvalidAttempts,											
								InvalidAttemptDateTime		=	@pInvalidAttemptDateTime,
								InvalidAttemptDateTimeUTC	=	GETUTCDATE(),
								IsBlocked					=	@pIsBlocked,
								ModifiedBy					=	@pUserRegistrationId,
								ModifiedDate				=	GETDATE(),
								ModifiedDateUTC				=	GETUTCDATE()
						WHERE	UserRegistrationId			=	@pUserRegistrationId

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
				'ERROR_LINE: '+CONVERT(VARCHAR(10),	ERROR_LINE())+' - '+ERROR_MESSAGE(),
				GETDATE()
		   )

END CATCH
GO
