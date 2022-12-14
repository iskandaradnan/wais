USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngMaintenanceWorkOrderTxn_Mobile]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[udt_EngMaintenanceWorkOrderTxn_Mobile] AS TABLE(
	[WorkOrderId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[AssetId] [int] NULL,
	[MaintenanceDetails] [nvarchar](1000) NULL,
	[MaintenanceWorkCategory] [int] NULL,
	[MaintenanceWorkType] [int] NULL,
	[TypeOfWorkOrder] [int] NULL,
	[QRCode] [varbinary](1000) NULL,
	[MaintenanceWorkDateTime] [datetime] NULL,
	[TargetDateTime] [datetime] NULL,
	[EngineerStaffId] [int] NULL,
	[RequestorStaffId] [int] NULL,
	[WorkOrderPriority] [int] NULL,
	[Image1FMDocumentId] [int] NULL,
	[Image2FMDocumentId] [int] NULL,
	[Image3FMDocumentId] [int] NULL,
	[PlannerId] [int] NULL,
	[WorkGroupId] [int] NULL,
	[WorkOrderStatus] [int] NULL,
	[PlannerHistoryId] [int] NULL,
	[Remarks] [nvarchar](1000) NULL,
	[BreakDownRequestId] [int] NULL,
	[WOAssignmentId] [int] NULL,
	[UserAreaId] [int] NULL,
	[UserLocationId] [int] NULL,
	[StandardTaskDetId] [int] NULL,
	[UserId] [int] NULL,
	[MobileGuid] [nvarchar](max) NULL,
	[WOImage] [varbinary](max) NULL,
	[WOVideo] [varbinary](max) NULL
)
GO
