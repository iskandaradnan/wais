USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngSparePartPurchaseRequest]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_EngSparePartPurchaseRequest] AS TABLE(
	[SparePartsRequsetId] [int] NULL,
	[SparePartsId] [int] NULL,
	[WorkOrderId] [int] NULL,
	[Quantity] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[UserId] [int] NULL
)
GO
