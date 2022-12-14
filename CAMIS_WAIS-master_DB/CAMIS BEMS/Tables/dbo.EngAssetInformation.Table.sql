USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetInformation]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetInformation](
	[AssetInformationId] [int] IDENTITY(1,1) NOT NULL,
	[ServiceId] [int] NOT NULL,
	[Type] [int] NOT NULL,
	[ManufacturerId] [int] NULL,
	[MakeId] [int] NULL,
	[BrandId] [int] NULL,
	[ModelId] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
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
PRIMARY KEY CLUSTERED 
(
	[AssetInformationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetInformation] ADD  CONSTRAINT [DF_EngAssetInformation_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetInformation] ADD  CONSTRAINT [DF_EngAssetInformation_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetInformation] ADD  CONSTRAINT [DF_EngAssetInformation_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetInformation]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetInformation_EngAssetStandardizationBrand_BrandId] FOREIGN KEY([BrandId])
REFERENCES [dbo].[EngAssetStandardizationBrand] ([BrandId])
GO
ALTER TABLE [dbo].[EngAssetInformation] CHECK CONSTRAINT [FK_EngAssetInformation_EngAssetStandardizationBrand_BrandId]
GO
ALTER TABLE [dbo].[EngAssetInformation]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetInformation_EngAssetStandardizationMake_MakeId] FOREIGN KEY([MakeId])
REFERENCES [dbo].[EngAssetStandardizationMake] ([MakeId])
GO
ALTER TABLE [dbo].[EngAssetInformation] CHECK CONSTRAINT [FK_EngAssetInformation_EngAssetStandardizationMake_MakeId]
GO
ALTER TABLE [dbo].[EngAssetInformation]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetInformation_EngAssetStandardizationManufacturer_ManufacturerId] FOREIGN KEY([ManufacturerId])
REFERENCES [dbo].[EngAssetStandardizationManufacturer] ([ManufacturerId])
GO
ALTER TABLE [dbo].[EngAssetInformation] CHECK CONSTRAINT [FK_EngAssetInformation_EngAssetStandardizationManufacturer_ManufacturerId]
GO
ALTER TABLE [dbo].[EngAssetInformation]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetInformation_EngAssetStandardizationModel_ModelId] FOREIGN KEY([ModelId])
REFERENCES [dbo].[EngAssetStandardizationModel] ([ModelId])
GO
ALTER TABLE [dbo].[EngAssetInformation] CHECK CONSTRAINT [FK_EngAssetInformation_EngAssetStandardizationModel_ModelId]
GO
ALTER TABLE [dbo].[EngAssetInformation]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetInformation_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngAssetInformation] CHECK CONSTRAINT [FK_EngAssetInformation_MstService_ServiceId]
GO
