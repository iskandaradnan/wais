USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngMWORemarkChange]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_EngMWORemarkChange] AS TABLE(
	[WorkOrderId] [int] NULL,
	[MaintenanceDetails] [int] NULL
)
GO
