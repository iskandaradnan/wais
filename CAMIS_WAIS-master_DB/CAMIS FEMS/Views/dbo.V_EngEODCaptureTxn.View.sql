USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngEODCaptureTxn]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE VIEW [dbo].[V_EngEODCaptureTxn]
AS
	SELECT	EODCapture.CaptureId,
			EODCapture.CustomerId,
			Customer.CustomerName,
			EODCapture.FacilityId,
			Facility.FacilityName,			
			EODCapture.RecordDate AS RecordDate,
			UserLocation.UserLocationName,
			Asset.AssetId,
			Asset.AssetNo,
			Asset.AssetDescription AS AssetDesc,
			EODCapture.NextCaptureDate AS NextCapdate,
			EODCapture.CaptureDocumentNo,
			EODCapture.ModifiedDateUTC
	FROM	EngEODCaptureTxn								AS	EODCapture		WITH(NOLOCK)
			INNER JOIN EngAssetClassification				AS Classification WITH(NOLOCK)	ON EODCapture.AssetClassificationId	= Classification.AssetClassificationId
			INNER JOIN MstCustomer							AS	Customer		WITH(NOLOCK)	ON	EODCapture.CustomerId			=	Customer.CustomerId
			INNER JOIN MstLocationFacility					AS	Facility		WITH(NOLOCK)	ON	EODCapture.FacilityId			=	Facility.FacilityId
			INNER JOIN MstService							AS	Service			WITH(NOLOCK)	ON	EODCapture.ServiceId			=	Service.ServiceId
			--INNER JOIN EngEODCategorySystem					AS	EODCategory		WITH(NOLOCK)	ON	EODCapture.CategorySystemId		=	EODCategory.CategorySystemId
			LEFT JOIN MstLocationUserLocation				AS	UserLocation	WITH(NOLOCK)	ON	EODCapture.UserLocationId		=	UserLocation.UserLocationId
			INNER JOIN EngAsset								AS	Asset			WITH(NOLOCK)	ON	EODCapture.AssetId				=	Asset.AssetId
GO
