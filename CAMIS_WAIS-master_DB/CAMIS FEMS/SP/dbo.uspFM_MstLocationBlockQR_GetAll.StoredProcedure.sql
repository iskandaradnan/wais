USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstLocationBlockQR_GetAll]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_MstLocationBlockQR_GetAll]
Description			: QR Code Asset number fetch control
Authors				: Dhilip V
Date				: 23-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_MstLocationBlockQR_GetAll]  @pBlockCode='',@pPageIndex=1,@pPageSize=20
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_MstLocationBlockQR_GetAll]                           
                            
  @pContainsBlockName				NVARCHAR(100)	=	NULL,
  @pBeginWithBlockName				NVARCHAR(100)	=	NULL,
  @pEqualBlockName					NVARCHAR(100)	=	NULL,
  @pNotEqulBlockName					NVARCHAR(100)	=	NULL,

  @pContainsLevelName			NVARCHAR(100)	=	NULL,
  @pBeginWithLevelName			NVARCHAR(100)	=	NULL,
  @pEqualLevelName				NVARCHAR(100)	=	NULL,
  @pNotEqulLevelName				NVARCHAR(100)	=	NULL,

  @pContainsUserArea				NVARCHAR(100)	=	NULL,
  @pBeginWithUserArea				NVARCHAR(100)	=	NULL,
  @pEqualUserArea					NVARCHAR(100)	=	NULL,
  @pNotEqulUserArea					NVARCHAR(100)	=	NULL,

  @pContainsUserLocation			NVARCHAR(100)	=	NULL,
  @pBeginWithUserLocation			NVARCHAR(100)	=	NULL,
  @pEqualUserLocation				NVARCHAR(100)	=	NULL,
  @pNotEqulUserLocation				NVARCHAR(100)	=	NULL,


  @pPageIndex			INT,
  @pPageSize			INT

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
		FROM		MstLocationBlock								AS	Block				WITH(NOLOCK)
					INNER JOIN	MstLocationLevel					AS	Level				WITH(NOLOCK) ON	Block.BlockId			=	Level.BlockId
					INNER JOIN	MstLocationUserArea					AS	UserArea			WITH(NOLOCK) ON	Block.BlockId			=	UserArea.BlockId
					INNER JOIN	MstLocationUserLocation				AS	UserLocation		WITH(NOLOCK) ON	Block.BlockId			=	UserLocation.BlockId
		WHERE		Block.Active =1
					AND ((ISNULL(@pContainsBlockName,'')='' )		OR (ISNULL(@pContainsBlockName,'') <> '' AND Block.BlockName LIKE '%' + @pContainsBlockName + '%'))
					AND ((ISNULL(@pBeginWithBlockName,'')='' )		OR (ISNULL(@pBeginWithBlockName,'') <> '' AND Block.BlockName LIKE '' + @pBeginWithBlockName + '%'))
					AND ((ISNULL(@pEqualBlockName,'')='' )		OR (ISNULL(@pEqualBlockName,'') <> '' AND Block.BlockName = '' + @pEqualBlockName + ''))
					AND ((ISNULL(@pNotEqulBlockName,'')='' )		OR (ISNULL(@pNotEqulBlockName,'') <> '' AND Block.BlockName <> '' + @pNotEqulBlockName + ''))

					AND ((ISNULL(@pContainsLevelName,'')='' )		OR (ISNULL(@pContainsLevelName,'') <> '' AND Level.LevelName LIKE '%' + @pContainsLevelName + '%'))
					AND ((ISNULL(@pBeginWithLevelName,'')='' )		OR (ISNULL(@pBeginWithLevelName,'') <> '' AND Level.LevelName LIKE '' + @pBeginWithLevelName + '%'))
					AND ((ISNULL(@pEqualLevelName,'')='' )		OR (ISNULL(@pEqualLevelName,'') <> '' AND Level.LevelName = '' + @pEqualLevelName + ''))
					AND ((ISNULL(@pNotEqulLevelName,'')='' )		OR (ISNULL(@pNotEqulLevelName,'') <> '' AND Level.LevelName <> '' + @pNotEqulLevelName + ''))


					AND ((ISNULL(@pContainsUserArea,'')='' )		OR (ISNULL(@pContainsUserArea,'') <> '' AND UserArea.UserAreaName LIKE '%' + @pContainsUserArea + '%'))
					AND ((ISNULL(@pBeginWithUserArea,'')='' )		OR (ISNULL(@pBeginWithUserArea,'') <> '' AND UserArea.UserAreaName LIKE '' + @pBeginWithUserArea + '%'))
					AND ((ISNULL(@pEqualUserArea,'')='' )		OR (ISNULL(@pEqualUserArea,'') <> '' AND UserArea.UserAreaName = '' + @pEqualUserArea + ''))
					AND ((ISNULL(@pNotEqulUserArea,'')='' )		OR (ISNULL(@pNotEqulUserArea,'') <> '' AND UserArea.UserAreaName <> '' + @pNotEqulUserArea + ''))


					AND ((ISNULL(@pContainsUserLocation,'')='' )		OR (ISNULL(@pContainsUserLocation,'') <> '' AND UserLocation.UserLocationName LIKE '%' + @pContainsUserLocation + '%'))
					AND ((ISNULL(@pBeginWithUserLocation,'')='' )		OR (ISNULL(@pBeginWithUserLocation,'') <> '' AND UserLocation.UserLocationName LIKE '' + @pBeginWithUserLocation + '%'))
					AND ((ISNULL(@pEqualUserLocation,'')='' )		OR (ISNULL(@pEqualUserLocation,'') <> '' AND UserLocation.UserLocationName = '' + @pEqualUserLocation + ''))
					AND ((ISNULL(@pNotEqulUserLocation,'')='' )		OR (ISNULL(@pNotEqulUserLocation,'') <> '' AND UserLocation.UserLocationName <> '' + @pNotEqulUserLocation + ''))


		SELECT		Block.BlockId,
					Block.BlockCode,
					Block.BlockName,
					Level.LevelId,
					Level.LevelCode,
					Level.LevelName,
					Level.LevelId,
					UserArea.UserAreaId,
					UserArea.UserAreaCode,
					UserArea.UserAreaName,
					UserLocation.UserLocationId,
					UserLocation.UserLocationCode,
					UserLocation.UserLocationName,
					@TotalRecords AS TotalRecords
		FROM		MstLocationBlock								AS	Block				WITH(NOLOCK)
					INNER JOIN	MstLocationLevel					AS	Level				WITH(NOLOCK) ON	Block.BlockId			=	Level.BlockId
					INNER JOIN	MstLocationUserArea					AS	UserArea			WITH(NOLOCK) ON	Block.BlockId			=	UserArea.BlockId
					INNER JOIN	MstLocationUserLocation				AS	UserLocation		WITH(NOLOCK) ON	Block.BlockId			=	UserLocation.BlockId
		WHERE		Block.Active =1
					AND ((ISNULL(@pContainsBlockName,'')='' )		OR (ISNULL(@pContainsBlockName,'') <> '' AND Block.BlockName LIKE '%' + @pContainsBlockName + '%'))
					AND ((ISNULL(@pBeginWithBlockName,'')='' )		OR (ISNULL(@pBeginWithBlockName,'') <> '' AND Block.BlockName LIKE '' + @pBeginWithBlockName + '%'))
					AND ((ISNULL(@pEqualBlockName,'')='' )		OR (ISNULL(@pEqualBlockName,'') <> '' AND Block.BlockName = '' + @pEqualBlockName + ''))
					AND ((ISNULL(@pNotEqulBlockName,'')='' )		OR (ISNULL(@pNotEqulBlockName,'') <> '' AND Block.BlockName <> '' + @pNotEqulBlockName + ''))

					AND ((ISNULL(@pContainsLevelName,'')='' )		OR (ISNULL(@pContainsLevelName,'') <> '' AND Level.LevelName LIKE '%' + @pContainsLevelName + '%'))
					AND ((ISNULL(@pBeginWithLevelName,'')='' )		OR (ISNULL(@pBeginWithLevelName,'') <> '' AND Level.LevelName LIKE '' + @pBeginWithLevelName + '%'))
					AND ((ISNULL(@pEqualLevelName,'')='' )		OR (ISNULL(@pEqualLevelName,'') <> '' AND Level.LevelName = '' + @pEqualLevelName + ''))
					AND ((ISNULL(@pNotEqulLevelName,'')='' )		OR (ISNULL(@pNotEqulLevelName,'') <> '' AND Level.LevelName <> '' + @pNotEqulLevelName + ''))


					AND ((ISNULL(@pContainsUserArea,'')='' )		OR (ISNULL(@pContainsUserArea,'') <> '' AND UserArea.UserAreaName LIKE '%' + @pContainsUserArea + '%'))
					AND ((ISNULL(@pBeginWithUserArea,'')='' )		OR (ISNULL(@pBeginWithUserArea,'') <> '' AND UserArea.UserAreaName LIKE '' + @pBeginWithUserArea + '%'))
					AND ((ISNULL(@pEqualUserArea,'')='' )		OR (ISNULL(@pEqualUserArea,'') <> '' AND UserArea.UserAreaName = '' + @pEqualUserArea + ''))
					AND ((ISNULL(@pNotEqulUserArea,'')='' )		OR (ISNULL(@pNotEqulUserArea,'') <> '' AND UserArea.UserAreaName <> '' + @pNotEqulUserArea + ''))


					AND ((ISNULL(@pContainsUserLocation,'')='' )		OR (ISNULL(@pContainsUserLocation,'') <> '' AND UserLocation.UserLocationName LIKE '%' + @pContainsUserLocation + '%'))
					AND ((ISNULL(@pBeginWithUserLocation,'')='' )		OR (ISNULL(@pBeginWithUserLocation,'') <> '' AND UserLocation.UserLocationName LIKE '' + @pBeginWithUserLocation + '%'))
					AND ((ISNULL(@pEqualUserLocation,'')='' )		OR (ISNULL(@pEqualUserLocation,'') <> '' AND UserLocation.UserLocationName = '' + @pEqualUserLocation + ''))
					AND ((ISNULL(@pNotEqulUserLocation,'')='' )		OR (ISNULL(@pNotEqulUserLocation,'') <> '' AND UserLocation.UserLocationName <> '' + @pNotEqulUserLocation + ''))

		ORDER BY	Block.ModifiedDateUTC DESC
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
