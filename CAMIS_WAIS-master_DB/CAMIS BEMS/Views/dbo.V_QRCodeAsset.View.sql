USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_QRCodeAsset]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[V_QRCodeAsset]
AS

		SELECT		DISTINCT Asset.AssetId,
					Asset.FacilityId,
					Asset.AssetNo,
					Asset.AssetDescription,
					AssetClassification.AssetClassificationCode,
					TypeCode.AssetTypeCodeId,
					TypeCode.AssetTypeCode,
					TypeCode.AssetTypeDescription,
					Manufacturer.Manufacturer,
					Model.Model,
					UserArea.UserAreaId,
					UserArea.UserAreaCode,
					UserArea.UserAreaName,
					UserLocation.UserLocationId,
					UserLocation.UserLocationCode,
					UserLocation.UserLocationName,
					Asset.QRCode						AS	AssetQRCode,
					Asset.ModifiedDateUTC,
					Asset.ContractType				AS ContractTypeId,
					LovContractType.FieldValue		AS ContractType
		FROM		EngAsset										AS Asset				WITH(NOLOCK)
					INNER JOIN	EngAssetClassification				AS AssetClassification 	WITH(NOLOCK) ON Asset.AssetClassification		= AssetClassification.AssetClassificationId
					INNER JOIN	EngAssetTypeCode					AS TypeCode				WITH(NOLOCK) ON	Asset.AssetTypeCodeId			= TypeCode.AssetTypeCodeId
					LEFT JOIN	EngAssetStandardizationManufacturer	AS	Manufacturer		WITH(NOLOCK) ON	Asset.Manufacturer				= Manufacturer.ManufacturerId
					LEFT JOIN	EngAssetStandardizationModel		AS	Model				WITH(NOLOCK) ON	Asset.Model						= Model.ModelId
					LEFT JOIN	MstLocationUserLocation				AS	UserLocation		WITH(NOLOCK) ON	Asset.UserLocationId			= UserLocation.UserLocationId
					LEFT JOIN	MstLocationUserArea					AS	UserArea			WITH(NOLOCK) ON	Asset.UserAreaId				= UserArea.UserAreaId
					LEFT JOIN	FMLovMst							AS	LovContractType		WITH(NOLOCK) ON	Asset.ContractType				= LovContractType.LovId
		WHERE		Asset.Active =1 AND isnull(Asset.AssetStatusLovId,0) <>2
GO
