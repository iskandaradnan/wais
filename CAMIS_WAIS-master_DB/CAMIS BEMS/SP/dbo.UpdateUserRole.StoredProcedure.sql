USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UpdateUserRole]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UpdateUserRole]
(
	@UserRole As [dbo].[UMUserRoleType] Readonly
)	
AS 

-- Exec [UpdateUserRole] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: UpdateUserRole
--DESCRIPTION		: SAVE RECORD IN UMUSERROLE TABLE 
--AUTHORS			: BIJU NB
--DATE				: 19-March-2018
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--BIJU NB           : 19-March-2018 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	DECLARE @Table TABLE (ID INT)

UPDATE A
SET 
A.UserTypeId = B.UserTypeId,
A.Name = B.Name,
A.[Status] = B.[Status],
A.Remarks = B.Remarks,
A.ModifiedBy = B.UserId,
A.ModifiedDate = GETDATE(),
A.ModifiedDateUTC = GETUTCDATE()
FROM UMUserRole A
INNER JOIN @UserRole B
ON A.UMUserRoleId = B.UMUserRoleId
WHERE A.UMUserRoleId = B.UMUserRoleId

	SELECT UMUserRoleId, [Timestamp] FROM UMUserRole WHERE UMUserRoleId = (SELECT UMUserRoleId FROM @UserRole)

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
