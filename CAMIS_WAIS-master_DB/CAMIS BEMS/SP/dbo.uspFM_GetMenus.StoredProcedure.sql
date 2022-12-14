USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_GetMenus]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_GetMenus
Description			: Get the staff details by passing the staffId.
Authors				: Dhilip V
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
Exec [uspFM_GetMenus] @Id=10,@pFacilityId=19
Exec [uspFM_GetMenus] @Id=1,@pFacilityId=NULL

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_GetMenus]

	--@PageSize		INT,
	--@PageIndex		INT,
	@Id				INT,
	@pFacilityId	INT = NULL

AS 

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	DECLARE @mUserRoleId INT;

	IF (ISNULL(@pFacilityId, 0) = 0)
		BEGIN
			
			SET @mUserRoleId= (	SELECT	TOP 1 B.UserRoleId 
								FROM	UMUserRegistration A
										JOIN UMUserLocationMstDet B ON A.UserRegistrationId = B.UserRegistrationId
										JOIN MstLocationFacility C ON B.FacilityId = C.FacilityId
										JOIN MstCustomer D ON B.CustomerId = D.CustomerId
								WHERE	A.UserRegistrationId = @Id 
								ORDER BY D.CustomerName ASC, C.FacilityName ASC
								)
		END
	ELSE
		BEGIN
			SET @mUserRoleId= (	SELECT	TOP 1 A.UserRoleId 
								FROM	UMUserLocationMstDet A
								WHERE	A.UserRegistrationId = @Id AND A.FacilityId = @pFacilityId 
							)
		END


-- Declaration
	CREATE TABLE #ScreenIds (	Id INT IDENTITY(1,1),
								ScreenId INT
							)
	CREATE TABLE #Menu (	ScreenId INT, 
							ScreenName NVARCHAR(100),
							PageURL NVARCHAR(250),
							ParentMenuId INT,
							SequenceNo INT,
							ControllerName NVARCHAR(200)
						)
	DECLARE @Count INT;
	DECLARE @ScreenId INT;

-- Default Values



-- Execution
		INSERT INTO #ScreenIds (ScreenId)
		SELECT D.ScreenId
		FROM UMUserRegistration A
		JOIN UMUserLocationMstDet B ON A.UserRegistrationId = B.UserRegistrationId
		JOIN UMRoleScreenPermission C ON B.UserRoleId = C.UMUserRoleId
		JOIN UMScreen D ON C.ScreenId = D.ScreenId
		WHERE A.UserRegistrationId = @Id AND CHARINDEX('1',C.[Permissions]) != 0 AND B.UserRoleId=@mUserRoleId and D.ModuleId not in (12,9)

		SELECT @Count = COUNT(1) FROM #ScreenIds

		WHILE @Count > 0
		BEGIN
			SELECT @ScreenId = ScreenId FROM #ScreenIds WHERE Id = @Count;

			WITH EntityChildren AS
			(
			SELECT ScreenId, ScreenName, PageURL, 
					ParentMenuId, SequenceNo, 
					ControllerName FROM UMScreen WHERE ScreenId = @ScreenId and ModuleId not in (12,9) and active=1
			UNION ALL
			SELECT A.ScreenId, A.ScreenName, A.PageURL, 
					A.ParentMenuId, A.SequenceNo, 
					A.ControllerName 
					FROM UMScreen A 
					JOIN EntityChildren B on A.ScreenId = B.ParentMenuId where  a.ModuleId not in (12,9) and active=1
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

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
