USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSLinenAdjustmentTxnDet_Update]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSLinenAdjustmentTxnDet_Update] AS TABLE(
	[Justification] [nvarchar](1000) NULL,
	[LinenAdjustmentDetId] [int] NULL,
	[ModifiedBy] [int] NOT NULL
)
GO
