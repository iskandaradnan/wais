USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMAssetObsolete_Fetch]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_CRMAsset_Fetch]
Description			: Asset number fetch control
Authors				: Dhilip V
Date				: 30-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_CRMAssetObsolete_Fetch]  @pAssetNo='',@pModelId=1,@pManufacturerId=3,@pFacilityId=1

SELECT * FROM EngAsset where Manufacturer=3 and Model=1 and FacilityId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_CRMAssetObsolete_Fetch]                           
                            
  @pAssetNo					NVARCHAR(100)	=	NULL,
  @pManufacturerId			NVARCHAR(100)	=	NULL,
  @pModelId			INT				=	NULL,
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
		FROM		EngAsset										AS Asset				WITH(NOLOCK)
					INNER JOIN	EngAssetStandardizationManufacturer	AS	Manufacturer		WITH(NOLOCK) ON	Asset.Manufacturer				= Manufacturer.ManufacturerId
					INNER JOIN	EngAssetStandardizationModel		AS	Model				WITH(NOLOCK) ON	Asset.Model						= Model.ModelId
		WHERE		Asset.Active =1 AND Asset.AssetStatusLovId <>2
					AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
					AND ((ISNULL(@pManufacturerId,'')='' )		OR (ISNULL(@pManufacturerId,'') <> '' AND Asset.Manufacturer =  + @pManufacturerId ))
					AND ((ISNULL(@pModelId,'')='' )		OR (ISNULL(@pModelId,'') <> '' AND Asset.Model =  + @pModelId ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))

		SELECT		Asset.AssetId,
					Asset.AssetNo,
					Asset.AssetDescription,
					Asset.Manufacturer		AS ManufacturerId,
					Manufacturer.Manufacturer,
					Asset.Model				AS	ModelId,
					Model.Model,
					Asset.SoftwareVersion,
					Asset.SoftwareKey,
					Asset.SerialNo,
					@TotalRecords AS TotalRecords
		FROM		EngAsset										AS Asset				WITH(NOLOCK)
					INNER JOIN	EngAssetStandardizationManufacturer	AS	Manufacturer		WITH(NOLOCK) ON	Asset.Manufacturer				= Manufacturer.ManufacturerId
					INNER JOIN	EngAssetStandardizationModel		AS	Model				WITH(NOLOCK) ON	Asset.Model						= Model.ModelId
		WHERE		Asset.Active =1 AND Asset.AssetStatusLovId <>2
					AND ((ISNULL(@pAssetNo,'')='' )		OR (ISNULL(@pAssetNo,'') <> '' AND Asset.AssetNo LIKE '%' + @pAssetNo + '%'))
					AND ((ISNULL(@pManufacturerId,'')='' )		OR (ISNULL(@pManufacturerId,'') <> '' AND Asset.Manufacturer =  + @pManufacturerId ))
					AND ((ISNULL(@pModelId,'')='' )		OR (ISNULL(@pModelId,'') <> '' AND Asset.Model =  + @pModelId ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
		ORDER BY	Asset.ModifiedDateUTC DESC
 

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
