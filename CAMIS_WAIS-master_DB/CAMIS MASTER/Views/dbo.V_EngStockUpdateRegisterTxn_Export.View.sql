USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_EngStockUpdateRegisterTxn_Export]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[V_EngStockUpdateRegisterTxn_Export]
AS
	SELECT	distinct StockUpdateReg.StockUpdateId,
			StockUpdateReg.CustomerId,
			StockUpdateRegDet.StockUpdateDetId,
			Customer.CustomerName,
			StockUpdateReg.FacilityId,
			StockUpdateReg.StockUpdateNo								AS	[StockUpdateNo],
			--FORMAT(StockUpdateReg.Date,'dd-MMM-yyyy')					AS	Date,
			CAST(StockUpdateReg.Date AS DATE)							AS	Date,
			YEAR(StockUpdateReg.Date)									AS	Year,											
			(SELECT SUM(DET.Cost) TotCost 
			FROM EngStockUpdateRegisterTxnDet AS DET 
			WHERE DET.StockUpdateId=StockUpdateReg.StockUpdateId)       AS [TotalSparePartCost(RM)],
			Facility.FacilityCode,
			Facility.FacilityName,
            SparePart.PartNo											AS	[PartNo],
			SparePart.PartDescription,
			LovSparePartType.FieldValue									AS	[SparePartType],
			StockUpdateRegDet.LocationId,
			LocationId.FieldValue										AS	[Location],
			ItemMaster.ItemNo											AS	[ItemCode],
			ItemMaster.ItemDescription,
			StockUpdateRegDet.EstimatedLifeSpan							AS	EstimatedLifeSpan,
	        LovPartSource.FieldValue AS PartSource,
			SparePart.LifeSpanOptionId,
			LifeSpanOptionId.FieldValue									AS	LifeSpanOptions,
			FORMAT(StockUpdateRegDet.StockExpiryDate,'dd-MMM-yyyy')		AS	[ExpiryDate],
			StockUpdateRegDet.Quantity,			
			StockUpdateRegDet.PurchaseCost,
			StockUpdateRegDet.Cost,
			StockUpdateRegDet.InvoiceNo									AS	[InvoiceNo.],
			StockUpdateRegDet.VendorName,
			StockUpdateRegDet.BinNo,
			StockUpdateRegDet.Remarks,
			StockUpdateReg.ModifiedDateUTC
	FROM	EngStockUpdateRegisterTxn				AS	StockUpdateReg		WITH(NOLOCK)
			INNER JOIN MstCustomer					AS	Customer			WITH(NOLOCK)	ON	StockUpdateReg.CustomerId		=	Customer.CustomerId
			INNER JOIN MstLocationFacility			AS	Facility			WITH(NOLOCK)	ON	StockUpdateReg.FacilityId		=	Facility.FacilityId
			INNER JOIN EngStockUpdateRegisterTxnDet	AS	StockUpdateRegDet	WITH(NOLOCK)	ON	StockUpdateReg.StockUpdateId	=	StockUpdateRegDet.StockUpdateId
			INNER JOIN EngSpareParts				AS	SparePart			WITH(NOLOCK)	ON	StockUpdateRegDet.SparePartsId	=	SparePart.SparePartsId
			INNER JOIN FMItemMaster					AS	ItemMaster			WITH(NOLOCK)	ON	SparePart.ItemId				=	ItemMaster.ItemId
			INNER JOIN FMLovMst						AS	LovPartCategory		WITH(NOLOCK)	ON	ItemMaster.PartCategory			=	LovPartCategory.LovId
			LEFT JOIN FMLovMst						AS	LovSparePartType	WITH(NOLOCK)	ON	StockUpdateRegDet.SparePartType	=	LovSparePartType.LovId
			LEFT JOIN FMLovMst						AS	LovPartSource	    WITH(NOLOCK)    ON	SparePart.PartSourceId			=	LovPartSource.LovId
			LEFT JOIN FMLovMst						AS	LocationId		    WITH(NOLOCK)    ON	StockUpdateRegDet.LocationId	=	LocationId.LovId
			LEFT JOIN FMLovMst						AS	LifeSpanOptionId    WITH(NOLOCK)    ON	SparePart.LifeSpanOptionId		=	LifeSpanOptionId.LovId
GO
