USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[EngStockUpdateRegisterTxnDetType]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[EngStockUpdateRegisterTxnDetType] AS TABLE(
	[StockUpdateDetId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[StockUpdateId] [int] NULL,
	[SparePartsId] [int] NULL,
	[StockExpiryDate] [datetime] NULL,
	[StockExpiryDateUTC] [datetime] NULL,
	[Quantity] [numeric](24, 2) NULL,
	[Cost] [numeric](24, 2) NULL,
	[PurchaseCost] [numeric](24, 2) NULL,
	[InvoiceNo] [nvarchar](50) NULL,
	[Remarks] [nvarchar](1000) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL
)
GO
