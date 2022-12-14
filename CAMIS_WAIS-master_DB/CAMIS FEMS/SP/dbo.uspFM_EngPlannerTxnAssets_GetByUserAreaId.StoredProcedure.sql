USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngPlannerTxnAssets_GetByUserAreaId]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngPlannerTxnAssets_GetByUserAreaId
Description			: To Get the data from table EngPlannerTxn using the Primary Key id
Authors				: Balaji M S
Date				: 11-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngPlannerTxnAssets_GetByUserAreaId] @pUserAreaId=1,@pPageSize=5,@pPageIndex=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngPlannerTxnAssets_GetByUserAreaId]                           
  
  --@pPageSize INT,
  --@pPageIndex INT,
  @pUserAreaId INT

AS                                              

BEGIN TRY

	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @TotalRecords INT;
	DECLARE	@pTotalPage	NUMERIC(24,2)

	--SELECT	@TotalRecords	=	COUNT(*)
	--FROM	EngAsset										AS Asset			WITH(NOLOCK)
	--		LEFT JOIN  MstLocationUserArea					AS UserArea			WITH(NOLOCK)	ON UserArea.UserAreaId		= Asset.UserAreaId
	--		LEFT JOIN  EngAssetTypeCode					AS AssetTypeCode	WITH(NOLOCK)	ON Asset.AssetTypeCodeId	= AssetTypeCode.AssetTypeCodeId
	--		--LEFT JOIN  MstLocationUserLocation				AS UserLocation		WITH(NOLOCK)	ON Asset.UserLocationId		= UserLocation.UserLocationId
	--		LEFT JOIN  EngAssetStandardizationManufacturer	AS Manufacturer		WITH(NOLOCK)	ON Asset.Manufacturer		= Manufacturer.ManufacturerId
	--		LEFT JOIN  EngAssetStandardizationModel			AS Model			WITH(NOLOCK)	ON Asset.Model				= Model.ModelId
	--WHERE	UserArea.UserAreaId = @pUserAreaId


	--SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	--SET @pTotalPage = CEILING(@pTotalPage)

    SELECT	DISTINCT UserArea.UserAreaId			AS UserAreaId,
			Asset.AssetId,
			Asset.AssetNo,
			Asset.AssetDescription,
			AssetTypeCode.AssetTypeCode,
			AssetTypeCode.AssetTypeDescription,
			Manufacturer.Manufacturer				AS	ManufacturerName,
			Model.Model								AS	ModelName,
			--@TotalRecords							AS	TotalRecords,
			--@pTotalPage								AS	TotalPageCalc
			0							AS	TotalRecords,
			0								AS	TotalPageCalc
	FROM	EngAsset										AS Asset			WITH(NOLOCK)
			LEFT JOIN  MstLocationUserArea					AS UserArea			WITH(NOLOCK)	ON UserArea.UserAreaId		= Asset.UserAreaId
			LEFT JOIN  EngAssetTypeCode						AS AssetTypeCode	WITH(NOLOCK)	ON Asset.AssetTypeCodeId	= AssetTypeCode.AssetTypeCodeId
			--LEFT JOIN  MstLocationUserLocation			AS UserLocation		WITH(NOLOCK)	ON Asset.UserLocationId		= UserLocation.UserLocationId
			LEFT JOIN  EngAssetStandardizationManufacturer	AS Manufacturer		WITH(NOLOCK)	ON Asset.Manufacturer		= Manufacturer.ManufacturerId
			LEFT JOIN  EngAssetStandardizationModel			AS Model			WITH(NOLOCK)	ON Asset.Model				= Model.ModelId
	WHERE	UserArea.UserAreaId = @pUserAreaId
	ORDER BY Asset.AssetNo DESC
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
