USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngMwoCompletionInfoTxnDet]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngMwoCompletionInfoTxnDet](
	[CompletionInfoDetId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[CompletionInfoId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[StandardTaskDetId] [int] NULL,
	[StartDateTime] [datetime] NOT NULL,
	[StartDateTimeUTC] [datetime] NOT NULL,
	[EndDateTime] [datetime] NULL,
	[EndDateTimeUTC] [datetime] NULL,
	[RepairHours] [numeric](24, 2) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [nvarchar](500) NOT NULL,
	[LabourCost] [numeric](24, 2) NULL,
	[MobileGuid] [nvarchar](max) NULL,
	[Remarks] [varchar](max) NULL,
 CONSTRAINT [PK_EngMwoCompletionInfoTxnDet] PRIMARY KEY CLUSTERED 
(
	[CompletionInfoDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxnDet] ADD  CONSTRAINT [DF_EngMwoCompletionInfoTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoCompletionInfoTxnDet_EngMwoCompletionInfoTxn_CompletionInfoId] FOREIGN KEY([CompletionInfoId])
REFERENCES [dbo].[EngMwoCompletionInfoTxn] ([CompletionInfoId])
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxnDet] CHECK CONSTRAINT [FK_EngMwoCompletionInfoTxnDet_EngMwoCompletionInfoTxn_CompletionInfoId]
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoCompletionInfoTxnDet_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxnDet] CHECK CONSTRAINT [FK_EngMwoCompletionInfoTxnDet_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoCompletionInfoTxnDet_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxnDet] CHECK CONSTRAINT [FK_EngMwoCompletionInfoTxnDet_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoCompletionInfoTxnDet_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxnDet] CHECK CONSTRAINT [FK_EngMwoCompletionInfoTxnDet_MstService_ServiceId]
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoCompletionInfoTxnDet_UMUserRegistration_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[EngMwoCompletionInfoTxnDet] CHECK CONSTRAINT [FK_EngMwoCompletionInfoTxnDet_UMUserRegistration_UserId]
GO
