USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_UMUserRegistration]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_UMUserRegistration]

AS

	SELECT	DISTINCT UserReg.UserRegistrationId,

			UserReg.CustomerId,

			UserReg.FacilityId,

			Customer.CustomerName,

			UserReg.StaffName,

			UserReg.UserName,

			UserType.Name				AS	UserTypeValue,

			UserReg.Email,

			LovStatus.FieldValue		AS	StatusValue,

			UserReg.ModifiedDateUTC,

			IsBlocked,

			Designation.Designation,

			CASE WHEN ISNULL(IsCenterPool,0)=0 THEN 'No'

			ELSE 'Yes' END CenterPool,
			 UserReg.UserTypeId	

	FROM	UMUserRegistration					AS UserReg		WITH(NOLOCK)

			INNER JOIN UMUserType				AS UserType		WITH(NOLOCK) ON UserReg.UserTypeId			= UserType.UserTypeId

			INNER JOIN UMUserLocationMstDet		AS UserLoc		WITH(NOLOCK) ON UserReg.UserRegistrationId	= UserLoc.UserRegistrationId

			INNER JOIN FmLovMst					AS LovStatus	WITH(NOLOCK) ON UserReg.[Status]			= LovStatus.LovId

			LEFT JOIN MstCustomer				AS Customer		WITH(NOLOCK) ON UserReg.CustomerId			= Customer.CustomerId

			LEFT JOIN UserDesignation			AS Designation	WITH(NOLOCK) ON UserReg.UserDesignationId	= Designation.UserDesignationId

			--INNER JOIN FmLovMst					AS LovAccessLvl	WITH(NOLOCK) ON UserReg.AccessLevel			= LovAccessLvl.LovId
GO
