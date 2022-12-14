USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_JiDetails_Submit]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_JiDetails_Submit](
	[SubmitIdno] [int] IDENTITY(1,1) NOT NULL,
	[Status] [nvarchar](50) NULL,
	[DetailsId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CLS_JiDetails_Submit]  WITH CHECK ADD  CONSTRAINT [JIDetails_FK_SubmitIdno] FOREIGN KEY([DetailsId])
REFERENCES [dbo].[CLS_JiDetails] ([DetailsId])
GO
ALTER TABLE [dbo].[CLS_JiDetails_Submit] CHECK CONSTRAINT [JIDetails_FK_SubmitIdno]
GO
