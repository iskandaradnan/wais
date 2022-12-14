USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSCleanLinenDespatchTxnDet]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSCleanLinenDespatchTxnDet] AS TABLE(
	[CleanLinenDespatchId] [int] NOT NULL,
	[LinenItemId] [int] NOT NULL,
	[DespatchedQuantity] [numeric](24, 2) NOT NULL,
	[ReceivedQuantity] [numeric](24, 2) NOT NULL,
	[Variance] [numeric](24, 2) NULL,
	[Remarks] [nvarchar](500) NULL,
	[LinenDescription] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL
)
GO
