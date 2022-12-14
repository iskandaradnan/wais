USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSCleanLinenDespatchTxn]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSCleanLinenDespatchTxn] AS TABLE(
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[DocumentNo] [nvarchar](50) NOT NULL,
	[DateReceived] [datetime] NOT NULL,
	[DespatchedFrom] [int] NULL,
	[ReceivedBy] [int] NOT NULL,
	[NoOfPackages] [numeric](24, 2) NULL,
	[TotalWeightKg] [numeric](24, 2) NOT NULL,
	[TotalReceivedPcs] [int] NULL,
	[ModifiedBy] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL
)
GO
