USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[DedTransactionMappingTxnDet12072021]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DedTransactionMappingTxnDet12072021](
	[DedTxnMappingDetId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[DedTxnMappingId] [int] NULL,
	[Date] [datetime] NULL,
	[DocumentNo] [nvarchar](100) NULL,
	[Details] [nvarchar](1000) NULL,
	[AssetNo] [nvarchar](100) NULL,
	[AssetDescription] [nvarchar](500) NULL,
	[ScreenName] [nvarchar](500) NULL,
	[DemeritPoint] [int] NULL,
	[FinalDemeritPoint] [int] NULL,
	[DisputedDemeritPoints] [int] NULL,
	[IsValid] [bit] NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[DeductionValue] [int] NULL,
	[FinalDeductionValue] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[Year] [int] NULL,
	[Month] [int] NULL,
	[IndicatorDetId] [int] NULL,
	[IndicatorName] [varchar](20) NULL,
	[Flag] [varchar](50) NULL,
	[UptimeAchieved] [numeric](18, 2) NULL,
	[PurchaseCost] [int] NULL,
	[DeductionFigureperAsset] [numeric](18, 2) NULL,
	[NameofReport] [varchar](4000) NULL,
	[SubmissionDueDate] [datetime] NULL,
	[DateSubmitted] [datetime] NULL,
	[Frequency] [varchar](50) NULL,
	[ScheduledDate] [datetime] NULL,
	[ReScheduledDate] [datetime] NULL,
	[StartDate] [datetime] NULL,
	[TypeCode] [varchar](50) NULL,
	[TRPIUptime] [numeric](18, 2) NULL,
	[FileName] [nvarchar](250) NULL,
	[RemarksJOHN] [nvarchar](1000) NULL,
	[PostDeductionValue] [numeric](18, 2) NULL,
	[ReportID] [int] NULL,
	[LastDateOf7thDay] [datetime] NULL,
	[CompletedDate] [datetime] NULL
) ON [PRIMARY]
GO
