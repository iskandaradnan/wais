USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[FEMSASSET23022020]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FEMSASSET23022020](
	[ASSET NO] [varchar](50) NULL,
	[ASSET CLASSIFICATION ID] [int] NULL,
	[USERLOCATIONID] [varchar](50) NULL,
	[ASSET NAME] [varchar](500) NULL,
	[DEPARTMENT  AREA CODE] [varchar](50) NULL,
	[MANUFACTURER] [varchar](50) NULL,
	[MODEL] [varchar](50) NULL
) ON [PRIMARY]
GO
