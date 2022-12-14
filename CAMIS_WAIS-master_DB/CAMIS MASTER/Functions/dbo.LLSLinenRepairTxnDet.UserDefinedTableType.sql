USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSLinenRepairTxnDet]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSLinenRepairTxnDet] AS TABLE(
	[LinenRepairId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[LinenItemId] [int] NULL,
	[RepairQuantity] [numeric](24, 2) NULL,
	[RepairCompletedQuantity] [numeric](24, 2) NULL,
	[BalanceRepairQuantity] [numeric](24, 2) NULL,
	[DescriptionOfProblem] [varchar](50) NULL,
	[CreatedBy] [int] NOT NULL
)
GO
