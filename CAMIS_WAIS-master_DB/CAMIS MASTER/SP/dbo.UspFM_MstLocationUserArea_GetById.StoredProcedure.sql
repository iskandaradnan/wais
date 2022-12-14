USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_MstLocationUserArea_GetById]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngAssetTypeCodeStandardTasks_GetById
Description			: To Get the data from table EngAssetTypeCodeStandardTasks using the Primary Key id
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC UspFM_MstLocationUserArea_GetById @Id=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_MstLocationUserArea_GetById]                           
 -- @pUserId		 INT,
  @Id   INT 
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


-- Default Values


-- Execution






	IF(ISNULL(@Id,0) = 0) RETURN

    SELECT	UserArea.UserAreaId				AS UserAreaId, 
			UserArea.CustomerId				AS CustomerId,
			UserArea.FacilityId				AS FacilityId,
			UserArea.BlockId				AS BlockId,
			UserArea.LevelId				AS LevelId,
			UserArea.UserAreaCode			AS UserAreaCode,
			UserArea.UserAreaName			AS UserAreaName,
			LocLevel.LevelCode				AS UserLevelCode,
			LocLevel.LevelName				AS UserLevelName,
			UserArea.CustomerUserId			AS CompanyStaffId,
			CompanyStaff.StaffName			AS CompanyStaffName,
			HospitalStaff.StaffName			AS HospitalStaffName,
			UserArea.FacilityUserId			AS HospitalStaffId,
			UserArea.Remarks				AS Remarks,
			UserArea.Active,
			UserArea.[Timestamp],
			UserArea.ActiveFromDate			AS ActiveFromDate,
			UserArea.ActiveFromDateUTC		AS ActiveFromDateUTC,
			UserArea.ActiveToDate			AS ActiveToDate,
			UserArea.ActiveToDateUTC		AS ActiveToDateUTC,
			block.BlockCode,
			block.BlockName,
			UserArea.GuId,
			isnull(UserArea.Category,0) as Category
	FROM	MstLocationUserArea					AS UserArea			WITH(NOLOCK)
			INNER JOIN  MstLocationBlock        AS block		    WITH(NOLOCK)	on UserArea.BlockId			= block.BlockId
			INNER JOIN  MstLocationLevel		AS LocLevel			WITH(NOLOCK)	on UserArea.LevelId			= LocLevel.LevelId
			INNER JOIN  UMUserRegistration		AS CompanyStaff		WITH(NOLOCK)	on UserArea.CustomerUserId	= CompanyStaff.UserRegistrationId
			INNER JOIN  UMUserRegistration		AS HospitalStaff	WITH(NOLOCK)	on UserArea.FacilityUserId	= HospitalStaff.UserRegistrationId
	WHERE	UserArea.UserAreaId = @Id 

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
