USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngStockAdjustmentTxn]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[V_EngStockAdjustmentTxn]
AS
	SELECT	DISTINCT StockAdjustment.StockAdjustmentId,
			StockAdjustment.CustomerId,
			Customer.CustomerName,
			StockAdjustment.FacilityId,
			Facility.FacilityCode,
			Facility.FacilityName,
			YEAR(StockAdjustment.AdjustmentDate)				AS Year,
			DATENAME(MM,StockAdjustment.AdjustmentDate)			AS Month,
			StockAdjustment.StockAdjustmentNo,
			StockAdjustment.AdjustmentDate,
			--FORMAT(StockAdjustment.AdjustmentDate,'dd-MMM-yyyy') AS AdjustmentDate,
			PartCategory.Category									AS PartCategory,
			LovApprovalStatus.FieldValue						AS ApprovalStatusValue,
			StockAdjustment.ApprovedBy,
			StockAdjustment.ApprovedDate,
			--FORMAT(StockAdjustment.ApprovedDate,'dd-MMM-yyyy')	AS	ApprovedDate ,
			SpareParts.PartNo,
			SpareParts.PartDescription,
			ItemMst.ItemNo,
			ItemMst.ItemDescription,
			StockUPDet.Quantity as QuantityInFacility,
			StockAdjustmentDet.PhysicalQuantity,
			StockAdjustmentDet.Variance,
			StockAdjustmentDet.AdjustedQuantity,
			StockAdjustmentDet.Cost,
			StockAdjustmentDet.[PurchaseCost],
			StockAdjustmentDet.[InvoiceNo],
			StockAdjustmentDet.VendorName,
			StockAdjustmentDet.Remarks,
			StockAdjustment.ModifiedDateUTC
	FROM	EngStockAdjustmentTxn					AS	StockAdjustment		WITH(NOLOCK)
			INNER JOIN MstCustomer					AS	Customer			WITH(NOLOCK)	ON	StockAdjustment.CustomerId			=	Customer.CustomerId
			INNER JOIN MstLocationFacility			AS	Facility			WITH(NOLOCK)	ON	StockAdjustment.FacilityId			=	Facility.FacilityId
			INNER JOIN FMLovMst						AS	LovApprovalStatus	WITH(NOLOCK)	ON	StockAdjustment.ApprovalStatus		=	LovApprovalStatus.LovId	
			INNER JOIN EngStockAdjustmentTxnDet		AS	StockAdjustmentDet	WITH(NOLOCK)	ON	StockAdjustment.StockAdjustmentId	=	StockAdjustmentDet.StockAdjustmentId	
			INNER JOIN EngStockUpdateRegisterTxnDet	AS	StockUPDet			WITH(NOLOCK)	ON	StockAdjustmentDet.StockUpdateDetId	=	StockUPDet.StockUpdateDetId	
			INNER JOIN EngSpareParts				AS	SpareParts			WITH(NOLOCK)	ON	StockAdjustmentDet.SparePartsId		=	SpareParts.SparePartsId
			INNER JOIN FMItemMaster					AS	ItemMst				WITH(NOLOCK)	ON	SpareParts.ItemId					=	ItemMst.ItemId
			INNER JOIN EngSparePartsCategory		AS	PartCategory		WITH(NOLOCK)	ON	ItemMst.PartCategory				=	PartCategory.SparePartsCategoryId
			

			--OUTER APPLY (	SELECT	 TOP 1 ItemMst.ItemDescription,
			--						PartCategory.Category 
			--				FROM EngStockAdjustmentTxnDet		AS	StockAdjustmentDet	WITH(NOLOCK)
			--				INNER JOIN EngSpareParts			AS	SpareParts			WITH(NOLOCK)	ON	StockAdjustmentDet.SparePartsId		=	SpareParts.SparePartsId
			--				INNER JOIN FMItemMaster				AS	ItemMst				WITH(NOLOCK)	ON	SpareParts.ItemId					=	ItemMst.ItemId
			--				INNER JOIN EngSparePartsCategory	AS	PartCategory		WITH(NOLOCK)	ON	ItemMst.PartCategory				=	PartCategory.SparePartsCategoryId
			--				--ORDER BY StockAdjustmentDet.ModifiedDateUTC DESC
			--			)	AS	ItemCat
GO
