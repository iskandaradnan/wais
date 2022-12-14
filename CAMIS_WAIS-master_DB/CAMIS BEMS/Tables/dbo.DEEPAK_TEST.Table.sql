USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[DEEPAK_TEST]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DEEPAK_TEST](
	[AssetNo] [nvarchar](50) NOT NULL,
	[AssetTypeCode] [nvarchar](25) NULL,
	[AssetPurchasePrice] [numeric](24, 2) NULL,
	[AssetAge] [int] NULL,
	[OperatingHours] [float] NULL,
	[OperatingDaysWeeks] [float] NULL,
	[TotalAnnualHours] [float] NULL,
	[DownTimeAging] [int] NOT NULL,
	[Uptime_Calc] [float] NULL,
	[RunningTotal] [float] NULL,
	[TargetUptime] [float] NULL,
	[AssetTypeDescription] [nvarchar](250) NULL,
	[TotalAccumDowtimeHours] [float] NULL,
	[Uptime] [numeric](18, 2) NULL,
	[DeductionFigurePerAsset] [numeric](6, 2) NULL,
	[DeductionFigurePerAssetLessThenEighty] [numeric](7, 2) NULL,
	[Year] [int] NULL,
	[Month] [int] NULL
) ON [PRIMARY]
GO
