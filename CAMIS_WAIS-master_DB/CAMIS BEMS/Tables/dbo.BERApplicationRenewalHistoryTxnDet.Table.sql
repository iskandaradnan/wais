USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[BERApplicationRenewalHistoryTxnDet]    Script Date: 20-09-2021 17:02:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BERApplicationRenewalHistoryTxnDet](
	[RenewalHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[ApplicationId] [int] NOT NULL,
	[RenewalDate] [date] NOT NULL,
	[PresentValue] [numeric](24, 2) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_BERApplicationRenewalHistoryTxnDet] PRIMARY KEY CLUSTERED 
(
	[RenewalHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BERApplicationRenewalHistoryTxnDet] ADD  CONSTRAINT [DF_BERApplicationRenewalHistoryTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[BERApplicationRenewalHistoryTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_BERApplicationRenewalHistoryTxnDet_BERApplicationTxn_ApplicationId] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[BERApplicationTxn] ([ApplicationId])
GO
ALTER TABLE [dbo].[BERApplicationRenewalHistoryTxnDet] CHECK CONSTRAINT [FK_BERApplicationRenewalHistoryTxnDet_BERApplicationTxn_ApplicationId]
GO
ALTER TABLE [dbo].[BERApplicationRenewalHistoryTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_BERApplicationRenewalHistoryTxnDet_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[BERApplicationRenewalHistoryTxnDet] CHECK CONSTRAINT [FK_BERApplicationRenewalHistoryTxnDet_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[BERApplicationRenewalHistoryTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_BERApplicationRenewalHistoryTxnDet_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[BERApplicationRenewalHistoryTxnDet] CHECK CONSTRAINT [FK_BERApplicationRenewalHistoryTxnDet_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[BERApplicationRenewalHistoryTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_BERApplicationRenewalHistoryTxnDet_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[BERApplicationRenewalHistoryTxnDet] CHECK CONSTRAINT [FK_BERApplicationRenewalHistoryTxnDet_MstService_ServiceId]
GO
