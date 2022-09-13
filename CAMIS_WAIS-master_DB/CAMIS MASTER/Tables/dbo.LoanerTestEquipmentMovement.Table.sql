USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LoanerTestEquipmentMovement]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoanerTestEquipmentMovement](
	[TestEquipmentMovementId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
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
 CONSTRAINT [PK_LoanerTestEquipmentMovement] PRIMARY KEY CLUSTERED 
(
	[TestEquipmentMovementId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LoanerTestEquipmentMovement] ADD  CONSTRAINT [DF_LoanerTestEquipmentMovement_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[LoanerTestEquipmentMovement]  WITH CHECK ADD  CONSTRAINT [FK_LoanerTestEquipmentMovement_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[LoanerTestEquipmentMovement] CHECK CONSTRAINT [FK_LoanerTestEquipmentMovement_EngAsset_AssetId]
GO
ALTER TABLE [dbo].[LoanerTestEquipmentMovement]  WITH CHECK ADD  CONSTRAINT [FK_LoanerTestEquipmentMovement_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[LoanerTestEquipmentMovement] CHECK CONSTRAINT [FK_LoanerTestEquipmentMovement_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[LoanerTestEquipmentMovement]  WITH CHECK ADD  CONSTRAINT [FK_LoanerTestEquipmentMovement_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[LoanerTestEquipmentMovement] CHECK CONSTRAINT [FK_LoanerTestEquipmentMovement_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[LoanerTestEquipmentMovement]  WITH CHECK ADD  CONSTRAINT [FK_LoanerTestEquipmentMovement_UMUserRegistration_AssignedUserId] FOREIGN KEY([AssignedUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[LoanerTestEquipmentMovement] CHECK CONSTRAINT [FK_LoanerTestEquipmentMovement_UMUserRegistration_AssignedUserId]
GO
