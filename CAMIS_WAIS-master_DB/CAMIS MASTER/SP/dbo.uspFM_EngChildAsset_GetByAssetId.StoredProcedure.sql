USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngChildAsset_GetByAssetId]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngChildAsset_GetByAssetId
Description			: To Get the data from table EngAsset using the Primary Key id
Authors				: Dhilip V
Date				: 18-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngChildAsset_GetByAssetId] @pAssetId=1,@pPageIndex=2,@pPageSize=5

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngChildAsset_GetByAssetId]                           
  @pAssetId			INT ,
  @pPageIndex		INT	=	NULL,
  @pPageSize		INT	=	NULL
AS                                              

BEGIN TRY


	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @TotalRecords INT

	SET @pPageIndex = (@pPageIndex + 1)

	IF(ISNULL(@pAssetId,0) = 0) RETURN

		SELECT		@TotalRecords	=	COUNT(*)
		FROM	EngAsset											AS Asset				WITH(NOLOCK)
				INNER JOIN	MstService								AS AssetService			WITH(NOLOCK)	ON Asset.ServiceId				= AssetService.ServiceId			
				INNER JOIN	EngAssetTypeCode						AS AssetTypeCode		WITH(NOLOCK)	ON Asset.AssetTypeCodeId		= AssetTypeCode.AssetTypeCodeId
				LEFT JOIN	FMLovMst								AS AssetStatus			WITH(NOLOCK)	ON Asset.AssetStatusLovId		= AssetStatus.LovId
				LEFT JOIN	FMLovMst								AS AssetRealTimeStatus	WITH(NOLOCK)	ON Asset.RealTimeStatusLovId	= AssetRealTimeStatus.LovId			
				LEFT JOIN	EngAssetStandardizationManufacturer		AS Manufacturer			WITH(NOLOCK)	ON Asset.Manufacturer			= Manufacturer.ManufacturerId
				LEFT JOIN	EngAssetStandardizationModel			AS Model				WITH(NOLOCK)	ON Asset.Model					= Model.ModelId				
		WHERE	Asset.AssetParentId = @pAssetId 		

		SELECT	Asset.AssetId												AS AssetId,
				Asset.AssetParentId											AS AssetParentId,
				Asset.ServiceId												AS ServiceId,
				AssetService.ServiceKey										AS ServiceName,						
				Asset.AssetNo												AS AssetNo,
				Asset.AssetDescription										AS AssetDescription,
				Asset.AssetTypeCodeId										AS AssetTypeCodeId,
				AssetTypeCode.AssetTypeCode									AS AssetTypeCode,
				AssetTypeCode.AssetTypeDescription							AS AssetTypeDescription,			
				Asset.Manufacturer											AS ManufacturerId,
				Manufacturer.Manufacturer									AS ManufacturerName,
				Asset.Model													AS ModelId,
				Model.Model													AS ModelName,
				AssetStatus.FieldValue										AS AssetStatus,
				@TotalRecords												AS TotalRecords
		FROM	EngAsset											AS Asset				WITH(NOLOCK)
				INNER JOIN	MstService								AS AssetService			WITH(NOLOCK)	ON Asset.ServiceId				= AssetService.ServiceId			
				INNER JOIN	EngAssetTypeCode						AS AssetTypeCode		WITH(NOLOCK)	ON Asset.AssetTypeCodeId		= AssetTypeCode.AssetTypeCodeId
				LEFT JOIN	FMLovMst								AS AssetStatus			WITH(NOLOCK)	ON Asset.AssetStatusLovId		= AssetStatus.LovId
				LEFT JOIN	FMLovMst								AS AssetRealTimeStatus	WITH(NOLOCK)	ON Asset.RealTimeStatusLovId	= AssetRealTimeStatus.LovId			
				LEFT JOIN	EngAssetStandardizationManufacturer		AS Manufacturer			WITH(NOLOCK)	ON Asset.Manufacturer			= Manufacturer.ManufacturerId
				LEFT JOIN	EngAssetStandardizationModel			AS Model				WITH(NOLOCK)	ON Asset.Model					= Model.ModelId				
		WHERE	Asset.AssetParentId = @pAssetId 
		ORDER BY Asset.ModifiedDate DESC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 
END TRY--RiskRating

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
