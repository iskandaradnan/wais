USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[UEM_TEMP_ONE]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UEM_TEMP_ONE](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Address] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
