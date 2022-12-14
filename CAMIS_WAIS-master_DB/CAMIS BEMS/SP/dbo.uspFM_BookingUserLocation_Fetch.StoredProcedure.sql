USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BookingUserLocation_Fetch]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_MstLocationUserLocation_Fetch
Description			: UserLocation fetch
Authors				: Dhilip V
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_MstLocationUserLocation_Fetch  @pUserLocationCode='ul',@pUserAreaId=null,@pPageIndex=1,@pPageSize=5,@pFacilityId=null


SELECT * FROM MstLocationUserLocation
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_BookingUserLocation_Fetch]                           
  @pUserLocationCode		NVARCHAR(100)	=	NULL,
  @pPageIndex				INT,
  @pPageSize				INT,
  @pFacilityId				INT
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
		FROM		MstLocationUserLocation UserLocation WITH(NOLOCK)
					INNER JOIN MstLocationUserArea	AS	UserArea	WITH(NOLOCK)	ON	UserLocation.UserAreaId	=	UserArea.UserAreaId
					INNER JOIN MstLocationLevel		AS	Level		WITH(NOLOCK)	ON	UserArea.LevelId		=	Level.LevelId
					INNER JOIN MstLocationBlock		AS	Block		WITH(NOLOCK)	ON	Level.BlockId			=	Block.BlockId
					INNER JOIN MstLocationFacility	AS	Facility	WITH(NOLOCK)	ON	Block.FacilityId	=	Facility.FacilityId
		WHERE		UserLocation.Active =1
					AND ((ISNULL(@pUserLocationCode,'') = '' )	OR (ISNULL(@pUserLocationCode,'') <> '' AND ( UserLocation.UserLocationCode LIKE + '%' + @pUserLocationCode + '%'  OR UserLocation.UserLocationName LIKE + '%' + @pUserLocationCode + '%' )))					
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
					UserLocation.ModifiedDateUTC,
					@TotalRecords AS TotalRecords
		FROM		MstLocationUserLocation UserLocation WITH(NOLOCK)
					INNER JOIN MstLocationUserArea	AS	UserArea WITH(NOLOCK)	ON	UserLocation.UserAreaId	=	UserArea.UserAreaId
					INNER JOIN MstLocationLevel		AS	Level	 WITH(NOLOCK)	ON	UserArea.LevelId		=	Level.LevelId
					INNER JOIN MstLocationBlock		AS	Block	 WITH(NOLOCK)	ON	Level.BlockId			=	Block.BlockId
					INNER JOIN MstLocationFacility	AS	Facility	 WITH(NOLOCK)	ON	Block.FacilityId	=	Facility.FacilityId
		WHERE		UserLocation.Active =1
					AND ((ISNULL(@pUserLocationCode,'') = '' )	OR (ISNULL(@pUserLocationCode,'') <> '' AND ( UserLocation.UserLocationCode LIKE + '%' + @pUserLocationCode + '%'  OR UserLocation.UserLocationName LIKE + '%' + @pUserLocationCode + '%' )))					
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND UserLocation.FacilityId = @pFacilityId))
		ORDER BY	UserLocation.ModifiedDateUTC DESC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 
	
	
	
		--SELECT		UserLocation.UserLocationId,
		--			UserLocation.UserLocationCode,
		--			UserLocation.UserLocationName,
		--			UserLocation.UserAreaId,
		--			UserArea.UserAreaCode,
		--			UserArea.UserAreaName,
		--			Level.LevelCode,
		--			Level.LevelName,
		--			Block.BlockCode,
		--			Block.BlockName,
		--			UserLocation.ModifiedDateUTC,
		--			@TotalRecords AS TotalRecords
		--FROM		MstLocationUserLocation UserLocation WITH(NOLOCK)
		--			INNER JOIN MstLocationUserArea	AS	UserArea WITH(NOLOCK)	ON	UserLocation.UserAreaId	=	UserArea.UserAreaId
		--			INNER JOIN MstLocationLevel		AS	Level	 WITH(NOLOCK)	ON	UserArea.LevelId		=	Level.LevelId
		--			INNER JOIN MstLocationBlock		AS	Block	 WITH(NOLOCK)	ON	Level.BlockId			=	Block.BlockId
		--WHERE		UserLocation.Active =1
		--			AND ((ISNULL(@pUserLocationCode,'') = '' )	OR (ISNULL(@pUserLocationCode,'') <> '' AND ( UserLocation.UserLocationCode LIKE + '%' + @pUserLocationCode + '%'  OR UserLocation.UserLocationName LIKE + '%' + @pUserLocationCode + '%' )))
		--			AND ((ISNULL(@pUserAreaId,'') = '' )	OR (ISNULL(@pUserAreaId,'') <> '' AND UserLocation.UserAreaId =  @pUserAreaId ))
		--			AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND UserLocation.FacilityId = @pFacilityId))
		--ORDER BY	UserLocation.ModifiedDateUTC DESC
		--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 



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
