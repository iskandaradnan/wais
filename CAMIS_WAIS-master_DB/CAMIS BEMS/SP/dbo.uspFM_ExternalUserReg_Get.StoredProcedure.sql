USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_ExternalUserReg_Get]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[uspFM_ExternalUserReg_Get]
(
	@pUserRegId INT
)
	
AS 

 
/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: uspFM_ExternalUserReg_Get
--DESCRIPTION		: GET USER ROLES FOR A GIVEN TYPE
--AUTHORS			: Dhilip V
--DATE				: 20-March-2018
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 

Exec [uspFM_ExternalUserReg_Get] @pUserRegId=1

--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--BIJU NB           : 21-March-2018 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	
	DECLARE @CNT INT =0


	IF EXISTS (
	SELECT	a.UserRegistrationId,UserTypeId AS AccessLevel
	FROM	UMUserRegistration A 
	WHERE	a.UserRegistrationId = @pUserRegId
			AND A.UserTypeId=4)

	BEGIN 
		SET @CNT=1
		SELECT @CNT	AccessLevel	
	END
	ELSE
		BEGIN
			SELECT @CNT AccessLevel
		END

	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
