USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSCleanLinenRequestLinenItemTxnDet_Update]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSCleanLinenRequestLinenItemTxnDet_Update] AS TABLE(
	[CLRLinenItemId] [int] NULL,
	[RequestedQuantity] [int] NULL,
	[CleanLinenRequestId] [int] NULL,
	[ModifiedBy] [int] NOT NULL
)
GO
