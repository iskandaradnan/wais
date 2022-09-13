USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngAssetSoftware]    Script Date: 20-09-2021 17:09:18 ******/
CREATE TYPE [dbo].[udt_EngAssetSoftware] AS TABLE(
	[AssetSoftwareId] [int] NULL,
	[AssetId] [int] NULL,
	[SoftwareVersion] [nvarchar](50) NULL,
	[SoftwareKey] [nvarchar](50) NULL,
	[IsDeleted] [int] NULL
)
GO
