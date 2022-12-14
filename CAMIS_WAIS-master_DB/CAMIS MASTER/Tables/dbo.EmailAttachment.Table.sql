USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EmailAttachment]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailAttachment](
	[EmailAttachmentId] [int] IDENTITY(1,1) NOT NULL,
	[EmailQueueId] [int] NOT NULL,
	[AttachmentName] [nvarchar](75) NOT NULL,
	[AttachmentType] [nvarchar](50) NULL,
	[Content] [varbinary](max) NOT NULL,
 CONSTRAINT [PK_EmailAttachment] PRIMARY KEY CLUSTERED 
(
	[EmailAttachmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmailAttachment]  WITH CHECK ADD  CONSTRAINT [FK_EmailAttachment] FOREIGN KEY([EmailQueueId])
REFERENCES [dbo].[EmailQueue] ([EmailQueueId])
GO
ALTER TABLE [dbo].[EmailAttachment] CHECK CONSTRAINT [FK_EmailAttachment]
GO
