USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSLinenRepairTxnDet_Update]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSLinenRepairTxnDet_Update] AS TABLE(
	[LinenRepairDetId] [int] NULL,
	[RepairCompletedQuantity] [numeric](24, 2) NULL,
	[RepairQuantity] [numeric](24, 2) NULL,
	[DescriptionOfProblem] [varchar](50) NULL,
	[LinenRepairId] [int] NULL,
	[ModifiedBy] [int] NOT NULL
)
GO
