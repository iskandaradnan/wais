USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngStockUpdateRegisterTxnDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngStockUpdateRegisterTxnDet](
	[StockUpdateDetId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[StockUpdateId] [int] NOT NULL,
	[SparePartsId] [int] NOT NULL,
	[StockExpiryDate] [datetime] NULL,
	[StockExpiryDateUTC] [datetime] NULL,
	[Quantity] [numeric](24, 2) NOT NULL,
	[Cost] [numeric](24, 2) NOT NULL,
	[PurchaseCost] [numeric](24, 2) NOT NULL,
	[InvoiceNo] [nvarchar](25) NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[VendorName] [nvarchar](100) NULL,
	[EstimatedLifeSpan] [numeric](24, 2) NULL,
	[EstimatedLifeSpanId] [int] NULL,
	[BinNo] [nvarchar](25) NULL,
	[SparePartType] [int] NULL,
	[LocationId] [int] NULL,
 CONSTRAINT [PK_EngStockUpdateRegisterTxnDet] PRIMARY KEY CLUSTERED 
(
	[StockUpdateDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngStockUpdateRegisterTxnDet] ADD  CONSTRAINT [DF_EngStockUpdateRegisterTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngStockUpdateRegisterTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngStockUpdateRegisterTxnDet_EngSpareParts_SparePartsId] FOREIGN KEY([SparePartsId])
REFERENCES [dbo].[EngSpareParts] ([SparePartsId])
GO
ALTER TABLE [dbo].[EngStockUpdateRegisterTxnDet] CHECK CONSTRAINT [FK_EngStockUpdateRegisterTxnDet_EngSpareParts_SparePartsId]
GO
ALTER TABLE [dbo].[EngStockUpdateRegisterTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngStockUpdateRegisterTxnDet_EngStockUpdateRegisterTxn_StockUpdateId] FOREIGN KEY([StockUpdateId])
REFERENCES [dbo].[EngStockUpdateRegisterTxn] ([StockUpdateId])
GO
ALTER TABLE [dbo].[EngStockUpdateRegisterTxnDet] CHECK CONSTRAINT [FK_EngStockUpdateRegisterTxnDet_EngStockUpdateRegisterTxn_StockUpdateId]
GO
ALTER TABLE [dbo].[EngStockUpdateRegisterTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngStockUpdateRegisterTxnDet_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngStockUpdateRegisterTxnDet] CHECK CONSTRAINT [FK_EngStockUpdateRegisterTxnDet_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngStockUpdateRegisterTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngStockUpdateRegisterTxnDet_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngStockUpdateRegisterTxnDet] CHECK CONSTRAINT [FK_EngStockUpdateRegisterTxnDet_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngStockUpdateRegisterTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngStockUpdateRegisterTxnDet_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngStockUpdateRegisterTxnDet] CHECK CONSTRAINT [FK_EngStockUpdateRegisterTxnDet_MstService_ServiceId]
GO
