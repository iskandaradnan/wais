USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngAssetTypeCode]    Script Date: 20-09-2021 16:50:19 ******/
CREATE TYPE [dbo].[udt_EngAssetTypeCode] AS TABLE(
	[AssetTypeCodeId] [int] NULL,
	[ServiceId] [int] NULL,
	[AssetClassificationId] [int] NULL,
	[AssetTypeCode] [nvarchar](25) NOT NULL,
	[AssetTypeDescription] [nvarchar](250) NOT NULL,
	[EquipmentFunctionCatagoryLovId] [int] NOT NULL,
	[QAPAssetTypeB1] [bit] NULL,
	[QAPServiceAvailabilityB2] [bit] NULL,
	[QAPUptimeTargetPerc] [numeric](24, 2) NULL,
	[EffectiveFrom] [datetime] NULL,
	[EffectiveFromUTC] [datetime] NULL,
	[EffectiveTo] [datetime] NULL,
	[EffectiveToUTC] [datetime] NULL,
	[TRPILessThan5YrsPerc] [numeric](24, 2) NOT NULL,
	[TRPI5to10YrsPerc] [numeric](24, 2) NOT NULL,
	[TRPIGreaterThan10YrsPerc] [numeric](24, 2) NOT NULL,
	[UserId] [int] NULL,
	[TypeOfContractLovId] [int] NOT NULL,
	[LifeExpectancy] [int] NULL
)
GO
