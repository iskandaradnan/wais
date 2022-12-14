USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_MstLocationUserLocation_GetById]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_MstLocationUserLocation_GetById
Description			: To Get the data from table EngAssetTypeCodeStandardTasks using the Primary Key id
Authors				: Balaji M S
Date				: 04-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_MstLocationUserLocation_GetById]  @Id=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_MstLocationUserLocation_GetById]                           
--  @pUserId				INT,
  @Id		INT 
AS                                              

BEGIN TRY


	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF(ISNULL(@Id,0) = 0) RETURN

    SELECT	UserLocation.UserLocationId							AS UserLocationId,
			UserLocation.CustomerId								AS CustomerId,
			UserLocation.FacilityId								AS FacilityId,
			UserLocation.BlockId								AS BlockId,
			UserLocation.LevelId								AS LevelId,
			UserLocation.UserAreaId								AS UserAreaId,
			UserArea.UserAreaCode								AS UserAreaCode,
			UserArea.UserAreaName								AS UserAreaName,
			UserLocation.UserLocationCode						AS UserLocationCode,
			UserLocation.UserLocationName						AS UserLocationName,
			UserLocation.ActiveFromDate							AS ActiveFromDate,
			UserLocation.ActiveFromDateUTC						AS ActiveFromDateUTC,
			UserLocation.ActiveToDate							AS ActiveToDate,
			UserLocation.ActiveToDateUTC						AS ActiveToDateUTC,
			UserLocation.AuthorizedUserId						AS AuthorizedStaffId,
			Staff.StaffName										AS AuthorizedStaffName ,
			UserLocation.Remarks								AS Remarks, 
			UserLocation.[Timestamp],
			UserLocation.Active,
			UserLocation.CompanyStaffId,
			level.LevelCode,
			level.LevelName,
			block.BlockCode,
			block.BlockName,
						
			company.StaffName			AS CompanyStaffName,
			UserLocation.GuId
	FROM	MstLocationUserLocation								AS UserLocation		   WITH(NOLOCK)
			INNER JOIN  MstLocationBlock						AS block			   WITH(NOLOCK)	ON block.BlockId			        = UserLocation.BlockId
			INNER JOIN  MstLocationLevel						AS level			   WITH(NOLOCK)	ON level.LevelId					= UserLocation.LevelId
			INNER JOIN  MstLocationUserArea						AS UserArea			   WITH(NOLOCK)	ON UserLocation.UserAreaId			= UserArea.UserAreaId
			INNER JOIN	UMUserRegistration						AS Staff			   WITH(NOLOCK)	ON UserLocation.AuthorizedUserId	= Staff.UserRegistrationId
			INNER JOIN	UMUserRegistration						AS company			   WITH(NOLOCK)	ON UserLocation.CompanyStaffId	        = company.UserRegistrationId
	WHERE	UserLocation.UserLocationId = @Id 
	ORDER BY UserLocation.ModifiedDate ASC
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
