USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_UMUserRegistration_Export]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[V_UMUserRegistration_Export]
AS
	SELECT	DISTINCT UserReg.UserRegistrationId,
			UserReg.CustomerId,
			UserReg.FacilityId,
			UserReg.StaffName,
			UserReg.UserName,
			LovGender.FieldValue						AS	Gender,
			UserReg.PhoneNumber							AS	[PhoneNo.],
			UserReg.Email,
			UserReg.MobileNumber						AS	[MobileNo.],
			FORMAT(UserReg.DateJoined,'dd-MMM-yyyy')	AS	DateOfJoining,
			UserType.Name								AS	UserTypeValue,
			LovStatus.FieldValue						AS	StatusValue,
			--LovAccessLevel.FieldValue					as	AccessLevelValue,
			Designation.Designation,
			LovNationality.FieldValue					AS	Nationality,
			Grade.UserGrade								AS	Grade,
			Competency.AssetClassificationDescription as Competency,
			Speciality.Speciality,
			Department.Department,
			Customer.CustomerName,
			Facility.FacilityName		AS	LocationName,
			UserRole.Name				AS	UserRole,
			Contractor.ContractorName,
			CASE WHEN ISNULL(IsCenterPool,0)=0 THEN 'No'
			ELSE 'Yes' END CenterPool,
			LabourCostPerHour,
			UserReg.ModifiedDateUTC
	FROM	UMUserRegistration					AS UserReg			WITH(NOLOCK)
			INNER JOIN UMUserType				AS UserType			WITH(NOLOCK) ON UserReg.UserTypeId				= UserType.UserTypeId
			INNER JOIN FmLovMst					AS LovStatus		WITH(NOLOCK) ON UserReg.[Status]				= LovStatus.LovId
			LEFT JOIN MstCustomer				AS Customer			WITH(NOLOCK) ON UserReg.CustomerId				= Customer.CustomerId
			LEFT JOIN FmLovMst					AS LovGender		WITH(NOLOCK) ON UserReg.Gender					= LovGender.LovId
			INNER JOIN UMUserLocationMstDet		AS UMUserLoc		WITH(NOLOCK) ON UserReg.UserRegistrationId		= UMUserLoc.UserRegistrationId
			INNER JOIN MstLocationFacility		AS Facility			WITH(NOLOCK) ON UserReg.FacilityId				= Facility.FacilityId
			INNER JOIN UMUserRole				AS UserRole			WITH(NOLOCK) ON UMUserLoc.UserRoleId			= UserRole.UMUserRoleId
			--LEFT JOIN FmLovMst					AS LovAccessLevel	WITH(NOLOCK) ON UserReg.AccessLevel				= LovAccessLevel.LovId
			LEFT JOIN UserDesignation			AS Designation		WITH(NOLOCK) ON UserReg.UserDesignationId		= Designation.UserDesignationId
			LEFT JOIN FmLovMst					AS LovNationality	WITH(NOLOCK) ON UserReg.Nationality				= LovNationality.LovId
			LEFT JOIN UserGrade					AS Grade			WITH(NOLOCK) ON UserReg.UserGradeId				= Grade.UserGradeId
			LEFT JOIN UserDepartment			AS Department		WITH(NOLOCK) ON UserReg.UserDepartmentId		= Department.UserDepartmentId
			OUTER APPLY SplitString(UserReg.UserCompetencyId,',') SplitCompetency
			LEFT JOIN  EngAssetClassification	AS	Competency		WITH(NOLOCK) ON SplitCompetency.Item			=	Competency.AssetClassificationId
			OUTER APPLY SplitString(UserReg.UserSpecialityId,',') SplitSpeciality
			LEFT JOIN  UserSpeciality			AS	Speciality		WITH(NOLOCK) ON SplitSpeciality.Item			=	Speciality.UserSpecialityId
			LEFT JOIN MstContractorandVendor			AS	Contractor		WITH(NOLOCK) ON UserReg.ContractorId	= Contractor.ContractorId
GO
