USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngSpareParts]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
























CREATE VIEW [dbo].[V_EngSpareParts]



AS



	SELECT	SpareParts.SparePartsId,



			ItemMaster.ItemNo					AS	ItemCode,



			ItemMaster.ItemDescription,



			SpareParts.PartNo,



			SpareParts.PartDescription,



			PartsCategory.Category				AS	PartCategoryName,



			Model.Model							AS	ModelName,



			Manufacturer.Manufacturer			AS	ManufacturerName,



			TypeCode.AssetTypeCode,

			SpareParts.PartSourceId,

			PartSourceLov.FieldValue   PartSource, 



			TypeCode.AssetTypeDescription,



			CASE WHEN SpareParts.Status=1 THEN 'Active'



				 WHEN SpareParts.Status=2 THEN 'Inactive'



			END									AS	StatusValue,



			SpareParts.Status,



			SpareParts.ModifiedDateUTC



	FROM	EngSpareParts									AS	SpareParts		WITH(NOLOCK)



			INNER JOIN FMItemMaster							AS	ItemMaster		WITH(NOLOCK)	ON	SpareParts.ItemId				=	ItemMaster.ItemId



			LEFT JOIN EngSparePartsCategory					AS	PartsCategory	WITH(NOLOCK)	ON	ItemMaster.PartCategory			=	PartsCategory.SparePartsCategoryId



			LEFT JOIN EngAssetStandardizationManufacturer	AS	Manufacturer	WITH(NOLOCK)	ON	SpareParts.ManufacturerId		=	Manufacturer.ManufacturerId



			LEFT JOIN EngAssetStandardizationModel			AS	Model			WITH(NOLOCK)	ON	SpareParts.ModelId				=	Model.ModelId



			LEFT JOIN EngAssetTypeCode						AS	TypeCode		WITH(NOLOCK)	ON	SpareParts.AssetTypeCodeId	=	TypeCode.AssetTypeCodeId



			LEFT JOIN FMLovMst								AS	PartSourceLov		WITH(NOLOCK)	ON	PartSourceLov.LovId	=	SpareParts.PartSourceId
GO
