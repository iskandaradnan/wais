USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngTrainingScheduleUserAreaHistory]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_EngTrainingScheduleUserAreaHistory] AS TABLE(
	[TrainingScheduleAreaId] [int] NULL,
	[UserAreaId] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[UserId] [int] NULL
)
GO
