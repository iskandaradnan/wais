USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_UMBlockedUsers_Export]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_UMBlockedUsers_Export]
AS
	SELECT	Customer.CustomerName,
			UserReg.FacilityId,
			Facility.FacilityName,
			UserReg.StaffName,
			UserReg.UserName,
			UserType.Name UserTypeValue, 
			UserReg.Email,
			LovStatus.FieldValue StatusValue,
			UserReg.ModifiedDateUTC
	FROM	UMUserRegistration				AS	UserReg		WITH(NOLOCK)
			INNER JOIN UMUserType			AS	UserType	WITH(NOLOCK) ON UserReg.UserTypeId = UserType.UserTypeId
			INNER JOIN FmLovMst				AS	LovStatus	WITH(NOLOCK) ON UserReg.[Status] = LovStatus.LovId
			INNER JOIN MstCustomer			AS  Customer	WITH(NOLOCK) ON UserReg.CustomerId = Customer.CustomerId 
			INNER JOIN MstLocationFacility	AS  Facility	WITH(NOLOCK) ON UserReg.FacilityId = Facility.FacilityId 
	WHERE	UserReg.IsBlocked = 1
GO
