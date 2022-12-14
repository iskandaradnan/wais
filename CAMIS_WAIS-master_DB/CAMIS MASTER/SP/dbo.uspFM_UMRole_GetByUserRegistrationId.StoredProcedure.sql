USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UMRole_GetByUserRegistrationId]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_UMRole_GetByUserRegistrationId
Description			: Get the Role Screen Permissions for user
Authors				: Dhilip V
Date				: 14-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_UMRole_GetByUserRegistrationId  @pUserRegistrationId=16,@pFacilityId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_UMRole_GetByUserRegistrationId]        
                   
  @pUserRegistrationId		INT,
  @pFacilityId				INT

AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


-- Default Values


-- Execution

	IF(ISNULL(@pUserRegistrationId,0) = 0) RETURN

	SELECT	DISTINCT UserRole.UMUserRoleId
	FROM	UMUserRole				AS	UserRole
	INNER JOIN (SELECT DISTINCT UserRoleId,UserRegistrationId,FacilityId FROM UMUserLocationMstDet ) AS UserLocationMst	ON	UserRole.UMUserRoleId	=	UserLocationMst.UserRoleId	
	WHERE	UserLocationMst.UserRegistrationId = @pUserRegistrationId AND UserLocationMst.FacilityId	=@pFacilityId

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
