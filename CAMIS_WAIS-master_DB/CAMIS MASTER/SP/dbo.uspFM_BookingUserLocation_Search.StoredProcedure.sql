USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BookingUserLocation_Search]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_MstLocationUserLocation_Search
Description			: UserLocation search popup
Authors				: Dhilip V
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_MstLocationUserLocation_Search  @pUserLocationCode=NULL,@pUserLocationName=NULL,@pUserAreaCode=NULL,@pUserAreaName=NULL,
@pUserAreaId=1,@pPageIndex=1,@pPageSize=5,@pFacilityId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_BookingUserLocation_Search]                           
	  @pUserLocationCode			NVARCHAR(100)	=	NULL,
	  @pUserLocationName			NVARCHAR(100)	=	NULL,
	  @pUserAreaCode				NVARCHAR(100)	=	NULL,
	  @pUserAreaName				NVARCHAR(100)	=	NULL,	
	  @pPageIndex					INT,
	  @pPageSize					INT,
	  @pFacilityId					INT
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
		FROM		MstLocationUserLocation						AS UserLocation WITH(NOLOCK)
					INNER JOIN	MstLocationUserArea				AS UserArea		WITH(NOLOCK) ON UserLocation.UserAreaId=UserArea.UserAreaId
					INNER JOIN MstLocationLevel		AS	Level	 WITH(NOLOCK)	ON	UserArea.LevelId		=	Level.LevelId
					INNER JOIN MstLocationBlock		AS	Block	 WITH(NOLOCK)	ON	Level.BlockId			=	Block.BlockId
					INNER JOIN MstLocationFacility	AS	Facility	WITH(NOLOCK)	ON	Block.FacilityId	=	Facility.FacilityId
		WHERE		UserLocation.Active =1
					AND ((ISNULL(@pUserLocationCode,'')='' )	OR ( ISNULL(@pUserLocationCode,'') <> ''  AND  UserLocation.UserLocationCode LIKE '%' + @pUserLocationCode + '%'))
					AND ((ISNULL(@pUserLocationName,'')='' ) OR (ISNULL(@pUserLocationName ,'') <> '' AND UserLocation.UserLocationName LIKE '%' + @pUserLocationName + '%'))
					AND ((ISNULL(@pUserAreaCode,'')='' ) OR (ISNULL(@pUserAreaCode,'') <> '' AND UserArea.UserAreaCode LIKE '%' + @pUserAreaCode + '%'))
					AND ((ISNULL(@pUserAreaName,'')='' ) OR (ISNULL(@pUserAreaName,'') <> '' AND UserArea.UserAreaName LIKE '%' + @pUserAreaName + '%'))
					
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND UserLocation.FacilityId = @pFacilityId))

		SELECT		UserLocation.UserLocationId,
					UserLocation.UserLocationCode,
					UserLocation.UserLocationName,
					UserLocation.UserAreaId,
					UserArea.UserAreaCode,
					UserArea.UserAreaName,
					Level.LevelId,
					Level.LevelCode,
					Level.LevelName,
					Block.BlockId,
					Block.BlockCode,
					Block.BlockName,
					Facility.FacilityCode,
					Facility.FacilityName, 
					@TotalRecords AS TotalRecords
		FROM		MstLocationUserLocation						AS UserLocation WITH(NOLOCK)
					INNER JOIN	MstLocationUserArea				AS UserArea		WITH(NOLOCK) ON UserLocation.UserAreaId=UserArea.UserAreaId
					INNER JOIN MstLocationLevel		AS	Level	 WITH(NOLOCK)	ON	UserArea.LevelId		=	Level.LevelId
					INNER JOIN MstLocationBlock		AS	Block	 WITH(NOLOCK)	ON	Level.BlockId			=	Block.BlockId
					INNER JOIN MstLocationFacility	AS	Facility	 WITH(NOLOCK)	ON	Block.FacilityId	=	Facility.FacilityId
		WHERE		UserLocation.Active =1
					AND ((ISNULL(@pUserLocationCode,'')='' )	OR ( ISNULL(@pUserLocationCode,'') <> ''  AND  UserLocation.UserLocationCode LIKE '%' + @pUserLocationCode + '%'))
					AND ((ISNULL(@pUserLocationName,'')='' ) OR (ISNULL(@pUserLocationName ,'') <> '' AND UserLocation.UserLocationName LIKE '%' + @pUserLocationName + '%'))
					AND ((ISNULL(@pUserAreaCode,'')='' ) OR (ISNULL(@pUserAreaCode,'') <> '' AND UserArea.UserAreaCode LIKE '%' + @pUserAreaCode + '%'))
					AND ((ISNULL(@pUserAreaName,'')='' ) OR (ISNULL(@pUserAreaName,'') <> '' AND UserArea.UserAreaName LIKE '%' + @pUserAreaName + '%'))
					
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND UserLocation.FacilityId = @pFacilityId))
		ORDER BY	UserLocation.ModifiedDateUTC DESC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 

END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	ERROR_LINE())+' - '+ERROR_MESSAGE(),
				GETDATE()
		   )

END CATCH
GO
