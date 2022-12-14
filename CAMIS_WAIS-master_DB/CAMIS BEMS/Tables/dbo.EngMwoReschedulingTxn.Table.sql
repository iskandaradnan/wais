USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngMwoReschedulingTxn]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngMwoReschedulingTxn](
	[WorkOrderReschedulingId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NULL,
	[WorkOrderId] [int] NOT NULL,
	[RescheduleDate] [datetime] NOT NULL,
	[RescheduleDateUTC] [datetime] NOT NULL,
	[RescheduleApprovedBy] [int] NULL,
	[Reasons] [int] NULL,
	[ImpactSchedulePlanner] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[AcceptedBy] [int] NULL,
	[Signature] [varbinary](max) NULL,
	[Reason] [nvarchar](100) NULL,
 CONSTRAINT [PK_EngMwoReschedulingTxn] PRIMARY KEY CLUSTERED 
(
	[WorkOrderReschedulingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngMwoReschedulingTxn] ADD  CONSTRAINT [DF_EngMwoReschedulingTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngMwoReschedulingTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoReschedulingTxn_EngMaintenanceWorkOrderTxn_WorkOrderId] FOREIGN KEY([WorkOrderId])
REFERENCES [dbo].[EngMaintenanceWorkOrderTxn] ([WorkOrderId])
GO
ALTER TABLE [dbo].[EngMwoReschedulingTxn] CHECK CONSTRAINT [FK_EngMwoReschedulingTxn_EngMaintenanceWorkOrderTxn_WorkOrderId]
GO
ALTER TABLE [dbo].[EngMwoReschedulingTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoReschedulingTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngMwoReschedulingTxn] CHECK CONSTRAINT [FK_EngMwoReschedulingTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngMwoReschedulingTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoReschedulingTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngMwoReschedulingTxn] CHECK CONSTRAINT [FK_EngMwoReschedulingTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngMwoReschedulingTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoReschedulingTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngMwoReschedulingTxn] CHECK CONSTRAINT [FK_EngMwoReschedulingTxn_MstService_ServiceId]
GO
