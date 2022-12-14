USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[PBIBemAssetData]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PBIBemAssetData](
	[AssetId] [int] NOT NULL,
	[AssetClassificationDescription] [nvarchar](100) NULL,
	[AssetDescription] [nvarchar](500) NULL,
	[AssetClassificationCode] [nvarchar](25) NULL,
	[AssetClassification] [int] NULL,
	[WorkOrderId] [int] NULL,
	[MaintenanceWorkNo] [nvarchar](100) NULL,
	[MaintenanceWorkType] [int] NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[UserName] [varchar](9) NOT NULL,
	[FacilityName] [varchar](3) NOT NULL,
	[FieldValue] [nvarchar](100) NULL,
	[AgeDifference] [int] NULL,
	[AgeDiffBucket] [varchar](10) NULL,
	[WarrantyStatus] [varchar](15) NOT NULL,
	[PurchaseDate] [datetime] NULL,
	[WarrantyStartDate] [datetime] NULL,
	[WarrantyEndDate] [datetime] NULL,
	[MaintenanceWorkDateTime] [datetime] NULL,
	[DownTimeDays] [int] NULL,
	[RN] [bigint] NULL,
	[LicenseExpireStatus] [varchar](18) NULL,
	[ContractExpireStatus] [varchar](18) NULL,
	[AgeDiffBucketOrder] [int] NULL,
	[LicenseExpireStatusOrder] [int] NULL,
	[ContractExpireStatusOrder] [int] NULL
) ON [PRIMARY]
GO
