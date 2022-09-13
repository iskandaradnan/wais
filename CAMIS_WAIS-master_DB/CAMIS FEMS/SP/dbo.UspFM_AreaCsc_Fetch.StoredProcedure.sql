USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_AreaCsc_Fetch]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_MstLocationLevel_Fetch
Description			: StaffName Fetch control
Authors				: Dhilip V
Date				: 12-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC UspFM_BlockCsc_Fetch  @pBlockCode=null,@pPageIndex=1,@pPageSize=5,@pFacilityId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_AreaCsc_Fetch]   
      
  @pUserAreaCode			NVARCHAR(100)	=	NULL,
  @pPageIndex			INT,
  @pPageSize			INT,
  @pFacilityId			INT,
  @pLevelId				INT = null
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
		FROM		MstLocationUserArea area WITH(NOLOCK)
		           INNER JOIN	MstLocationLevel level WITH(NOLOCK) ON Level.LevelId=area.LevelId
					INNER JOIN	MstLocationBlock Block WITH(NOLOCK) ON Block.BlockId=area.BlockId
					INNER JOIN	MstLocationFacility Facility WITH(NOLOCK) ON Facility.FacilityId=area.FacilityId
					INNER JOIN	MstCustomer Customer WITH(NOLOCK) ON Customer.CustomerId=area.CustomerId
		WHERE		area.Active =1 and area.LevelId=@pLevelId
					AND ((ISNULL(@pUserAreaCode,'') = '' )	OR (ISNULL(@pUserAreaCode,'') <> '' AND (area.UserAreaCode LIKE  + '%' + @pUserAreaCode + '%' or area.UserAreaCode LIKE  + '%' + @pUserAreaCode + '%') ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND area.FacilityId = @pFacilityId))

		SELECT		block.BlockId,
					block.BlockCode,
					block.BlockName,
					Block.BlockId,
					level.LevelId,
					level.LevelCode,
					level.LevelName,
					Facility.FacilityId,
					Customer.CustomerId,
					Facility.FacilityName,
					Facility.FacilityCode,
					area.UserAreaId,
					area.UserAreaCode,
					area.UserAreaName,
					@TotalRecords AS TotalRecords
		FROM		MstLocationUserArea area WITH(NOLOCK)
		           INNER JOIN	MstLocationLevel level WITH(NOLOCK) ON Level.LevelId=area.LevelId
					INNER JOIN	MstLocationBlock Block WITH(NOLOCK) ON Block.BlockId=area.BlockId
					INNER JOIN	MstLocationFacility Facility WITH(NOLOCK) ON Facility.FacilityId=area.FacilityId
					INNER JOIN	MstCustomer Customer WITH(NOLOCK) ON Customer.CustomerId=area.CustomerId
		WHERE		area.Active =1 and area.LevelId=@pLevelId
					AND ((ISNULL(@pUserAreaCode,'') = '' )	OR (ISNULL(@pUserAreaCode,'') <> '' AND (area.UserAreaCode LIKE  + '%' + @pUserAreaCode + '%' or area.UserAreaCode LIKE  + '%' + @pUserAreaCode + '%') ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND area.FacilityId = @pFacilityId))
		ORDER BY	area.ModifiedDateUTC DESC
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
