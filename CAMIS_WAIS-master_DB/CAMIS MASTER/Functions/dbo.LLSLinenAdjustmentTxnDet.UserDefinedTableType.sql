USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSLinenAdjustmentTxnDet]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSLinenAdjustmentTxnDet] AS TABLE(
	[LinenAdjustmentId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[LinenItemId] [int] NOT NULL,
	[ActualQuantity] [int] NOT NULL,
	[StoreBalance] [int] NULL,
	[AdjustQuantity] [int] NULL,
	[Justification] [nvarchar](150) NULL,
	[CreatedBy] [int] NOT NULL
)
GO
