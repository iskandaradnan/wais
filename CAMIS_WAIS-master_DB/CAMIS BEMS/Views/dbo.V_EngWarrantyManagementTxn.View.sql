USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngWarrantyManagementTxn]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[V_EngWarrantyManagementTxn]
AS
	SELECT	WarrantyMgmt.WarrantyMgmtId,
			WarrantyMgmt.CustomerId,
			Customer.CustomerName,
			WarrantyMgmt.FacilityId,
			Facility.FacilityName,
			WarrantyMgmt.WarrantyNo,
			WarrantyMgmt.WarrantyDate,
			Asset.AssetNo,
			Asset.AssetDescription,
			UserArea.UserAreaName,
			WarrantyMgmt.ModifiedDateUTC
	FROM	EngWarrantyManagementTxn		AS	WarrantyMgmt	WITH(NOLOCK)
			INNER JOIN MstCustomer			AS	Customer		WITH(NOLOCK)	ON WarrantyMgmt.CustomerId	=	Customer.CustomerId
			INNER JOIN MstLocationFacility	AS	Facility		WITH(NOLOCK)	ON WarrantyMgmt.FacilityId	=	Facility.FacilityId
			INNER JOIN EngAsset				AS	Asset			WITH(NOLOCK)	ON	Asset.AssetId			=	WarrantyMgmt.AssetId	
			LEFT JOIN MstLocationUserArea	AS	UserArea		WITH(NOLOCK)	ON	Asset.UserAreaId		=	UserArea.UserAreaId
	WHERE	Asset.Active=1
GO
