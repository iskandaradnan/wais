USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UMAuthenicateUser_Contractor_GetById]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspFM_UMAuthenicateUser_Contractor_GetById]
	@UserName	NVARCHAR(75),
	@Password	NVARCHAR(max),
	@AccessLevel int = null

AS 

-- Exec [uspFM_UMAuthenicateUser_Contractor_GetById] 'superadmin','lg7J6YCogK2HOSZQzjkKwUMkYcgG6WY61wXJhiHbsa9YQN3c6e1h1ysjzG4=',@AccessLevel=308

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: uspFM_UMAuthenicateUser_Contractor_GetById
--DESCRIPTION		: AUTHENTICATE THE USER
--AUTHORS			: BIJU NB
--DATE				: 12-March-2018
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--BIJU NB           : 12-March-2018 : 
-------:------------:----------------------------------------------------------------------------------------------------*/

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY

DECLARE	@Count						INT	 = 0,
		@UserId						INT  = 0,
		@pIsBlocked					BIT  = 0,
		@pInvalidAttempts			INT  = 0,
		@pIsUserValid				BIT  = 0,
		@pInvalidAttemptDateTime	DATETIME = NULL ,
		@pStaffName					NVARCHAR(100)  = NULL,	
		@pUserTypeId				INT = 0,
		@pIsAuthenticated			BIT = 0,
		@pIsValidCustomer			BIT = 0,
		@pCustomerCount				INT = 0
		
		SET @pIsValidCustomer=1;

		declare @UserNameCount int ;
		SELECT @UserNameCount = COUNT(1)
		FROM UMUserRegistration AS A WITH(NOLOCK) 
				INNER JOIN UMUserLocationMstDet AS B  WITH(NOLOCK) ON A.UserRegistrationId=B.UserRegistrationId
				INNER JOIN MstLocationFacility AS C  WITH(NOLOCK) ON B.FacilityId=C.FacilityId
				INNER JOIN MstCustomer AS D  WITH(NOLOCK) ON C.CustomerId=D.CustomerId
		WHERE UPPER(UserName) = UPPER(@UserName) AND a.Status=1  

		IF @UserNameCount > 0
		BEGIN
		SELECT @pCustomerCount = COUNT(1)
		FROM UMUserRegistration AS A WITH(NOLOCK) 
				INNER JOIN UMUserLocationMstDet AS B  WITH(NOLOCK) ON A.UserRegistrationId=B.UserRegistrationId
				INNER JOIN MstLocationFacility AS C  WITH(NOLOCK) ON B.FacilityId=C.FacilityId
				INNER JOIN MstCustomer AS D  WITH(NOLOCK) ON C.CustomerId=D.CustomerId
		WHERE UPPER(UserName) = UPPER(@UserName) AND a.Status=1  	
				AND (D.ActiveToDate IS NULL OR cast(D.ActiveToDate as date) >= cast(GETDATE() as date))
		IF(@pCustomerCount=0)
			BEGIN
				SET @pIsValidCustomer=0
			END
			ELSE
			BEGIN
				SET @pIsValidCustomer=1
			END
	    END

IF (@pIsValidCustomer=1)
BEGIN


IF (ISNULL(@AccessLevel,0)=0)
BEGIN

	SELECT @pIsUserValid =	CASE WHEN EXISTS (	SELECT UserName FROM UMUserRegistration AS UserReg WITH(NOLOCK)
												WHERE UPPER(UserName) = UPPER(@UserName) AND UserReg.Status=1 AND UserTypeId IN (1,2,3,5))
									THEN	1 ELSE	0	END
	IF (@pIsUserValid=1)
	BEGIN
	SELECT @UserId	=	UserRegistrationId,
			@pInvalidAttempts	= (ISNULL(InvalidAttempts,0)),
			@pInvalidAttemptDateTime=InvalidAttemptDateTime,
			@pIsBlocked			= (ISNULL(IsBlocked,0))
	FROM UMUserRegistration WITH(NOLOCK) 
	WHERE UPPER(UserName) = UPPER(@UserName)
		AND UserTypeId IN (1,2,3,5)
	 
	END

	SELECT @Count = COUNT(1) 
	FROM UMUserRegistration  AS UserReg WITH(NOLOCK)
	WHERE UPPER(UserName) = UPPER(@UserName) AND [Password] = @Password AND UserReg.Status=1  AND UserTypeId IN (1,2,3,5)

	IF(@Count = 1)
	BEGIN
		SELECT @UserId = UserRegistrationId 
		FROM UMUserRegistration WITH(NOLOCK) 
		WHERE UPPER(UserName) = UPPER(@UserName) AND [Password] = @Password 

		SELECT	@UserId				= UserRegistrationId,
				@pStaffName			= (StaffName),
				@pUserTypeId		=  UserTypeId,
				@pIsBlocked			= (ISNULL(IsBlocked,0)),
				@pInvalidAttempts	= (ISNULL(InvalidAttempts,0)),
				@pInvalidAttemptDateTime=InvalidAttemptDateTime,
				@pIsAuthenticated	= 1
		FROM	UMUserRegistration WITH(NOLOCK)
		WHERE	UserRegistrationId=@UserId
		 AND UserTypeId IN (1,2,3,5)
		 
	END





	SELECT	@UserId						AS UserId,
			@pStaffName					AS StaffName,
			@pUserTypeId				AS UserTypeId,
			@pIsBlocked					AS IsBlocked,
			@pInvalidAttempts			AS InvalidAttempts,
			@pInvalidAttemptDateTime	AS InvalidAttemptDateTime,
			@pIsUserValid				AS IsUserValid,
			@pIsAuthenticated			AS IsAuthenticated,
			@pIsValidCustomer			AS IsValidCustomer


