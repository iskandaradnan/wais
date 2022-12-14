USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetVmVariation_GetByAssetId_DD]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetVmVariation_GetByAssetId_DD
Description			: Get AssetVmVariation details by passing the AssetId
Authors				: Dhilip V
Date				: 02-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAssetVmVariation_GetByAssetId_DD  @pAssetId=1,@pPageIndex=1,@pPageSize=5

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAssetVmVariation_GetByAssetId_DD]                           
  @pAssetId			INT,
  @pPageIndex		INT	=	NULL,
  @pPageSize		INT	=	NULL
AS                                                     

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


-- Default Values


-- Execution


	IF(ISNULL(@pAssetId,0) = 0) RETURN

    SELECT	Asset.AssetId						AS	AssetId,
			Asset.CustomerId					AS	CustomerId,
			Asset.FacilityId					AS	FacilityId,
			Asset.ServiceId						AS	ServiceId,
			TandC.TandCDocumentNo				AS	SNFDocumentNo,
			TandC.VariationStatus				AS	VariationStatusLovId,
			LovVariationStatus.FieldValue		AS	VariationStatusLovName,
			TandC.PurchaseCost					AS	PurchaseProjectCost,
			TandC.TandCDate						AS	VariationDate,					---- & [SnfDate] Have to verify this  
			TandC.ServiceStartDate				AS	StartServiceDate,
			TandC.ServiceEndDate				AS	StopServiceDate,
			TandC.TandCDate						AS	CommissioningDate,				---- Have to verify this
			TandC.WarrantyEndDate				AS	WarrantyEndDate,
			MONTH(TandC.TandCDate)				AS	VariationMonth,					---- Have to verify this
			YEAR(TandC.TandCDate)				AS	VariationYear,					---- Have to verify this
			TandC.Status						AS	VariationApprovedStatusLovId,	---- Name has to check with bala
			CASE 
				WHEN TandC.Status=7 THEN 'Yes'
				ELSE 'NO'
			END									AS	VariationApprovedStatusLovName,
---------- These fields extra needed to the VmVaraiationTable -------------------
			Asset.AssetClassification,
			TandC.WarrantyDuration,
			TandC.WarrantyStartDate,
			Asset.UserLocationId,
			Asset.UserAreaId,
			TandC.MainSupplierCode,
			TandC.MainSupplierName,
			TandC.ContractLPONo

 	FROM	EngAsset										AS	Asset				WITH(NOLOCK)
			INNER JOIN	EngTestingandCommissioningTxnDet	AS	TandCDet			WITH(NOLOCK)	ON Asset.TestingandCommissioningDetId	=	TandCDet.TestingandCommissioningDetId
			INNER JOIN	EngTestingandCommissioningTxn		AS	TandC				WITH(NOLOCK)	ON TandCDet.TestingandCommissioningId	=	TandC.TestingandCommissioningId
			INNER JOIN	FMLovMst							AS	LovVariationStatus	WITH(NOLOCK)	ON TandC.VariationStatus				=	LovVariationStatus.LovId
	WHERE	Asset.AssetId	=	@pAssetId
	ORDER BY	Asset.AssetId ASC
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
