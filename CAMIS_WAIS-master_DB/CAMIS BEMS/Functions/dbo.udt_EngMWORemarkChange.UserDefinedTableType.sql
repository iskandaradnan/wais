USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngMWORemarkChange]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[udt_EngMWORemarkChange] AS TABLE(
	[WorkOrderId] [int] NULL,
	[MaintenanceDetails] [int] NULL
)
GO
