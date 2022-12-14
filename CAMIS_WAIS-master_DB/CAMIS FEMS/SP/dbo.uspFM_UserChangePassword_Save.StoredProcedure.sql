USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UserChangePassword_Save]    Script Date: 20-09-2021 16:56:54 ******/
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
EXEC uspFM_UserChangePassword_Save  @pUserName='user1',@pNewPassword='53Z8qnDxdD6dkDuBOCpcNqNFcVi0fwvMzDv70LS/dxgb4XW0UsGOYHTvCU0=',@pExpiryDuration=NULL,@pUserId=1
select * from UMUserRegistration
select * from UMChangePassword
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_UserChangePassword_Save]

	@pUserName						NVARCHAR(200),                     
	@pNewPassword					NVARCHAR(max),
	@pExpiryDuration				INT = NULL


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
	DECLARE @pUserRegistrationId  INT
	DECLARE @pUserIdget  INT
-- Default Values


-- Execution


	IF (@pUserName IS NOT NULL)
		BEGIN

		SELECT @pOldPassword	=	[Password]	 FROM UMUserRegistration	WHERE UserName	=	@pUserName
		SELECT @pUserRegistrationId	=	UserRegistrationId	 FROM UMUserRegistration	WHERE UserName	=	@pUserName
		SELECT @pUserIdget   = UserRegistrationId	 FROM UMUserRegistration	WHERE UserName	=	@pUserName
			UPDATE UMUserRegistration SET	Password					=	@pNewPassword,
											PasswordChangedDateTime		=	GETDATE(),
											PasswordChangedDateTimeUTC	=	GETUTCDATE(),
											ModifiedBy					=	@pUserIdget,
											ModifiedDate				=	GETDATE(),
											ModifiedDateUTC				=	GETUTCDATE()
									WHERE	UserName					=	@pUserName

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
											@pUserIdget,
											GETDATE(),
											GETUTCDATE(),
											@pUserIdget,
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
