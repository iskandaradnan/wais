USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[TEMPOPENPREVMONTH_NCR]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TEMPOPENPREVMONTH_NCR](
	[CustomerID] [int] NULL,
	[FacilityID] [int] NULL,
	[DedNCRValidationId] [int] NULL,
	[CRMRequestId] [int] NULL,
	[RequestNo] [varchar](50) NULL,
	[RequestDateTime] [datetime] NULL,
	[AssetId] [int] NULL,
	[AssetNo] [varchar](50) NULL,
	[Completed_Date] [datetime] NULL,
	[DeductionFigureAsset] [int] NULL,
	[Year] [int] NULL,
	[Month] [int] NULL,
	[IndicatorDetId] [int] NULL,
	[RequestStatus] [int] NULL,
	[Request_StartDate] [datetime] NULL
) ON [PRIMARY]
GO
