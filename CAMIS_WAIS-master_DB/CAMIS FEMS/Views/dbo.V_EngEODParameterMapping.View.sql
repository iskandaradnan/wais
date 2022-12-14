USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngEODParameterMapping]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[V_EngEODParameterMapping]
AS
	SELECT	EODParameter.ParameterMappingId,
			EODParameter.CustomerId,
			Customer.CustomerName,
			EODParameter.FacilityId,
			Facility.FacilityName,
			Service.ServiceKey					AS	Service,
			Classification.AssetClassificationDescription	AS	AssetClassification,
			TypeCode.AssetTypeCode,
			TypeCode.AssetTypeDescription,
			Manufacturer.Manufacturer,
			Model.Model,
			EODParameter.ModifiedDateUTC,
			EODParameter.Active
	FROM	EngEODParameterMapping							AS	EODParameter	WITH(NOLOCK)
			INNER JOIN MstCustomer							AS	Customer		WITH(NOLOCK)	ON	EODParameter.CustomerId				=	Customer.CustomerId
			INNER JOIN MstLocationFacility					AS	Facility		WITH(NOLOCK)	ON	EODParameter.FacilityId				=	Facility.FacilityId
			INNER JOIN MstService							AS	Service			WITH(NOLOCK)	ON	EODParameter.ServiceId				=	Service.ServiceId
			INNER JOIN EngAssetClassification				AS	Classification	WITH(NOLOCK)	ON	EODParameter.AssetClassificationId	=	Classification.AssetClassificationId
			INNER JOIN EngAssetTypeCode						AS	TypeCode		WITH(NOLOCK)	ON	EODParameter.AssetTypeCodeId		=	TypeCode.AssetTypeCodeId
			INNER JOIN EngAssetStandardizationManufacturer	AS	Manufacturer	WITH(NOLOCK)	ON	EODParameter.ManufacturerId			=	Manufacturer.ManufacturerId
			INNER JOIN EngAssetStandardizationModel			AS	Model			WITH(NOLOCK)	ON	EODParameter.ModelId				=	Model.ModelId
GO
