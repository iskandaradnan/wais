USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngEODParameterMapping]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngEODParameterMapping](
	[ParameterMappingId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[AssetClassificationId] [int] NOT NULL,
	[ManufacturerId] [int] NOT NULL,
	[ModelId] [int] NOT NULL,
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
	[AssetTypeCodeId] [int] NOT NULL,
	[FrequencyLovId] [int] NULL,
 CONSTRAINT [PK_EngEODParameterMapping] PRIMARY KEY CLUSTERED 
(
	[ParameterMappingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngEODParameterMapping] ADD  CONSTRAINT [DF_EngEODParameterMapping_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngEODParameterMapping] ADD  CONSTRAINT [DF_EngEODParameterMapping_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngEODParameterMapping] ADD  CONSTRAINT [DF_EngEODParameterMapping_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngEODParameterMapping]  WITH CHECK ADD  CONSTRAINT [FK_EngEODParameterMapping_EngAssetClassification_AssetClassificationId] FOREIGN KEY([AssetClassificationId])
REFERENCES [dbo].[EngAssetClassification] ([AssetClassificationId])
GO
ALTER TABLE [dbo].[EngEODParameterMapping] CHECK CONSTRAINT [FK_EngEODParameterMapping_EngAssetClassification_AssetClassificationId]
GO
ALTER TABLE [dbo].[EngEODParameterMapping]  WITH CHECK ADD  CONSTRAINT [FK_EngEODParameterMapping_EngAssetStandardizationManufacturer_ManufacturerId] FOREIGN KEY([ManufacturerId])
REFERENCES [dbo].[EngAssetStandardizationManufacturer] ([ManufacturerId])
GO
ALTER TABLE [dbo].[EngEODParameterMapping] CHECK CONSTRAINT [FK_EngEODParameterMapping_EngAssetStandardizationManufacturer_ManufacturerId]
GO
ALTER TABLE [dbo].[EngEODParameterMapping]  WITH CHECK ADD  CONSTRAINT [FK_EngEODParameterMapping_EngAssetStandardizationModel_ModelId] FOREIGN KEY([ModelId])
REFERENCES [dbo].[EngAssetStandardizationModel] ([ModelId])
GO
ALTER TABLE [dbo].[EngEODParameterMapping] CHECK CONSTRAINT [FK_EngEODParameterMapping_EngAssetStandardizationModel_ModelId]
GO
ALTER TABLE [dbo].[EngEODParameterMapping]  WITH CHECK ADD  CONSTRAINT [FK_EngEODParameterMapping_EngAssetTypeCode_AssetTypeCodeId] FOREIGN KEY([AssetTypeCodeId])
REFERENCES [dbo].[EngAssetTypeCode] ([AssetTypeCodeId])
GO
ALTER TABLE [dbo].[EngEODParameterMapping] CHECK CONSTRAINT [FK_EngEODParameterMapping_EngAssetTypeCode_AssetTypeCodeId]
GO
ALTER TABLE [dbo].[EngEODParameterMapping]  WITH CHECK ADD  CONSTRAINT [FK_EngEODParameterMapping_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngEODParameterMapping] CHECK CONSTRAINT [FK_EngEODParameterMapping_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngEODParameterMapping]  WITH CHECK ADD  CONSTRAINT [FK_EngEODParameterMapping_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngEODParameterMapping] CHECK CONSTRAINT [FK_EngEODParameterMapping_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngEODParameterMapping]  WITH CHECK ADD  CONSTRAINT [FK_EngEODParameterMapping_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngEODParameterMapping] CHECK CONSTRAINT [FK_EngEODParameterMapping_MstService_ServiceId]
GO
