USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetContractorsandVendor]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetContractorsandVendor](
	[AssetContractorId] [int] IDENTITY(1,1) NOT NULL,
	[AssetId] [int] NOT NULL,
	[ContractorId] [int] NOT NULL,
	[ContractStartDate] [datetime] NULL,
	[ContractStartDateUTC] [datetime] NULL,
	[ContractEndDate] [datetime] NULL,
	[ContractEndDateUTC] [datetime] NULL,
	[ContractValueRM] [numeric](24, 2) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[Active] [bit] NOT NULL,
	[BuiltIn] [bit] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngAssetContractorsandVendor] PRIMARY KEY CLUSTERED 
(
	[AssetContractorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetContractorsandVendor] ADD  CONSTRAINT [DF_EngAssetContractorsandVendor_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetContractorsandVendor] ADD  CONSTRAINT [DF_EngAssetContractorsandVendor_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetContractorsandVendor] ADD  CONSTRAINT [DF_EngAssetContractorsandVendor_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetContractorsandVendor]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetContractorsandVendor_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[EngAssetContractorsandVendor] CHECK CONSTRAINT [FK_EngAssetContractorsandVendor_EngAsset_AssetId]
GO
ALTER TABLE [dbo].[EngAssetContractorsandVendor]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetContractorsandVendor_MstContractorandVendor_ContractorId] FOREIGN KEY([ContractorId])
REFERENCES [dbo].[MstContractorandVendor] ([ContractorId])
GO
ALTER TABLE [dbo].[EngAssetContractorsandVendor] CHECK CONSTRAINT [FK_EngAssetContractorsandVendor_MstContractorandVendor_ContractorId]
GO
