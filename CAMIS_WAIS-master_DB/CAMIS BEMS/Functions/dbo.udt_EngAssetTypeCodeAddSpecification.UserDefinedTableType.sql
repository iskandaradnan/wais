USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngAssetTypeCodeAddSpecification]    Script Date: 20-09-2021 17:09:18 ******/
CREATE TYPE [dbo].[udt_EngAssetTypeCodeAddSpecification] AS TABLE(
	[AssetTypeCodeAddSpecId] [int] NULL,
	[AssetTypeCodeId] [int] NULL,
	[SpecificationType] [int] NULL,
	[SpecificationUnit] [int] NULL,
	[UserId] [int] NULL,
	[Active] [bit] NULL DEFAULT ((1))
)
GO
