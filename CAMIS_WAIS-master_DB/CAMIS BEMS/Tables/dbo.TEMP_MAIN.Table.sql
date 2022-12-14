USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[TEMP_MAIN]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TEMP_MAIN](
	[CustomerID] [varchar](3) NOT NULL,
	[FacilityID] [varchar](3) NOT NULL,
	[DedNCRValidationId] [int] NOT NULL,
	[CRMRequestId] [int] NOT NULL,
	[RequestNo] [nvarchar](50) NULL,
	[RequestStatus] [int] NULL,
	[RequestDateTime] [datetime] NULL,
	[AssetId] [int] NULL,
	[AssetNo] [nvarchar](50) NULL,
	[Completed_Date] [datetime] NULL,
	[DeductionFigureAsset] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[IndicatorDetId] [int] NOT NULL
) ON [PRIMARY]
GO
