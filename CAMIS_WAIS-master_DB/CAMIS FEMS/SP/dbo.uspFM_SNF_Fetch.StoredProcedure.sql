USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_SNF_Fetch]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_SNF_Fetch
Description			: StaffName search popup
Authors				: Dhilip V
Date				: 09-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_SNF_Fetch  @pAssetId=1,@pSNFDocNo=NULL,@pPageIndex=1,@pPageSize=5,@pFacilityId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_SNF_Fetch]                           
  @pAssetId				INT,
  @pSNFDocNo			NVARCHAR(100)	=	NULL,
  @pPageIndex			INT,
  @pPageSize			INT,
  @pFacilityId			INT
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT
	DECLARE	@pTotalPage		NUMERIC(24,2)

-- Default Values


-- Execution

	SELECT	@TotalRecords	=	COUNT(*)
 	FROM	EngAsset										AS	Asset				WITH(NOLOCK)
			--INNER JOIN	EngTestingandCommissioningTxnDet	AS	TandCDet			WITH(NOLOCK)	ON Asset.TestingandCommissioningDetId	=	TandCDet.TestingandCommissioningDetId
			--INNER JOIN	EngTestingandCommissioningTxn		AS	TandC				WITH(NOLOCK)	ON TandCDet.TestingandCommissioningId	=	TandC.TestingandCommissioningId
			INNER JOIN	EngTestingandCommissioningTxn		AS	TandC				WITH(NOLOCK)	ON Asset.AssetId						=	TandC.AssetId
			INNER JOIN	FMLovMst							AS	LovVariationStatus	WITH(NOLOCK)	ON TandC.VariationStatus				=	LovVariationStatus.LovId
	WHERE	((ISNULL(@pAssetId,'') = '' )	OR (ISNULL(@pAssetId,'') <> '' AND Asset.AssetId = @pAssetId  ))
			AND ((ISNULL(@pSNFDocNo,'') = '' )	OR (ISNULL(@pSNFDocNo,'') <> '' AND TandC.TandCDocumentNo LIKE + '%' + @pSNFDocNo + '%' ))
			AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPage = CEILING(@pTotalPage)

    SELECT	TandC.TestingandCommissioningId		AS	TestingandCommissioningId,
			Asset.AssetId						AS	AssetId,
			Asset.CustomerId					AS	CustomerId,
			Asset.FacilityId					AS	FacilityId,
			Asset.ServiceId						AS	ServiceId,
			TandC.TandCDocumentNo				AS	SNFDocumentNo,
			TandC.VariationStatus				AS	VariationStatusLovId,
			LovVariationStatus.FieldValue		AS	VariationStatusLovName,
			TandC.PurchaseCost					AS	PurchaseProjectCost,
			TandC.TandCDate						AS	VariationDate,					---- & [SnfDate] Have to verify this  
			TandC.TandCDate						AS	SnfDate,
			TandC.ServiceStartDate				AS	StartServiceDate,
			TandC.ServiceEndDate				AS	StopServiceDate,
			TandC.TandCDate						AS	CommissioningDate,				---- Have to verify this
			TandC.WarrantyEndDate				AS	WarrantyEndDate,
			MONTH(TandC.TandCDate)				AS	VariationMonth,					---- Have to verify this
			YEAR(TandC.TandCDate)				AS	VariationYear,					---- Have to verify this
			CASE 
				WHEN TandC.Status=7 THEN 99
				ELSE 100
			END									AS	VariationApprovedStatusLovId,	---- Name has to check with bala
			CASE 
				WHEN TandC.Status=7 THEN 'Yes'
				ELSE 'NO'
			END									AS	VariationApprovedStatusLovName,
---------- These fields extra needed to the VmVaraiationTable -------------------
			Asset.AssetClassification,
			TandC.WarrantyDuration,
			TandC.WarrantyStartDate,
			TandC.MainSupplierCode,
			TandC.MainSupplierName,
			TandC.ContractLPONo,
			Asset.PurchaseDate,
			CAST(CASE	WHEN Asset.[Authorization]=199 THEN 1
					ELSE 0
			END						AS BIT)		AS	AuthorizedStatus,
			TandC.Timestamp,
			@TotalRecords						AS TotalRecords,
			@pTotalPage							AS TotalPageCalc
 	FROM	EngAsset										AS	Asset				WITH(NOLOCK)
			--INNER JOIN	EngTestingandCommissioningTxnDet	AS	TandCDet			WITH(NOLOCK)	ON Asset.TestingandCommissioningDetId	=	TandCDet.TestingandCommissioningDetId
			--INNER JOIN	EngTestingandCommissioningTxn		AS	TandC				WITH(NOLOCK)	ON TandCDet.TestingandCommissioningId	=	TandC.TestingandCommissioningId
			INNER JOIN	EngTestingandCommissioningTxn		AS	TandC				WITH(NOLOCK)	ON Asset.AssetId						=	TandC.AssetId
			INNER JOIN	FMLovMst							AS	LovVariationStatus	WITH(NOLOCK)	ON TandC.VariationStatus				=	LovVariationStatus.LovId
	WHERE	((ISNULL(@pAssetId,'') = '' )	OR (ISNULL(@pAssetId,'') <> '' AND Asset.AssetId = @pAssetId  ))
			AND ((ISNULL(@pSNFDocNo,'') = '' )	OR (ISNULL(@pSNFDocNo,'') <> '' AND TandC.TandCDocumentNo LIKE + '%' + @pSNFDocNo + '%' ))
			AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Asset.FacilityId = @pFacilityId))
	ORDER BY Asset.AssetId
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
		   );
		THROW;

END CATCH
GO
