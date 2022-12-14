USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSCleanLinenIssueLinenBagTxnDet]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSCleanLinenIssueLinenBagTxnDet] AS TABLE(
	[CleanLinenIssueId] [int] NULL,
	[LaundryBag] [int] NOT NULL,
	[IssuedQuantity] [numeric](24, 2) NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL
)
GO
