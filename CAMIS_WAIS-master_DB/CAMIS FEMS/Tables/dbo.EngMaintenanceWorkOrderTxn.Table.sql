USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngMaintenanceWorkOrderTxn]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngMaintenanceWorkOrderTxn](
	[WorkOrderId] [int] IDENTITY(1,1) NOT NULL,
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
	[WorkOrderStatus] [int] NULL,
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
	[WorkGroupType] [int] NULL,
 CONSTRAINT [PK_EngMaintenanceWorkOrderTxn] PRIMARY KEY CLUSTERED 
(
	[WorkOrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn] ADD  CONSTRAINT [DF_EngMaintenanceWorkOrderTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn] ADD  CONSTRAINT [DF_MIGRATEDDATA]  DEFAULT ((0)) FOR [MIGRATED_DATA]
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMaintenanceWorkOrderTxn_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn] CHECK CONSTRAINT [FK_EngMaintenanceWorkOrderTxn_EngAsset_AssetId]
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMaintenanceWorkOrderTxn_EngPlannerHistoryTxn_PlannerHistoryId] FOREIGN KEY([PlannerHistoryId])
REFERENCES [dbo].[EngPlannerTxnHistory] ([PlannerHistoryId])
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn] CHECK CONSTRAINT [FK_EngMaintenanceWorkOrderTxn_EngPlannerHistoryTxn_PlannerHistoryId]
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMaintenanceWorkOrderTxn_EngPlannerTxn_PlannerId] FOREIGN KEY([PlannerId])
REFERENCES [dbo].[EngPlannerTxn] ([PlannerId])
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn] CHECK CONSTRAINT [FK_EngMaintenanceWorkOrderTxn_EngPlannerTxn_PlannerId]
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMaintenanceWorkOrderTxn_FieldBreakDownRequest_BreakDownRequestId] FOREIGN KEY([BreakDownRequestId])
REFERENCES [dbo].[FieldBreakDownRequest] ([BreakDownRequestId])
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn] CHECK CONSTRAINT [FK_EngMaintenanceWorkOrderTxn_FieldBreakDownRequest_BreakDownRequestId]
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMaintenanceWorkOrderTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn] CHECK CONSTRAINT [FK_EngMaintenanceWorkOrderTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMaintenanceWorkOrderTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn] CHECK CONSTRAINT [FK_EngMaintenanceWorkOrderTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMaintenanceWorkOrderTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn] CHECK CONSTRAINT [FK_EngMaintenanceWorkOrderTxn_MstService_ServiceId]
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMaintenanceWorkOrderTxn_SmartAssignWorkOrderAssignment_WOAssignmentId] FOREIGN KEY([WOAssignmentId])
REFERENCES [dbo].[SmartAssignWorkOrderAssignment] ([WOAssignmentId])
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn] CHECK CONSTRAINT [FK_EngMaintenanceWorkOrderTxn_SmartAssignWorkOrderAssignment_WOAssignmentId]
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMaintenanceWorkOrderTxn_UMUserRegistration_EngineerStaffId] FOREIGN KEY([EngineerUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn] CHECK CONSTRAINT [FK_EngMaintenanceWorkOrderTxn_UMUserRegistration_EngineerStaffId]
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMaintenanceWorkOrderTxn_UMUserRegistration_EngineerUserId] FOREIGN KEY([EngineerUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn] CHECK CONSTRAINT [FK_EngMaintenanceWorkOrderTxn_UMUserRegistration_EngineerUserId]
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngMaintenanceWorkOrderTxn_UMUserRegistration_RequestorUserId] FOREIGN KEY([RequestorUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[EngMaintenanceWorkOrderTxn] CHECK CONSTRAINT [FK_EngMaintenanceWorkOrderTxn_UMUserRegistration_RequestorUserId]
GO
