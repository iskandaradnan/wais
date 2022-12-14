USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngPPMRescheduleTxnDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngPPMRescheduleTxnDet](
	[PpmRescheduleDetId] [int] IDENTITY(1,1) NOT NULL,
	[WorkOrderId] [int] NULL,
	[UserId] [int] NULL,
	[RescheduleDate] [datetime] NOT NULL,
	[RescheduleDateUTC] [datetime] NOT NULL,
	[Reason] [int] NOT NULL,
	[ImpactSchedulePlanner] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngPpmRescheduleTxnDet] PRIMARY KEY CLUSTERED 
(
	[PpmRescheduleDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngPPMRescheduleTxnDet] ADD  CONSTRAINT [DF_EngPpmRescheduleTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngPPMRescheduleTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngPPMRescheduleTxnDet_EngMaintenanceWorkOrderTxn_WorkOrderId] FOREIGN KEY([WorkOrderId])
REFERENCES [dbo].[EngMaintenanceWorkOrderTxn] ([WorkOrderId])
GO
ALTER TABLE [dbo].[EngPPMRescheduleTxnDet] CHECK CONSTRAINT [FK_EngPPMRescheduleTxnDet_EngMaintenanceWorkOrderTxn_WorkOrderId]
GO
ALTER TABLE [dbo].[EngPPMRescheduleTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngPPMRescheduleTxnDet_UMUserRegistration_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[EngPPMRescheduleTxnDet] CHECK CONSTRAINT [FK_EngPPMRescheduleTxnDet_UMUserRegistration_UserId]
GO
