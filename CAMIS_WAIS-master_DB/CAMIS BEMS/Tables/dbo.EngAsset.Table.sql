USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngAsset]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAsset](
	[AssetId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[WorkGroupId] [int] NULL,
	[AssetClassification] [int] NULL,
	[IsAssetOld] [bit] NULL,
	[QRCode] [varbinary](max) NULL,
	[AssetPreRegistrationNo] [nvarchar](50) NULL,
	[AssetNo] [nvarchar](50) NOT NULL,
	[AssetNoOld] [nvarchar](50) NULL,
	[AssetDescription] [nvarchar](500) NULL,
	[AssetTypeCodeId] [int] NULL,
	[CommissioningDate] [date] NOT NULL,
	[ServiceStartDate] [datetime] NOT NULL,
	[ServiceStartDateUTC] [datetime] NOT NULL,
	[EffectiveDate] [datetime] NULL,
	[EffectiveDateUTC] [datetime] NULL,
	[ExpectedLifespan] [int] NULL,
	[AssetStatusLovId] [int] NULL,
	[RealTimeStatusLovId] [int] NULL,
	[OperatingHours] [numeric](24, 2) NULL,
	[Image1FMDocumentId] [int] NULL,
	[Image2FMDocumentId] [int] NULL,
	[Image3FMDocumentId] [int] NULL,
	[Image4FMDocumentId] [int] NULL,
	[VedioFMDocumentId] [int] NULL,
	[UserAreaId] [int] NULL,
	[UserLocationId] [int] NULL,
	[Manufacturer] [int] NULL,
	[Model] [int] NULL,
	[AppliedPartTypeLovId] [int] NULL,
	[EquipmentClassLovId] [int] NULL,
	[SerialNo] [nvarchar](100) NULL,
	[RiskRating] [int] NULL,
	[MainSupplier] [nvarchar](50) NULL,
	[ManufacturingDate] [datetime] NULL,
	[ManufacturingDateUTC] [datetime] NULL,
	[SpecificationUnit] [int] NULL,
	[PowerSpecification] [int] NULL,
	[Volt] [numeric](24, 2) NULL,
	[PpmPlannerId] [int] NULL,
	[RiPlannerId] [int] NULL,
	[OtherPlannerId] [int] NULL,
	[PurchaseCostRM] [numeric](24, 2) NULL,
	[PurchaseDate] [datetime] NULL,
	[PurchaseDateUTC] [datetime] NULL,
	[WarrantyDuration] [numeric](24, 0) NULL,
	[WarrantyStartDate] [datetime] NULL,
	[WarrantyStartDateUTC] [datetime] NULL,
	[WarrantyEndDate] [datetime] NULL,
	[WarrantyEndDateUTC] [datetime] NULL,
	[CumulativePartCost] [numeric](24, 0) NULL,
	[CumulativeLabourCost] [numeric](24, 0) NULL,
	[CumulativeContractCost] [numeric](24, 0) NULL,
	[RegistrationNo] [nvarchar](200) NULL,
	[ChassisNo] [nvarchar](200) NULL,
	[EngineCapacity] [nvarchar](25) NULL,
	[FuelType] [int] NULL,
	[Specification] [int] NULL,
	[DisposalApprovalDate] [datetime] NULL,
	[DisposalApprovalDateUTC] [datetime] NULL,
	[DisposedDate] [datetime] NULL,
	[DisposedDateUTC] [datetime] NULL,
	[DisposedBy] [nvarchar](100) NULL,
	[DisposeMethod] [nvarchar](100) NULL,
	[Authorization] [int] NULL,
	[TestingandCommissioningDetId] [int] NULL,
	[AssetParentId] [int] NULL,
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
	[AssetStandardizationId] [int] NULL,
	[NamePlateManufacturer] [nvarchar](100) NULL,
	[PowerSpecificationWatt] [numeric](24, 2) NULL,
	[PowerSpecificationAmpere] [numeric](24, 2) NULL,
	[PurchaseCategory] [int] NULL,
	[IsLoaner] [bit] NOT NULL,
	[TypeOfAsset] [int] NULL,
	[Image5FMDocumentId] [int] NULL,
	[Image6FMDocumentId] [int] NULL,
	[SoftwareVersion] [nvarchar](50) NULL,
	[SoftwareKey] [nvarchar](50) NULL,
	[TransferRemarks] [nvarchar](500) NULL,
	[PurchaseOrderNo] [nvarchar](100) NULL,
	[InstalledLocationId] [int] NULL,
	[TransferFacilityName] [nvarchar](500) NULL,
	[PreviousAssetNo] [nvarchar](500) NULL,
	[TransferMode] [int] NULL,
	[MainsFuseRating] [numeric](24, 2) NULL,
	[OtherTransferDate] [datetime] NULL,
	[Field1] [nvarchar](500) NULL,
	[Field2] [nvarchar](500) NULL,
	[Field3] [nvarchar](500) NULL,
	[Field4] [nvarchar](500) NULL,
	[Field5] [nvarchar](500) NULL,
	[Field6] [nvarchar](500) NULL,
	[Field7] [nvarchar](500) NULL,
	[Field8] [nvarchar](500) NULL,
	[Field9] [nvarchar](500) NULL,
	[Field10] [nvarchar](500) NULL,
	[ServiceStopDate] [datetime] NULL,
	[IsMailSent] [bit] NULL,
	[RunningHoursCapture] [int] NULL,
	[ContractType] [int] NULL,
	[AssetWorkingStatus] [int] NULL,
	[CompanyStaffId] [int] NULL,
	[WarrantyEmail] [bit] NULL,
	[Asset_Name] [varchar](500) NULL,
	[Item_Code] [varchar](50) NULL,
	[Item_Description] [varchar](500) NULL,
	[Package_Code] [varchar](50) NULL,
	[Package_Description] [varchar](500) NULL,
	[Asset_Category] [varchar](50) NULL,
	[WorkGroup] [varchar](50) NULL,
	[BatchNo] [int] NULL,
	[MigrationStatus] [int] NULL,
 CONSTRAINT [PK_EngAsset] PRIMARY KEY CLUSTERED 
(
	[AssetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAsset] ADD  CONSTRAINT [DF_EngAsset_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAsset] ADD  CONSTRAINT [DF_EngAsset_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAsset] ADD  CONSTRAINT [DF_EngAsset_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAsset] ADD  CONSTRAINT [DF_EngAsset_IsLoaner]  DEFAULT ((0)) FOR [IsLoaner]
GO
ALTER TABLE [dbo].[EngAsset] ADD  DEFAULT ((0)) FOR [WarrantyEmail]
GO
ALTER TABLE [dbo].[EngAsset] ADD  CONSTRAINT [MigrationStatus]  DEFAULT ((0)) FOR [MigrationStatus]
GO
ALTER TABLE [dbo].[EngAsset]  WITH CHECK ADD  CONSTRAINT [FK_EngAsset_EngAssetClassification_AssetClassification] FOREIGN KEY([AssetClassification])
REFERENCES [dbo].[EngAssetClassification] ([AssetClassificationId])
GO
ALTER TABLE [dbo].[EngAsset] CHECK CONSTRAINT [FK_EngAsset_EngAssetClassification_AssetClassification]
GO
ALTER TABLE [dbo].[EngAsset]  WITH CHECK ADD  CONSTRAINT [FK_EngAsset_EngAssetStandardization_AssetStandardizationId] FOREIGN KEY([AssetStandardizationId])
REFERENCES [dbo].[EngAssetStandardization] ([AssetStandardizationId])
GO
ALTER TABLE [dbo].[EngAsset] CHECK CONSTRAINT [FK_EngAsset_EngAssetStandardization_AssetStandardizationId]
GO
ALTER TABLE [dbo].[EngAsset]  WITH CHECK ADD  CONSTRAINT [FK_EngAsset_EngAssetStandardizationManufacturer_ManufacturerId] FOREIGN KEY([Manufacturer])
REFERENCES [dbo].[EngAssetStandardizationManufacturer] ([ManufacturerId])
GO
ALTER TABLE [dbo].[EngAsset] CHECK CONSTRAINT [FK_EngAsset_EngAssetStandardizationManufacturer_ManufacturerId]
GO
ALTER TABLE [dbo].[EngAsset]  WITH CHECK ADD  CONSTRAINT [FK_EngAsset_EngAssetStandardizationModel_ModelId] FOREIGN KEY([Model])
REFERENCES [dbo].[EngAssetStandardizationModel] ([ModelId])
GO
ALTER TABLE [dbo].[EngAsset] CHECK CONSTRAINT [FK_EngAsset_EngAssetStandardizationModel_ModelId]
GO
ALTER TABLE [dbo].[EngAsset]  WITH CHECK ADD  CONSTRAINT [FK_EngAsset_EngAssetTypeCode_AssetTypeCodeId] FOREIGN KEY([AssetTypeCodeId])
REFERENCES [dbo].[EngAssetTypeCode] ([AssetTypeCodeId])
GO
ALTER TABLE [dbo].[EngAsset] CHECK CONSTRAINT [FK_EngAsset_EngAssetTypeCode_AssetTypeCodeId]
GO
ALTER TABLE [dbo].[EngAsset]  WITH CHECK ADD  CONSTRAINT [FK_EngAsset_EngAssetWorkGroup_WorkGroupId] FOREIGN KEY([WorkGroupId])
REFERENCES [dbo].[EngAssetWorkGroup] ([WorkGroupId])
GO
ALTER TABLE [dbo].[EngAsset] CHECK CONSTRAINT [FK_EngAsset_EngAssetWorkGroup_WorkGroupId]
GO
ALTER TABLE [dbo].[EngAsset]  WITH CHECK ADD  CONSTRAINT [FK_EngAsset_EngTestingandCommissioningTxnDet_TestingandCommissioningDetId] FOREIGN KEY([TestingandCommissioningDetId])
REFERENCES [dbo].[EngTestingandCommissioningTxnDet] ([TestingandCommissioningDetId])
GO
ALTER TABLE [dbo].[EngAsset] CHECK CONSTRAINT [FK_EngAsset_EngTestingandCommissioningTxnDet_TestingandCommissioningDetId]
GO
ALTER TABLE [dbo].[EngAsset]  WITH CHECK ADD  CONSTRAINT [FK_EngAsset_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngAsset] CHECK CONSTRAINT [FK_EngAsset_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngAsset]  WITH CHECK ADD  CONSTRAINT [FK_EngAsset_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngAsset] CHECK CONSTRAINT [FK_EngAsset_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngAsset]  WITH CHECK ADD  CONSTRAINT [FK_EngAsset_MstLocationUserArea_UserAreaId] FOREIGN KEY([UserAreaId])
REFERENCES [dbo].[MstLocationUserArea] ([UserAreaId])
GO
ALTER TABLE [dbo].[EngAsset] CHECK CONSTRAINT [FK_EngAsset_MstLocationUserArea_UserAreaId]
GO
ALTER TABLE [dbo].[EngAsset]  WITH CHECK ADD  CONSTRAINT [FK_EngAsset_MstLocationUserLocation_UserLocationId] FOREIGN KEY([UserLocationId])
REFERENCES [dbo].[MstLocationUserLocation] ([UserLocationId])
GO
ALTER TABLE [dbo].[EngAsset] CHECK CONSTRAINT [FK_EngAsset_MstLocationUserLocation_UserLocationId]
GO
ALTER TABLE [dbo].[EngAsset]  WITH CHECK ADD  CONSTRAINT [FK_EngAsset_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngAsset] CHECK CONSTRAINT [FK_EngAsset_MstService_ServiceId]
GO
