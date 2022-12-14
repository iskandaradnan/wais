USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_DeptAreaPeriodicWork]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_DeptAreaPeriodicWork](
	[PeriodicWorkScheduleId] [int] IDENTITY(1,1) NOT NULL,
	[DeptAreaId] [int] NOT NULL,
	[UserAreaId] [int] NOT NULL,
	[ContainerWashing] [nvarchar](30) NULL,
	[Ceiling] [nvarchar](30) NULL,
	[Lights] [nvarchar](30) NULL,
	[FloorScrubbing] [nvarchar](30) NULL,
	[FloorPolishing] [nvarchar](30) NULL,
	[FloorBuffing] [nvarchar](30) NULL,
	[FloorBB] [nvarchar](30) NULL,
	[FloorShampooing] [nvarchar](30) NULL,
	[FloorExtraction] [nvarchar](30) NULL,
	[WallWiping] [nvarchar](30) NULL,
	[WindowDW] [nvarchar](30) NULL,
	[PerimeterDrain] [nvarchar](30) NULL,
	[ToiletDescaling] [nvarchar](30) NULL,
	[HighRiseNetting] [nvarchar](30) NULL,
	[ExternalFacade] [nvarchar](30) NULL,
	[ExternalHighLevelGlass] [nvarchar](30) NULL,
	[InternetGlass] [nvarchar](30) NULL,
	[FlatRoof] [nvarchar](30) NULL,
	[StainlessSteelPolishing] [nvarchar](30) NULL,
	[ExposeCeiling] [nvarchar](30) NULL,
	[LedgesDampWipe] [nvarchar](30) NULL,
	[SkyLightHighDusting] [nvarchar](30) NULL,
	[SignagesWiping] [nvarchar](30) NULL,
	[DecksHighDusting] [nvarchar](30) NULL,
	[UserAreaCode] [nvarchar](100) NULL
) ON [PRIMARY]
GO
