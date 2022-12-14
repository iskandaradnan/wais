USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngContractOutRegisterAssetHistory]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngContractOutRegisterAssetHistory](
	[ContractDetHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[ContractHistoryId] [int] NULL,
	[ContractId] [int] NULL,
	[AssetId] [int] NULL,
	[ContractType] [int] NULL,
	[ContractValue] [numeric](24, 2) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NULL,
	[GuId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_EngContractOutRegisterAssetHistory] PRIMARY KEY CLUSTERED 
(
	[ContractDetHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngContractOutRegisterAssetHistory] ADD  CONSTRAINT [DF_EngContractOutRegisterAssetHistory_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngContractOutRegisterAssetHistory]  WITH CHECK ADD  CONSTRAINT [FK_EngContractOutRegisterAssetHistory_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[EngContractOutRegisterAssetHistory] CHECK CONSTRAINT [FK_EngContractOutRegisterAssetHistory_EngAsset_AssetId]
GO
ALTER TABLE [dbo].[EngContractOutRegisterAssetHistory]  WITH CHECK ADD  CONSTRAINT [FK_EngContractOutRegisterAssetHistory_EngContractOutRegister_ContractId] FOREIGN KEY([ContractId])
REFERENCES [dbo].[EngContractOutRegister] ([ContractId])
GO
ALTER TABLE [dbo].[EngContractOutRegisterAssetHistory] CHECK CONSTRAINT [FK_EngContractOutRegisterAssetHistory_EngContractOutRegister_ContractId]
GO
ALTER TABLE [dbo].[EngContractOutRegisterAssetHistory]  WITH CHECK ADD  CONSTRAINT [FK_EngContractOutRegisterAssetHistory_EngContractOutRegisterHistory_ContractHistoryId] FOREIGN KEY([ContractHistoryId])
REFERENCES [dbo].[EngContractOutRegisterHistory] ([ContractHistoryId])
GO
ALTER TABLE [dbo].[EngContractOutRegisterAssetHistory] CHECK CONSTRAINT [FK_EngContractOutRegisterAssetHistory_EngContractOutRegisterHistory_ContractHistoryId]
GO
