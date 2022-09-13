USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngAssetStandardization_Export]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[V_EngAssetStandardization_Export]
AS

SELECT	AssetStd.AssetStandardizationId,
		TypeCode.AssetTypeCode,
		TypeCode.AssetTypeDescription,
		Model.Model,
		Manufacturer.Manufacturer,		
		LovStatus.FieldValue			AS	Status,
		AssetStd.ModifiedDateUTC
FROM	EngAssetStandardization							AS	AssetStd		WITH(NOLOCK)
		INNER JOIN EngAssetTypeCode						AS TypeCode			WITH(NOLOCK)	ON	AssetStd.AssetTypeCodeId	=	TypeCode.AssetTypeCodeId
		INNER JOIN EngAssetStandardizationManufacturer	AS Manufacturer		WITH(NOLOCK)	ON	AssetStd.ManufacturerId		=	Manufacturer.ManufacturerId
		INNER JOIN EngAssetStandardizationModel			AS Model			WITH(NOLOCK)	ON	AssetStd.ModelId			=	Model.ModelId
		INNER JOIN FMLovMst								AS LovStatus		WITH(NOLOCK)	ON	AssetStd.Status				=	LovStatus.LovId
GO
