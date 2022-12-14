USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[SmartAssignPorteringAssignment]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SmartAssignPorteringAssignment](
	[PorteringAssignmentId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[PorteringId] [int] NOT NULL,
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
 CONSTRAINT [PK_SmartAssignPorteringAssignment] PRIMARY KEY CLUSTERED 
(
	[PorteringAssignmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SmartAssignPorteringAssignment] ADD  CONSTRAINT [DF_SmartAssignPorteringAssignment_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[SmartAssignPorteringAssignment]  WITH CHECK ADD  CONSTRAINT [FK_SmartAssignPorteringAssignment_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[SmartAssignPorteringAssignment] CHECK CONSTRAINT [FK_SmartAssignPorteringAssignment_EngAsset_AssetId]
GO
ALTER TABLE [dbo].[SmartAssignPorteringAssignment]  WITH CHECK ADD  CONSTRAINT [FK_SmartAssignPorteringAssignment_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[SmartAssignPorteringAssignment] CHECK CONSTRAINT [FK_SmartAssignPorteringAssignment_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[SmartAssignPorteringAssignment]  WITH CHECK ADD  CONSTRAINT [FK_SmartAssignPorteringAssignment_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[SmartAssignPorteringAssignment] CHECK CONSTRAINT [FK_SmartAssignPorteringAssignment_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[SmartAssignPorteringAssignment]  WITH CHECK ADD  CONSTRAINT [FK_SmartAssignPorteringAssignment_PorteringTransaction_PorteringId] FOREIGN KEY([PorteringId])
REFERENCES [dbo].[PorteringTransaction] ([PorteringId])
GO
ALTER TABLE [dbo].[SmartAssignPorteringAssignment] CHECK CONSTRAINT [FK_SmartAssignPorteringAssignment_PorteringTransaction_PorteringId]
GO
ALTER TABLE [dbo].[SmartAssignPorteringAssignment]  WITH CHECK ADD  CONSTRAINT [FK_SmartAssignPorteringAssignment_UMUserRegistration_AssignedStaffId] FOREIGN KEY([AssignedUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[SmartAssignPorteringAssignment] CHECK CONSTRAINT [FK_SmartAssignPorteringAssignment_UMUserRegistration_AssignedStaffId]
GO
ALTER TABLE [dbo].[SmartAssignPorteringAssignment]  WITH CHECK ADD  CONSTRAINT [FK_SmartAssignPorteringAssignment_UMUserRegistration_AssignedUserId] FOREIGN KEY([AssignedUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[SmartAssignPorteringAssignment] CHECK CONSTRAINT [FK_SmartAssignPorteringAssignment_UMUserRegistration_AssignedUserId]
GO
