USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngEODCategorySystemDet]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_EngEODCategorySystemDet] AS TABLE(
	[CategorySystemDetId] [int] NULL,
	[CategorySystemId] [int] NULL,
	[AssetTypeCodeId] [int] NOT NULL,
	[UserId] [int] NULL
)
GO
