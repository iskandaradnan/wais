USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_FinMonthlyFeeTxnDet]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_FinMonthlyFeeTxnDet] AS TABLE(
	[MonthlyFeeDetId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[Month] [int] NULL,
	[VersionNo] [int] NULL,
	[BemsMSF] [numeric](24, 2) NULL,
	[BemsCF] [numeric](24, 2) NULL,
	[BemsPercent] [numeric](24, 2) NULL,
	[TotalFee] [numeric](24, 2) NULL,
	[FemsMSF] [numeric](24, 2) NULL,
	[FemsCF] [numeric](24, 2) NULL,
	[FemsPercent] [numeric](24, 2) NULL,
	[IsAmdGenerated] [bit] NULL,
	[AmdUserId] [int] NULL,
	[AmdDate] [datetime] NULL,
	[AmdDateUTC] [datetime] NULL
)
GO
