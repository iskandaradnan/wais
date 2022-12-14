USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_MstDedIndicatorDet]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_MstDedIndicatorDet] AS TABLE(
	[IndicatorDetId] [int] NULL,
	[IndicatorId] [int] NULL,
	[IndicatorNo] [nvarchar](50) NULL,
	[IndicatorName] [nvarchar](500) NULL,
	[IndicatorDesc] [nvarchar](1000) NULL,
	[IndicatorType] [int] NULL,
	[Weightage] [numeric](24, 2) NULL,
	[Frequency] [int] NULL
)
GO
