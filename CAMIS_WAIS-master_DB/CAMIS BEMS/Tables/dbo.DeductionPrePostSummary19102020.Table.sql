USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[DeductionPrePostSummary19102020]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeductionPrePostSummary19102020](
	[ServiceType] [varchar](4) NOT NULL,
	[Year] [int] NULL,
	[Month] [int] NULL,
	[MonthlyServiceFee] [numeric](24, 2) NULL,
	[IndicatorNo] [nvarchar](25) NOT NULL,
	[IndicatorName] [nvarchar](250) NOT NULL,
	[TransactionDemeritPoint] [numeric](8, 2) NULL,
	[NcrDemeritPoint] [numeric](6, 2) NULL,
	[PreTotalDemeritsPoints] [numeric](9, 2) NULL,
	[PostTransactionDemeritPoint] [numeric](8, 2) NULL,
	[PostNcrDemeritPoint] [numeric](8, 2) NULL,
	[PostTotalDemeritsPoints] [numeric](9, 2) NULL,
	[DeductionValue] [numeric](24, 2) NULL,
	[NCRDeductionValue] [numeric](18, 5) NULL,
	[PreTotalDeductionValue] [numeric](28, 5) NULL,
	[PostDeductionValue] [numeric](13, 2) NULL,
	[PostNCRDeductionValue] [numeric](18, 5) NULL,
	[PostTotalDeductionValue] [numeric](19, 5) NULL,
	[PreDeduction_%] [numeric](18, 2) NULL,
	[PostDeduction_%] [numeric](18, 2) NULL,
	[FEE] [int] NULL,
	[IndicatorDetId] [int] NULL
) ON [PRIMARY]
GO
