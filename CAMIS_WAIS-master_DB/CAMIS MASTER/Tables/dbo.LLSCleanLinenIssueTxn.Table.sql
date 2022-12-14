USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSCleanLinenIssueTxn]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSCleanLinenIssueTxn](
	[CleanLinenIssueId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[CleanLinenRequestId] [int] NOT NULL,
	[CLINo] [nvarchar](50) NULL,
	[DeliveryDate1st] [datetime] NULL,
	[ReceivedBy1st] [int] NULL,
	[DeliveryDate2nd] [datetime] NULL,
	[ReceivedBy2nd] [int] NULL,
	[Verifier] [int] NULL,
	[DeliveredBy] [int] NULL,
	[DeliveryWeight1st] [numeric](10, 2) NULL,
	[DeliveryWeight2nd] [numeric](10, 2) NULL,
	[IssuedOnTime] [nvarchar](10) NOT NULL,
	[DeliverySchedule] [int] NULL,
	[QCTimeliness] [int] NULL,
	[ShortfallQC] [int] NULL,
	[CLIOption] [nvarchar](10) NOT NULL,
	[TotalItemIssued] [int] NULL,
	[TotalBagIssued] [int] NULL,
	[TotalItemShortfall] [int] NOT NULL,
	[TotalBagShortfall] [int] NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[CLRNo] [varchar](100) NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_LLSCleanLinenIssuesTxnNew] PRIMARY KEY CLUSTERED 
(
	[CleanLinenIssueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LLSCleanLinenIssueTxn] ADD  CONSTRAINT [DF_TotalItemShortfall]  DEFAULT ((0)) FOR [TotalItemShortfall]
GO
ALTER TABLE [dbo].[LLSCleanLinenIssueTxn] ADD  CONSTRAINT [DF_TotalBagShortfall]  DEFAULT ((0)) FOR [TotalBagShortfall]
GO
ALTER TABLE [dbo].[LLSCleanLinenIssueTxn] ADD  CONSTRAINT [DF_LLSCleanLinenIssueTxn_GuIdNew]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[LLSCleanLinenIssueTxn]  WITH CHECK ADD  CONSTRAINT [FK_LLSCleanLinenIssueTxn_LLSCleanLinenRequestTxnNew] FOREIGN KEY([CleanLinenRequestId])
REFERENCES [dbo].[LLSCleanLinenRequestTxn] ([CleanLinenRequestId])
GO
ALTER TABLE [dbo].[LLSCleanLinenIssueTxn] CHECK CONSTRAINT [FK_LLSCleanLinenIssueTxn_LLSCleanLinenRequestTxnNew]
GO
