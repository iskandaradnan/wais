USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngTrainingScheduleUserAreaHistory]    Script Date: 20-09-2021 16:50:19 ******/
CREATE TYPE [dbo].[udt_EngTrainingScheduleUserAreaHistory] AS TABLE(
	[TrainingScheduleAreaId] [int] NULL,
	[UserAreaId] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[UserId] [int] NULL
)
GO
