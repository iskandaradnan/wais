USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[FetchResult1]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FetchResult1](
	[AssetId] [int] NOT NULL,
	[AssetNo] [nvarchar](50) NOT NULL,
	[AssetNoOld] [nvarchar](50) NULL,
	[AssetDescription] [nvarchar](500) NULL,
	[AssetClassificationId] [int] NOT NULL,
	[AssetClassificationCode] [nvarchar](25) NOT NULL,
	[AssetTypeCodeId] [int] NOT NULL,
	[AssetTypeCode] [nvarchar](25) NOT NULL,
	[AssetTypeDescription] [nvarchar](250) NOT NULL,
	[ManufacturerId] [int] NULL,
	[Manufacturer] [nvarchar](500) NULL,
	[ModelId] [int] NULL,
	[Model] [nvarchar](500) NULL,
	[UserAreaId] [int] NULL,
	[UserAreaCode] [nvarchar](25) NULL,
	[UserAreaName] [nvarchar](100) NULL,
	[UserLocationId] [int] NULL,
	[UserLocationCode] [nvarchar](25) NULL,
	[UserLocationName] [nvarchar](100) NULL,
	[WarrantyEndDate] [datetime] NULL,
	[MainSupplier] [nvarchar](50) NULL,
	[ContractEndDate] [datetime] NULL,
	[ContractorCode] [nvarchar](25) NULL,
	[ContractorName] [nvarchar](100) NULL,
	[ContactNumber] [nvarchar](200) NULL,
	[SerialNo] [nvarchar](100) NULL,
	[TypeofAsset] [int] NOT NULL,
	[TypeofAssetValue] [varchar](8) NOT NULL,
	[TotalRecords] [int] NULL
) ON [PRIMARY]
GO
