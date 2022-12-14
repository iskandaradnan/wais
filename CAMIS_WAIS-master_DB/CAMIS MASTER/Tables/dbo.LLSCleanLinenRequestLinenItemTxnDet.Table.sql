USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSCleanLinenRequestLinenItemTxnDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSCleanLinenRequestLinenItemTxnDet](
	[CLRLinenItemId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[CleanLinenRequestId] [int] NOT NULL,
	[CleanLinenIssueId] [int] NULL,
	[LinenItemId] [int] NOT NULL,
	[LinenItemId_test] [int] NULL,
	[BalanceOnShelf] [int] NULL,
	[RequestedQuantity] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [int] NULL,
	[unqkey] [varchar](500) NULL,
 CONSTRAINT [PK_LLSCleanLinenRequestLinenItemTxnDetNew] PRIMARY KEY CLUSTERED 
(
	[CLRLinenItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
