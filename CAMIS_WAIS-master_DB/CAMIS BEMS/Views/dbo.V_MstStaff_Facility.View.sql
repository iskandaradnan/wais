USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_MstStaff_Facility]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[V_MstStaff_Facility]
AS
    SELECT	
			Staff.UserRegistrationId		AS	StaffMasterId,
			Staff.CustomerId				AS	CustomerId,
			Customer.CustomerName			AS	CustomerName,
			Staff.FacilityId				AS	FacilityId,
			Facility.FacilityName			AS	FacilityName,
			0			AS	AccessLevelId,
			''		AS	AccessLevel,
			--Staff.StaffEmployeeId			AS	StaffEmployeeId,
			Staff.StaffName					AS	StaffName,
			Staff.Email						AS	Email,
			staff.Nationality				AS	NationalityLovId,
			LovNationality.FieldValue		AS	Nationality,	
			Staff.Gender					AS	GenderLovId,
			LovGender.FieldValue			AS	Gender,
			Staff.UserDesignationId				AS	DesignationId,
			Designation.Designation			AS	DesignationName,
			Staff.ModifiedDateUTC			AS  ModifiedDateUTC,
			Staff.Active                    AS	Active
 	FROM	UMUserRegistration				AS	Staff			WITH(NOLOCK)	
			INNER JOIN MstCustomer			AS	Customer		WITH(NOLOCK)	ON Staff.CustomerId			=	Customer.CustomerId
			INNER JOIN MstLocationFacility	AS	Facility		WITH(NOLOCK)	ON Staff.FacilityId			=	Facility.FacilityId
			--INNER JOIN FMLovMst				AS	LovAccessLevel	WITH(NOLOCK)	ON Staff.AccessLevel		=	LovAccessLevel.LovId
			LEFT JOIN  UserDesignation		AS	Designation		WITH(NOLOCK)	ON Staff.UserDesignationId		=	Designation.UserDesignationId
			INNER JOIN  FMLovMst			AS	LovGender		WITH(NOLOCK)	ON Staff.Gender				=	LovGender.LovId
			INNER JOIN  FMLovMst			AS	LovNationality	WITH(NOLOCK)	ON Staff.Nationality		=	LovNationality.LovId
	WHERE	Staff.UserTypeId=1
GO
