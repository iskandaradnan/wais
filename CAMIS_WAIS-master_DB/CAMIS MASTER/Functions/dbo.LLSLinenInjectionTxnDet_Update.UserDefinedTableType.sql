USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSLinenInjectionTxnDet_Update]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSLinenInjectionTxnDet_Update] AS TABLE(
	[QuantityInjected] [int] NULL,
	[TestReport] [nvarchar](1000) NULL,
	[LinenInjectionDetId] [int] NULL,
	[ModifiedBy] [int] NOT NULL
)
GO
