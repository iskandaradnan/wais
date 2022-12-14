USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_DailyCleaningActivityGridviewfields]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_DailyCleaningActivityGridviewfields](
	[DailyFetchId] [int] IDENTITY(1,1) NOT NULL,
	[DailyActivityId] [int] NULL,
	[UserAreaCode] [varchar](30) NULL,
	[Status] [varchar](30) NULL,
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
 CONSTRAINT [PK_CLS_DailyCleaningActivityGridviewfields] PRIMARY KEY CLUSTERED 
(
	[DailyFetchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CLS_DailyCleaningActivityGridviewfields]  WITH CHECK ADD  CONSTRAINT [CLS_FK_DailyActivityId] FOREIGN KEY([DailyActivityId])
REFERENCES [dbo].[CLS_DailyCleaningActivity] ([DailyActivityId])
GO
ALTER TABLE [dbo].[CLS_DailyCleaningActivityGridviewfields] CHECK CONSTRAINT [CLS_FK_DailyActivityId]
GO
