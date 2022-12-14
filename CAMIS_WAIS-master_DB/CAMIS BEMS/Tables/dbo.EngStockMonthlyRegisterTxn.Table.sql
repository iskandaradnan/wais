USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngStockMonthlyRegisterTxn]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngStockMonthlyRegisterTxn](
	[MonthlyStockId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[SparePartsId] [int] NOT NULL,
	[StockUpdateNo] [nvarchar](50) NOT NULL,
	[Date] [datetime] NOT NULL,
	[DateUTC] [datetime] NOT NULL,
	[TotalCost] [numeric](24, 2) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngStockMonthlyRegisterTxn] PRIMARY KEY CLUSTERED 
(
	[MonthlyStockId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngStockMonthlyRegisterTxn] ADD  CONSTRAINT [DF_EngStockMonthlyRegisterTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
