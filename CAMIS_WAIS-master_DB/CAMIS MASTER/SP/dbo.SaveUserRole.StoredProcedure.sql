USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SaveUserRole]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SaveUserRole]
(
	@UserRole As [dbo].[UMUserRoleType] Readonly
)	
AS 

-- Exec [SaveUserRole] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: SaveUserRole
--DESCRIPTION		: SAVE RECORD IN UMUSERROLE TABLE 
--AUTHORS			: BIJU NB
--DATE				: 20-March-2018
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--BIJU NB           : 20-March-2018 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	DECLARE @Table TABLE (ID INT)

	INSERT INTO UMUserRole (
				UserTypeId, Name, [Status], Remarks, CreatedBy, CreatedDate,
				CreatedDateUTC, ModifiedBy, ModifiedDate, ModifiedDateUTC,
				Active, BuiltIn) OUTPUT INSERTED.UMUserRoleId INTO @Table
	SELECT UserTypeId, Name, [Status], Remarks, UserId, GETDATE(),
				GETUTCDATE(), null, GETDATE(), GETUTCDATE(),
				1, 1 FROM @UserRole

	SELECT UMUserRoleId, [Timestamp] FROM UMUserRole WHERE UMUserRoleId IN (SELECT ID FROM @Table)

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
