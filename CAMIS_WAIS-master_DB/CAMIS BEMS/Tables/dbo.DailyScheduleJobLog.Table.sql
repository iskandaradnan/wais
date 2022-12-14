USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[DailyScheduleJobLog]    Script Date: 20-09-2021 17:02:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DailyScheduleJobLog](
	[JobId] [int] IDENTITY(1,1) NOT NULL,
	[Status] [varchar](50) NULL,
	[LastRunDate] [datetime] NULL,
 CONSTRAINT [PK_JobId] PRIMARY KEY CLUSTERED 
(
	[JobId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
