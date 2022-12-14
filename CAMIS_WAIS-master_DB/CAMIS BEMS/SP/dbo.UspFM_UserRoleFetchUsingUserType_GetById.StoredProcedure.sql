USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_UserRoleFetchUsingUserType_GetById]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_PorteringTransaction_GetById
Description			: To Get the data from table PorteringTransaction using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_UserRoleFetchUsingUserType_GetById] @pUserTypeId=2

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_UserRoleFetchUsingUserType_GetById]                           
 -- @pUserId				INT	=	NULL,
  @pUserTypeId			INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	
	DECLARE @mCustomerId INT
	DECLARE @mFacilityId INT,@mBlockId INT,@mLevelId INT
	DECLARE @mUserLocationId INT,@mUserAreaId INT

	IF(ISNULL(@pUserTypeId,0) = 0) RETURN

	SELECT	UserRole.UMUserRoleId as LovId,
			UserRole.UserTypeId,
			UserRole.Name as FieldValue,
			0 AS IsDefault

	FROM	UMUserRole											AS UserRole
	WHERE	UserRole.UserTypeId = @pUserTypeId AND UserRole.Status = 1
	ORDER BY UserRole.Name ASC

	


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
