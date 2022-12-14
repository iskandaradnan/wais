USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EODModel_Fetch]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EODModel_Fetch
Description			: Model Fetch control
Authors				: Dhilip V
Date				: 15-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EODModel_Fetch  @pModel=null,@pCategorySystemId=1,@pManufacturerId=3,@pPageIndex=1,@pPageSize=5
SELECT * FROM EngAssetStandardization
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EODModel_Fetch]                       
  @pModel				NVARCHAR(100)	=	NULL,
  @pCategorySystemId	INT,
  @pManufacturerId		INT,
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

		SELECT		DISTINCT Model.ModelId,
					Model.Model,
					Model.ModifiedDateUTC
		INTO		#TempRes
		FROM		EngAssetStandardizationModel			AS Model WITH(NOLOCK)
					INNER JOIN EngAssetStandardization			AS AssetStd WITH(NOLOCK)	ON	Model.ModelId				=	AssetStd.ModelId
					INNER JOIN EngEODCategorySystemDet			AS CatSysDet WITH(NOLOCK)	ON	AssetStd.AssetTypeCodeId	=	CatSysDet.AssetTypeCodeId
		WHERE		Model.Active =1 AND AssetStd.Status=1
					AND ((ISNULL(@pModel,'')='' )	OR ( ISNULL(@pModel,'') <> ''  AND Model LIKE '%' + @pModel + '%'))
					AND ((ISNULL(@pCategorySystemId,'')='' )	OR ( ISNULL(@pCategorySystemId,'') <> ''  AND CatSysDet.CategorySystemId = @pCategorySystemId))
					AND ((ISNULL(@pManufacturerId,'')='' )	OR ( ISNULL(@pManufacturerId,'') <> ''  AND AssetStd.ManufacturerId = @pManufacturerId))


		SELECT	@TotalRecords	=	COUNT(1)
		FROM	#TempRes

		SELECT	ModelId,
				Model,
				@TotalRecords	AS	TotalRecords
		FROM	#TempRes
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
