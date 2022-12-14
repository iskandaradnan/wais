USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UMAuthenicateUser_GetById]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[uspFM_UMAuthenicateUser_GetById]
	@UserName	NVARCHAR(75),
	@Password	NVARCHAR(max)
	--@AccessLevel int = null

AS 

-- Exec [uspFM_UMAuthenicateUser_GetById] 'superadmin','lg7J6YCogK2HOSZQzjkKwUMkYcgG6WY61wXJhiHbsa9YQN3c6e1h1ysjzG4=',@AccessLevel=0

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: uspFM_UMAuthenicateUser_GetById
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
		@pIsAuthenticated			BIT = 0,
		@pIsInActive				BIT,
		@pImage						VARBINARY(MAX)

--IF (ISNULL(@AccessLevel,0)=0)
--BEGIN

	SELECT @pIsUserValid =	CASE WHEN EXISTS (	SELECT UserName FROM UMUserRegistration AS UserReg WITH(NOLOCK)
												WHERE UPPER(UserName) = UPPER(@UserName) )
									THEN	1 ELSE	0	END
	IF (@pIsUserValid=1)
	BEGIN
	SELECT @UserId	=	UserRegistrationId,
			@pInvalidAttempts	= (ISNULL(InvalidAttempts,0)),
			@pInvalidAttemptDateTime=InvalidAttemptDateTime,
			@pIsBlocked			= (ISNULL(IsBlocked,0))
	FROM UMUserRegistration WITH(NOLOCK) 
	WHERE UPPER(UserName) = UPPER(@UserName)

	 IF ((SELECT COUNT(*) FROM UMUserLocationMstDet WHERE UserRegistrationId	=	@UserId)>1)
		BEGIN
			SET	@pImage	= (SELECT TOP 1 CustomerImage FROM MstCustomer A INNER JOIN UMUserRegistration B ON A.CustomerId=B.CustomerId WHERE B.UserRegistrationId=@UserId )
		END
		ELSE
		BEGIN
			SET	@pImage	= (SELECT TOP 1 D.FacilityImage FROM MstCustomer A INNER JOIN UMUserRegistration B ON A.CustomerId=B.CustomerId 
							INNER JOIN UMUserLocationMstDet C ON B.FacilityId	=	C.FacilityId	
							INNER JOIN MstLocationFacility D ON C.FacilityId	=	D.FacilityId	
							WHERE B.UserRegistrationId=@UserId )
		END
	END

	SELECT @Count = COUNT(1) 
	FROM UMUserRegistration  AS UserReg WITH(NOLOCK)
	WHERE UPPER(UserName) = UPPER(@UserName) AND [Password] = @Password 

	IF(@Count = 1)
	BEGIN
		SELECT @UserId = UserRegistrationId 
		FROM UMUserRegistration WITH(NOLOCK) 
		WHERE UPPER(UserName) = UPPER(@UserName) AND [Password] = @Password 

		SELECT	@UserId				= UserRegistrationId,
				@pStaffName			= (StaffName),
				@pIsBlocked			= (ISNULL(IsBlocked,0)),
				@pInvalidAttempts	= (ISNULL(InvalidAttempts,0)),
				@pInvalidAttemptDateTime=InvalidAttemptDateTime,
				@pIsAuthenticated	= 1,
				@pIsInActive		= CASE WHEN [Status] =1 THEN 0 ELSE CASE WHEN [Status] =2 THEN 1  END END
		FROM	UMUserRegistration WITH(NOLOCK)
		WHERE	UserRegistrationId=@UserId

	 IF ((SELECT COUNT(*) FROM UMUserLocationMstDet WHERE UserRegistrationId	=	@UserId)>1)
		BEGIN
			SET	@pImage	= (SELECT TOP 1  CustomerImage FROM MstCustomer A INNER JOIN UMUserRegistration B ON A.CustomerId=B.CustomerId WHERE B.UserRegistrationId=@UserId )
		END
		ELSE
		BEGIN
			SET	@pImage	= (SELECT TOP 1  D.FacilityImage FROM MstCustomer A INNER JOIN UMUserRegistration B ON A.CustomerId=B.CustomerId 
							INNER JOIN UMUserLocationMstDet C ON B.FacilityId	=	C.FacilityId	
							INNER JOIN MstLocationFacility D ON C.FacilityId	=	D.FacilityId	
							WHERE B.UserRegistrationId=@UserId )
		END
				 
	END

	declare @lUserRoleId int

	SELECT @lUserRoleId =UserRoleId  FROM UMUserLocationMstDet A
	JOIN MstLocationFacility B ON A.FacilityId = B.FacilityId
	WHERE UserRegistrationId = @UserId

	SELECT	@UserId						AS UserId,
			@pStaffName					AS StaffName,
			@pIsBlocked					AS IsBlocked,
			@pInvalidAttempts			AS InvalidAttempts,
			@pInvalidAttemptDateTime	AS InvalidAttemptDateTime,
			@pIsUserValid				AS IsUserValid,
			@pIsAuthenticated			AS IsAuthenticated,
			ISNULL(@pIsInActive,0)		AS IsInActive,
			@pImage						AS Image,
			@lUserRoleId			    as UserRoleId

