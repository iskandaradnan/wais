USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngSpareParts]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngSpareParts](
	[SparePartsId] [int] IDENTITY(1,1) NOT NULL,
	[ServiceId] [int] NOT NULL,
	[ItemId] [int] NOT NULL,
	[PartNo] [nvarchar](25) NOT NULL,
	[PartDescription] [nvarchar](250) NULL,
	[AssetTypeCodeId] [int] NULL,
	[ManufacturerId] [int] NOT NULL,
	[BrandId] [int] NULL,
	[ModelId] [int] NOT NULL,
	[UnitOfMeasurement] [int] NOT NULL,
	[SparePartType] [int] NULL,
	[Location] [int] NULL,
	[Specify] [nvarchar](100) NULL,
	[PartCategory] [int] NULL,
	[MinLevel] [numeric](24, 2) NOT NULL,
	[MaxLevel] [numeric](24, 2) NULL,
	[MinPrice] [numeric](24, 2) NULL,
	[MaxPrice] [numeric](24, 2) NULL,
	[Status] [int] NOT NULL,
	[CurrentStockLevel] [nvarchar](150) NULL,
	[Image1DocumentId] [int] NULL,
	[Image2DocumentId] [int] NULL,
	[Image3DocumentId] [int] NULL,
	[Image4DocumentId] [int] NULL,
	[Image5DocumentId] [int] NULL,
	[Image6DocumentId] [int] NULL,
	[VideoDocumentId] [int] NULL,
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
	[PartSourceId] [int] NOT NULL,
	[EstimatedLifeSpanInHours] [numeric](24, 2) NULL,
	[LifeSpanOptionId] [int] NOT NULL,
 CONSTRAINT [PK_EngSpareParts] PRIMARY KEY CLUSTERED 
(
	[SparePartsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngSpareParts] ADD  CONSTRAINT [DF_EngSpareParts_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngSpareParts] ADD  CONSTRAINT [DF_EngSpareParts_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngSpareParts] ADD  CONSTRAINT [DF_EngSpareParts_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngSpareParts]  WITH CHECK ADD  CONSTRAINT [FK_EngSpareParts_EngAssetStandardizationBrand_BrandId] FOREIGN KEY([BrandId])
REFERENCES [dbo].[EngAssetStandardizationBrand] ([BrandId])
GO
ALTER TABLE [dbo].[EngSpareParts] CHECK CONSTRAINT [FK_EngSpareParts_EngAssetStandardizationBrand_BrandId]
GO
ALTER TABLE [dbo].[EngSpareParts]  WITH CHECK ADD  CONSTRAINT [FK_EngSpareParts_EngAssetStandardizationManufacturer_ManufacturerId] FOREIGN KEY([ManufacturerId])
REFERENCES [dbo].[EngAssetStandardizationManufacturer] ([ManufacturerId])
GO
ALTER TABLE [dbo].[EngSpareParts] CHECK CONSTRAINT [FK_EngSpareParts_EngAssetStandardizationManufacturer_ManufacturerId]
GO
ALTER TABLE [dbo].[EngSpareParts]  WITH CHECK ADD  CONSTRAINT [FK_EngSpareParts_EngAssetStandardizationModel_ModelId] FOREIGN KEY([ModelId])
REFERENCES [dbo].[EngAssetStandardizationModel] ([ModelId])
GO
ALTER TABLE [dbo].[EngSpareParts] CHECK CONSTRAINT [FK_EngSpareParts_EngAssetStandardizationModel_ModelId]
GO
ALTER TABLE [dbo].[EngSpareParts]  WITH CHECK ADD  CONSTRAINT [FK_EngSpareParts_EngSparePartsCategory_PartCategory] FOREIGN KEY([PartCategory])
REFERENCES [dbo].[EngSparePartsCategory] ([SparePartsCategoryId])
GO
ALTER TABLE [dbo].[EngSpareParts] CHECK CONSTRAINT [FK_EngSpareParts_EngSparePartsCategory_PartCategory]
GO
ALTER TABLE [dbo].[EngSpareParts]  WITH CHECK ADD  CONSTRAINT [FK_EngSpareParts_FMItemMaster_ItemId] FOREIGN KEY([ItemId])
REFERENCES [dbo].[FMItemMaster] ([ItemId])
GO
ALTER TABLE [dbo].[EngSpareParts] CHECK CONSTRAINT [FK_EngSpareParts_FMItemMaster_ItemId]
GO
ALTER TABLE [dbo].[EngSpareParts]  WITH CHECK ADD  CONSTRAINT [FK_EngSpareParts_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngSpareParts] CHECK CONSTRAINT [FK_EngSpareParts_MstService_ServiceId]
GO
