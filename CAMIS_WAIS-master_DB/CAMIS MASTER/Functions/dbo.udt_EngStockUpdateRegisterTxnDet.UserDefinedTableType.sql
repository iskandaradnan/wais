USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngStockUpdateRegisterTxnDet]    Script Date: 20-09-2021 16:50:19 ******/
CREATE TYPE [dbo].[udt_EngStockUpdateRegisterTxnDet] AS TABLE(
	[StockUpdateDetId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[StockUpdateId] [int] NULL,
	[SparePartsId] [int] NULL,
	[StockExpiryDate] [datetime] NULL,
	[StockExpiryDateUTC] [datetime] NULL,
	[Quantity] [numeric](18, 0) NULL,
	[Cost] [numeric](24, 2) NULL,
	[PurchaseCost] [numeric](24, 2) NULL,
	[InvoiceNo] [nvarchar](200) NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[PartNo] [nvarchar](100) NULL,
	[VendorName] [nvarchar](200) NULL,
	[EstimatedLifeSpan] [numeric](24, 2) NULL,
	[EstimatedLifeSpanId] [int] NULL,
	[BinNo] [nvarchar](25) NULL,
	[SparePartType] [int] NULL,
	[LocationId] [int] NULL
)
GO
