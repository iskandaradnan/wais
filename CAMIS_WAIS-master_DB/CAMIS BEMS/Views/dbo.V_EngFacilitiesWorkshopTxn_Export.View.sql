USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngFacilitiesWorkshopTxn_Export]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE VIEW [dbo].[V_EngFacilitiesWorkshopTxn_Export]
AS
	SELECT	DISTINCT FWorkshop.CustomerId,
			Customer.CustomerName,
			FWorkshop.FacilityId,
			Facility.FacilityName,
			FWorkshop.Year,
			Service.ServiceKey						AS Service,
			LovTypeofFac.FieldValue					AS FacilityType,
			ISNULL(LovCategory.FieldValue,'')		AS Category,
			Asset.AssetNo							AS AssetNo,
			FWorkshopDet.Description				AS Description,
			FWorkshopDet.Manufacturer				AS Manufacturer,
			FWorkshopDet.Model						AS Model,
			FWorkshopDet.SerialNo					AS SerialNo,
			FORMAT(FWorkshopDet.CalibrationDueDate,'dd-MMM-yyyy')		AS CalibrationDueDate,
			FWorkshopDet.Location					AS LocationId,
			Location.FieldValue						AS Location,
			FWorkshopDet.Quantity					AS Quantity,
			FWorkshopDet.SizeArea					AS SizeArea,
			FWorkshop.ModifiedDateUTC
	FROM	EngFacilitiesWorkshopTxn						AS	FWorkshop		WITH(NOLOCK)
			left JOIN EngFacilitiesWorkshopTxnDet			AS	FWorkshopDet	WITH(NOLOCK)	ON FWorkshop.FacilitiesWorkshopId	=	FWorkshopDet.FacilitiesWorkshopId
			INNER JOIN MstCustomer							AS	Customer		WITH(NOLOCK)	ON FWorkshop.CustomerId				=	Customer.CustomerId
			INNER JOIN MstLocationFacility					AS	Facility		WITH(NOLOCK)	ON FWorkshop.FacilityId				=	Facility.FacilityId
			INNER JOIN MstService							AS	Service			WITH(NOLOCK)	ON	FWorkshop.ServiceId				=	Service.ServiceId
			LEFT JOIN FMLovMst								AS	LovTypeofFac	WITH(NOLOCK)	ON	FWorkshop.FacilityType			=	LovTypeofFac.LovId
			LEFT JOIN FMLovMst								AS	LovCategory		WITH(NOLOCK)	ON	FWorkshop.Category				=	LovCategory.LovId
			LEFT JOIN FMLovMst								AS	Location		WITH(NOLOCK)	ON	FWorkshopDet.Location				=	Location.LovId
			left JOIN EngAsset								AS	Asset			WITH(NOLOCK)	ON	FWorkshopDet.AssetId			=	Asset.AssetId
GO
