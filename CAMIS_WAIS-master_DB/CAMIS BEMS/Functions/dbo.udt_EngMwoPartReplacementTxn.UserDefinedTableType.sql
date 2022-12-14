USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngMwoPartReplacementTxn]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[udt_EngMwoPartReplacementTxn] AS TABLE(
	[PartReplacementId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[WorkOrderId] [int] NULL,
	[SparePartStockRegisterId] [int] NULL,
	[Quantity] [int] NULL,
	[Cost] [numeric](24, 2) NULL,
	[TotalPartsCost] [numeric](24, 2) NULL,
	[LabourCost] [numeric](24, 2) NULL,
	[StockUpdateDetId] [int] NULL,
	[ActualQuantityinStockUpdate] [int] NULL,
	[UserId] [int] NULL,
	[AverageUsageHours] [nvarchar](100) NULL,
	[SparePartRunningHours] [numeric](24, 2) NULL,
	[IsPartReplacedCost] [int] NULL,
	[PartReplacementCost] [numeric](24, 2) NULL,
	[EstimatedLifeSpan] [int] NULL,
	[LifeSpanExpiryDate] [datetime] NULL,
	[StockType] [int] NULL
)
GO
