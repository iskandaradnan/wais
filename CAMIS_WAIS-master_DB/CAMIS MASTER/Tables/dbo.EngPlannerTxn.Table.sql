USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngPlannerTxn]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngPlannerTxn](
	[PlannerId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[WorkGroupId] [int] NOT NULL,
	[TypeOfPlanner] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[UserAreaId] [int] NULL,
	[AssigneeCompanyUserId] [int] NOT NULL,
	[FacilityUserId] [int] NULL,
	[AssetClassificationId] [int] NULL,
	[AssetTypeCodeId] [int] NULL,
	[AssetId] [int] NULL,
	[StandardTaskDetId] [int] NULL,
	[WarrantyType] [int] NOT NULL,
	[ContactNo] [nvarchar](30) NULL,
	[EngineerUserId] [int] NULL,
	[ScheduleType] [int] NULL,
	[Month] [nvarchar](200) NULL,
	[Date] [nvarchar](100) NULL,
	[Week] [nvarchar](100) NULL,
	[Day] [nvarchar](100) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[Status] [int] NULL,
	[WorkOrderType] [int] NOT NULL,
	[GenerationType] [int] NULL,
	[FirstDate] [datetime] NULL,
	[NextDate] [datetime] NULL,
	[LastDate] [datetime] NULL,
	[IntervalInWeeks] [numeric](24, 2) NULL,
 CONSTRAINT [PK_EngPlannerTxn] PRIMARY KEY CLUSTERED 
(
	[PlannerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngPlannerTxn] ADD  CONSTRAINT [DF_EngPlannerTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngPlannerTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngPlannerTxn_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[EngPlannerTxn] CHECK CONSTRAINT [FK_EngPlannerTxn_EngAsset_AssetId]
GO
ALTER TABLE [dbo].[EngPlannerTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngPlannerTxn_EngAssetTypeCode_AssetTypeCodeId] FOREIGN KEY([AssetTypeCodeId])
REFERENCES [dbo].[EngAssetTypeCode] ([AssetTypeCodeId])
GO
ALTER TABLE [dbo].[EngPlannerTxn] CHECK CONSTRAINT [FK_EngPlannerTxn_EngAssetTypeCode_AssetTypeCodeId]
GO
ALTER TABLE [dbo].[EngPlannerTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngPlannerTxn_EngAssetWorkGroup_WorkGroupId] FOREIGN KEY([WorkGroupId])
REFERENCES [dbo].[EngAssetWorkGroup] ([WorkGroupId])
GO
ALTER TABLE [dbo].[EngPlannerTxn] CHECK CONSTRAINT [FK_EngPlannerTxn_EngAssetWorkGroup_WorkGroupId]
GO
ALTER TABLE [dbo].[EngPlannerTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngPlannerTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngPlannerTxn] CHECK CONSTRAINT [FK_EngPlannerTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngPlannerTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngPlannerTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngPlannerTxn] CHECK CONSTRAINT [FK_EngPlannerTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngPlannerTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngPlannerTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngPlannerTxn] CHECK CONSTRAINT [FK_EngPlannerTxn_MstService_ServiceId]
GO
ALTER TABLE [dbo].[EngPlannerTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngPlannerTxn_UMUserRegistration_AssigneeCompanyUserId] FOREIGN KEY([AssigneeCompanyUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[EngPlannerTxn] CHECK CONSTRAINT [FK_EngPlannerTxn_UMUserRegistration_AssigneeCompanyUserId]
GO
ALTER TABLE [dbo].[EngPlannerTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngPlannerTxn_UMUserRegistration_EngineerUserId] FOREIGN KEY([EngineerUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[EngPlannerTxn] CHECK CONSTRAINT [FK_EngPlannerTxn_UMUserRegistration_EngineerUserId]
GO
ALTER TABLE [dbo].[EngPlannerTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngPlannerTxn_UMUserRegistration_FacilityUserId] FOREIGN KEY([FacilityUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[EngPlannerTxn] CHECK CONSTRAINT [FK_EngPlannerTxn_UMUserRegistration_FacilityUserId]
GO
