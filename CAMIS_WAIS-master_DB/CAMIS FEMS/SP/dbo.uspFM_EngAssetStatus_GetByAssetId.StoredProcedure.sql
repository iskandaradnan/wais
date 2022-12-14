USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetStatus_GetByAssetId]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetStatus_GetByAssetId
Description			: Get the snf details for assets based on status
Authors				: Dhilip V
Date				: 18-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAssetStatus_GetByAssetId  @pAssetId=1
select * from EngAsset
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngAssetStatus_GetByAssetId]      
                     
  @pAssetId		INT

AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


-- Default Values


-- Execution

	IF(ISNULL(@pAssetId,0) = 0) RETURN

    SELECT	Asset.AssetId,
			Variation.VariationId,
			LovStatus.FieldValue			AS	Status,
			Variation.SNFDocumentNo,
			VariationStatus.FieldValue		AS	VariationStatus,
			Variation.VariationRaisedDate	AS	SNFRaisedDate,
			Variation.StartServiceDate,
			Variation.ServiceStopDate,
			Asset.ModifiedDate
 	FROM	EngAsset						AS Asset			WITH(NOLOCK)	
			INNER JOIN VmVariationTxn		AS	Variation		WITH(NOLOCK)	ON Asset.AssetId				=	Variation.AssetId
			INNER JOIN MstLocationFacility	AS	Facility		WITH(NOLOCK)	ON Asset.FacilityId				=	Facility.FacilityId
			INNER JOIN FMLovMst				AS	LovStatus		WITH(NOLOCK)	ON Asset.AssetStatusLovId		=	LovStatus.LovId
			LEFT JOIN  FMLovMst				AS	VariationStatus	WITH(NOLOCK)	ON Variation.VariationStatus	=	VariationStatus.LovId
WHERE	Asset.AssetId = @pAssetId 

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
