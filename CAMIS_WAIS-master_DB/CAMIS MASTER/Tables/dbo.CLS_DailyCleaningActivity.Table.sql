USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_DailyCleaningActivity]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_DailyCleaningActivity](
	[DailyActivityId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[DocumentNo] [nvarchar](30) NOT NULL,
	[Date] [datetime] NULL,
	[TotalDone] [int] NULL,
	[TotalNotDone] [int] NULL,
 CONSTRAINT [DailyActivityId] PRIMARY KEY CLUSTERED 
(
	[DailyActivityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
