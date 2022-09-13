USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngSparePartPurchaseRequest]    Script Date: 20-09-2021 16:50:19 ******/
CREATE TYPE [dbo].[udt_EngSparePartPurchaseRequest] AS TABLE(
	[SparePartsRequsetId] [int] NULL,
	[SparePartsId] [int] NULL,
	[WorkOrderId] [int] NULL,
	[Quantity] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[UserId] [int] NULL
)
GO
