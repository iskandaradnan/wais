USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngMWOStatusChange]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_EngMWOStatusChange] AS TABLE(
	[WorkOrderId] [int] NULL,
	[WorkOrderStatus] [int] NULL
)
GO