--END

--ELSE IF (ISNULL(@AccessLevel,0)=308)

--BEGIN

--	SELECT @pIsUserValid =	CASE WHEN EXISTS (	SELECT UserName FROM UMUserRegistration AS UserReg WITH(NOLOCK)
--												WHERE UPPER(UserName) = UPPER(@UserName) AND UserReg.Status=1 AND UserReg.AccessLevel=308)
--									THEN	1 ELSE	0	END
--	IF (@pIsUserValid=1)
--	BEGIN
--	SELECT @UserId	=	UserRegistrationId,
--			@pInvalidAttempts	= (ISNULL(InvalidAttempts,0)),
--			@pInvalidAttemptDateTime=InvalidAttemptDateTime,
--			@pIsBlocked			= (ISNULL(IsBlocked,0))
--	FROM UMUserRegistration WITH(NOLOCK) 
--	WHERE UPPER(UserName) = UPPER(@UserName)
--	 AND AccessLevel=308
--	END

--	SELECT @Count = COUNT(1) 
--	FROM UMUserRegistration  AS UserReg WITH(NOLOCK)
--	WHERE UPPER(UserName) = UPPER(@UserName) AND [Password] = @Password AND UserReg.Status=1  AND UserReg.AccessLevel=308

--	IF(@Count = 1)
--	BEGIN
--		SELECT @UserId = UserRegistrationId 
--		FROM UMUserRegistration WITH(NOLOCK) 
--		WHERE UPPER(UserName) = UPPER(@UserName) AND [Password] = @Password  AND AccessLevel=308

--		SELECT	@UserId				= UserRegistrationId,
--				@pStaffName			= (StaffName),
--				@pIsBlocked			= (ISNULL(IsBlocked,0)),
--				@pInvalidAttempts	= (ISNULL(InvalidAttempts,0)),
--				@pInvalidAttemptDateTime=InvalidAttemptDateTime,
--				@pIsAuthenticated	= 1
--		FROM	UMUserRegistration WITH(NOLOCK)
--		WHERE	UserRegistrationId=@UserId  AND AccessLevel=308
--	END

--	SELECT	@UserId						AS UserId,
--			@pStaffName					AS StaffName,
--			@pIsBlocked					AS IsBlocked,
--			@pInvalidAttempts			AS InvalidAttempts,
--			@pInvalidAttemptDateTime	AS InvalidAttemptDateTime,
--			@pIsUserValid				AS IsUserValid,
--			@pIsAuthenticated			AS IsAuthenticated


--END



END TRY

BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
GO
