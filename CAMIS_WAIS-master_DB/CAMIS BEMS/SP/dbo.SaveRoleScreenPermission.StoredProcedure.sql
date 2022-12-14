USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SaveRoleScreenPermission]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SaveRoleScreenPermission]
(
	@RoleScreenPermissions As [dbo].[UMRoleScreenPermission] Readonly
)	
AS 

-- Exec [SaveRoleScreenPermission] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: SaveRoleScreenPermission
--DESCRIPTION		: SAVE ROLE SCREEN PERMISSION SCREEN
--AUTHORS			: BIJU NB
--DATE				: 22-March-2018
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--BIJU NB           : 22-March-2018 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY

BEGIN TRAN
	DECLARE @Count INT;
	DECLARE @ScreenId INT;
	DECLARE @UMUserRoleId INT;
	DECLARE @Permissions [nvarchar](30);
	DECLARE @UserId INT;

	CREATE TABLE #Permissions 
	(ID INT IDENTITY(1,1),
	[ScreenId] [int],
	[UMUserRoleId] [int],
	[Permissions] [nvarchar](30) ,
	[UserId] INT)

	INSERT INTO #Permissions (ScreenId, UMUserRoleId, [Permissions], UserId)
	SELECT ScreenId, UMUserRoleId, [Permissions], UserId FROM @RoleScreenPermissions
	
	
	SELECT @Count = COUNT(1) FROM #Permissions
	WHILE @Count > 0
	BEGIN
		SELECT @ScreenId = ScreenId, @UMUserRoleId = UMUserRoleId, @Permissions = [Permissions], @UserId = UserId FROM #Permissions WHERE ID = @Count;

		IF EXISTS(SELECT * FROM UMRoleScreenPermission WHERE ScreenId = @ScreenId AND UMUserRoleId = @UMUserRoleId)
		UPDATE UMRoleScreenPermission 
		SET [Permissions] = @Permissions,
		ModifiedBy = @UserId,
		ModifiedDate = GETDATE(),
		ModifiedDateUTC = GETUTCDATE()
		WHERE ScreenId = @ScreenId AND UMUserRoleId = @UMUserRoleId
		ELSE 
		BEGIN
		IF CHARINDEX('1', @Permissions)  <> 0 
			INSERT INTO UMRoleScreenPermission 
						(ScreenId,
						UMUserRoleId,
						[Permissions],
						CreatedBy,
						CreatedDate,
						CreatedDateUTC,
						ModifiedBy,
						ModifiedDate,
						ModifiedDateUTC,
						Active,
						BuiltIn,
						[GuId])
			VALUES (@ScreenId, @UMUserRoleId, @Permissions, @UserId, GETDATE(), GETUTCDATE(), NULL, NULL, NULL,1,1,NEWID())

		END

		SET @Count = @Count - 1;
	END

COMMIT TRAN

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

ROLLBACK;
THROW

END CATCH
SET NOCOUNT OFF
END
GO
