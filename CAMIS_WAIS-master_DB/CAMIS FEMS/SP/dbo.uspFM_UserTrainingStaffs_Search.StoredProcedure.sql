USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UserTrainingStaffs_Search]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_UserTrainingStaffs_Search
Description			: StaffName search popup
Authors				: Dhilip V
Date				: 11-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_UserTrainingStaffs_Search  @pStaffName=null,@pPageIndex=1,@pPageSize=5,@pFacilityId=2,@pTrainingScheduleId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_UserTrainingStaffs_Search]   
                        
  @pStaffName			NVARCHAR(100)	=	NULL,
  @pPageIndex			INT,
  @pPageSize			INT,
  @pFacilityId			INT,
  @pTrainingScheduleId	INT =	NULL

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
		FROM		UMUserRegistration				AS	UMUser		WITH(NOLOCK)
					INNER JOIN	MstLocationFacility	AS	Facility	WITH(NOLOCK) ON UMUser.FacilityId			=	Facility.FacilityId
					LEFT JOIN	UserDesignation		AS	Designation WITH(NOLOCK) ON UMUser.UserDesignationId	=	Designation.UserDesignationId
		WHERE		UMUser.Status =1
					AND ((ISNULL(@pStaffName,'') = '' )	OR (ISNULL(@pStaffName,'') <> '' AND (StaffName LIKE + '%' + @pStaffName + '%') ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND UMUser.FacilityId = @pFacilityId))
					AND UMUser.UserRegistrationId	NOT IN (SELECT ParticipantsUserId FROM EngTrainingScheduleTxnDet WHERE TrainingScheduleId	=	ISNULL(@pTrainingScheduleId,''))

		SELECT		UMUser.UserRegistrationId		AS	StaffMasterId,
					UMUser.StaffName,
					--Staff.StaffEmployeeId,
					Designation.Designation,
					Facility.FacilityName,
					@TotalRecords AS TotalRecords
		FROM		UMUserRegistration				AS	UMUser		WITH(NOLOCK)
					INNER JOIN	MstLocationFacility	AS	Facility	WITH(NOLOCK) ON UMUser.FacilityId			=	Facility.FacilityId
					LEFT JOIN	UserDesignation		AS	Designation WITH(NOLOCK) ON UMUser.UserDesignationId	=	Designation.UserDesignationId
		WHERE		UMUser.Status =1
					AND ((ISNULL(@pStaffName,'') = '' )	OR (ISNULL(@pStaffName,'') <> '' AND (StaffName LIKE  + '%' + @pStaffName + '%' ) ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND UMUser.FacilityId = @pFacilityId))
					AND UMUser.UserRegistrationId	NOT IN (SELECT ParticipantsUserId FROM EngTrainingScheduleTxnDet WHERE TrainingScheduleId	=	ISNULL(@pTrainingScheduleId,''))
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
