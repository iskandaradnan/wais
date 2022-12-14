USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSCleanLinenRequestLinenBagTxnDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSCleanLinenRequestLinenBagTxnDet](
	[CLRLinenBagId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[CleanLinenRequestId] [int] NOT NULL,
	[CleanLinenIssueId] [int] NULL,
	[LaundryBag] [int] NOT NULL,
	[RequestedQuantity] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_LLSCleanLinenRequestLinenBagTxnDetNew] PRIMARY KEY CLUSTERED 
(
	[CLRLinenBagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LLSCleanLinenRequestLinenBagTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_LLSCleanLinenRequestLinenBagTxnDet_LLSCleanLinenIssueTxn_CleanLinenIssueIdNew] FOREIGN KEY([CleanLinenIssueId])
REFERENCES [dbo].[LLSCleanLinenIssueTxn] ([CleanLinenIssueId])
GO
ALTER TABLE [dbo].[LLSCleanLinenRequestLinenBagTxnDet] CHECK CONSTRAINT [FK_LLSCleanLinenRequestLinenBagTxnDet_LLSCleanLinenIssueTxn_CleanLinenIssueIdNew]
GO
