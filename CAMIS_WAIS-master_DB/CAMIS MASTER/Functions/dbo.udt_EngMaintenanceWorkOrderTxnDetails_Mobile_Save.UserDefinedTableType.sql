USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngMaintenanceWorkOrderTxnDetails_Mobile_Save]    Script Date: 20-09-2021 16:50:19 ******/
CREATE TYPE [dbo].[udt_EngMaintenanceWorkOrderTxnDetails_Mobile_Save] AS TABLE(
	[WorkOrderId] [int] NULL,
	[Remarks] [nvarchar](1000) NULL
)
GO
