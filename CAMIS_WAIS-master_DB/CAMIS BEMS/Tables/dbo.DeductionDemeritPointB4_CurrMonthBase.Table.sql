USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[DeductionDemeritPointB4_CurrMonthBase]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeductionDemeritPointB4_CurrMonthBase](
	[AssetNo] [nvarchar](50) NOT NULL,
	[AssetId] [int] NULL,
	[AssetDescription] [nvarchar](500) NULL,
	[PurchaseCostRM] [numeric](24, 2) NULL,
	[MaintenanceWorkNo] [nvarchar](100) NOT NULL,
	[MaintenanceWorkDateTime] [datetime] NULL,
	[WarrantyStatus] [varchar](13) NOT NULL,
	[UserAreaCode] [nvarchar](25) NULL,
	[WOStatus] [nvarchar](100) NOT NULL,
	[TargetDateTime] [datetime] NULL,
	[Year] [int] NULL,
	[Month] [int] NULL,
	[ScheduleDate] [datetime] NULL,
	[ReScheduleDate] [datetime] NULL,
	[StartDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[DeductionFigurePerAsset] [int] NULL,
	[Remarks] [nvarchar](500) NULL
) ON [PRIMARY]
GO
