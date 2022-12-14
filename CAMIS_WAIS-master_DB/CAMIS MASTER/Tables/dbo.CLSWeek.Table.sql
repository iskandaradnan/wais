USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLSWeek]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLSWeek](
	[CLSWeekId] [int] IDENTITY(1,1) NOT NULL,
	[Year] [int] NULL,
	[Month] [int] NULL,
	[MonthName] [varchar](20) NULL,
	[WeekNo] [int] NULL,
	[WeekStartDate] [datetime] NULL,
	[WeekEndDate] [datetime] NULL,
 CONSTRAINT [PK_CLSWeek] PRIMARY KEY CLUSTERED 
(
	[CLSWeekId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
