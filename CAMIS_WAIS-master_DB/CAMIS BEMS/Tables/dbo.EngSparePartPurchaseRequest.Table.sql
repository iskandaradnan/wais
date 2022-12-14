USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngSparePartPurchaseRequest]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngSparePartPurchaseRequest](
	[SparePartsRequsetId] [int] IDENTITY(1,1) NOT NULL,
	[SparePartsId] [int] NULL,
	[WorkOrderId] [int] NULL,
	[Quantity] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_EngSparePartPurchaseRequest] PRIMARY KEY CLUSTERED 
(
	[SparePartsRequsetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngSparePartPurchaseRequest] ADD  CONSTRAINT [DF_EngSparePartPurchaseRequest_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngSparePartPurchaseRequest]  WITH CHECK ADD  CONSTRAINT [FK_EngSparePartPurchaseRequest_EngMaintenanceWorkOrderTxn_WorkOrderId] FOREIGN KEY([WorkOrderId])
REFERENCES [dbo].[EngMaintenanceWorkOrderTxn] ([WorkOrderId])
GO
ALTER TABLE [dbo].[EngSparePartPurchaseRequest] CHECK CONSTRAINT [FK_EngSparePartPurchaseRequest_EngMaintenanceWorkOrderTxn_WorkOrderId]
GO
ALTER TABLE [dbo].[EngSparePartPurchaseRequest]  WITH CHECK ADD  CONSTRAINT [FK_EngSparePartPurchaseRequest_EngSpareParts_SparePartsId] FOREIGN KEY([SparePartsId])
REFERENCES [dbo].[EngSpareParts] ([SparePartsId])
GO
ALTER TABLE [dbo].[EngSparePartPurchaseRequest] CHECK CONSTRAINT [FK_EngSparePartPurchaseRequest_EngSpareParts_SparePartsId]
GO
