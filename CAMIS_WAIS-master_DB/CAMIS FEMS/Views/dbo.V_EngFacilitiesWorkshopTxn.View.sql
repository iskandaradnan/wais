USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngFacilitiesWorkshopTxn]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_EngFacilitiesWorkshopTxn]
AS
	SELECT	DISTINCT FWorkshop.FacilitiesWorkshopId,
			FWorkshop.CustomerId,
			Customer.CustomerName,
			FWorkshop.FacilityId,
			Facility.FacilityName,
			FWorkshop.Year,
			FWorkshop.ServiceId,
			Service.ServiceKey			AS	Service,
			FWorkshop.FacilityType		AS	FacilityTypeLovId,
			LovTypeofFac.FieldValue		AS	FacilityType,
			FWorkshop.Category			AS	CategoryLovId,
			isnull(LovCategory.FieldValue,'')		AS	Category,
			FWorkshop.ModifiedDateUTC
	FROM	EngFacilitiesWorkshopTxn						AS	FWorkshop		WITH(NOLOCK)
			INNER JOIN MstCustomer							AS	Customer		WITH(NOLOCK)	ON FWorkshop.CustomerId				=	Customer.CustomerId
			INNER JOIN MstLocationFacility					AS	Facility		WITH(NOLOCK)	ON FWorkshop.FacilityId				=	Facility.FacilityId
			INNER JOIN MstService							AS	Service			WITH(NOLOCK)	ON	FWorkshop.ServiceId				=	Service.ServiceId
			LEFT JOIN FMLovMst								AS	LovTypeofFac	WITH(NOLOCK)	ON	FWorkshop.FacilityType			=	LovTypeofFac.LovId
			LEFT JOIN FMLovMst								AS	LovCategory		WITH(NOLOCK)	ON	FWorkshop.Category				=	LovCategory.LovId
			left JOIN EngFacilitiesWorkshopTxnDet			AS	FWorkshopDet	WITH(NOLOCK)	ON	FWorkshop.FacilitiesWorkshopId	=	FWorkshopDet.FacilitiesWorkshopId
GO
