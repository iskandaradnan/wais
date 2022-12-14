USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngStockUpdateRegisterTxn]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_EngStockUpdateRegisterTxn]
AS
	SELECT	distinct StockUpdateReg.StockUpdateId,
			StockUpdateReg.CustomerId,
			StockUpdateRegDet.StockUpdateDetId,
			Customer.CustomerName,
			StockUpdateReg.FacilityId,
			StockUpdateReg.StockUpdateNo,
			--FORMAT(StockUpdateReg.Date,'dd-MMM-yyyy')					AS	Date,
			CAST(StockUpdateReg.Date AS DATE)							AS	Date,
			YEAR(StockUpdateReg.Date)									AS	Year,	
			(SELECT SUM(DET.Cost) TotCost 
			FROM EngStockUpdateRegisterTxnDet AS DET 
			WHERE DET.StockUpdateId=StockUpdateReg.StockUpdateId)       AS [TotalSparePartCost(Currency)],
			Facility.FacilityCode,
			Facility.FacilityName,
			SparePart.ItemId,
			ItemMaster.ItemNo,
			ItemMaster.ItemDescription,
			SparePart.SparePartsId,
			SparePart.PartNo,
			SparePart.PartDescription,
			LovSparePartType.FieldValue									AS	[SparePartType],
			LovPartSource.FieldValue AS PartSource,
			FORMAT(StockUpdateRegDet.StockExpiryDate,'dd-MMM-yyyy')		AS [StockExpiryDate],
			StockUpdateRegDet.Quantity,
			StockUpdateRegDet.Cost										AS	[Cost(Currency)],
			StockUpdateRegDet.PurchaseCost								AS	[PurchaseCost(Currency)],
			StockUpdateRegDet.InvoiceNo									AS	[InvoiceNo.],
			StockUpdateRegDet.VendorName,
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
GO
