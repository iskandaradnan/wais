USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EODManufacturer_Search]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EODManufacturer_Search
Description			: Manufacturer Fetch control
Authors				: Dhilip V
Date				: 15-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EODManufacturer_Search  @pManufacturer=null,@pCategorySystemId=1,@pPageIndex=1,@pPageSize=5
SELECT * FROM EngAssetStandardization
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EODManufacturer_Search]                       
  @pManufacturer		NVARCHAR(100)	=	NULL,
  @pCategorySystemId	INT,
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

		SELECT		DISTINCT Manufacturer.ManufacturerId,
					Manufacturer.Manufacturer,
					Manufacturer.ModifiedDateUTC
					INTO	#TempRes
		FROM		EngAssetStandardizationManufacturer			AS Manufacturer WITH(NOLOCK)
					INNER JOIN EngAssetStandardization			AS AssetStd WITH(NOLOCK)	ON	Manufacturer.ManufacturerId	=	AssetStd.ManufacturerId
					INNER JOIN EngEODCategorySystemDet			AS CatSysDet WITH(NOLOCK)	ON	AssetStd.AssetTypeCodeId	=	CatSysDet.AssetTypeCodeId
		WHERE		Manufacturer.Active =1 AND AssetStd.Status=1
					AND ((ISNULL(@pManufacturer,'')='' )	OR ( ISNULL(@pManufacturer,'') <> ''  AND Manufacturer LIKE '%' + @pManufacturer + '%'))
					AND ((ISNULL(@pCategorySystemId,'')='' )	OR ( ISNULL(@pCategorySystemId,'') <> ''  AND CatSysDet.CategorySystemId = @pCategorySystemId))



		SELECT @TotalRecords	=	COUNT(1)
		FROM #TempRes

		SELECT	ManufacturerId,
				Manufacturer,
				@TotalRecords	AS	TotalRecords
		FROM #TempRes
		ORDER BY	ModifiedDateUTC DESC
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
