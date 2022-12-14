USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngAssetAccessories_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngAssetAccessories_GetById
Description			: To Get the data from table EngAssetAccessories using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngAssetAccessories_GetById] @pAssetId=99

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngAssetAccessories_GetById]
                           
  @pAssetId			INT

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	  @TotalRecords		INT
	DECLARE   @pTotalPage		NUMERIC(24,2)
	DECLARE   @pTotalPageCalc	INT

	IF(ISNULL(@pAssetId,0) = 0) RETURN



    SELECT	AssetAccessories.AccessoriesId						AS AccessoriesId,
			AssetAccessories.AssetId							AS AssetId,
			Asset.AssetNo										AS AssetNo,
			Asset.AssetDescription								AS AssetDescription,
			AssetAccessories.AccessoriesDescription				AS AccessoriesDescription,
			AssetAccessories.SerialNo							AS SerialNo,			
			AssetAccessories.Manufacturer						AS ManufacturerName,
			AssetAccessories.Model								AS ModelName,
			AssetAccessories.DocumentTitle						AS DocumentTitle,		
			AssetAccessories.DocumentExtension					AS DocumentExtension,
			AssetAccessories.FileName							AS FileName,
			AssetAccessories.DocumentRemarks					AS DocumentRemarks,
			AssetAccessories.FilePath							AS FilePath,
			AssetAccessories.DocumentGuid						AS DocumentGuid,
			@TotalRecords										AS TotalRecords,
			@pTotalPageCalc										AS TotalPageCalc
	FROM	EngAssetAccessories									AS AssetAccessories			WITH(NOLOCK)
			INNER JOIN	EngAsset								AS Asset					WITH(NOLOCK)			on AssetAccessories.AssetId				= Asset.AssetId
			--LEFT JOIN  EngAssetStandardizationManufacturer		AS Manufacturer				WITH(NOLOCK)			on AssetAccessories.Manufacturer		= Manufacturer.ManufacturerId
			--LEFT JOIN  EngAssetStandardizationModel			AS Model					WITH(NOLOCK)			on AssetAccessories.Model				= Model.ModelId
	WHERE	AssetAccessories.AssetId = @pAssetId 
	ORDER BY AssetAccessories.ModifiedDate DESC




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
