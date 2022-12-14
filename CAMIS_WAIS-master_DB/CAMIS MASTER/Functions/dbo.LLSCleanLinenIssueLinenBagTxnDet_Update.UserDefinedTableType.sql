USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSCleanLinenIssueLinenBagTxnDet_Update]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSCleanLinenIssueLinenBagTxnDet_Update] AS TABLE(
	[CLILinenBagId] [int] NULL,
	[CleanLinenIssueId] [int] NULL,
	[LaundryBag] [int] NULL,
	[IssuedQuantity] [numeric](24, 2) NULL,
	[Remarks] [nvarchar](1000) NULL,
	[ModifiedBy] [int] NOT NULL
)
GO
