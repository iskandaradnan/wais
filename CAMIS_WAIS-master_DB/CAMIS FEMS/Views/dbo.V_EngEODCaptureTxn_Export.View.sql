USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngEODCaptureTxn_Export]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE VIEW [dbo].[V_EngEODCaptureTxn_Export]
AS
	SELECT	EODCapture.CaptureId,			
			EODCapture.CustomerId,
			Customer.CustomerName,
			EODCapture.FacilityId,
			Facility.FacilityName,
			EODCapture.CaptureDocumentNo,				
			--FORMAT(EODCapture.RecordDate,'dd-MMM-yyyy HH:mm') AS RecordDate,
			CAST(EODCapture.RecordDate AS datetime) AS RecordDate,
			EODCapture.AssetClassificationId,
			Classification.AssetClassificationCode,
			Classification.AssetClassificationDescription,
			UserArea.UserAreaCode,
			UserArea.UserAreaName,
			UserLocation.UserLocationCode,
			UserLocation.UserLocationName,
			TypeCode.AssetTypeCode,
			CAST(NextCaptureDate AS date) AS NextCapdate,
			--FORMAT(NextCaptureDate,'dd-MMM-yyyy')		AS NextCapdate,
			Asset.AssetNo,
			Asset.AssetDescription,
			EODCaptureDet.ParamterValue						AS Paramter,
			UOM.UnitOfMeasurement,
			EODCaptureDet.Standard,
			EODCaptureDet.Minimum,
			EODCaptureDet.Maximum,
			EODCaptureDet.ActualValue,
			CASE 
				WHEN EODCaptureDet.Status = 1 THEN 'Pass'
				WHEN EODCaptureDet.Status = 2 THEN 'Fail'
			END												AS Status
			,
			EODCapture.ModifiedDateUTC
	FROM	EngEODCaptureTxn								AS	EODCapture		WITH(NOLOCK)
			INNER JOIN EngAssetClassification				AS Classification	WITH(NOLOCK)	ON EODCapture.AssetClassificationId	= Classification.AssetClassificationId
			INNER JOIN MstCustomer							AS	Customer		WITH(NOLOCK)	ON	EODCapture.CustomerId			=	Customer.CustomerId
			INNER JOIN MstLocationFacility					AS	Facility		WITH(NOLOCK)	ON	EODCapture.FacilityId			=	Facility.FacilityId
			INNER JOIN MstService							AS	Service			WITH(NOLOCK)	ON	EODCapture.ServiceId			=	Service.ServiceId
			INNER JOIN EngEODCaptureTxnDet					AS	EODCaptureDet	WITH(NOLOCK)	ON	EODCapture.CaptureId			=	EODCaptureDet.CaptureId
			--INNER JOIN EngEODCategorySystem					AS	EODCategory		WITH(NOLOCK)	ON	EODCapture.CategorySystemId		=	EODCategory.CategorySystemId
			LEFT JOIN EngAsset								AS	Asset			WITH(NOLOCK)	ON	EODCapture.AssetId				=	Asset.AssetId
			LEFT JOIN EngAssetTypeCode						AS	TypeCode		WITH(NOLOCK)	ON	EODCapture.AssetTypeCodeId		=	TypeCode.AssetTypeCodeId
			LEFT JOIN MstLocationUserLocation				AS	UserLocation	WITH(NOLOCK)	ON	EODCapture.UserLocationId		=	UserLocation.UserLocationId
			LEFT JOIN MstLocationUserArea					AS	UserArea		WITH(NOLOCK)	ON	EODCapture.UserAreaId			=	UserArea.UserAreaId
			LEFT JOIN FMUOM									AS	UOM				WITH(NOLOCK)	ON	EODCaptureDet.UOMId				=	UOM.UOMId
GO
