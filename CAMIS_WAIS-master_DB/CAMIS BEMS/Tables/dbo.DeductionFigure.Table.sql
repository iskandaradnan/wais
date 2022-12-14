USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[DeductionFigure]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeductionFigure](
	[IndicatorName] [varchar](3) NOT NULL,
	[IndicatorId] [int] NOT NULL,
	[ServiceArea] [varchar](20) NOT NULL,
	[PerformanceIndicators] [varchar](139) NOT NULL,
	[FrequencyOfDeduction] [varchar](9) NOT NULL,
	[EquipmentPriceCategory] [varchar](15) NOT NULL,
	[DeductionRM] [numeric](7, 2) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL
) ON [PRIMARY]
GO
