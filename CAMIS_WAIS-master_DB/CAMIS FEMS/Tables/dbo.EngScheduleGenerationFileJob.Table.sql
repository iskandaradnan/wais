USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngScheduleGenerationFileJob]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngScheduleGenerationFileJob](
	[JobId] [int] IDENTITY(1,1) NOT NULL,
	[FacilityId] [int] NULL,
	[CustomerId] [int] NULL,
	[Service] [int] NULL,
	[JobName] [nvarchar](500) NULL,
	[JobDescription] [nvarchar](max) NULL,
	[Gid] [nvarchar](1000) NULL,
	[Status] [nvarchar](100) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[TypeOfPlanner] [int] NULL,
	[Year] [int] NULL,
	[WeekNo] [int] NULL,
	[FileInfo] [nvarchar](max) NULL,
	[WeekLogId] [int] NULL,
	[EngUserAreaId] [int] NULL,
	[WorkGroup] [int] NULL,
 CONSTRAINT [PK_EngScheduleGenerationFileJob] PRIMARY KEY CLUSTERED 
(
	[JobId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngScheduleGenerationFileJob] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
