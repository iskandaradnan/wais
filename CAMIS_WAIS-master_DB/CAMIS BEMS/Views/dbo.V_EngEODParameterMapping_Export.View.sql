USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngEODParameterMapping_Export]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[V_EngEODParameterMapping_Export]
AS
	SELECT	EODParameter.ParameterMappingId,
			EODParameter.CustomerId,
			Customer.CustomerName,
			EODParameter.FacilityId,
			Facility.FacilityName,
			Service.ServiceKey									AS	Service,
			Classification.AssetClassificationDescription				as	AssetClassification,
			TypeCode.AssetTypeCode,
			TypeCode.AssetTypeDescription,
			Manufacturer.Manufacturer,
			Model.Model,
			EODParameterDet.Parameter,
			EODParameterDet.Standard,
			UOM.UnitOfMeasurement								AS UOM,
			LovDataType.FieldValue								AS DataType,
			EODParameterDet.DataValue							AS DropDownValues,
			EODParameterDet.Minimum,
			EODParameterDet.Maximum,
			LovFrequency.FieldValue								AS Frequency,
			FORMAT(EODParameterDet.EffectiveFrom,'dd-MMM-yyyy') AS EffectiveFrom,
			FORMAT(EODParameterDet.EffectiveTo,'dd-MMM-yyyy')	AS EffectiveTo,
			EODParameterDet.Remarks,
			EODParameter.ModifiedDateUTC
	FROM	EngEODParameterMapping							AS	EODParameter	WITH(NOLOCK)
			INNER JOIN EngEODParameterMappingDet			AS	EODParameterDet	WITH(NOLOCK)	ON	EODParameter.ParameterMappingId		=	EODParameterDet.ParameterMappingId
			INNER JOIN MstCustomer							AS	Customer		WITH(NOLOCK)	ON	EODParameter.CustomerId				=	Customer.CustomerId
			INNER JOIN MstLocationFacility					AS	Facility		WITH(NOLOCK)	ON	EODParameter.FacilityId				=	Facility.FacilityId
			INNER JOIN MstService							AS	Service			WITH(NOLOCK)	ON	EODParameter.ServiceId				=	Service.ServiceId
			INNER JOIN EngAssetClassification				AS	Classification	WITH(NOLOCK)	ON	EODParameter.AssetClassificationId	=	Classification.AssetClassificationId
			INNER JOIN EngAssetTypeCode						AS	TypeCode		WITH(NOLOCK)	ON	EODParameter.AssetTypeCodeId		=	TypeCode.AssetTypeCodeId
			INNER JOIN EngAssetStandardizationManufacturer	AS	Manufacturer	WITH(NOLOCK)	ON	EODParameter.ManufacturerId			=	Manufacturer.ManufacturerId
			INNER JOIN EngAssetStandardizationModel			AS	Model			WITH(NOLOCK)	ON	EODParameter.ModelId				=	Model.ModelId
			LEFT JOIN FMUOM									AS	UOM				WITH(NOLOCK)	ON	EODParameterDet.UOMId				=	UOM.UOMId
			LEFT JOIN FMLovMst								AS	LovDataType		WITH(NOLOCK)	ON	EODParameterDet.DataTypeLovId		=	LovDataType.LovId
			LEFT JOIN FMLovMst								AS	LovFrequency	WITH(NOLOCK)	ON	EODParameter.FrequencyLovId			=	LovFrequency.LovId
GO
