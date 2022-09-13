USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngAsset09072018]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAsset09072018](
	[AssetId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[WorkGroupId] [int] NOT NULL,
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
	[ExpectedLifespan] [int] NOT NULL,
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
	[TransferFacilityId] [int] NULL,
	[TransferRemarks] [nvarchar](500) NULL,
	[PurchaseOrderNo] [nvarchar](100) NULL,
	[InstalledLocationId] [int] NULL,
	[PreviousAssetId] [int] NULL,
	[TransferFacilityName] [nvarchar](500) NULL,
	[PreviousAssetNo] [nvarchar](500) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
