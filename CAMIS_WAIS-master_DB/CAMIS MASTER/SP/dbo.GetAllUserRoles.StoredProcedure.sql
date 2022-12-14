USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[GetAllUserRoles]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetAllUserRoles]
	
AS 

-- Exec [GetAllUserRoles] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: GetAllUserRoles
--DESCRIPTION		: GET USER ROLES FOR A GIVEN TYPE
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
	
	SELECT	UMUserRoleId LovId,
			A.Name FieldValue, 
			B.Name UserType,
			B.UserTypeId
	FROM	UMUserRole A
			JOIN UMUserType B ON A.UserTypeId = B.UserTypeId
	WHERE	A.[Status] = 1 
	ORDER BY A.Name
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
