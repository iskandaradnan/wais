USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngMaintenanceWorkOrderStatusHistory]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngMaintenanceWorkOrderStatusHistory](
	[WorkOrderHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[WorkOrderId] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngMaintenanceWorkOrderStatusHistory] PRIMARY KEY CLUSTERED 
(
	[WorkOrderHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderStatusHistory] ADD  CONSTRAINT [DF_EngMaintenanceWorkOrderStatusHistory_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderStatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_EngMaintenanceWorkOrderStatusHistory_EngMaintenanceWorkOrderTxn_WorkOrderId] FOREIGN KEY([WorkOrderId])
REFERENCES [dbo].[EngMaintenanceWorkOrderTxn] ([WorkOrderId])
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderStatusHistory] CHECK CONSTRAINT [FK_EngMaintenanceWorkOrderStatusHistory_EngMaintenanceWorkOrderTxn_WorkOrderId]
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderStatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_EngMaintenanceWorkOrderStatusHistory_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderStatusHistory] CHECK CONSTRAINT [FK_EngMaintenanceWorkOrderStatusHistory_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderStatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_EngMaintenanceWorkOrderStatusHistory_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderStatusHistory] CHECK CONSTRAINT [FK_EngMaintenanceWorkOrderStatusHistory_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderStatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_EngMaintenanceWorkOrderStatusHistory_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderStatusHistory] CHECK CONSTRAINT [FK_EngMaintenanceWorkOrderStatusHistory_MstService_ServiceId]
GO
