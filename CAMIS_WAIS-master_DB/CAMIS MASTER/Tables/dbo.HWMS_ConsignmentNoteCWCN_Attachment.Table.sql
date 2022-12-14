USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_ConsignmentNoteCWCN_Attachment]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_ConsignmentNoteCWCN_Attachment](
	[AttachmentId] [int] IDENTITY(1,1) NOT NULL,
	[ConsignmentId] [int] NULL,
	[FileType] [nvarchar](500) NULL,
	[FileName] [nvarchar](500) NULL,
	[AttachmentName] [nvarchar](500) NULL,
	[FilePath] [nvarchar](500) NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HWMS_ConsignmentNoteCWCN_Attachment]  WITH CHECK ADD  CONSTRAINT [consignments_FK_Id] FOREIGN KEY([ConsignmentId])
REFERENCES [dbo].[HWMS_ConsignmentNoteCWCN] ([ConsignmentId])
GO
ALTER TABLE [dbo].[HWMS_ConsignmentNoteCWCN_Attachment] CHECK CONSTRAINT [consignments_FK_Id]
GO
