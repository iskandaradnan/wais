USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[GetMenus]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetMenus]
(
	@Id				INT
)
AS 


-- Exec [GetMenus] 1

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: GetMenus
--DESCRIPTION		: GET MENUS FOR THE USER
--AUTHORS			: BIJU NB
--DATE				: 28-March-2018
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
	
		CREATE TABLE #Menu (ScreenId INT, ScreenName NVARCHAR(100), 
		PageURL NVARCHAR(250), ParentMenuId INT, SequenceNo INT, 
		ControllerName NVARCHAR(200))


		CREATE TABLE #ScreenIds (Id INT IDENTITY(1,1), ScreenId INT);

		INSERT INTO #ScreenIds (ScreenId)
		SELECT D.ScreenId
		FROM UMUserRegistration A
		JOIN UMUserLocationMstDet B ON A.UserRegistrationId = B.UserRegistrationId
		JOIN UMRoleScreenPermission C ON B.UserRoleId = C.UMUserRoleId
		JOIN UMScreen D ON C.ScreenId = D.ScreenId
		WHERE A.UserRegistrationId = @Id AND CHARINDEX('1',C.[Permissions]) != 0 

		DECLARE @Count INT;
		SELECT @Count = COUNT(1) FROM #ScreenIds
		DECLARE @ScreenId INT;

		WHILE @Count > 0
		BEGIN
			SELECT @ScreenId = ScreenId FROM #ScreenIds WHERE Id = @Count;

			WITH EntityChildren AS
			(
			SELECT ScreenId, ScreenName, PageURL, 
					ParentMenuId, SequenceNo, 
					ControllerName FROM UMScreen WHERE ScreenId = @ScreenId
			UNION ALL
			SELECT A.ScreenId, A.ScreenName, A.PageURL, 
					A.ParentMenuId, A.SequenceNo, 
					A.ControllerName 
					FROM UMScreen A 
					JOIN EntityChildren B on A.ScreenId = B.ParentMenuId 
			)
			INSERT INTO #Menu (ScreenId, ScreenName, PageURL, 
						ParentMenuId, SequenceNo, 
						ControllerName) 
			SELECT ScreenId, ScreenName, PageURL, 
						ParentMenuId, SequenceNo, 
						ControllerName FROM EntityChildren

		SET @Count = @Count - 1;
		END

		SELECT DISTINCT ScreenId, ScreenName, ISNULL(PageURL, '') PageURL, 
						ISNULL(ParentMenuId, 0) ParentMenuId, SequenceNo, 
						ISNULL(ControllerName, '') ControllerName FROM #Menu

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
