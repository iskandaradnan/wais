USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[DedGenerationTxnDet15092020]    Script Date: 20-09-2021 17:02:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DedGenerationTxnDet15092020](
	[DedGenerationDetId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[DedGenerationId] [int] NULL,
	[IndicatorDetId] [int] NOT NULL,
	[TotalParameter] [numeric](15, 2) NULL,
	[DeductionValue] [numeric](24, 2) NULL,
	[DeductionPercentage] [numeric](6, 2) NULL,
	[TransactionDemeritPoint] [numeric](8, 2) NULL,
	[NcrDemeritPoint] [numeric](6, 2) NULL,
	[SubParameterDetId] [int] NULL,
	[PostTransactionDemeritPoint] [numeric](8, 2) NULL,
	[PostNcrDemeritPoint] [numeric](8, 2) NULL,
	[Remarks] [nvarchar](500) NULL,
	[keyIndicatorValue] [numeric](24, 2) NULL,
	[Ringittequivalent] [numeric](24, 2) NULL,
	[GearingRatio] [numeric](24, 2) NULL,
	[PostDeductionValue] [numeric](13, 2) NULL,
	[PostDeductionPercentage] [numeric](5, 2) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[YEAR] [int] NULL,
	[MONTH] [int] NULL,
	[NCRDeductionValue] [numeric](18, 2) NULL,
	[PostNCRDeductionValue] [numeric](18, 2) NULL
) ON [PRIMARY]
GO
