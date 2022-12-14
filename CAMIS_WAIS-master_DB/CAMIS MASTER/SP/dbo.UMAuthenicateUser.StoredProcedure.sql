USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UMAuthenicateUser]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UMAuthenicateUser]
	@UserName	NVARCHAR(75),
	@Password	NVARCHAR(max),
	@Count INT OUTPUT,
	@UserId INT OUTPUT

AS 

-- Exec [UMAuthenicateUser] 'mohadmin','lg7J6YCogK2HOSZQzjkKwUMkYcgG6WY61wXJhiHbsa9YQN3c6e1h1ysjzG4=', 17

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: UMAuthenicateUser
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
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	
	SET @Count = 0;
	SET @UserId = 0;


	SELECT @Count = COUNT(1) FROM UMUserRegistration WHERE UPPER(UserName) = UPPER(@UserName) and [Password] = @Password
	IF(@Count = 1)
	SELECT @UserId = UserRegistrationId FROM UMUserRegistration WHERE UPPER(UserName) = UPPER(@UserName) and [Password] = @Password

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
