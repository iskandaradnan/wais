USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSCleanLinenRequestLinenItemTxnDet]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSCleanLinenRequestLinenItemTxnDet] AS TABLE(
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[CleanLinenRequestId] [int] NOT NULL,
	[CleanLinenIssueId] [int] NULL,
	[LinenItemId] [int] NOT NULL,
	[BalanceOnShelf] [int] NULL,
	[RequestedQuantity] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL
)
GO
