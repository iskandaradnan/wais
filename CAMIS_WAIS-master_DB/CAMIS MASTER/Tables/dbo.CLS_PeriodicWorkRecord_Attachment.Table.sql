USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_PeriodicWorkRecord_Attachment]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_PeriodicWorkRecord_Attachment](
	[AttachmentId] [int] IDENTITY(1,1) NOT NULL,
	[PeriodicId] [int] NULL,
	[FileType] [nvarchar](500) NULL,
	[FileName] [nvarchar](500) NULL,
	[AttachmentName] [nvarchar](500) NULL,
	[FilePath] [nvarchar](500) NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CLS_PeriodicWorkRecord_Attachment]  WITH CHECK ADD FOREIGN KEY([PeriodicId])
REFERENCES [dbo].[CLS_PeriodicWorkRecord] ([PeriodicId])
GO
ALTER TABLE [dbo].[CLS_PeriodicWorkRecord_Attachment]  WITH CHECK ADD FOREIGN KEY([PeriodicId])
REFERENCES [dbo].[CLS_PeriodicWorkRecord] ([PeriodicId])
GO
