USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_QRCodeAsset]    Script Date: 20-09-2021 16:50:19 ******/
CREATE TYPE [dbo].[udt_QRCodeAsset] AS TABLE(
	[QRCodeAssetId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[UserAreaId] [int] NULL,
	[UserLocationId] [int] NULL,
	[AssetId] [int] NULL,
	[AssetNo] [nvarchar](50) NULL,
	[QRCodeSize1] [varbinary](max) NULL,
	[QRCodeSize2] [varbinary](max) NULL,
	[QRCodeSize3] [varbinary](max) NULL,
	[QRCodeSize4] [varbinary](max) NULL,
	[QRCodeSize5] [varbinary](max) NULL
)
GO
