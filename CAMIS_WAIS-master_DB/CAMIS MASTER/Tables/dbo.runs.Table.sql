USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[runs]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[runs](
	[id] [int] NULL,
	[match] [nvarchar](10) NULL,
	[runs] [int] NULL
) ON [PRIMARY]
GO
