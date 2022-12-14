USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[SmartAssignWorkOrderAssignment]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SmartAssignWorkOrderAssignment](
	[WOAssignmentId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[BreakDownRequestId] [int] NOT NULL,
	[AssetId] [int] NOT NULL,
	[AssignedUserId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_SmartAssignWorkOrderAssignment] PRIMARY KEY CLUSTERED 
(
	[WOAssignmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SmartAssignWorkOrderAssignment] ADD  CONSTRAINT [DF_SmartAssignWorkOrderAssignment_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[SmartAssignWorkOrderAssignment]  WITH CHECK ADD  CONSTRAINT [FK_SmartAssignWorkOrderAssignment_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[SmartAssignWorkOrderAssignment] CHECK CONSTRAINT [FK_SmartAssignWorkOrderAssignment_EngAsset_AssetId]
GO
ALTER TABLE [dbo].[SmartAssignWorkOrderAssignment]  WITH CHECK ADD  CONSTRAINT [FK_SmartAssignWorkOrderAssignment_FieldBreakDownRequest_BreakDownRequestId] FOREIGN KEY([BreakDownRequestId])
REFERENCES [dbo].[FieldBreakDownRequest] ([BreakDownRequestId])
GO
ALTER TABLE [dbo].[SmartAssignWorkOrderAssignment] CHECK CONSTRAINT [FK_SmartAssignWorkOrderAssignment_FieldBreakDownRequest_BreakDownRequestId]
GO
ALTER TABLE [dbo].[SmartAssignWorkOrderAssignment]  WITH CHECK ADD  CONSTRAINT [FK_SmartAssignWorkOrderAssignment_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[SmartAssignWorkOrderAssignment] CHECK CONSTRAINT [FK_SmartAssignWorkOrderAssignment_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[SmartAssignWorkOrderAssignment]  WITH CHECK ADD  CONSTRAINT [FK_SmartAssignWorkOrderAssignment_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[SmartAssignWorkOrderAssignment] CHECK CONSTRAINT [FK_SmartAssignWorkOrderAssignment_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[SmartAssignWorkOrderAssignment]  WITH CHECK ADD  CONSTRAINT [FK_SmartAssignWorkOrderAssignment_UMUserRegistration_AssignedUserId] FOREIGN KEY([AssignedUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[SmartAssignWorkOrderAssignment] CHECK CONSTRAINT [FK_SmartAssignWorkOrderAssignment_UMUserRegistration_AssignedUserId]
GO
