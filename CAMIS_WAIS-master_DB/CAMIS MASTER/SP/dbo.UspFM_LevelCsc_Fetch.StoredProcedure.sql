USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_LevelCsc_Fetch]    Script Date: 20-09-2021 16:43:01 ******/
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
CREATE PROCEDURE  [dbo].[UspFM_LevelCsc_Fetch]   
      
  @pLevelCode			NVARCHAR(100)	=	NULL,
  @pPageIndex			INT,
  @pPageSize			INT,
  @pFacilityId			INT,
  @pBlockId				INT = null
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
		FROM		MstLocationLevel level WITH(NOLOCK)
					INNER JOIN	MstLocationBlock Block WITH(NOLOCK) ON Level.BlockId=Block.BlockId
					INNER JOIN	MstLocationFacility Facility WITH(NOLOCK) ON block.FacilityId=Facility.FacilityId
					INNER JOIN	MstCustomer Customer WITH(NOLOCK) ON Facility.CustomerId=Customer.CustomerId
		WHERE		level.Active =1 and level.BlockId=@pBlockId
					AND ((ISNULL(@pLevelCode,'') = '' )	OR (ISNULL(@pLevelCode,'') <> '' AND (level.LevelCode LIKE  + '%' + @pLevelCode + '%' or level.LevelCode LIKE  + '%' + @pLevelCode + '%') ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Facility.FacilityId = @pFacilityId))

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
					@TotalRecords AS TotalRecords
		FROM		MstLocationLevel level WITH(NOLOCK)
					INNER JOIN	MstLocationBlock Block WITH(NOLOCK) ON Level.BlockId=Block.BlockId
					INNER JOIN	MstLocationFacility Facility WITH(NOLOCK) ON block.FacilityId=Facility.FacilityId
					INNER JOIN	MstCustomer Customer WITH(NOLOCK) ON Facility.CustomerId=Customer.CustomerId
		WHERE		level.Active =1 and level.BlockId=@pBlockId
					AND ((ISNULL(@pLevelCode,'') = '' )	OR (ISNULL(@pLevelCode,'') <> '' AND (level.LevelCode LIKE  + '%' + @pLevelCode + '%' or level.LevelCode LIKE  + '%' + @pLevelCode + '%') ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Facility.FacilityId = @pFacilityId))
		ORDER BY	block.ModifiedDateUTC DESC
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
