USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_UserLocationFetch]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*========================================================================================================
Application Name	: UETrack-CLS              
Version				: 1.0
Procedure Name		: uspFM_MstLocationUserLocation_Fetch
Description			: UserLocation fetch
Authors				: Venu Kadiyala
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC Sp_CLS_UserLocationFetch  @pUserLocationCode='l',@pUserAreaId=265,@pPageIndex=1,@pPageSize=5,@pFacilityId=0


SELECT * FROM MstLocationUserLocation
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[Sp_CLS_UserLocationFetch]                           
  @pUserLocationCode		NVARCHAR(100)	=	NULL,
  @pUserAreaId				INT				=	NULL,
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
	set @pFacilityId = ''
-- Default Values


-- Execution

		SELECT		@TotalRecords	=	COUNT(*)
		FROM		MstLocationUserLocation UserLocation WITH(NOLOCK)
					INNER JOIN MstLocationUserArea	AS	UserArea WITH(NOLOCK)	ON	UserLocation.UserAreaId	=	UserArea.UserAreaId
					INNER JOIN MstLocationLevel		AS	Level	 WITH(NOLOCK)	ON	UserArea.LevelId		=	Level.LevelId
					INNER JOIN MstLocationBlock		AS	Block	 WITH(NOLOCK)	ON	Level.BlockId			=	Block.BlockId
		WHERE		UserLocation.Active =1
					AND ((ISNULL(@pUserLocationCode,'') = '' )	OR (ISNULL(@pUserLocationCode,'') <> '' AND ( UserLocation.UserLocationCode LIKE + '%' + @pUserLocationCode + '%'  OR UserLocation.UserLocationName LIKE + '%' + @pUserLocationCode + '%' )))
					AND ((ISNULL(@pUserAreaId,'') = '' )	OR (ISNULL(@pUserAreaId,'') <> '' AND UserLocation.UserAreaId =  @pUserAreaId ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND UserLocation.FacilityId = @pFacilityId))

		SELECT		UserLocation.UserLocationId,
					UserLocation.UserLocationCode,
					UserLocation.UserLocationName,
					UserLocation.UserAreaId,
					UserArea.UserAreaCode,
					UserArea.UserAreaName,
					Level.LevelCode,
					Level.LevelName,
					Block.BlockCode,
					Block.BlockName,
					UserLocation.ModifiedDateUTC,
					@TotalRecords AS TotalRecords
		FROM		MstLocationUserLocation UserLocation WITH(NOLOCK)
					INNER JOIN MstLocationUserArea	AS	UserArea WITH(NOLOCK)	ON	UserLocation.UserAreaId	=	UserArea.UserAreaId
					INNER JOIN MstLocationLevel		AS	Level	 WITH(NOLOCK)	ON	UserArea.LevelId		=	Level.LevelId
					INNER JOIN MstLocationBlock		AS	Block	 WITH(NOLOCK)	ON	Level.BlockId			=	Block.BlockId
		WHERE		UserLocation.Active =1
					AND ((ISNULL(@pUserLocationCode,'') = '' )	OR (ISNULL(@pUserLocationCode,'') <> '' AND ( UserLocation.UserLocationCode LIKE + '%' + @pUserLocationCode + '%'  OR UserLocation.UserLocationName LIKE + '%' + @pUserLocationCode + '%' )))
					AND ((ISNULL(@pUserAreaId,'') = '' )	OR (ISNULL(@pUserAreaId,'') <> '' AND UserLocation.UserAreaId =  @pUserAreaId ))
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
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
