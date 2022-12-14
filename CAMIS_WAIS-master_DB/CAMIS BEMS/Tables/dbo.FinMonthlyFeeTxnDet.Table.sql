USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[FinMonthlyFeeTxnDet]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FinMonthlyFeeTxnDet](
	[MonthlyFeeDetId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[MonthlyFeeId] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[VersionNo] [int] NULL,
	[BemsMSF] [numeric](18, 2) NOT NULL,
	[BemsCF] [numeric](18, 2) NULL,
	[BemsPercent] [numeric](18, 2) NULL,
	[TotalFee] [numeric](24, 2) NULL,
	[FemsMSF] [numeric](18, 2) NULL,
	[FemsCF] [numeric](18, 2) NULL,
	[FemsPercent] [numeric](18, 2) NULL,
	[IsAmdGenerated] [bit] NULL,
	[AmdUserId] [int] NULL,
	[AmdDate] [datetime] NULL,
	[AmdDateUTC] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[BemsKPIF] [numeric](24, 2) NULL,
	[Year] [int] NULL,
	[ProHawkBemsMSF] [numeric](18, 2) NULL,
 CONSTRAINT [PK_FinMonthlyFeeTxnDet] PRIMARY KEY CLUSTERED 
(
	[MonthlyFeeDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FinMonthlyFeeTxnDet] ADD  CONSTRAINT [DF_FinMonthlyFeeTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
