USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngAssetSoftware]    Script Date: 20-09-2021 16:50:19 ******/
CREATE TYPE [dbo].[udt_EngAssetSoftware] AS TABLE(
	[AssetSoftwareId] [int] NULL,
	[AssetId] [int] NULL,
	[SoftwareVersion] [nvarchar](50) NULL,
	[SoftwareKey] [nvarchar](50) NULL,
	[IsDeleted] [int] NULL
)
GO
