USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngEODCaptureTxnAttachment]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngEODCaptureTxnAttachment](
	[EodCaptureAttachmentId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[CaptureId] [int] NOT NULL,
	[DocumentId] [int] NOT NULL,
	[FileType] [int] NOT NULL,
	[FileName] [nvarchar](255) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngEodCaptureTxnAttachment] PRIMARY KEY CLUSTERED 
(
	[EodCaptureAttachmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngEODCaptureTxnAttachment] ADD  CONSTRAINT [DF_EngEodCaptureTxnAttachment_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngEODCaptureTxnAttachment]  WITH CHECK ADD  CONSTRAINT [FK_EngEodCaptureTxnAttachment_EngEodCaptureTxn_CaptureId] FOREIGN KEY([CaptureId])
REFERENCES [dbo].[EngEODCaptureTxn] ([CaptureId])
GO
ALTER TABLE [dbo].[EngEODCaptureTxnAttachment] CHECK CONSTRAINT [FK_EngEodCaptureTxnAttachment_EngEodCaptureTxn_CaptureId]
GO
ALTER TABLE [dbo].[EngEODCaptureTxnAttachment]  WITH CHECK ADD  CONSTRAINT [FK_EngEodCaptureTxnAttachment_FMDocument_DocumentId] FOREIGN KEY([DocumentId])
REFERENCES [dbo].[FMDocument] ([DocumentId])
GO
ALTER TABLE [dbo].[EngEODCaptureTxnAttachment] CHECK CONSTRAINT [FK_EngEodCaptureTxnAttachment_FMDocument_DocumentId]
GO
ALTER TABLE [dbo].[EngEODCaptureTxnAttachment]  WITH CHECK ADD  CONSTRAINT [FK_EngEodCaptureTxnAttachment_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngEODCaptureTxnAttachment] CHECK CONSTRAINT [FK_EngEodCaptureTxnAttachment_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngEODCaptureTxnAttachment]  WITH CHECK ADD  CONSTRAINT [FK_EngEodCaptureTxnAttachment_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngEODCaptureTxnAttachment] CHECK CONSTRAINT [FK_EngEodCaptureTxnAttachment_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngEODCaptureTxnAttachment]  WITH CHECK ADD  CONSTRAINT [FK_EngEodCaptureTxnAttachment_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngEODCaptureTxnAttachment] CHECK CONSTRAINT [FK_EngEodCaptureTxnAttachment_MstService_ServiceId]
GO
