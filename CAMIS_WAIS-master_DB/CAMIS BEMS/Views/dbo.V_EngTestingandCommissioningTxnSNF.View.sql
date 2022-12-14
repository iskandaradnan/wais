USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngTestingandCommissioningTxnSNF]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_EngTestingandCommissioningTxnSNF]
AS
	SELECT	TandC.TestingandCommissioningId,
			TandC.CustomerId,
			Customer.CustomerName,
			TandC.FacilityId,
			Facility.FacilityName,
			TandC.TandCDocumentNo				AS	SNFNo,
			CAST(TandC.TandCDate AS date)		AS	SNFDate,
			Asset.AssetNo,
			LovVariationStatus.FieldValue		AS	VariationStatus,
			ISNULL(Actions.Name,'Submit')		AS	Status,
			TandC.ModifiedDateUTC
	FROM	EngTestingandCommissioningTxn		AS	TandC				WITH(NOLOCK)
			INNER JOIN MstCustomer				AS	Customer			WITH(NOLOCK)	ON TandC.CustomerId			=	Customer.CustomerId
			INNER JOIN MstLocationFacility		AS	Facility			WITH(NOLOCK)	ON TandC.FacilityId			=	Facility.FacilityId
			INNER JOIN EngAsset					AS	Asset				WITH(NOLOCK)	ON TandC.AssetId			=	Asset.AssetId
			LEFT JOIN FMLovMst					AS	LovVariationStatus	WITH(NOLOCK)	ON TandC.VariationStatus	=	LovVariationStatus.LovId
			LEFT JOIN UMActions					AS	Actions				WITH(NOLOCK)	ON TandC.Status				=	Actions.ActionPermissionId
GO
