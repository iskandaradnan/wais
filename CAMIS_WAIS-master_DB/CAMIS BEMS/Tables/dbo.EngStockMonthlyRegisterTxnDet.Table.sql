USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngStockMonthlyRegisterTxnDet]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngStockMonthlyRegisterTxnDet](
	[MonthlyStockDetId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[MonthlyStockId] [int] NOT NULL,
	[StockUpdateId] [int] NOT NULL,
	[SparePartId] [int] NOT NULL,
	[StockExpiryDate] [datetime] NOT NULL,
	[StockExpiryDateUTC] [datetime] NOT NULL,
	[MinimumLevel] [numeric](24, 2) NOT NULL,
	[SparePartType] [int] NULL,
	[CurrentQuantity] [numeric](24, 2) NOT NULL,
	[ClosingMonthQuantity ] [numeric](24, 2) NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngStockMonthlyRegisterTxnDet] PRIMARY KEY CLUSTERED 
(
	[MonthlyStockDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngStockMonthlyRegisterTxnDet] ADD  CONSTRAINT [DF_EngStockMonthlyRegisterTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
