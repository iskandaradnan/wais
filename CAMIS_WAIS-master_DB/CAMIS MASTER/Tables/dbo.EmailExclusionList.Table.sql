USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EmailExclusionList]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailExclusionList](
	[EmailExclusionId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[EmailTemplateId] [int] NULL,
	[EmailAddress] [nvarchar](200) NOT NULL,
	[Type] [int] NULL,
	[Status] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EmailExclusionList] PRIMARY KEY CLUSTERED 
(
	[EmailExclusionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmailExclusionList] ADD  CONSTRAINT [DF_EmailExclusionList_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EmailExclusionList]  WITH CHECK ADD  CONSTRAINT [FK_EELmailTemplateId] FOREIGN KEY([EmailTemplateId])
REFERENCES [dbo].[NotificationTemplate] ([NotificationTemplateId])
GO
ALTER TABLE [dbo].[EmailExclusionList] CHECK CONSTRAINT [FK_EELmailTemplateId]
GO
ALTER TABLE [dbo].[EmailExclusionList]  WITH CHECK ADD  CONSTRAINT [FK_EmailExclusionList_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EmailExclusionList] CHECK CONSTRAINT [FK_EmailExclusionList_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EmailExclusionList]  WITH CHECK ADD  CONSTRAINT [FK_EmailExclusionList_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EmailExclusionList] CHECK CONSTRAINT [FK_EmailExclusionList_MstLocationFacility_FacilityId]
GO
