USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_MstStaff_Company]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE VIEW [dbo].[V_MstStaff_Company]

AS
    SELECT	
			--Staff.StaffMasterId				AS	StaffMasterId,
			Staff.CustomerId				AS	CustomerId,
			Customer.CustomerName			AS	CustomerName,
			Staff.FacilityId				AS	FacilityId,
			Facility.FacilityName			AS	FacilityName,
			0				AS	AccessLevelId,
			''		AS	AccessLevel,
			--Staff.StaffEmployeeId			AS	StaffEmployeeId,
			Staff.StaffName					AS	StaffName,
			staff.Nationality				AS	NationalityLovId,
			LovNationality.FieldValue		AS	Nationality,	
			Staff.Gender					AS	GenderLovId,
			LovGender.FieldValue			AS	Gender,
			--Staff.EmployeeTypeLovId			AS	EmployeeTypeLovId,
			--LovEmployeeType.FieldValue		AS	EmployeeType,
			--GradeId.StaffGradeId			AS	GradeId,
			--GradeId.StaffGrade				AS	Grade,
			Staff.ModifiedDateUTC			AS  ModifiedDateUTC,
			Staff.Active                    AS	Active
 	FROM	[dbo].UMUserRegistration					AS	Staff			WITH(NOLOCK)
			INNER JOIN MstCustomer				AS	Customer		WITH(NOLOCK)	ON Staff.CustomerId			=	Customer.CustomerId
			INNER JOIN MstLocationFacility		AS	Facility		WITH(NOLOCK)	ON Staff.FacilityId			=	Facility.FacilityId
			--INNER JOIN [FMLovMst]				AS	LovAccessLevel	WITH(NOLOCK)	ON Staff.AccessLevel		=	LovAccessLevel.LovId
			--LEFT JOIN  [MstStaffRole]			AS	StaffRole		WITH(NOLOCK)	ON Staff.DesignationId		=	StaffRole.StaffRoleId
			--LEFT JOIN  [FMLovMst]				AS	LovEmployeeType	WITH(NOLOCK)	ON Staff.EmployeeTypeLovId	=	LovEmployeeType.LovId
			INNER JOIN [FMLovMst]				AS	LovGender		WITH(NOLOCK)	ON Staff.Gender				=	LovGender.LovId
			INNER JOIN [FMLovMst]				AS	LovNationality	WITH(NOLOCK)	ON Staff.Nationality		=	LovNationality.LovId
			--LEFT JOIN MstStaffGrade			AS	GradeId		WITH(NOLOCK)		ON Staff.StaffGraded			=	GradeId.StaffGradeId
	WHERE	Staff.UserTypeId in (1,2)
GO
