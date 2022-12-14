USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_StaffShiftDet_Search]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_StaffShiftDet_Search
Description			: StaffName fetch control
Authors				: Dhilip V
Date				: 11-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_StaffShiftDet_Search  @pStaffName=null,@pPageIndex=1,@pPageSize=50,@pFacilityId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_StaffShiftDet_Search]   
                        
  @pStaffName			NVARCHAR(100)	=	NULL,
  @pPageIndex			INT,
  @pPageSize			INT,
  @pFacilityId			INT,
  @pDesignation			NVARCHAR(100)	=	NULL
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT
-- Default Values


-- Execution


		SELECT		DISTINCT UMUser.UserRegistrationId,
					UMUser.StaffName,
					UMUser.MobileNumber,
					UserType.Name	AS UserType,
					UserRole.Name		AS [Role],
					Designation.Designation,
					@TotalRecords AS TotalRecords
		INTO		#TempUserReg
		FROM		UMUserRegistration					AS	UMUser		WITH(NOLOCK)
					INNER JOIN	UMUserLocationMstDet	AS	UMUserDet	WITH(NOLOCK) ON UMUser.UserRegistrationId	=	UMUserDet.UserRegistrationId
					INNER JOIN	MstLocationFacility		AS	Facility	WITH(NOLOCK) ON UMUser.FacilityId			=	Facility.FacilityId
					INNER JOIN	UserDesignation			AS	Designation WITH(NOLOCK) ON UMUser.UserDesignationId	=	Designation.UserDesignationId
					INNER JOIN	UMUserType				AS	UserType	WITH(NOLOCK) ON UMUser.UserTypeId			=	UserType.UserTypeId
					INNER JOIN	UMUserRole				AS	UserRole	WITH(NOLOCK) ON UMUserDet.UserRoleId		=	UserRole.UMUserRoleId
		WHERE		UMUser.Status =1
					AND ((ISNULL(@pStaffName,'') = '' )	OR (ISNULL(@pStaffName,'') <> '' AND (StaffName LIKE  + '%' + @pStaffName + '%') ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND UMUserDet.FacilityId = @pFacilityId))
					AND UserType.UserTypeId = 2
					AND ((ISNULL(@pDesignation,'')='' )		OR (ISNULL(@pDesignation,'') <> '' AND Designation.Designation LIKE  + '%' +  @pDesignation + '%'))
		--ORDER BY	UMUser.ModifiedDateUTC DESC
		--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 

		SELECT		@TotalRecords	=	COUNT(*)
		FROM		#TempUserReg


		SELECT		UserRegistrationId,
					StaffName,
					MobileNumber,
					UserType,
					CAST('' AS nvarchar(50)) AS AccessLevel,
					[Role],
					Designation,
					@TotalRecords AS TotalRecords
		FROM		#TempUserReg
		ORDER BY	UserRegistrationId DESC
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
