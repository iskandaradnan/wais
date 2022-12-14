USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_MstStaff_Facility_Export]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[V_MstStaff_Facility_Export]
AS
    SELECT	Customer.CustomerName			AS	CustomerName,
			Facility.FacilityName			AS	FacilityName,
			''		AS	AccessLevel,
			--Staff.StaffEmployeeId			AS	StaffEmployeeId,
			Staff.StaffName					AS	StaffName,
			LovNationality.FieldValue		AS	Nationality,	
			LovGender.FieldValue			AS	Gender,
			Designation.Designation			AS	DesignationName,
			CASE WHEN Staff.Active=1 THEN 'Active'
				 WHEN Staff.Active=0 THEN 'InActive'
			END								AS	[Status],
			Staff.ModifiedDateUTC			AS  ModifiedDateUTC
 	FROM	UMUserRegistration				AS	Staff			WITH(NOLOCK)	
			INNER JOIN MstCustomer			AS	Customer		WITH(NOLOCK)	ON Staff.CustomerId			=	Customer.CustomerId
			INNER JOIN MstLocationFacility	AS	Facility		WITH(NOLOCK)	ON Staff.FacilityId			=	Facility.FacilityId
			--INNER JOIN FMLovMst				AS	LovAccessLevel	WITH(NOLOCK)	ON Staff.AccessLevel		=	LovAccessLevel.LovId
			LEFT JOIN  UserDesignation		AS	Designation		WITH(NOLOCK)	ON Staff.UserDesignationId		=	Designation.UserDesignationId
			INNER JOIN  FMLovMst			AS	LovGender		WITH(NOLOCK)	ON Staff.Gender				=	LovGender.LovId
			INNER JOIN  FMLovMst			AS	LovNationality	WITH(NOLOCK)	ON Staff.Nationality		=	LovNationality.LovId
GO
