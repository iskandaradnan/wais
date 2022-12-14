USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngTrainingScheduleTxnDet]    Script Date: 20-09-2021 16:50:19 ******/
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
