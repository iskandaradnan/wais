USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngSpareParts_GetById]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngSpareParts_GetById
Description			: Get the SpareParts details by passing the SparePartsId.
Authors				: Dhilip V
Date				: 26-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngSpareParts_GetById  @pSparePartsId=1
SELECT * FROM EngSpareParts
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngSpareParts_GetById]                           
  @pSparePartsId		INT
AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @mStockAdjustmentQuantity numeric(24,2)
	DECLARE @mStockUpdateQuantity numeric(24,2)

-- Default Values


-- Execution


	IF(ISNULL(@pSparePartsId,0) = 0) RETURN

	IF EXISTS (SELECT 1 FROM EngStockAdjustmentTxnDet WHERE SparePartsId = @pSparePartsId)
	BEGIN
	SET @mStockAdjustmentQuantity = (SELECT SUM(AdjustedQuantity) AS CurrentStockLevel FROM EngStockAdjustmentTxnDet WHERE SparePartsId = @pSparePartsId GROUP BY SparePartsId)
	END

	ELSE
	BEGIN
	SET @mStockUpdateQuantity = (SELECT SUM(Quantity) AS CurrentStockLevel FROM EngStockUpdateRegisterTxnDet WHERE SparePartsId = @pSparePartsId GROUP BY SparePartsId)
	END

    SELECT	SpareParts.SparePartsId,
			SpareParts.ServiceId,
			Service.ServiceKey					AS	ServiceName,
			SpareParts.ItemId,
			ItemMaster.ItemNo,
			ItemMaster.ItemDescription,
			SpareParts.PartNo,
			SpareParts.PartDescription,
			SpareParts.AssetTypeCodeId,
			TypeCode.AssetTypeCode,
			TypeCode.AssetTypeDescription,
			SpareParts.ManufacturerId,
			Manufacturer.Manufacturer			AS ManufacturerName,
			SpareParts.ModelId,
			Model.Model							AS ModelName,
			SpareParts.UnitOfMeasurement,
			UOM.UnitOfMeasurement				AS	UnitOfMeasurementName,
			SpareParts.SparePartType,
			LovPartType.FieldValue				AS SparePartTypeValue,
			SpareParts.Location,
			LovLocation.FieldValue				AS LocationValue,
			SpareParts.Specify,
			SpareParts.PartCategory,
			Category.Category					AS CategoryName,
			
			MinLevel,
			MaxLevel,
			MinPrice,
			MaxPrice,
			SpareParts.Status,
			LovStatus.FieldValue				AS	StatusValue,
			LifeSpanOptionId,
			--CurrentStockLevel,
			Image1DocumentId,
			Image2DocumentId,
			Image3DocumentId,
			Image4DocumentId,
			Image5DocumentId,
			Image6DocumentId,
			VideoDocumentId,
		
			SpareParts.[Timestamp]               AS [Timestamp]
			,SpareParts.PartSourceId,
			SpareParts.GuId,
			SpareParts.EstimatedLifeSpanInHours,
			CASE WHEN @mStockAdjustmentQuantity IS NOT NULL THEN @mStockAdjustmentQuantity ELSE CASE WHEN @mStockAdjustmentQuantity IS NULL THEN ISNULL(@mStockUpdateQuantity,0) END END AS CurrentStockLevel
 	FROM	EngSpareParts										AS SpareParts		WITH(NOLOCK)	
			INNER JOIN	MstService								AS	Service			WITH(NOLOCK)	ON SpareParts.ServiceId			=	Service.ServiceId
			INNER JOIN	FMItemMaster							AS	ItemMaster		WITH(NOLOCK)	ON SpareParts.ItemId			=	ItemMaster.ItemId
			LEFT JOIN	EngAssetTypeCode						AS	TypeCode		WITH(NOLOCK)	ON SpareParts.AssetTypeCodeId	=	TypeCode.AssetTypeCodeId
			INNER JOIN	EngAssetStandardizationManufacturer		AS	Manufacturer	WITH(NOLOCK)	ON SpareParts.ManufacturerId	=	Manufacturer.ManufacturerId
			INNER JOIN  EngAssetStandardizationModel			AS	Model			WITH(NOLOCK)	ON SpareParts.ModelId			=	Model.ModelId
			LEFT JOIN	FMUOM									AS	UOM				WITH(NOLOCK)	ON SpareParts.UnitOfMeasurement	=	UOM.UOMId
			LEFT JOIN	FMLovMst								AS	LovPartType		WITH(NOLOCK)	ON SpareParts.SparePartType		=	LovPartType.LovId
			LEFT JOIN	FMLovMst								AS	LovLocation		WITH(NOLOCK)	ON SpareParts.Location			=	LovLocation.LovId
			INNER JOIN	EngSparePartsCategory					AS	Category		WITH(NOLOCK)	ON SpareParts.PartCategory		=	Category.SparePartsCategoryId
			LEFT JOIN	FMLovMst								AS	LovStatus		WITH(NOLOCK)	ON SpareParts.Status			=	LovStatus.LovId

	WHERE	SpareParts.SparePartsId = @pSparePartsId 





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
