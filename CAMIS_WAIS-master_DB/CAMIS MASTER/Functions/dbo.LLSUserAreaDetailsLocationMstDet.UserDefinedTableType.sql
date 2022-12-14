USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSUserAreaDetailsLocationMstDet]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSUserAreaDetailsLocationMstDet] AS TABLE(
	[LLSUserAreaId] [int] NOT NULL,
	[UserLocationId] [int] NULL,
	[UserAreaCode] [nvarchar](25) NOT NULL,
	[UserLocationCode] [nvarchar](100) NOT NULL,
	[LinenSchedule] [nvarchar](20) NOT NULL,
	[1stScheduleStartTime] [time](7) NOT NULL,
	[2ndScheduleStartTime] [time](7) NULL,
	[3rdScheduleStartTime] [time](7) NULL,
	[FacilityId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL
)
GO
