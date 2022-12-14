USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UMUserRole_GetByFacilityId]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[uspFM_UMUserRole_GetByFacilityId]
(
	@pUserRegId INT,
	@pFacilityId INT
)
	
AS 

-- Exec [uspFM_UMUserRole_GetByFacilityId] @pUserRegId=1,@pFacilityId=1

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: uspFM_UMUserRole_GetByFacilityId
--DESCRIPTION		: GET USER ROLES FOR A GIVEN TYPE
--AUTHORS			: BIJU NB
--DATE				: 20-March-2018
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--BIJU NB           : 21-March-2018 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	
	SELECT	c.UMUserRoleId, c.Name UserRoleName 
	FROM	UMUserRegistration	a 
			INNER JOIN UMUserLocationMstDet b on a.UserRegistrationId=b.UserRegistrationId
			INNER JOIN UMUserRole c on b.UserRoleId	=	c.UMUserRoleId
	WHERE	a.UserRegistrationId = @pUserRegId
			AND B.FacilityId	=	@pFacilityId

	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
