USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[FetchRoleScreenPermission]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FetchRoleScreenPermission]
(
@Id INT,
@pModuleId INT
)
AS 

-- Exec [FetchRoleScreenPermission] @Id=1,@pModuleId=1

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: FetchRoleScreenPermission
--DESCRIPTION		: FETCH ROLE SCREEN PERMISSIONS
--AUTHORS			: BIJU NB
--DATE				: 20-March-2018
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--BIJU NB           : 26-March-2018 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	
	SELECT	ISNULL(E.ScreenRoleId, 0) ScreenRoleId, 
			A.ScreenId, 
			A.ScreenDescription, 
			ISNULL(E.[Permissions], '0000000000000') [Permissions],
			C.[Permissions] ScreenPermissions ,
			--A.ScreenId, 
			--E.ScreenId,
			--D.UMUserRoleId,
			E.UMUserRoleId
	FROM UMScreen A
	JOIN UMScreenUserTypeMapping B ON A.ScreenId = B.ScreenId
	JOIN UMScreenPermission C ON A.ScreenId = C.ScreenId
	JOIN UMUserRole D ON B.UserTypeId = D.UserTypeId
	LEFT JOIN UMRoleScreenPermission E ON A.ScreenId = E.ScreenId AND D.UMUserRoleId = E.UMUserRoleId
	WHERE	A.PageURL IS NOT NULL	AND A.ScreenId not in (114,119)
			AND D.UMUserRoleId = @Id
			AND A.ModuleId	=	@pModuleId
			AND a.Active  = 1
	ORDER BY A.ScreenDescription
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
