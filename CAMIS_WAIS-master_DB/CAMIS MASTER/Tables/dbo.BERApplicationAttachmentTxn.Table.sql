USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[BERApplicationAttachmentTxn]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BERApplicationAttachmentTxn](
	[BERApplicationAttachmentId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[ApplicationId] [int] NULL,
	[DocumentId] [int] NOT NULL,
	[FileType] [int] NOT NULL,
	[AttachedBy] [int] NULL,
	[FileName] [nvarchar](255) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_BERApplicationAttachmentTxn] PRIMARY KEY CLUSTERED 
(
	[BERApplicationAttachmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BERApplicationAttachmentTxn] ADD  CONSTRAINT [DF_BERApplicationAttachmentTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[BERApplicationAttachmentTxn]  WITH CHECK ADD  CONSTRAINT [FK_BERApplicationAttachmentTxn_BERApplicationTxn_ApplicationId] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[BERApplicationTxn] ([ApplicationId])
GO
ALTER TABLE [dbo].[BERApplicationAttachmentTxn] CHECK CONSTRAINT [FK_BERApplicationAttachmentTxn_BERApplicationTxn_ApplicationId]
GO
ALTER TABLE [dbo].[BERApplicationAttachmentTxn]  WITH CHECK ADD  CONSTRAINT [FK_BERApplicationAttachmentTxn_FMDocument_DocumentId] FOREIGN KEY([DocumentId])
REFERENCES [dbo].[FMDocument] ([DocumentId])
GO
ALTER TABLE [dbo].[BERApplicationAttachmentTxn] CHECK CONSTRAINT [FK_BERApplicationAttachmentTxn_FMDocument_DocumentId]
GO
ALTER TABLE [dbo].[BERApplicationAttachmentTxn]  WITH CHECK ADD  CONSTRAINT [FK_BERApplicationAttachmentTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[BERApplicationAttachmentTxn] CHECK CONSTRAINT [FK_BERApplicationAttachmentTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[BERApplicationAttachmentTxn]  WITH CHECK ADD  CONSTRAINT [FK_BERApplicationAttachmentTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[BERApplicationAttachmentTxn] CHECK CONSTRAINT [FK_BERApplicationAttachmentTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[BERApplicationAttachmentTxn]  WITH CHECK ADD  CONSTRAINT [FK_BERApplicationAttachmentTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[BERApplicationAttachmentTxn] CHECK CONSTRAINT [FK_BERApplicationAttachmentTxn_MstService_ServiceId]
GO
