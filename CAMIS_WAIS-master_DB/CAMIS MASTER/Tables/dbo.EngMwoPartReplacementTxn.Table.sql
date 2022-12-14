USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngMwoPartReplacementTxn]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngMwoPartReplacementTxn](
	[PartReplacementId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[WorkOrderId] [int] NOT NULL,
	[SparePartStockRegisterId] [int] NOT NULL,
	[Quantity] [numeric](24, 2) NULL,
	[Cost] [numeric](24, 2) NULL,
	[TotalPartsCost] [numeric](24, 2) NULL,
	[InVoiceNo] [nvarchar](25) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[LabourCost] [numeric](24, 2) NULL,
	[TotalCost] [numeric](24, 2) NULL,
	[StockUpdateDetId] [int] NULL,
	[ActualQuantityinStockUpdate] [int] NULL,
	[SparePartRunningHours] [numeric](24, 2) NULL,
	[UsedDateTime] [datetime] NOT NULL,
	[IsPartReplacedCost] [int] NULL,
	[PartReplacementCost] [numeric](24, 2) NULL,
	[EstimatedLifeSpan] [int] NULL,
	[LifeSpanExpiryDate] [datetime] NULL,
	[StockType] [int] NULL,
	[MobileGuid] [nvarchar](500) NULL,
 CONSTRAINT [PK_EngMwoPartReplacementTxn] PRIMARY KEY CLUSTERED 
(
	[PartReplacementId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngMwoPartReplacementTxn] ADD  CONSTRAINT [DF_EngMwoPartReplacementTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngMwoPartReplacementTxn] ADD  CONSTRAINT [DF_EngMwoPartReplacementTxn_UsedDateTime]  DEFAULT (getdate()) FOR [UsedDateTime]
GO
ALTER TABLE [dbo].[EngMwoPartReplacementTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoPartReplacementTxn_EngMaintenanceWorkOrderTxn_WorkOrderId] FOREIGN KEY([WorkOrderId])
REFERENCES [dbo].[EngMaintenanceWorkOrderTxn] ([WorkOrderId])
GO
ALTER TABLE [dbo].[EngMwoPartReplacementTxn] CHECK CONSTRAINT [FK_EngMwoPartReplacementTxn_EngMaintenanceWorkOrderTxn_WorkOrderId]
GO
ALTER TABLE [dbo].[EngMwoPartReplacementTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoPartReplacementTxn_EngSpareParts_SparePartStockRegisterId] FOREIGN KEY([SparePartStockRegisterId])
REFERENCES [dbo].[EngSpareParts] ([SparePartsId])
GO
ALTER TABLE [dbo].[EngMwoPartReplacementTxn] CHECK CONSTRAINT [FK_EngMwoPartReplacementTxn_EngSpareParts_SparePartStockRegisterId]
GO
ALTER TABLE [dbo].[EngMwoPartReplacementTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoPartReplacementTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngMwoPartReplacementTxn] CHECK CONSTRAINT [FK_EngMwoPartReplacementTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngMwoPartReplacementTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoPartReplacementTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngMwoPartReplacementTxn] CHECK CONSTRAINT [FK_EngMwoPartReplacementTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngMwoPartReplacementTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoPartReplacementTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngMwoPartReplacementTxn] CHECK CONSTRAINT [FK_EngMwoPartReplacementTxn_MstService_ServiceId]
GO