END

ELSE IF (ISNULL(@AccessLevel,0)=4)

BEGIN

	SELECT @pIsUserValid =	CASE WHEN EXISTS (	SELECT UserName FROM UMUserRegistration AS UserReg WITH(NOLOCK)
												WHERE UPPER(UserName) = UPPER(@UserName) AND UserReg.Status=1 AND UserReg.UserTypeId IN (4))
									THEN	1 ELSE	0	END
	IF (@pIsUserValid=1)
	BEGIN
	SELECT @UserId	=	UserRegistrationId,
			@pInvalidAttempts	= (ISNULL(InvalidAttempts,0)),
			@pInvalidAttemptDateTime=InvalidAttemptDateTime,
			@pIsBlocked			= (ISNULL(IsBlocked,0))
	FROM UMUserRegistration WITH(NOLOCK) 
	WHERE UPPER(UserName) = UPPER(@UserName)
	 AND UserTypeId IN (4)
	END

	SELECT @Count = COUNT(1) 
	FROM UMUserRegistration  AS UserReg WITH(NOLOCK)
	WHERE UPPER(UserName) = UPPER(@UserName) AND [Password] = @Password AND UserReg.Status=1  AND UserReg.UserTypeId IN (4)

	IF(@Count = 1)
	BEGIN
		SELECT @UserId = UserRegistrationId 
		FROM UMUserRegistration WITH(NOLOCK) 
		WHERE UPPER(UserName) = UPPER(@UserName) AND [Password] = @Password  AND UserTypeId IN (4)

		SELECT	@UserId				= UserRegistrationId,
				@pStaffName			= (StaffName),
				@pUserTypeId		= UserTypeId,
				@pIsBlocked			= (ISNULL(IsBlocked,0)),
				@pInvalidAttempts	= (ISNULL(InvalidAttempts,0)),
				@pInvalidAttemptDateTime=InvalidAttemptDateTime,
				@pIsAuthenticated	= 1
		FROM	UMUserRegistration WITH(NOLOCK)
		WHERE	UserRegistrationId=@UserId  AND UserTypeId IN (4)
	END




	SELECT	@UserId						AS UserId,
			@pStaffName					AS StaffName,
			@pUserTypeId				AS UserTypeId,
			@pIsBlocked					AS IsBlocked,
			@pInvalidAttempts			AS InvalidAttempts,
			@pInvalidAttemptDateTime	AS InvalidAttemptDateTime,
			@pIsUserValid				AS IsUserValid,
			@pIsAuthenticated			AS IsAuthenticated,
			@pIsValidCustomer			AS IsValidCustomer



END

END
ELSE
BEGIN
	SELECT	@UserId						AS UserId,
			@pStaffName					AS StaffName,
			@pUserTypeId				AS UserTypeId,
			@pIsBlocked					AS IsBlocked,
			@pInvalidAttempts			AS InvalidAttempts,
			@pInvalidAttemptDateTime	AS InvalidAttemptDateTime,
			@pIsUserValid				AS IsUserValid,
			@pIsAuthenticated			AS IsAuthenticated,
			@pIsValidCustomer			AS IsValidCustomer
END

END TRY

BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
GO
