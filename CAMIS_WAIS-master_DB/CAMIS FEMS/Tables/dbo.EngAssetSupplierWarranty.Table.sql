USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetSupplierWarranty]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetSupplierWarranty](
	[SupplierWarrantyId] [int] IDENTITY(1,1) NOT NULL,
	[AssetId] [int] NOT NULL,
	[Category] [int] NOT NULL,
	[ContractorId] [int] NULL,
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
 CONSTRAINT [PK_EngAssetSupplierWarranty] PRIMARY KEY CLUSTERED 
(
	[SupplierWarrantyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetSupplierWarranty] ADD  CONSTRAINT [DF_EngAssetSupplierWarranty_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetSupplierWarranty] ADD  CONSTRAINT [DF_EngAssetSupplierWarranty_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetSupplierWarranty] ADD  CONSTRAINT [DF_EngAssetSupplierWarranty_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetSupplierWarranty]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetSupplierWarranty_MstContractorandVendor_ContractorId] FOREIGN KEY([ContractorId])
REFERENCES [dbo].[MstContractorandVendor] ([ContractorId])
GO
ALTER TABLE [dbo].[EngAssetSupplierWarranty] CHECK CONSTRAINT [FK_EngAssetSupplierWarranty_MstContractorandVendor_ContractorId]
GO
