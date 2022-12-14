USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLSUserLocationDetailsPeriodicWorkMstDet]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLSUserLocationDetailsPeriodicWorkMstDet](
	[PeriodicWorkScheduleId] [int] IDENTITY(1,1) NOT NULL,
	[CLSUserAreaId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ContainerReceptacleWashing] [int] NULL,
	[CeilingHighDusting] [int] NULL,
	[LightsAirCondFanWiping] [int] NULL,
	[FloorNonPolishableScrubbing] [int] NULL,
	[FloorPolishablePolish] [int] NULL,
	[FloorPolishableBuffing] [int] NULL,
	[FloorCarpetBonnetBuffing] [int] NULL,
	[FloorCarpetShampooing] [int] NULL,
	[FloorCarpetHeatSteam] [int] NULL,
	[WallWiping] [int] NULL,
	[WindowDoorWiping] [int] NULL,
	[PerimeterDrainWash] [int] NULL,
	[ToiletDescaling] [int] NULL,
	[HighRiseNettingDusting] [int] NULL,
	[ExternalFacadeCleaning] [int] NULL,
	[ExternalHighLevelGlassCleaning] [int] NULL,
	[InternalGlassSqueegeeClean] [int] NULL,
	[FlatRoofWashScrub] [int] NULL,
	[StainlessSteelPolishing] [int] NULL,
	[ExposeCeilingTruss] [int] NULL,
	[LedgesDampWipe] [int] NULL,
	[SkylightHighDusting] [int] NULL,
	[SignagesWiping] [int] NULL,
	[DeksHighDusting] [int] NULL,
	[Status] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_CLSUserLocationDetailsPeriodicWorkMstDet] PRIMARY KEY CLUSTERED 
(
	[PeriodicWorkScheduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
