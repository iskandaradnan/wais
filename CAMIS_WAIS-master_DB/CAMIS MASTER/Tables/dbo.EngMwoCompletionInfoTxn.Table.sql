USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngMwoCompletionInfoTxn]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngMwoCompletionInfoTxn](
	[CompletionInfoId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NULL,
	[WorkOrderId] [int] NOT NULL,
	[RepairDetails] [nvarchar](500) NULL,
	[PPMAgreedDate] [datetime] NULL,
	[PPMAgreedDateUTC] [datetime] NULL,
	[StartDateTime] [datetime] NULL,
	[StartDateTimeUTC] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[EndDateTimeUTC] [datetime] NULL,
	[HandoverDateTime] [datetime] NULL,
	[HandoverDateTimeUTC] [datetime] NULL,
	[CompletedBy] [int] NULL,
	[AcceptedBy] [int] NULL,
	[Signature] [nvarchar](500) NULL,
	[ServiceAvailability] [bit] NULL,
	[LoanerProvision] [bit] NULL,
	[HandoverDelay] [int] NULL,
	[DowntimeHoursMin] [numeric](24, 2) NULL,
	[CauseCode] [int] NULL,
	[QCCode] [int] NULL,
	[ResourceType] [int] NULL,
	[LabourCost] [numeric](24, 2) NULL,
	[PartsCost] [numeric](24, 2) NULL,
	[ContractorCost] [numeric](24, 2) NULL,
	[TotalCost] [numeric](24, 2) NULL,
	[ContractorId] [int] NULL,
	[ContractorHours] [numeric](24, 0) NULL,
	[PartsRequired] [bit] NULL,
	[Approved] [bit] NULL,
	[AppType] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[RepairHours] [numeric](24, 2) NULL,
	[ProcessStatus] [int] NULL,
	[ProcessStatusDate] [datetime] NULL,
	[ProcessStatusReason] [int] NULL,
	[RunningHours] [numeric](24, 2) NULL,
	[VendorCost] [numeric](24, 2) NULL,
	[MobileGuid] [nvarchar](max) NULL,
	[DownTimeHours] [numeric](30, 2) NULL,
	[WOSignature] [varbinary](max) NULL,
	[CustomerFeedback] [int] NULL,
 CONSTRAINT [PK_EngMwoCompletionInfoTxn] PRIMARY KEY CLUSTERED 
(
	[CompletionInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxn] ADD  CONSTRAINT [DF_EngMwoCompletionInfoTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoCompletionInfoTxn_EngMaintenanceWorkOrderTxn_WorkOrderId] FOREIGN KEY([WorkOrderId])
REFERENCES [dbo].[EngMaintenanceWorkOrderTxn] ([WorkOrderId])
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxn] CHECK CONSTRAINT [FK_EngMwoCompletionInfoTxn_EngMaintenanceWorkOrderTxn_WorkOrderId]
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoCompletionInfoTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxn] CHECK CONSTRAINT [FK_EngMwoCompletionInfoTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoCompletionInfoTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxn] CHECK CONSTRAINT [FK_EngMwoCompletionInfoTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoCompletionInfoTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxn] CHECK CONSTRAINT [FK_EngMwoCompletionInfoTxn_MstService_ServiceId]
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoCompletionInfoTxn_UMUserRegistration_AcceptedBy] FOREIGN KEY([AcceptedBy])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxn] CHECK CONSTRAINT [FK_EngMwoCompletionInfoTxn_UMUserRegistration_AcceptedBy]
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoCompletionInfoTxn_UMUserRegistration_CompletedBy] FOREIGN KEY([CompletedBy])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxn] CHECK CONSTRAINT [FK_EngMwoCompletionInfoTxn_UMUserRegistration_CompletedBy]
GO
