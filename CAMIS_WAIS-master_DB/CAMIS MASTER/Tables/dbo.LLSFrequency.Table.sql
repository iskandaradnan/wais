USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSFrequency]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSFrequency](
	[Frequency ] [nvarchar](255) NULL,
	[Year] [float] NULL,
	[MonthName] [nvarchar](255) NULL,
	[MonthNo] [float] NULL
) ON [PRIMARY]
GO
