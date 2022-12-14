USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_UMUserRegistration_Mobile_GetById]    Script Date: 20-09-2021 16:56:54 ******/
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
EXEC [UspFM_UMUserRegistration_Mobile_GetById] @pUserRegistrationId=32
select * from UMUserRegistration
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_UMUserRegistration_Mobile_GetById]                           
 -- @pUserId				INT	=	NULL,
  @pUserRegistrationId			INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	

	IF(ISNULL(@pUserRegistrationId,0) = 0) RETURN

	SELECT	UserRegistration.UserRegistrationId					AS UserRegistrationId,
			UserRegistration.UserName							AS UserName,
			UserLocation.FacilityId								AS UserLocationFacilityId,
			UserLocationFacility.FacilityCode					AS FacilityCode,
			UserLocationFacility.FacilityName					AS FacilityName,
			UserCustomer.CustomerCode							AS CustomerCode,
			UserCustomer.CustomerName							AS CustomerName,
			--UserRegistration.UserRoleId							AS UserRoleId,
			--RoleName.UserRole									AS RoleName,
			UserRegistration.UserTypeId							AS UserTypeId,
			UserType.Name										AS UserTypeName,
			UserRole.UMUserRoleId								AS UMUserRoleId,
			UserRole.Name										AS UserRoleName,
			Screen.ScreenName									AS ScreenName,
			UserRegistration.CustomerId							AS CustomerId,
			UserRegistration.GuId								AS GuId,
			UserRegistration.UserDesignationId					AS UserDesignationId,
			Designation.Designation								AS DesignationValue,
			Currency.FieldValue									AS CurrencyValue,
			UserRegistration.Timestamp							AS Timestamp
	FROM	UMUserRegistration									AS UserRegistration
			INNER JOIN	UMUserLocationMstDet					AS UserLocation				WITH(NOLOCK)	ON UserRegistration.UserRegistrationId			= UserLocation.UserRegistrationId
			INNER JOIN  MstLocationFacility						AS UserLocationFacility		WITH(NOLOCK)	ON UserLocation.FacilityId						= UserLocationFacility.FacilityId
			INNER JOIN	MstCustomer								AS UserCustomer				WITH(NOLOCK)	ON UserRegistration.CustomerId					= UserCustomer.CustomerId
			--INNER JOIN  UserRole								AS RoleName					WITH(NOLOCK)	ON UserRegistration.UserRoleId					= RoleName.UserRoleId
			INNER JOIN  UMUserRole								AS UserRole					WITH(NOLOCK)	ON UserLocation.UserRoleId						= UserRole.UMUserRoleId
			INNER JOIN  UMUserType								AS UserType					WITH(NOLOCK)	ON UserRegistration.UserTypeId					= UserType.UserTypeId
			INNER JOIN  UMRoleScreenPermission					AS RoleScreen				WITH(NOLOCK)	ON UserLocation.UserRoleId						= RoleScreen.UMUserRoleId
			INNER JOIN  UMScreen								AS Screen					WITH(NOLOCK)	ON RoleScreen.ScreenId							= Screen.ScreenId
			INNER JOIN  UserDesignation							AS Designation				WITH(NOLOCK)	ON UserRegistration.UserDesignationId			= Designation.UserDesignationId
			LEFT  JOIN  FMConfigCustomerValues					AS ConfigCustomer			WITH(NOLOCK)	ON UserCustomer.CustomerId						= ConfigCustomer.CustomerId
			LEFT  JOIN  FMLovMst								AS Currency					WITH(NOLOCK)	ON ConfigCustomer.ConfigKeyLovId				= Currency.LovId
	WHERE	UserRegistration.UserRegistrationId = @pUserRegistrationId and RoleScreen.[Permissions] not in ('0000000000000') and Screen.ModuleId =9 AND ConfigCustomer.ConfigKeyId = 2
	ORDER BY UserRegistration.ModifiedDate ASC


	
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
