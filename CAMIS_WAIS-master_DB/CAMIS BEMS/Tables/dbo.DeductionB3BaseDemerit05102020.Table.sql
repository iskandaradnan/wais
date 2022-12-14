USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[DeductionB3BaseDemerit05102020]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeductionB3BaseDemerit05102020](
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
	[Month] [int] NULL,
	[DemritPoint_1] [int] NOT NULL,
	[DemritPoint_2] [int] NOT NULL
) ON [PRIMARY]
GO
