USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_OSWRecordSheet_Attachment]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_OSWRecordSheet_Attachment](
	[AttachmentId] [int] IDENTITY(1,1) NOT NULL,
	[OSWRId] [int] NULL,
	[FileType] [nvarchar](500) NULL,
	[FileName] [nvarchar](500) NULL,
	[AttachmentName] [nvarchar](500) NULL,
	[FilePath] [nvarchar](500) NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HWMS_OSWRecordSheet_Attachment]  WITH CHECK ADD FOREIGN KEY([OSWRId])
REFERENCES [dbo].[HWMS_OSWRecordSheet] ([OSWRId])
GO
