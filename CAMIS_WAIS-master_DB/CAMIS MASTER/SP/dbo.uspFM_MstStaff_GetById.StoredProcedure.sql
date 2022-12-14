USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstStaff_GetById]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_MstStaff_GetById
Description			: Get the staff details by passing the staffId.
Authors				: Dhilip V
Date				: 02-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_MstStaff_GetById  @pStaffMasterId=38

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_MstStaff_GetById]                           
  @pStaffMasterId		INT
AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


-- Default Values


-- Execution


	IF(ISNULL(@pStaffMasterId,0) = 0) RETURN

    SELECT	
			Staff.StaffMasterId				AS StaffMasterId,
			Staff.CustomerId				AS CustomerId,
			Customer.CustomerName			AS CustomerName,
			Staff.FacilityId				AS FacilityId,
			Facility.FacilityName			AS FacilityName,
			Staff.AccessLevel				AS AccessLevel,
			LovAccessLevel.FieldValue		AS AccessLevelName,
			Staff.StaffEmployeeId			AS StaffEmployeeId,
			Staff.StaffName					AS StaffName,
			Staff.StaffRoleId				AS StaffRoleId,
			StaffRole.StaffRole				AS StaffRoleName,
			Staff.DesignationId				AS DesignationId,
			StaffDesignation.Designation	AS DesignationName,
			Staff.StaffCompetencyId			AS StaffCompetencyId,
			StaffCompetency.Competency		AS CompetencyName,
			Staff.StaffSpecialityId			AS StaffSpecialityId,
			StaffSpeciality.Speciality		AS SpecialityName,
			Staff.StaffGraded				AS StaffGraded,
			StaffGrade.StaffGrade			AS StaffGradeName,
			Staff.StaffDepartmentId			AS StaffDepartmentId,
			StaffDepartment.Department		AS StaffDepartmentName,
			Staff.IsEmployeeShared          AS IsEmployeeShared,
			Staff.Active                    AS Active,
			Staff.ContactNo                 AS ContactNo,
			Staff.Email                     AS Email,
			Staff.EmployeeTypeLovId			AS EmployeeTypeLovId,
			LovEmployeeType.FieldValue		AS EmployeeTypName,
			Staff.Gender					AS GenderLovId,
			LovGender.FieldValue			AS GenderName,
			staff.Nationality				AS NationalityLovId,
			LovNationality.FieldValue		AS NationalityName,		
			Staff.[Timestamp]               AS [Timestamp]
 	FROM	MstStaff						AS Staff			 WITH(NOLOCK)	
			INNER JOIN MstCustomer			AS	Customer		 WITH(NOLOCK)	ON Staff.CustomerId			=	Customer.CustomerId
			INNER JOIN MstLocationFacility	AS	Facility		 WITH(NOLOCK)	ON Staff.FacilityId			=	Facility.FacilityId
			INNER JOIN FMLovMst				AS	LovAccessLevel	 WITH(NOLOCK)	ON Staff.AccessLevel		=	LovAccessLevel.LovId
			LEFT JOIN  MstStaffRole			AS	StaffRole		 WITH(NOLOCK)	ON Staff.DesignationId		=	StaffRole.StaffRoleId
			LEFT JOIN  MstStaffDesignation	AS	StaffDesignation WITH(NOLOCK)	ON Staff.DesignationId		=	StaffDesignation.DesignationId
			OUTER APPLY SplitString(Staff.StaffCompetencyId,',') SplitStringCompetency
			LEFT JOIN  MstStaffCompetency	AS	StaffCompetency	 WITH(NOLOCK)	ON SplitStringCompetency.id	=	StaffCompetency.StaffCompetencyId
			OUTER APPLY SplitString(Staff.StaffSpecialityId,',') SplitStringSpeciality
			LEFT JOIN  MstStaffSpeciality	AS	StaffSpeciality	 WITH(NOLOCK)	ON SplitStringSpeciality.id	=	StaffSpeciality.StaffSpecialityId
			LEFT JOIN  MstStaffGrade		AS	StaffGrade		 WITH(NOLOCK)	ON Staff.StaffGraded		=	StaffGrade.StaffGradeId
			LEFT JOIN  MstStaffDepartment	AS	StaffDepartment	 WITH(NOLOCK)	ON Staff.StaffDepartmentId	=	StaffDepartment.StaffDepartmentId
			LEFT JOIN  FMLovMst				AS	LovEmployeeType	 WITH(NOLOCK)	ON Staff.EmployeeTypeLovId	=	LovEmployeeType.LovId
			INNER JOIN  FMLovMst			AS	LovGender		 WITH(NOLOCK)	ON Staff.Gender				=	LovGender.LovId
			INNER JOIN  FMLovMst			AS	LovNationality	 WITH(NOLOCK)	ON Staff.Nationality		=	LovNationality.LovId

	WHERE	Staff.StaffMasterId = @pStaffMasterId 

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
