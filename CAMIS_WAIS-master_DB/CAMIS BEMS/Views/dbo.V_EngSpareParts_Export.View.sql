USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngSpareParts_Export]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[V_EngSpareParts_Export]
AS
	SELECT	ItemMaster.ItemNo					AS	ItemCode,
			ItemMaster.ItemDescription,
			SpareParts.PartNo,
			SpareParts.PartDescription,
			TypeCode.AssetTypeCode,
			TypeCode.AssetTypeDescription,
			Model.Model							AS	ModelName,
			Manufacturer.Manufacturer			AS	ManufacturerName,			
			UOM.UnitOfMeasurement,
			LovPartType.FieldValue				AS	SparePartType,
			LovPartSource.FieldValue			AS	PartSource,
			LovLifespan.FieldValue				AS	LifespanOptions,

			LovLocation.FieldValue				AS	Location,
			Specify,
						
			MinLevel,
			MaxLevel,
			MinPrice,
			MaxPrice,
			CASE WHEN SpareParts.Status=1 THEN 'Active'
				 WHEN SpareParts.Status=2 THEN 'Inactive'
			END									AS	StatusValue,

			CASE WHEN SpareParts.CurrentStocklevel is null then '0'
			WHEN SpareParts.CurrentStocklevel = ''  then '0'
			 else SpareParts.CurrentStocklevel
			END									AS	CurrentStocklevel,
		  --   SpareParts.CurrentStocklevel,
			SpareParts.ModifiedDateUTC
	FROM	EngSpareParts									AS	SpareParts		WITH(NOLOCK)
			INNER JOIN FMItemMaster							AS	ItemMaster		WITH(NOLOCK)	ON	SpareParts.ItemId				=	ItemMaster.ItemId
			INNER JOIN EngAssetTypeCode						AS	TypeCode		WITH(NOLOCK)	ON	SpareParts.AssetTypeCodeId		=	TypeCode.AssetTypeCodeId
			LEFT JOIN EngSparePartsCategory					AS	PartsCategory	WITH(NOLOCK)	ON	ItemMaster.PartCategory			=	PartsCategory.SparePartsCategoryId
			LEFT JOIN EngAssetStandardizationManufacturer	AS	Manufacturer	WITH(NOLOCK)	ON	SpareParts.ManufacturerId		=	Manufacturer.ManufacturerId
			LEFT JOIN EngAssetStandardizationModel			AS	Model			WITH(NOLOCK)	ON	SpareParts.ModelId				=	Model.ModelId
			LEFT JOIN FMUOM									AS	UOM				WITH(NOLOCK)	ON	SpareParts.UnitOfMeasurement	=	UOM.UOMId
			LEFT JOIN FMLovMst								AS	LovLocation		WITH(NOLOCK)	ON	SpareParts.Location				=	LovLocation.LovId
			LEFT JOIN FMLovMst								AS	LovPartType		WITH(NOLOCK)	ON	SpareParts.SparePartType		=	LovPartType.LovId
			LEFT JOIN FMLovMst								AS	LovLifespan		WITH(NOLOCK)	ON	SpareParts.LifeSpanOptionId		=	LovLifespan.LovId
			LEFT JOIN FMLovMst								AS	LovPartSource	WITH(NOLOCK)	ON	SpareParts.PartSourceId			=	LovPartSource.LovId
GO
