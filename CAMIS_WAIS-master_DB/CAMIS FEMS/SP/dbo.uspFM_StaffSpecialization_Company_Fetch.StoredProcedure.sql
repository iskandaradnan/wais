USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_StaffSpecialization_Company_Fetch]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_StaffSpecialization_Company_Fetch
Description			: StaffName Fetch control
Authors				: Dhilip V
Date				: 05-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_StaffSpecialization_Company_Fetch  @pStaffName='',@pPageIndex=1,@pPageSize=50,@pFacilityId=2,@pTypeOfRequest=136

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_StaffSpecialization_Company_Fetch]              
  @pStaffName			NVARCHAR(100)	=	NULL,
  @pPageIndex			INT,
  @pPageSize			INT,
  @pFacilityId			INT,
  @pTypeOfRequest		INT = NULL
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT
-- Default Values


-- Execution

	IF (@pTypeOfRequest = 136 OR @pTypeOfRequest =137)
	
		BEGIN

		SELECT		@TotalRecords	=	COUNT(*)
		FROM		UMUserRegistration					AS	UMUser WITH(NOLOCK)
					INNER JOIN	MstLocationFacility		AS	Facility	WITH(NOLOCK) ON UMUser.FacilityId			=	Facility.FacilityId
					LEFT JOIN	UserDesignation			AS	Designation WITH(NOLOCK) ON UMUser.UserDesignationId	=	Designation.UserDesignationId
					--INNER JOIN	UserSpeciality			AS	Speciality WITH(NOLOCK) ON UMUser.UserSpecialityId		=	Speciality.UserSpecialityId
					OUTER APPLY SplitString(UMUser.UserSpecialityId,',') SplitSpeciality
		WHERE		UMUser.Status =1
					AND UMUser.UserTypeId IN (2,3)
					AND SplitSpeciality.Item=1
					AND ((ISNULL(@pStaffName,'') = '' )	OR (ISNULL(@pStaffName,'') <> '' AND (StaffName LIKE  + '%' + @pStaffName + '%' --or StaffEmployeeId LIKE  + '%' + @pStaffName + '%'
					) ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Facility.FacilityId = @pFacilityId))

		SELECT		UMUser.UserRegistrationId		AS	StaffMasterId,
					UMUser.StaffName,
					--UMUser.StaffEmployeeId,
					Facility.FacilityName,
					UMUser.PhoneNumber				AS	ContactNo,
					Designation.Designation,
					Designation.UserDesignationId	AS	DesignationId,
					UMUser.Email,
					--CAST(CAST((DATEDIFF(m, UMUser.DateJoined, GETDATE())/12) AS VARCHAR) + '.' + 
					--	CASE	WHEN DATEDIFF(m, UMUser.DateJoined, GETDATE())%12 = 0 THEN '1' 
					--			ELSE cast((abs(DATEDIFF(m, UMUser.DateJoined, GETDATE())%12)) 
					--	AS VARCHAR) END AS FLOAT)				AS [Experience], 
					DATEDIFF(YEAR,UMUser.DateJoined,GETDATE()) AS [Experience],
					@TotalRecords AS TotalRecords
		FROM		UMUserRegistration					AS	UMUser WITH(NOLOCK)
					INNER JOIN	MstLocationFacility		AS	Facility	WITH(NOLOCK) ON UMUser.FacilityId			=	Facility.FacilityId
					LEFT JOIN	UserDesignation			AS	Designation WITH(NOLOCK) ON UMUser.UserDesignationId	=	Designation.UserDesignationId
					--INNER JOIN	UserSpeciality			AS	Speciality WITH(NOLOCK) ON UMUser.UserSpecialityId		=	Speciality.UserSpecialityId
					OUTER APPLY SplitString(UMUser.UserSpecialityId,',') SplitSpeciality
		WHERE		UMUser.Status =1
					AND UMUser.UserTypeId IN (2,3)
					AND SplitSpeciality.Item=1
					AND ((ISNULL(@pStaffName,'') = '' )	OR (ISNULL(@pStaffName,'') <> '' AND (StaffName LIKE  + '%' + @pStaffName + '%' --or StaffEmployeeId LIKE  + '%' + @pStaffName + '%'
					) ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Facility.FacilityId = @pFacilityId))
		ORDER BY	UMUser.ModifiedDateUTC DESC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 

	END

	ELSE

	BEGIN


		SELECT		@TotalRecords	=	COUNT(*)
		FROM		UMUserRegistration					AS	UMUser WITH(NOLOCK)
					INNER JOIN	MstLocationFacility		AS	Facility	WITH(NOLOCK) ON UMUser.FacilityId			=	Facility.FacilityId
					LEFT JOIN	UserDesignation			AS	Designation WITH(NOLOCK) ON UMUser.UserDesignationId	=	Designation.UserDesignationId
					--INNER JOIN	UserSpeciality			AS	Speciality WITH(NOLOCK) ON UMUser.UserSpecialityId		=	Speciality.UserSpecialityId
					--OUTER APPLY SplitString(UMUser.UserSpecialityId,',') SplitSpeciality
		WHERE		UMUser.Status =1
					AND UMUser.UserTypeId IN (2,3)
					--AND SplitSpeciality.Item=1
					AND ((ISNULL(@pStaffName,'') = '' )	OR (ISNULL(@pStaffName,'') <> '' AND (StaffName LIKE  + '%' + @pStaffName + '%' --or StaffEmployeeId LIKE  + '%' + @pStaffName + '%'
					) ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Facility.FacilityId = @pFacilityId))

		SELECT		UMUser.UserRegistrationId		AS	StaffMasterId,
					UMUser.StaffName,
					--UMUser.StaffEmployeeId,
					Facility.FacilityName,
					UMUser.PhoneNumber				AS	ContactNo,
					Designation.Designation,
					Designation.UserDesignationId	AS	DesignationId,
					UMUser.Email,
					--CAST(CAST((DATEDIFF(m, UMUser.DateJoined, GETDATE())/12) AS VARCHAR) + '.' + 
					--	CASE	WHEN DATEDIFF(m, UMUser.DateJoined, GETDATE())%12 = 0 THEN '1' 
					--			ELSE cast((abs(DATEDIFF(m, UMUser.DateJoined, GETDATE())%12)) 
					--	AS VARCHAR) END AS FLOAT)				AS [Experience], 
					DATEDIFF(YEAR,UMUser.DateJoined,GETDATE()) AS [Experience],
					@TotalRecords AS TotalRecords
		FROM		UMUserRegistration					AS	UMUser WITH(NOLOCK)
					INNER JOIN	MstLocationFacility		AS	Facility	WITH(NOLOCK) ON UMUser.FacilityId			=	Facility.FacilityId
					LEFT JOIN	UserDesignation			AS	Designation WITH(NOLOCK) ON UMUser.UserDesignationId	=	Designation.UserDesignationId
					--INNER JOIN	UserSpeciality			AS	Speciality WITH(NOLOCK) ON UMUser.UserSpecialityId		=	Speciality.UserSpecialityId
					--OUTER APPLY SplitString(UMUser.UserSpecialityId,',') SplitSpeciality
		WHERE		UMUser.Status =1
					AND UMUser.UserTypeId IN (2,3)
					--AND SplitSpeciality.Item=1
					AND ((ISNULL(@pStaffName,'') = '' )	OR (ISNULL(@pStaffName,'') <> '' AND (StaffName LIKE  + '%' + @pStaffName + '%' --or StaffEmployeeId LIKE  + '%' + @pStaffName + '%'
					) ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Facility.FacilityId = @pFacilityId))
		ORDER BY	UMUser.ModifiedDateUTC DESC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 

	END


END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   );
		 THROW;

END CATCH
GO
