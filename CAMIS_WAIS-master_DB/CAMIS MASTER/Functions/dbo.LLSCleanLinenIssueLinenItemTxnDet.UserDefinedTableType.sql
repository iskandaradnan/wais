USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSCleanLinenIssueLinenItemTxnDet]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSCleanLinenIssueLinenItemTxnDet] AS TABLE(
	[CleanLinenIssueId] [int] NULL,
	[LinenitemId] [int] NOT NULL,
	[RequestedQuantity] [int] NULL,
	[DeliveryIssuedQty1st] [numeric](24, 2) NULL,
	[DeliveryIssuedQty2nd] [numeric](24, 2) NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL
)
GO
