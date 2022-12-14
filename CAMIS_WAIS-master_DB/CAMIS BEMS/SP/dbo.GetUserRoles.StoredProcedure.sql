USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[GetUserRoles]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[GetUserRoles]
(
	@Id INT
)
	
AS 

-- Exec [GetUserRoles] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: GetUserRoles
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
	
	SELECT UMUserRoleId LovId, Name FieldValue,
	0 AS IsDefault 
	FROM UMUserRole WHERE UserTypeId = @Id AND [Status] = 1 ORDER BY Name
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
