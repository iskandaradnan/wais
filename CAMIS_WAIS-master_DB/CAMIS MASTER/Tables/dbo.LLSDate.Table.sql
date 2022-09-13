USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSDate]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSDate](
	[Date] [date] NULL,
	[Month] [int] NULL,
	[MonthName] [varchar](20) NULL,
	[Year] [int] NULL,
	[DAY] [int] NULL
) ON [PRIMARY]
GO
