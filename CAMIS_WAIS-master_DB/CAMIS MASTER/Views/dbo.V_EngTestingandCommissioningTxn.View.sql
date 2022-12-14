USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_EngTestingandCommissioningTxn]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V_EngTestingandCommissioningTxn]
AS
	SELECT	TandC.TestingandCommissioningId,
			TandC.CustomerId,
			Customer.CustomerName,
			TandC.FacilityId,
			Facility.FacilityName,
			TandC.TandCDocumentNo,
			CAST(TandC.TandCDate AS date)					AS	TandCDate,
			TandC.TandCStatus								AS	TandCStatusLovId,
			LovStatus.FieldValue							AS	TandCStatusName,
			LovActions.LovId								AS  StatusId,
			LovActions.FieldValue							AS	StatusName,
			TandC.ModifiedDateUTC,
			TandC.AssetCategoryLovId ,
			LovCategory.FieldValue							AS	AssetCategory,
			Asset.AssetNo,
			CRm.RequestNo
	FROM	EngTestingandCommissioningTxn				AS	TandC		WITH(NOLOCK)
			INNER JOIN MstCustomer						AS	Customer	WITH(NOLOCK)	ON TandC.CustomerId							=	Customer.CustomerId
			INNER JOIN MstLocationFacility				AS	Facility	WITH(NOLOCK)	ON TandC.FacilityId							=	Facility.FacilityId
			INNER JOIN EngTestingandCommissioningTxnDet	AS	TandCDet	WITH(NOLOCK)	ON TandC.TestingandCommissioningId			=	TandCDet.TestingandCommissioningId
			LEFT JOIN FMLovMst							AS	LovStatus	WITH(NOLOCK)	ON TandC.TandCStatus						=	LovStatus.LovId
			LEFT JOIN FMLovMst							AS	LovActions	WITH(NOLOCK)	ON TandC.Status								=	LovActions.LovId
			LEFT JOIN FMLovMst							AS	LovCategory	WITH(NOLOCK)	ON TandC.AssetCategoryLovId					=	LovCategory.LovId
			LEFT JOIN EngAsset							AS	Asset		WITH(NOLOCK)	ON TandCDet.TestingandCommissioningDetId	=	Asset.TestingandCommissioningDetId
			LEFT JOIN CRMRequest							AS	crm		WITH(NOLOCK)	ON crm.CRMRequestId	=	TandC.CRMRequestId
GO
