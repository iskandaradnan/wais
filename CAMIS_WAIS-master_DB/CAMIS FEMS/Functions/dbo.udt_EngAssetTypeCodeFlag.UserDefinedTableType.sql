USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngAssetTypeCodeFlag]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_EngAssetTypeCodeFlag] AS TABLE(
	[AssetTypeCodeFlagId] [int] NULL,
	[AssetTypeCodeId] [int] NULL,
	[MaintenanceFlag] [int] NOT NULL,
	[UserId] [int] NULL
)
GO
