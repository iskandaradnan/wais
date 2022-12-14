USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSCleanLinenIssueLinenItemTxnDet_Update]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSCleanLinenIssueLinenItemTxnDet_Update] AS TABLE(
	[CLILinenItemId] [int] NULL,
	[CleanLinenIssueId] [int] NULL,
	[DeliveryIssuedQty1st] [numeric](24, 2) NULL,
	[DeliveryIssuedQty2nd] [numeric](24, 2) NULL,
	[Remarks] [nvarchar](1000) NULL,
	[ModifiedBy] [int] NOT NULL
)
GO
