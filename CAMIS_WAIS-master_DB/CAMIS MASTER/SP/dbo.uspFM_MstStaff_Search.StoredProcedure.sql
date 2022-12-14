USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstStaff_Search]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_MstStaff_Search
Description			: StaffName search popup
Authors				: Dhilip V
Date				: 02-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_MstStaff_Search  @pStaffName='',@pFacilityName=null,@pPageIndex=1,@pPageSize=50,@pFacilityId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_MstStaff_Search]     
                      
  @pStaffName			NVARCHAR(100)	=	NULL,
  @pFacilityName		NVARCHAR(100)	=	NULL,
  --@pStaffEmployeeId		NVARCHAR(100)	=	NULL,
  @pDesignation			NVARCHAR(200)	=	NULL,
  @pPageIndex			INT,
  @pPageSize			INT,
  @pFacilityId			INT
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT

-- Default Values


-- Execution
		SELECT		@TotalRecords	=	COUNT(*)
		FROM		UMUserRegistration					AS	UMUser		WITH(NOLOCK)
					LEFT JOIN	UMUserLocationMstDet	AS	UserLoc		WITH(NOLOCK) ON UMUser.UserRegistrationId	=	UserLoc.UserRegistrationId
					LEFT JOIN	MstLocationFacility		AS	Facility	WITH(NOLOCK) ON UserLoc.FacilityId			=	Facility.FacilityId
					LEFT JOIN	UserDesignation			AS	Designation WITH(NOLOCK) ON UMUser.UserDesignationId	=	Designation.UserDesignationId
		WHERE		UMUser.Status =1 and UMUser.UserTypeId in (1,2) 
					AND ((ISNULL(@pStaffName,'')='' )	OR ( ISNULL(@pStaffName,'') <> ''  AND StaffName LIKE '%' + @pStaffName + '%'))
					--AND ((ISNULL(@pStaffEmployeeId,'')='' ) OR (ISNULL(@pStaffEmployeeId ,'') <> '' AND StaffEmployeeId LIKE '%' + @pStaffEmployeeId + '%'))
					AND ((ISNULL(@pFacilityName,'')='' ) OR (ISNULL(@pFacilityName,'') <> '' AND Facility.FacilityName LIKE '%' + @pFacilityName + '%'))
					AND ((ISNULL(@pDesignation,'')='' ) OR (ISNULL(@pDesignation,'') <> '' AND Designation.Designation LIKE '%' + @pDesignation + '%'))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND UserLoc.FacilityId = @pFacilityId))

		SELECT		UMUser.UserRegistrationId		AS	StaffMasterId,
					UMUser.StaffName,
					--Staff.StaffEmployeeId,
					Designation.UserDesignationId	AS	DesignationId,
					Designation.Designation,
					Facility.FacilityName,
					@TotalRecords AS TotalRecords
		FROM		UMUserRegistration					AS	UMUser		WITH(NOLOCK)
					LEFT JOIN	UMUserLocationMstDet	AS	UserLoc		WITH(NOLOCK) ON UMUser.UserRegistrationId	=	UserLoc.UserRegistrationId
					LEFT JOIN	MstLocationFacility		AS	Facility	WITH(NOLOCK) ON UserLoc.FacilityId			=	Facility.FacilityId
					LEFT JOIN	UserDesignation			AS	Designation WITH(NOLOCK) ON UMUser.UserDesignationId	=	Designation.UserDesignationId
		WHERE		UMUser.Status =1 and UMUser.UserTypeId in (1,2) 
					AND ((ISNULL(@pStaffName,'')='' )	OR ( ISNULL(@pStaffName,'') <> ''  AND StaffName LIKE '%' + @pStaffName + '%'))
					--AND ((ISNULL(@pStaffEmployeeId,'')='' ) OR (ISNULL(@pStaffEmployeeId ,'') <> '' AND StaffEmployeeId LIKE '%' + @pStaffEmployeeId + '%'))
					AND ((ISNULL(@pFacilityName,'')='' ) OR (ISNULL(@pFacilityName,'') <> '' AND Facility.FacilityName LIKE '%' + @pFacilityName + '%'))
					AND ((ISNULL(@pDesignation,'')='' ) OR (ISNULL(@pDesignation,'') <> '' AND Designation.Designation LIKE '%' + @pDesignation + '%'))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND UserLoc.FacilityId = @pFacilityId))
		ORDER BY	UMUser.ModifiedDateUTC DESC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 

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
