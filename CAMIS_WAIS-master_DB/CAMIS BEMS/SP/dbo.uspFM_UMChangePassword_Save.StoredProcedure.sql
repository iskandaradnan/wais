USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UMChangePassword_Save]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_UMChangePassword_Save
Description			: Change Password details
Authors				: Dhilip V
Date				: 18-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_UMChangePassword_Save  @pUserRegistrationId=4,@pNewPassword='lg7J6YCogK2HOSZQzjkKwUMkYcgG6WY61wXJhiHbsa9YQN3c6e1h1ysjzG4=',@pExpiryDuration=NULL,@pUserId=1
select * from UMUserRegistration
select * from UMChangePassword
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_UMChangePassword_Save]

	@pUserRegistrationId			INT,                     
	@pNewPassword					NVARCHAR(max),
	@pExpiryDuration				INT		=	NULL,
	@pUserId						INT

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)
	DECLARE @pOldPassword	NVARCHAR(max)
-- Default Values


-- Execution


	IF (ISNULL(@pUserRegistrationId,0)>0)
		BEGIN

		SELECT @pOldPassword	=	[Password]	 FROM UMUserRegistration	WHERE UserRegistrationId	=	@pUserRegistrationId

			UPDATE UMUserRegistration SET	Password					=	@pNewPassword,
											PasswordChangedDateTime		=	GETDATE(),
											PasswordChangedDateTimeUTC	=	GETUTCDATE(),
											ModifiedBy					=	@pUserId,
											ModifiedDate				=	GETDATE(),
											ModifiedDateUTC				=	GETUTCDATE()
									WHERE	UserRegistrationId			=	@pUserRegistrationId

			INSERT INTO UMChangePassword (	UserRegistrationId,
											OldPassword,
											NewPassword,
											ExpiryDuration,
											CreatedBy,
											CreatedDate,
											CreatedDateUTC,
											ModifiedBy,
											ModifiedDate,
											ModifiedDateUTC
										)
								VALUES	(	@pUserRegistrationId,
											@pOldPassword,
											@pNewPassword,
											@pExpiryDuration,
											@pUserId,
											GETDATE(),
											GETUTCDATE(),
											@pUserId,
											GETDATE(),
											GETUTCDATE()
										)

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
