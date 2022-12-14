USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngMwoPartReplacementTxn_Mobile]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_EngMwoPartReplacementTxn_Mobile] AS TABLE(
	[PartReplacementId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[WorkOrderId] [int] NULL,
	[SparePartStockRegisterId] [int] NULL,
	[Quantity] [int] NULL,
	[Cost] [numeric](24, 2) NULL,
	[LabourCost] [numeric](24, 2) NULL,
	[StockUpdateDetId] [int] NULL,
	[ActualQuantityinStockUpdate] [int] NULL,
	[UserId] [int] NULL,
	[SparePartRunningHours] [numeric](24, 2) NULL,
	[PartReplacementCost] [numeric](24, 2) NULL,
	[MobileGuid] [nvarchar](500) NULL,
	[StockType] [int] NULL,
	[IsPartReplacedCost] [int] NULL
)
GO
