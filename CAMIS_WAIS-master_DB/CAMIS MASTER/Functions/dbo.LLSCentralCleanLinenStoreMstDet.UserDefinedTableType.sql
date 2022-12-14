USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSCentralCleanLinenStoreMstDet]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSCentralCleanLinenStoreMstDet] AS TABLE(
	[CCLSId] [int] NOT NULL,
	[LinenItemId] [int] NOT NULL,
	[StoreBalance] [numeric](24, 2) NULL,
	[StockLevel] [numeric](24, 2) NULL,
	[ReorderQuantity] [numeric](24, 2) NULL,
	[Par1] [numeric](24, 2) NULL,
	[Par2] [numeric](24, 2) NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[CreatedBy] [int] NOT NULL
)
GO
