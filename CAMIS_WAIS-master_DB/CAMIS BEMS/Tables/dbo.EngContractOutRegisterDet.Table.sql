USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngContractOutRegisterDet]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngContractOutRegisterDet](
	[ContractDetId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[ContractId] [int] NOT NULL,
	[AssetId] [int] NOT NULL,
	[ContractType] [int] NULL,
	[ContractValue] [numeric](24, 2) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngContractOutRegisterDet] PRIMARY KEY CLUSTERED 
(
	[ContractDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngContractOutRegisterDet] ADD  CONSTRAINT [DF_EngContractOutRegisterDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngContractOutRegisterDet]  WITH CHECK ADD  CONSTRAINT [FK_EngContractOutRegisterDet_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[EngContractOutRegisterDet] CHECK CONSTRAINT [FK_EngContractOutRegisterDet_EngAsset_AssetId]
GO
ALTER TABLE [dbo].[EngContractOutRegisterDet]  WITH CHECK ADD  CONSTRAINT [FK_EngContractOutRegisterDet_EngContractOutRegister_ContractId] FOREIGN KEY([ContractId])
REFERENCES [dbo].[EngContractOutRegister] ([ContractId])
GO
ALTER TABLE [dbo].[EngContractOutRegisterDet] CHECK CONSTRAINT [FK_EngContractOutRegisterDet_EngContractOutRegister_ContractId]
GO
ALTER TABLE [dbo].[EngContractOutRegisterDet]  WITH CHECK ADD  CONSTRAINT [FK_EngContractOutRegisterDet_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngContractOutRegisterDet] CHECK CONSTRAINT [FK_EngContractOutRegisterDet_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngContractOutRegisterDet]  WITH CHECK ADD  CONSTRAINT [FK_EngContractOutRegisterDet_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngContractOutRegisterDet] CHECK CONSTRAINT [FK_EngContractOutRegisterDet_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngContractOutRegisterDet]  WITH CHECK ADD  CONSTRAINT [FK_EngContractOutRegisterDet_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngContractOutRegisterDet] CHECK CONSTRAINT [FK_EngContractOutRegisterDet_MstService_ServiceId]
GO
