USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_ToiletInspectionTxn_Attachment]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_ToiletInspectionTxn_Attachment](
	[AttachmentId] [int] IDENTITY(1,1) NOT NULL,
	[ToiletInspectionId] [int] NULL,
	[FileType] [nvarchar](500) NULL,
	[FileName] [nvarchar](500) NULL,
	[AttachmentName] [nvarchar](500) NULL,
	[FilePath] [nvarchar](500) NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CLS_ToiletInspectionTxn_Attachment]  WITH CHECK ADD FOREIGN KEY([ToiletInspectionId])
REFERENCES [dbo].[CLS_ToiletInspectionTxn] ([ToiletInspectionId])
GO
ALTER TABLE [dbo].[CLS_ToiletInspectionTxn_Attachment]  WITH CHECK ADD FOREIGN KEY([ToiletInspectionId])
REFERENCES [dbo].[CLS_ToiletInspectionTxn] ([ToiletInspectionId])
GO
