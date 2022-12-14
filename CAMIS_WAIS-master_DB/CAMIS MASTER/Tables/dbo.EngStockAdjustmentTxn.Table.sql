USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngStockAdjustmentTxn]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngStockAdjustmentTxn](
	[StockAdjustmentId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[StockAdjustmentNo] [nvarchar](50) NOT NULL,
	[AdjustmentDate] [datetime] NOT NULL,
	[AdjustmentDateUTC] [datetime] NOT NULL,
	[ApprovalStatus] [int] NULL,
	[ApprovedBy] [nvarchar](50) NULL,
	[ApprovedDate] [datetime] NULL,
	[ApprovedDateUTC] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngStockAdjustmentTxn] PRIMARY KEY CLUSTERED 
(
	[StockAdjustmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngStockAdjustmentTxn] ADD  CONSTRAINT [DF_EngStockAdjustmentTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngStockAdjustmentTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngStockAdjustmentTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngStockAdjustmentTxn] CHECK CONSTRAINT [FK_EngStockAdjustmentTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngStockAdjustmentTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngStockAdjustmentTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngStockAdjustmentTxn] CHECK CONSTRAINT [FK_EngStockAdjustmentTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngStockAdjustmentTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngStockAdjustmentTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngStockAdjustmentTxn] CHECK CONSTRAINT [FK_EngStockAdjustmentTxn_MstService_ServiceId]
GO
