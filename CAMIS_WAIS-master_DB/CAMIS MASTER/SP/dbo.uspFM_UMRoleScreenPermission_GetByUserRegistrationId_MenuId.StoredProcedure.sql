USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UMRoleScreenPermission_GetByUserRegistrationId_MenuId]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create PROCEDURE  [dbo].[uspFM_UMRoleScreenPermission_GetByUserRegistrationId_MenuId]        

                   

  @pUserRegistrationId		INT,
  @Screenid INT



AS                                               



BEGIN TRY



-- Paramter Validation 



	SET NOCOUNT ON; 

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



-- Declaration





-- Default Values





-- Execution



	IF(ISNULL(@pUserRegistrationId,0) = 0) RETURN



	SELECT	DISTINCT ScreenPermission.UMUserRoleId AS UMUserRoleId,

			UserRole.Name	UserRoleName,

			ScreenPermission.ScreenId		AS	ScreenPageId,

			Screen.ControllerName			AS	ControllerName,

			Actions.ActionPermissionId		AS	ActionPermissionId,

			Actions.Name					AS	ActionPermissionName,

			UserLocationMst.FacilityId,

			Screen.PageURL

	FROM	UMRoleScreenPermission		AS	ScreenPermission

	INNER JOIN UMScreen					AS	Screen				ON	ScreenPermission.ScreenId		=	Screen.ScreenId

	INNER JOIN UMUserRole				AS	UserRole			ON	ScreenPermission.UMUserRoleId	=	UserRole.UMUserRoleId

	INNER JOIN (SELECT DISTINCT UserRoleId,UserRegistrationId,FacilityId FROM UMUserLocationMstDet ) AS UserLocationMst	ON	ScreenPermission.UMUserRoleId	=	UserLocationMst.UserRoleId	

	OUTER APPLY (SELECT ID FROM [dbo].[udf_fnSplitWord] (ScreenPermission.Permissions) WHERE SplitWord =1) ActionSplit 

	INNER JOIN UMActions				AS	Actions	 ON Actions.ActionPermissionId	= ActionSplit.ID

	WHERE	UserLocationMst.UserRegistrationId = @pUserRegistrationId and controllername is not null
	and Screen.ScreenId=@Screenid
	ORDER BY ScreenPermission.ScreenId ASC , Actions.ActionPermissionId ASC



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
