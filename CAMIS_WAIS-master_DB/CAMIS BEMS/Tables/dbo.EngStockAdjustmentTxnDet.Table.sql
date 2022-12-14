USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngStockAdjustmentTxnDet]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngStockAdjustmentTxnDet](
	[StockAdjustmentDetId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[StockAdjustmentId] [int] NOT NULL,
	[StockUpdateDetId] [int] NOT NULL,
	[SparePartsId] [int] NOT NULL,
	[PhysicalQuantity] [numeric](24, 2) NOT NULL,
	[Variance] [numeric](24, 2) NULL,
	[AdjustedQuantity] [numeric](24, 2) NOT NULL,
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
 CONSTRAINT [PK_EngStockAdjustmentTxnDet] PRIMARY KEY CLUSTERED 
(
	[StockAdjustmentDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngStockAdjustmentTxnDet] ADD  CONSTRAINT [DF_EngStockAdjustmentTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngStockAdjustmentTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngStockAdjustmentTxnDet_EngSpareParts_SparePartsId] FOREIGN KEY([SparePartsId])
REFERENCES [dbo].[EngSpareParts] ([SparePartsId])
GO
ALTER TABLE [dbo].[EngStockAdjustmentTxnDet] CHECK CONSTRAINT [FK_EngStockAdjustmentTxnDet_EngSpareParts_SparePartsId]
GO
ALTER TABLE [dbo].[EngStockAdjustmentTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngStockAdjustmentTxnDet_EngStockAdjustmentTxn_StockAdjustmentId] FOREIGN KEY([StockAdjustmentId])
REFERENCES [dbo].[EngStockAdjustmentTxn] ([StockAdjustmentId])
GO
ALTER TABLE [dbo].[EngStockAdjustmentTxnDet] CHECK CONSTRAINT [FK_EngStockAdjustmentTxnDet_EngStockAdjustmentTxn_StockAdjustmentId]
GO
ALTER TABLE [dbo].[EngStockAdjustmentTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngStockAdjustmentTxnDet_EngStockUpdateRegisterTxnDet_StockUpdateDetId] FOREIGN KEY([StockUpdateDetId])
REFERENCES [dbo].[EngStockUpdateRegisterTxnDet] ([StockUpdateDetId])
GO
ALTER TABLE [dbo].[EngStockAdjustmentTxnDet] CHECK CONSTRAINT [FK_EngStockAdjustmentTxnDet_EngStockUpdateRegisterTxnDet_StockUpdateDetId]
GO
ALTER TABLE [dbo].[EngStockAdjustmentTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngStockAdjustmentTxnDet_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngStockAdjustmentTxnDet] CHECK CONSTRAINT [FK_EngStockAdjustmentTxnDet_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngStockAdjustmentTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngStockAdjustmentTxnDet_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngStockAdjustmentTxnDet] CHECK CONSTRAINT [FK_EngStockAdjustmentTxnDet_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngStockAdjustmentTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngStockAdjustmentTxnDet_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngStockAdjustmentTxnDet] CHECK CONSTRAINT [FK_EngStockAdjustmentTxnDet_MstService_ServiceId]
GO
