USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngMwoProcessStatusTxnDet]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngMwoProcessStatusTxnDet](
	[ProcessStatusId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[CompletionInfoId] [int] NOT NULL,
	[StaffId] [int] NULL,
	[ServiceId] [int] NULL,
	[Status] [int] NULL,
	[Date] [datetime] NULL,
	[Reason] [int] NULL,
	[DocumentNo] [nvarchar](50) NULL,
	[ProvideLoaner] [int] NULL,
	[AlternativeServiceProvided] [int] NULL,
	[AssetProvided] [int] NULL,
	[RequestDate] [datetime] NULL,
	[ProvisionDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[AcceptedBy] [int] NULL,
	[ReferenceNo] [nvarchar](25) NULL,
	[ProjectId] [int] NULL,
	[BerApplicationId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngMwoProcessStatusTxnDet] PRIMARY KEY CLUSTERED 
(
	[ProcessStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngMwoProcessStatusTxnDet] ADD  CONSTRAINT [DF_EngMwoProcessStatusTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngMwoProcessStatusTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoProcessStatusTxnDet_EngMwoCompletionInfoTxn_CompletionInfoId] FOREIGN KEY([CompletionInfoId])
REFERENCES [dbo].[EngMwoCompletionInfoTxn] ([CompletionInfoId])
GO
ALTER TABLE [dbo].[EngMwoProcessStatusTxnDet] CHECK CONSTRAINT [FK_EngMwoProcessStatusTxnDet_EngMwoCompletionInfoTxn_CompletionInfoId]
GO
ALTER TABLE [dbo].[EngMwoProcessStatusTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoProcessStatusTxnDet_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngMwoProcessStatusTxnDet] CHECK CONSTRAINT [FK_EngMwoProcessStatusTxnDet_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngMwoProcessStatusTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoProcessStatusTxnDet_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngMwoProcessStatusTxnDet] CHECK CONSTRAINT [FK_EngMwoProcessStatusTxnDet_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngMwoProcessStatusTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoProcessStatusTxnDet_UMUserRegistration_AcceptedBy] FOREIGN KEY([AcceptedBy])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[EngMwoProcessStatusTxnDet] CHECK CONSTRAINT [FK_EngMwoProcessStatusTxnDet_UMUserRegistration_AcceptedBy]
GO
ALTER TABLE [dbo].[EngMwoProcessStatusTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoProcessStatusTxnDet_UMUserRegistration_StaffId] FOREIGN KEY([StaffId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[EngMwoProcessStatusTxnDet] CHECK CONSTRAINT [FK_EngMwoProcessStatusTxnDet_UMUserRegistration_StaffId]
GO
