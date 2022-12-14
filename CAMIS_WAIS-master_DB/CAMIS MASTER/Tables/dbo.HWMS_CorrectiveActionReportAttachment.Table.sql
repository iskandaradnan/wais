USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_CorrectiveActionReportAttachment]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_CorrectiveActionReportAttachment](
	[AttachmentId] [int] IDENTITY(1,1) NOT NULL,
	[CARId] [int] NULL,
	[FileType] [nvarchar](50) NULL,
	[FileName] [nvarchar](50) NULL,
	[AttachmentName] [nvarchar](50) NULL,
	[FilePath] [nvarchar](50) NULL,
	[isDeleted] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HWMS_CorrectiveActionReportAttachment]  WITH CHECK ADD FOREIGN KEY([CARId])
REFERENCES [dbo].[HWMS_CorrectiveActionReport] ([CARId])
GO
