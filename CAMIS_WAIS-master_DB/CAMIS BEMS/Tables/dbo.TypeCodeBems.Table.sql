USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[TypeCodeBems]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TypeCodeBems](
	[Asset Type Code] [nvarchar](255) NULL,
	[Model ] [nvarchar](255) NULL,
	[Manufacturer ] [nvarchar](255) NULL
) ON [PRIMARY]
GO
