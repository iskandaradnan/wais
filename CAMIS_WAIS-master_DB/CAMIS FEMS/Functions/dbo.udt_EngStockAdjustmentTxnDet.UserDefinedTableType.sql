USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngStockAdjustmentTxnDet]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_EngStockAdjustmentTxnDet] AS TABLE(
	[StockAdjustmentDetId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[StockAdjustmentId] [int] NULL,
	[StockUpdateDetId] [int] NULL,
	[SparePartsId] [int] NULL,
	[PhysicalQuantity] [numeric](24, 2) NULL,
	[Variance] [numeric](24, 2) NULL,
	[AdjustedQuantity] [numeric](24, 2) NULL,
	[Cost] [numeric](24, 2) NULL,
	[PurchaseCost] [numeric](24, 2) NULL,
	[InvoiceNo] [nvarchar](50) NULL,
	[Remarks] [nvarchar](1000) NULL,
	[VendorName] [nvarchar](200) NULL,
	[UserId] [int] NULL
)
GO
