USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_MstStaff_Company_Export]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[V_MstStaff_Company_Export]

AS
    SELECT	Customer.CustomerName			AS	CustomerName,
			Facility.FacilityName			AS	FacilityName,
			''		AS	AccessLevel,
			--Staff.StaffEmployeeId			AS	StaffEmployeeId,
			Staff.StaffName					AS	StaffName,
			LovNationality.FieldValue		AS	Nationality,	
			LovGender.FieldValue			AS	Gender,
			--LovEmployeeType.FieldValue		AS	EmployeeType,
			--MstStaffGrade.StaffGrade        AS  Grade,
			--MstStaffGrade.StaffGradeId      AS  GradeId,
			CASE WHEN Staff.Active=1 THEN 'Active'
				 WHEN Staff.Active=0 THEN 'InActive'
			END								AS	[Status],
			Staff.ModifiedDateUTC			AS  ModifiedDateUTC
 	FROM	[dbo].UMUserRegistration			AS	Staff			WITH(NOLOCK)
			INNER JOIN MstCustomer				AS	Customer		WITH(NOLOCK)	ON Staff.CustomerId			=	Customer.CustomerId
			INNER JOIN MstLocationFacility		AS	Facility		WITH(NOLOCK)	ON Staff.FacilityId			=	Facility.FacilityId
			--INNER JOIN [FMLovMst]				AS	LovAccessLevel	WITH(NOLOCK)	ON Staff.AccessLevel		=	LovAccessLevel.LovId
			--LEFT JOIN [MstStaffGrade]			AS	MstStaffGrade	WITH(NOLOCK)	ON Staff.StaffGraded		=	MstStaffGrade.StaffGradeId
			--LEFT JOIN  [MstStaffRole]			AS	StaffRole		WITH(NOLOCK)	ON Staff.DesignationId		=	StaffRole.StaffRoleId
			--LEFT JOIN  [FMLovMst]				AS	LovEmployeeType	WITH(NOLOCK)	ON Staff.EmployeeTypeLovId	=	LovEmployeeType.LovId
			INNER JOIN [FMLovMst]				AS	LovGender		WITH(NOLOCK)	ON Staff.Gender				=	LovGender.LovId
			INNER JOIN [FMLovMst]				AS	LovNationality	WITH(NOLOCK)	ON Staff.Nationality		=	LovNationality.LovId
	WHERE	Staff.UserTypeId in (1,2)
GO
