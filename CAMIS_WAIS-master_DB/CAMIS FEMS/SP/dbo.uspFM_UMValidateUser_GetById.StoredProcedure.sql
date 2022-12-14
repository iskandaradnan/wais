USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UMValidateUser_GetById]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[uspFM_UMValidateUser_GetById]
	@pUserName	NVARCHAR(75),
	@pPassword	NVARCHAR(max)

AS 

-- Exec [uspFM_UMValidateUser_GetById] 'superadmin','lg7J6YCogK2HOSZQzjkKwUMkYcgG6WY61wXJhiHbsa9YQN3c6e1h1ysjzG4='

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

		DECLARE @Count      INT  = 0
		SELECT @Count = COUNT(1) 
		FROM UMUserRegistration  AS UserReg WITH(NOLOCK)
		WHERE UPPER(UserName) = UPPER(@pUserName) AND [Password] = @pPassword AND UserReg.Active=1 
		AND (UserReg.IsBlocked = 0 OR UserReg.IsBlocked is null)

		IF(@Count=1)
		BEGIN 
		SELECT CAST (1 AS BIT)  AS IsAuthenticated, UserRegistrationId AS UserId  FROM UMUserRegistration  AS UserReg WITH(NOLOCK)
		WHERE UPPER(UserName) = UPPER(@pUserName) AND [Password] = @pPassword AND UserReg.Active=1 
		AND (UserReg.IsBlocked = 0 OR UserReg.IsBlocked is null)
		END

		ELSE
		BEGIN
		SELECT CAST(0 AS BIT) AS IsAuthenticated, 0 AS UserId
		END



END TRY

BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
GO
