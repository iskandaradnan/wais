USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngTestingandCommissioningTxnSNF_Export]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_EngTestingandCommissioningTxnSNF_Export]
AS
	SELECT	TandC.TestingandCommissioningId,
			TandC.CustomerId,
			Customer.CustomerName,
			TandC.FacilityId,
			Facility.FacilityName,
			Service.ServiceKey								AS	Service,
			TandC.TandCDocumentNo							AS	SNFNo,
			FORMAT(TandC.TandCDate,'dd-MMM-yyyy') 			AS	SNFDate,
			Asset.AssetNo,
			Asset.AssetDescription,
			LovVStatus.FieldValue							AS	VariationStatus,
			FORMAT(TandC.PurchaseDate,'dd-MMM-yyyy') 		AS	PurchaseDate,
			TandC.PurchaseCost,
			TandC.ContractLPONo,
			FORMAT(TandC.ServiceStartDate,'dd-MMM-yyyy') 	AS	ServiceStartDate,
			FORMAT(TandC.ServiceEndDate,'dd-MMM-yyyy') 		AS	ServiceEndDate,
			TandC.MainSupplierCode,
			TandC.MainSupplierName,
			TandC.WarrantyDuration,
			FORMAT(TandC.WarrantyStartDate,'dd-MMM-yyyy') 	AS	WarrantyStartDate,
			FORMAT(TandC.WarrantyEndDate,'dd-MMM-yyyy') 	AS	WarrantyEndDate,
			TandC.Remarks,
			TandC.ModifiedDateUTC
	FROM	EngTestingandCommissioningTxn				AS TandC			WITH(NOLOCK)
			INNER JOIN MstCustomer						AS	Customer		WITH(NOLOCK)	ON TandC.CustomerId						=	Customer.CustomerId
			INNER JOIN MstLocationFacility				AS	Facility		WITH(NOLOCK)	ON TandC.FacilityId						=	Facility.FacilityId
			INNER JOIN MstService						AS	Service			WITH(NOLOCK)	ON TandC.ServiceId						=	Service.ServiceId
			INNER JOIN EngAsset							AS	Asset			WITH(NOLOCK)	ON TandC.AssetId						=	Asset.AssetId
			LEFT JOIN FMLovMst							AS	LovVStatus		WITH(NOLOCK)	ON TandC.VariationStatus				=	LovVStatus.LovId
GO
