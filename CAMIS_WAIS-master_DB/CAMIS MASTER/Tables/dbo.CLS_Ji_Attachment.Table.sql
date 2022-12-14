USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_Ji_Attachment]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_Ji_Attachment](
	[AttachId] [int] IDENTITY(1,1) NOT NULL,
	[FileType] [nvarchar](50) NULL,
	[FileName] [nvarchar](50) NULL,
	[Attachment] [nvarchar](50) NULL,
	[DetailsId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CLS_Ji_Attachment]  WITH CHECK ADD  CONSTRAINT [JIAttach_FK_Idno] FOREIGN KEY([DetailsId])
REFERENCES [dbo].[CLS_JiDetails] ([DetailsId])
GO
ALTER TABLE [dbo].[CLS_Ji_Attachment] CHECK CONSTRAINT [JIAttach_FK_Idno]
GO
