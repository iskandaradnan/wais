USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSCleanLinenIssueTxn]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSCleanLinenIssueTxn] AS TABLE(
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[CleanLinenRequestId] [int] NOT NULL,
	[CLRNo] [varchar](100) NULL,
	[CLINo] [nvarchar](50) NULL,
	[ReceivedBy1st] [int] NULL,
	[ReceivedBy2nd] [int] NULL,
	[Verifier] [int] NULL,
	[DeliveredBy] [int] NULL,
	[DeliveryDate1st] [datetime] NULL,
	[DeliveryWeight1st] [numeric](10, 2) NULL,
	[DeliveryWeight2nd] [numeric](10, 2) NULL,
	[IssuedOnTime] [nvarchar](10) NOT NULL,
	[DeliverySchedule] [nvarchar](10) NOT NULL,
	[QCTimeliness] [int] NULL,
	[ShortfallQC] [int] NULL,
	[CLIOption] [nvarchar](10) NOT NULL,
	[TotalItemIssued] [int] NULL,
	[TotalBagIssued] [int] NULL,
	[TotalItemShortfall] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[ModifiedBy] [int] NOT NULL
)
GO
