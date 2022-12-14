USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_CARAttachments]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_CARAttachments](
	[AttachmentId] [int] IDENTITY(1,1) NOT NULL,
	[CARId] [int] NULL,
	[FileType] [nvarchar](50) NULL,
	[FileName] [nvarchar](50) NULL,
	[AttachmentName] [nvarchar](50) NULL,
	[FilePath] [nvarchar](50) NULL,
	[isDeleted] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CLS_CARAttachments]  WITH CHECK ADD FOREIGN KEY([CARId])
REFERENCES [dbo].[CLS_CorrectiveActionReport] ([CARId])
GO
