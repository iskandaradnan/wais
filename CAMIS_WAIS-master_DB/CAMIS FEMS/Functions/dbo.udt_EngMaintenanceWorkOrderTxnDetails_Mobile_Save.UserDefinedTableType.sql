USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngMaintenanceWorkOrderTxnDetails_Mobile_Save]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_EngMaintenanceWorkOrderTxnDetails_Mobile_Save] AS TABLE(
	[WorkOrderId] [int] NULL,
	[Remarks] [nvarchar](1000) NULL
)
GO
