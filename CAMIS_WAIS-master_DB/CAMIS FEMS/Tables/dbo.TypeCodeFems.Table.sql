USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[TypeCodeFems]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TypeCodeFems](
	[Services] [nvarchar](255) NULL,
	[Asset Type Code] [nvarchar](255) NULL,
	[Model ] [nvarchar](255) NULL,
	[Manufacturer ] [nvarchar](255) NULL
) ON [PRIMARY]
GO
