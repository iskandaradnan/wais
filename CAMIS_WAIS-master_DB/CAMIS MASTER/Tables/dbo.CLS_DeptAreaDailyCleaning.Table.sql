USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_DeptAreaDailyCleaning]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_DeptAreaDailyCleaning](
	[DailyCleaningActivityId] [int] IDENTITY(1,1) NOT NULL,
	[DeptAreaId] [int] NOT NULL,
	[UserAreaId] [int] NOT NULL,
	[DustMop] [int] NULL,
	[DampMop] [int] NULL,
	[Vacuum] [int] NULL,
	[Washing] [int] NULL,
	[Sweeping] [int] NULL,
	[Wiping] [int] NULL,
	[WipingWR] [int] NULL,
	[WipingFFE] [int] NULL,
	[ToiletWash] [int] NULL,
	[PaperHandTowel] [int] NULL,
	[Toilet] [int] NULL,
	[HandSoap] [int] NULL,
	[Deodorisers] [int] NULL,
	[DomesticWasteCollection] [int] NULL,
	[PeriodicalWork] [int] NULL,
	[UserAreaCode] [nvarchar](100) NULL
) ON [PRIMARY]
GO
