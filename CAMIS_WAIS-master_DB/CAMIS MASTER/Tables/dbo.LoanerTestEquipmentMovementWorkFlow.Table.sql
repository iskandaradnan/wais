USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LoanerTestEquipmentMovementWorkFlow]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoanerTestEquipmentMovementWorkFlow](
	[TestEquipmentMovementWorkFlowId] [int] IDENTITY(1,1) NOT NULL,
	[TestEquipmentMovementId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[AssetId] [int] NOT NULL,
	[WorkFlowId] [int] NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_LoanerTestEquipmentMovementWorkFlow] PRIMARY KEY CLUSTERED 
(
	[TestEquipmentMovementWorkFlowId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LoanerTestEquipmentMovementWorkFlow] ADD  CONSTRAINT [DF_LoanerTestEquipmentMovementWorkFlow_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[LoanerTestEquipmentMovementWorkFlow]  WITH CHECK ADD  CONSTRAINT [FK_LoanerTestEquipmentMovementWorkFlow_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[LoanerTestEquipmentMovementWorkFlow] CHECK CONSTRAINT [FK_LoanerTestEquipmentMovementWorkFlow_EngAsset_AssetId]
GO
ALTER TABLE [dbo].[LoanerTestEquipmentMovementWorkFlow]  WITH CHECK ADD  CONSTRAINT [FK_LoanerTestEquipmentMovementWorkFlow_LoanerTestEquipmentMovement_TestEquipmentMovementId] FOREIGN KEY([TestEquipmentMovementId])
REFERENCES [dbo].[LoanerTestEquipmentMovement] ([TestEquipmentMovementId])
GO
ALTER TABLE [dbo].[LoanerTestEquipmentMovementWorkFlow] CHECK CONSTRAINT [FK_LoanerTestEquipmentMovementWorkFlow_LoanerTestEquipmentMovement_TestEquipmentMovementId]
GO
ALTER TABLE [dbo].[LoanerTestEquipmentMovementWorkFlow]  WITH CHECK ADD  CONSTRAINT [FK_LoanerTestEquipmentMovementWorkFlow_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[LoanerTestEquipmentMovementWorkFlow] CHECK CONSTRAINT [FK_LoanerTestEquipmentMovementWorkFlow_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[LoanerTestEquipmentMovementWorkFlow]  WITH CHECK ADD  CONSTRAINT [FK_LoanerTestEquipmentMovementWorkFlow_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[LoanerTestEquipmentMovementWorkFlow] CHECK CONSTRAINT [FK_LoanerTestEquipmentMovementWorkFlow_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[LoanerTestEquipmentMovementWorkFlow]  WITH CHECK ADD  CONSTRAINT [FK_LoanerTestEquipmentMovementWorkFlow_SmartAssignWorkFlow_WorkFlowId] FOREIGN KEY([WorkFlowId])
REFERENCES [dbo].[SmartAssignWorkFlow] ([WorkFlowId])
GO
ALTER TABLE [dbo].[LoanerTestEquipmentMovementWorkFlow] CHECK CONSTRAINT [FK_LoanerTestEquipmentMovementWorkFlow_SmartAssignWorkFlow_WorkFlowId]
GO
