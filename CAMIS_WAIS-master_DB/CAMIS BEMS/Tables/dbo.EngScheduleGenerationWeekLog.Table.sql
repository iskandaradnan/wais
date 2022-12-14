USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngScheduleGenerationWeekLog]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngScheduleGenerationWeekLog](
	[WeekLogId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[WorkGroupId] [int] NOT NULL,
	[TypeOfPlanner] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[WeekNo] [int] NOT NULL,
	[WeekStartDate] [datetime] NULL,
	[WeekEndDate] [datetime] NULL,
	[GenerateDate] [datetime] NOT NULL,
	[DocumentNo] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[ClassificationId] [int] NULL,
 CONSTRAINT [PK_EngScheduleGenerationWeekLog] PRIMARY KEY CLUSTERED 
(
	[WeekLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngScheduleGenerationWeekLog] ADD  CONSTRAINT [DF_EngScheduleGenerationWeekLog_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngScheduleGenerationWeekLog] ADD  CONSTRAINT [df_EngScheduleGenerationWeekLog]  DEFAULT ((0)) FOR [ClassificationId]
GO
