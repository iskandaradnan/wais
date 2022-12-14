USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[CRMRequestCompletionInfo]    Script Date: 20-09-2021 17:02:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CRMRequestCompletionInfo](
	[CRMCompletionInfoId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NULL,
	[CRMRequestWOId] [int] NOT NULL,
	[StartDateTime] [datetime] NULL,
	[StartDateTimeUTC] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[EndDateTimeUTC] [datetime] NULL,
	[HandoverDateTime] [datetime] NULL,
	[HandoverDateTimeUTC] [datetime] NULL,
	[HandoverDelay] [int] NULL,
	[AcceptedBy] [int] NULL,
	[Signature] [varbinary](max) NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[CompletedBy] [int] NULL,
	[CompletedbyRemarks] [nvarchar](500) NULL,
 CONSTRAINT [PK_CRMRequestCompletionInfo] PRIMARY KEY CLUSTERED 
(
	[CRMCompletionInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[CRMRequestCompletionInfo] ADD  CONSTRAINT [DF_CRMRequestCompletionInfo_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[CRMRequestCompletionInfo]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestCompletionInfo_CRMRequestWorkOrderTxn_CRMRequestWOId] FOREIGN KEY([CRMRequestWOId])
REFERENCES [dbo].[CRMRequestWorkOrderTxn] ([CRMRequestWOId])
GO
ALTER TABLE [dbo].[CRMRequestCompletionInfo] CHECK CONSTRAINT [FK_CRMRequestCompletionInfo_CRMRequestWorkOrderTxn_CRMRequestWOId]
GO
ALTER TABLE [dbo].[CRMRequestCompletionInfo]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestCompletionInfo_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[CRMRequestCompletionInfo] CHECK CONSTRAINT [FK_CRMRequestCompletionInfo_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[CRMRequestCompletionInfo]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestCompletionInfo_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[CRMRequestCompletionInfo] CHECK CONSTRAINT [FK_CRMRequestCompletionInfo_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[CRMRequestCompletionInfo]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestCompletionInfo_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[CRMRequestCompletionInfo] CHECK CONSTRAINT [FK_CRMRequestCompletionInfo_MstService_ServiceId]
GO
ALTER TABLE [dbo].[CRMRequestCompletionInfo]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestCompletionInfo_UMUserRegistration_AcceptedBy] FOREIGN KEY([AcceptedBy])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[CRMRequestCompletionInfo] CHECK CONSTRAINT [FK_CRMRequestCompletionInfo_UMUserRegistration_AcceptedBy]
GO
