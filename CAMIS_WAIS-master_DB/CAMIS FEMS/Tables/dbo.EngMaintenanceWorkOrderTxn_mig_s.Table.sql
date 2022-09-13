USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngMaintenanceWorkOrderTxn_mig_s]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngMaintenanceWorkOrderTxn_mig_s](
	[WorkOrderId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[AssetId] [int] NULL,
	[MaintenanceWorkNo] [nvarchar](100) NOT NULL,
	[MaintenanceDetails] [nvarchar](500) NOT NULL,
	[MaintenanceWorkCategory] [int] NOT NULL,
	[MaintenanceWorkType] [int] NULL,
	[TypeOfWorkOrder] [int] NOT NULL,
	[QRCode] [varbinary](max) NULL,
	[MaintenanceWorkDateTime] [datetime] NULL,
	[TargetDateTime] [datetime] NULL,
	[EngineerUserId] [int] NULL,
	[RequestorUserId] [int] NULL,
	[WorkOrderPriority] [int] NULL,
	[Image1FMDocumentId] [int] NULL,
	[Image2FMDocumentId] [int] NULL,
	[Image3FMDocumentId] [int] NULL,
	[PlannerId] [int] NULL,
	[WorkGroupId] [int] NULL,
	[WorkOrderStatus] [int] NOT NULL,
	[PlannerHistoryId] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[BreakDownRequestId] [int] NULL,
	[WOAssignmentId] [int] NULL,
	[UserAreaId] [int] NULL,
	[UserLocationId] [int] NULL,
	[StandardTaskDetId] [int] NULL,
	[AssignedUserId] [int] NULL,
	[AssigneeLovId] [int] NULL,
	[RescheduleRemarks] [nvarchar](500) NULL,
	[PreviousTargetDateTime] [datetime] NULL,
	[MobileGuid] [nvarchar](max) NULL,
	[Field1] [nvarchar](500) NULL,
	[Field2] [nvarchar](500) NULL,
	[Field3] [nvarchar](500) NULL,
	[Field4] [nvarchar](500) NULL,
	[Field5] [nvarchar](500) NULL,
	[Field6] [nvarchar](500) NULL,
	[Field7] [nvarchar](500) NULL,
	[Field8] [nvarchar](500) NULL,
	[Field9] [nvarchar](500) NULL,
	[Field10] [nvarchar](500) NULL,
	[WOImage] [varbinary](max) NULL,
	[WOVideo] [varbinary](max) NULL,
	[Isdelete] [int] NULL,
	[MIGRATED_DATA] [int] NULL,
	[Isbis] [int] NULL,
	[Module] [int] NULL,
	[WorkOrderCategoryType] [int] NULL,
	[WorkGroupType] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
