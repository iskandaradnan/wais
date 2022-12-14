USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetStandardization]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetStandardization](
	[AssetStandardizationId] [int] IDENTITY(1,1) NOT NULL,
	[AssetTypeCodeId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[ManufacturerId] [int] NOT NULL,
	[ModelId] [int] NOT NULL,
	[UpperCost] [numeric](24, 2) NULL,
	[LowerCost] [numeric](24, 2) NULL,
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
	[Status] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[AssetStandardizationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetStandardization] ADD  CONSTRAINT [DF_EngAssetStandardization_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetStandardization] ADD  CONSTRAINT [DF_EngAssetStandardization_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetStandardization] ADD  CONSTRAINT [DF_EngAssetStandardization_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetStandardization]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetStandardization_EngAssetStandardizationManufacturer_ManufacturerId] FOREIGN KEY([ManufacturerId])
REFERENCES [dbo].[EngAssetStandardizationManufacturer] ([ManufacturerId])
GO
ALTER TABLE [dbo].[EngAssetStandardization] CHECK CONSTRAINT [FK_EngAssetStandardization_EngAssetStandardizationManufacturer_ManufacturerId]
GO
ALTER TABLE [dbo].[EngAssetStandardization]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetStandardization_EngAssetStandardizationModel_ModelId] FOREIGN KEY([ModelId])
REFERENCES [dbo].[EngAssetStandardizationModel] ([ModelId])
GO
ALTER TABLE [dbo].[EngAssetStandardization] CHECK CONSTRAINT [FK_EngAssetStandardization_EngAssetStandardizationModel_ModelId]
GO
ALTER TABLE [dbo].[EngAssetStandardization]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetStandardization_EngAssetTypeCode_AssetTypeCodeId] FOREIGN KEY([AssetTypeCodeId])
REFERENCES [dbo].[EngAssetTypeCode] ([AssetTypeCodeId])
GO
ALTER TABLE [dbo].[EngAssetStandardization] CHECK CONSTRAINT [FK_EngAssetStandardization_EngAssetTypeCode_AssetTypeCodeId]
GO
ALTER TABLE [dbo].[EngAssetStandardization]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetStandardization_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngAssetStandardization] CHECK CONSTRAINT [FK_EngAssetStandardization_MstService_ServiceId]
GO
