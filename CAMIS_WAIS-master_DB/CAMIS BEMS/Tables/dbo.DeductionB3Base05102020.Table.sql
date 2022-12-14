USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[DeductionB3Base05102020]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeductionB3Base05102020](
	[AssetNo] [nvarchar](50) NOT NULL,
	[AssetTypeCode] [nvarchar](25) NULL,
	[AssetPurchasePrice] [numeric](24, 2) NULL,
	[AssetAge] [int] NULL,
	[OperatingHours] [float] NULL,
	[OperatingDaysWeeks] [float] NULL,
	[DownTimeAging] [int] NOT NULL,
	[TotalAnnualHours] [float] NULL,
	[TargetUptime] [float] NULL,
	[AssetTypeDescription] [nvarchar](250) NULL,
	[TotalAccumDowtimeHours] [float] NULL,
	[DeductionFigurePerAsset1] [numeric](6, 2) NULL,
	[DeductionFigurePerAsset2] [numeric](7, 2) NULL,
	[CurrentUptime] [numeric](18, 2) NULL,
	[Jan] [numeric](38, 2) NULL,
	[Feb] [numeric](38, 2) NULL,
	[Mar] [numeric](38, 2) NULL,
	[Apr] [numeric](38, 2) NULL,
	[May] [numeric](38, 2) NULL,
	[Jun] [numeric](38, 2) NULL,
	[Jul] [numeric](38, 2) NULL,
	[Aug] [numeric](38, 2) NULL,
	[Sep] [numeric](38, 2) NULL,
	[Oct] [numeric](38, 2) NULL,
	[Nov] [numeric](38, 2) NULL,
	[Dec] [numeric](38, 2) NULL,
	[DeductionValue1] [numeric](18, 2) NULL,
	[DeductionValue2] [numeric](18, 2) NULL,
	[DemeritPointValue1] [int] NOT NULL,
	[DemeritPointValue2] [int] NOT NULL,
	[TotalProHawkDeduction] [numeric](19, 2) NULL,
	[Year] [int] NULL,
	[Month] [int] NULL,
	[Remarks] [varchar](6) NOT NULL
) ON [PRIMARY]
GO
