USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngAssetTypeCodeVariationRate]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_EngAssetTypeCodeVariationRate] AS TABLE(
	[AssetTypeCodeVariationId] [int] NULL,
	[AssetTypeCodeId] [int] NULL,
	[TypeCodeParameterId] [int] NOT NULL,
	[VariationRate] [numeric](24, 2) NOT NULL,
	[EffectiveFromDate] [datetime] NOT NULL,
	[EffectiveFromDateUTC] [datetime] NOT NULL,
	[UserId] [int] NULL
)
GO
