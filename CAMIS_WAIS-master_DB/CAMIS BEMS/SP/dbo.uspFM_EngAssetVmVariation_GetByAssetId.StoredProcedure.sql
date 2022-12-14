USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetVmVariation_GetByAssetId]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================

Application Name	: UETrack-BEMS              

Version				: 1.0

Procedure Name		: uspFM_EngAssetVmVariation_GetByAssetId

Description			: Get AssetVmVariation details by passing the AssetId

Authors				: Dhilip V

Date				: 06-May-2018

-----------------------------------------------------------------------------------------------------------



Unit Test:

EXEC uspFM_EngAssetVmVariation_GetByAssetId  @pAssetId=1,@pPageIndex=1,@pPageSize=5

EXEC uspFM_EngAssetVmVariation_GetByAssetId  @pAssetId=84,@pPageIndex=null,@pPageSize=null



-----------------------------------------------------------------------------------------------------------

Version History 

-----:------------:---------------------------------------------------------------------------------------

Init : Date       : Details

========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngAssetVmVariation_GetByAssetId]                           

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



    SELECT	DISTINCT TandC.TestingandCommissioningId		AS	TestingandCommissioningId,

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
			datename(mm,TandC.TandCDate)		AS	VariationMonthName,	
			YEAR(TandC.TandCDate)				AS	VariationYear,					---- Have to verify this

			CASE 

				WHEN TandC.Status=7 THEN 371

				ELSE 372

			END									AS	VariationApprovedStatusLovId,	---- Name has to check with bala

			CASE 

				WHEN TandC.Status=7 THEN 'Approved'

				ELSE 'Reject'

			END									AS	VariationApprovedStatusLovName,

---------- These fields extra needed to the VmVaraiationTable -------------------

			Asset.AssetClassification,

			TandC.WarrantyDuration,

			TandC.WarrantyStartDate,

			TandC.MainSupplierCode,

			TandC.MainSupplierName,

			TandC.ContractLPONo,

			Asset.PurchaseDate,

			--CAST(CASE	WHEN Asset.[Authorization]=199 THEN 1

			--		ELSE 0

			--END									AS BIT)		AS	AuthorizedStatus,

			vm.AuthorizedStatus,
			TandC.Timestamp,

			VM.VariationId

 	FROM	EngAsset										AS	Asset				WITH(NOLOCK)

			--LEFT JOIN	EngTestingandCommissioningTxnDet	AS	TandCDet			WITH(NOLOCK)	ON Asset.TestingandCommissioningDetId	=	TandCDet.TestingandCommissioningDetId

			--LEFT JOIN	EngTestingandCommissioningTxn		AS	TandC				WITH(NOLOCK)	ON TandCDet.TestingandCommissioningId	=	TandC.TestingandCommissioningId

			INNER JOIN	EngTestingandCommissioningTxn		AS	TandC				WITH(NOLOCK)	ON Asset.AssetId						=	TandC.AssetId

			INNER JOIN	FMLovMst							AS	LovVariationStatus	WITH(NOLOCK)	ON TandC.VariationStatus				=	LovVariationStatus.LovId

			OUTER APPLY (SELECT VariationId,AuthorizedStatus FROM VmVariationTxn AS Variation WHERE Asset.AssetId	=	Variation.AssetId AND TandC.VariationStatus=Variation.VariationStatus) VM

	WHERE	Asset.AssetId	=	@pAssetId

			AND TandC.Status	=	290

	ORDER BY	Asset.AssetId ASC

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
