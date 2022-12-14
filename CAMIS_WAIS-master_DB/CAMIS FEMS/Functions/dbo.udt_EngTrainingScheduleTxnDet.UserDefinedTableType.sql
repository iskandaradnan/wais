USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngTrainingScheduleTxnDet]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_EngTrainingScheduleTxnDet] AS TABLE(
	[TrainingScheduleDetId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[ParticipantsUserId] [int] NULL,
	[UserAreaId] [int] NULL,
	[Remarks] [nvarchar](1000) NULL
)
GO
