USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngMWORemarkChange]    Script Date: 20-09-2021 16:50:19 ******/
CREATE TYPE [dbo].[udt_EngMWORemarkChange] AS TABLE(
	[WorkOrderId] [int] NULL,
	[MaintenanceDetails] [int] NULL
)
GO
