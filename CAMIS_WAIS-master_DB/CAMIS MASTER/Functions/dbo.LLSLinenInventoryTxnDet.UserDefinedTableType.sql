USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSLinenInventoryTxnDet]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSLinenInventoryTxnDet] AS TABLE(
	[LinenInventoryId] [int] NOT NULL,
	[LlsLinenInventoryTxnDetId] [int] NOT NULL,
	[LinenItemId] [int] NOT NULL,
	[InUse] [numeric](18, 0) NULL,
	[Shelf] [numeric](18, 0) NULL,
	[CCLSInUse] [numeric](18, 0) NULL,
	[CCLSShelf] [numeric](18, 0) NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[LLSUserAreaLocationId] [int] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL
)
GO
