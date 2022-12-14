USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[DeductionDemeritPointB4_Base05102020]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeductionDemeritPointB4_Base05102020](
	[AssetNo] [nvarchar](50) NOT NULL,
	[AssetId] [int] NULL,
	[AssetDescription] [nvarchar](500) NULL,
	[PurchaseCostRM] [numeric](24, 2) NULL,
	[MaintenanceWorkNo] [nvarchar](100) NOT NULL,
	[MaintenanceWorkDateTime] [datetime] NULL,
	[WarrantyStatus] [varchar](13) NOT NULL,
	[UserAreaCode] [nvarchar](25) NULL,
	[ScheduleDate] [datetime] NULL,
	[ReScheduleDate] [datetime] NULL,
	[StartDateTime] [datetime] NULL,
	[DeductionFigurePerAsset] [int] NULL,
	[DemeritPoint] [int] NOT NULL,
	[ValidateStatus] [varchar](1) NOT NULL,
	[DeductionRM] [int] NULL,
	[Category] [varchar](27) NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[7thDaytoStart] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[Year] [int] NULL,
	[Month] [int] NULL,
	[DemeritPointPost] [int] NULL,
	[ValidateStatusPost] [varchar](1) NULL,
	[DeductionRMPost] [int] NULL
) ON [PRIMARY]
GO
