USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[CRMRequestProcessStatus]    Script Date: 20-09-2021 17:02:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CRMRequestProcessStatus](
	[CRMProcessStatusId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NULL,
	[CRMRequestWOId] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[DoneBy] [int] NULL,
	[DoneDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[AssignedUserId] [int] NULL,
 CONSTRAINT [PK_CRMRequestProcessStatus] PRIMARY KEY CLUSTERED 
(
	[CRMProcessStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CRMRequestProcessStatus] ADD  CONSTRAINT [DF_CRMRequestProcessStatus_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[CRMRequestProcessStatus]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestProcessStatus_CRMRequestProcessStatus_CRMRequestWOId] FOREIGN KEY([CRMRequestWOId])
REFERENCES [dbo].[CRMRequestWorkOrderTxn] ([CRMRequestWOId])
GO
ALTER TABLE [dbo].[CRMRequestProcessStatus] CHECK CONSTRAINT [FK_CRMRequestProcessStatus_CRMRequestProcessStatus_CRMRequestWOId]
GO
ALTER TABLE [dbo].[CRMRequestProcessStatus]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestProcessStatus_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[CRMRequestProcessStatus] CHECK CONSTRAINT [FK_CRMRequestProcessStatus_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[CRMRequestProcessStatus]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestProcessStatus_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[CRMRequestProcessStatus] CHECK CONSTRAINT [FK_CRMRequestProcessStatus_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[CRMRequestProcessStatus]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestProcessStatus_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[CRMRequestProcessStatus] CHECK CONSTRAINT [FK_CRMRequestProcessStatus_MstService_ServiceId]
GO
ALTER TABLE [dbo].[CRMRequestProcessStatus]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestProcessStatus_UMUserRegistration_AssignedUserId] FOREIGN KEY([AssignedUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[CRMRequestProcessStatus] CHECK CONSTRAINT [FK_CRMRequestProcessStatus_UMUserRegistration_AssignedUserId]
GO
