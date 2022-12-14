USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngMwoTransferTxn]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngMwoTransferTxn](
	[WOTransferId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[WorkOrderId] [int] NOT NULL,
	[AssignedUserId] [int] NOT NULL,
	[AssignedDate] [datetime] NOT NULL,
	[AssignedDateUTC] [datetime] NOT NULL,
	[TransferReasonLovId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[TransferStatus] [nvarchar](200) NULL,
 CONSTRAINT [PK_EngMwoTransferTxn] PRIMARY KEY CLUSTERED 
(
	[WOTransferId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngMwoTransferTxn] ADD  CONSTRAINT [DF_EngMwoTransferTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngMwoTransferTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoTransferTxn_EngMaintenanceWorkOrderTxn_WorkOrderId] FOREIGN KEY([WorkOrderId])
REFERENCES [dbo].[EngMaintenanceWorkOrderTxn] ([WorkOrderId])
GO
ALTER TABLE [dbo].[EngMwoTransferTxn] CHECK CONSTRAINT [FK_EngMwoTransferTxn_EngMaintenanceWorkOrderTxn_WorkOrderId]
GO
ALTER TABLE [dbo].[EngMwoTransferTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoTransferTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngMwoTransferTxn] CHECK CONSTRAINT [FK_EngMwoTransferTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngMwoTransferTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoTransferTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngMwoTransferTxn] CHECK CONSTRAINT [FK_EngMwoTransferTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngMwoTransferTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoTransferTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngMwoTransferTxn] CHECK CONSTRAINT [FK_EngMwoTransferTxn_MstService_ServiceId]
GO
ALTER TABLE [dbo].[EngMwoTransferTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoTransferTxn_UMUserRegistration_AssignedUserId] FOREIGN KEY([AssignedUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[EngMwoTransferTxn] CHECK CONSTRAINT [FK_EngMwoTransferTxn_UMUserRegistration_AssignedUserId]
GO
