USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSCleanLinenDespatchTxnDetUpdate]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSCleanLinenDespatchTxnDetUpdate] AS TABLE(
	[CleanLinenDespatchDetId] [int] NULL,
	[ReceivedQuantity] [int] NULL,
	[DespatchedQuantity] [int] NULL,
	[Remarks] [nvarchar](1000) NULL,
	[ModifiedBy] [int] NOT NULL
)
GO
