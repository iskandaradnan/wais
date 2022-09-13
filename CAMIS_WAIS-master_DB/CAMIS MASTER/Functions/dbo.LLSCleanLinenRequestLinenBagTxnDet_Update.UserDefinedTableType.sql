USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSCleanLinenRequestLinenBagTxnDet_Update]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSCleanLinenRequestLinenBagTxnDet_Update] AS TABLE(
	[CLRLinenBagId] [int] NULL,
	[RequestedQuantity] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[CleanLinenRequestId] [int] NULL,
	[ModifiedBy] [int] NOT NULL
)
GO
