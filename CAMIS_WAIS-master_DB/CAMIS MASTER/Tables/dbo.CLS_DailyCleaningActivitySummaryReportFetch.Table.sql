USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_DailyCleaningActivitySummaryReportFetch]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_DailyCleaningActivitySummaryReportFetch](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Hospital] [varchar](max) NULL,
	[Year] [int] NULL,
	[Month] [varchar](max) NULL,
	[UserAreaCode] [varchar](max) NULL,
	[UserArea] [varchar](max) NULL,
	[A1] [int] NULL,
	[A2] [int] NULL,
	[A3] [int] NULL,
	[A4] [int] NULL,
	[A5] [int] NULL,
	[B1] [int] NULL,
	[C1] [int] NULL,
	[D1] [int] NULL,
	[D2] [int] NULL,
	[D3] [int] NULL,
	[D4] [int] NULL,
	[E1] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
