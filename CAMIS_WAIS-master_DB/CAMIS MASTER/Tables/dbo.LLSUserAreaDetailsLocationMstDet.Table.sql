USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSUserAreaDetailsLocationMstDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSUserAreaDetailsLocationMstDet](
	[LLSUserAreaLocationId] [int] IDENTITY(1,1) NOT NULL,
	[LLSUserAreaId] [int] NOT NULL,
	[UserAreaCode] [nvarchar](25) NOT NULL,
	[UserLocationId] [int] NULL,
	[UserLocationCode] [nvarchar](50) NULL,
	[LinenSchedule] [nvarchar](20) NOT NULL,
	[1stScheduleStartTime] [time](7) NULL,
	[1stScheduleEndTime] [time](7) NULL,
	[2ndScheduleStartTime] [time](7) NULL,
	[2ndScheduleEndTime] [time](7) NULL,
	[3rdScheduleStartTime] [time](7) NULL,
	[3rdScheduleEndTime] [time](7) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NULL,
	[FacilityId] [int] NULL,
	[CustomerId] [int] NULL
) ON [PRIMARY]
GO
