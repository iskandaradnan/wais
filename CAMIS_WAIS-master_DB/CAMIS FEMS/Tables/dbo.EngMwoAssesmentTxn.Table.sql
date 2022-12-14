USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngMwoAssesmentTxn]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngMwoAssesmentTxn](
	[AssesmentId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NULL,
	[WorkOrderId] [int] NOT NULL,
	[UserId] [int] NULL,
	[Justification] [nvarchar](500) NOT NULL,
	[ResponseDateTime] [datetime] NULL,
	[ResponseDateTimeUTC] [datetime] NULL,
	[ResponseDuration] [nvarchar](100) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[AssetRealtimeStatus] [int] NULL,
	[TargetDateTime] [datetime] NULL,
	[IsChangeToVendor] [int] NULL,
	[AssignedVendor] [int] NULL,
	[FMvendorApproveStatus] [nvarchar](100) NULL,
	[Signature] [varbinary](max) NULL,
 CONSTRAINT [PK_EngMwoAssesmentTxn] PRIMARY KEY CLUSTERED 
(
	[AssesmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngMwoAssesmentTxn] ADD  CONSTRAINT [DF_EngMwoAssesmentTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngMwoAssesmentTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoAssesmentTxn_EngMaintenanceWorkOrderTxn_WorkOrderId] FOREIGN KEY([WorkOrderId])
REFERENCES [dbo].[EngMaintenanceWorkOrderTxn] ([WorkOrderId])
GO
ALTER TABLE [dbo].[EngMwoAssesmentTxn] CHECK CONSTRAINT [FK_EngMwoAssesmentTxn_EngMaintenanceWorkOrderTxn_WorkOrderId]
GO
ALTER TABLE [dbo].[EngMwoAssesmentTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoAssesmentTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngMwoAssesmentTxn] CHECK CONSTRAINT [FK_EngMwoAssesmentTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngMwoAssesmentTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoAssesmentTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngMwoAssesmentTxn] CHECK CONSTRAINT [FK_EngMwoAssesmentTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngMwoAssesmentTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoAssesmentTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngMwoAssesmentTxn] CHECK CONSTRAINT [FK_EngMwoAssesmentTxn_MstService_ServiceId]
GO
ALTER TABLE [dbo].[EngMwoAssesmentTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoAssesmentTxn_UMUserRegistration_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[EngMwoAssesmentTxn] CHECK CONSTRAINT [FK_EngMwoAssesmentTxn_UMUserRegistration_UserId]
GO
