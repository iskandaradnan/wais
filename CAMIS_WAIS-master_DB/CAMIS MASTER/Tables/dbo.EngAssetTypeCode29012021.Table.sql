USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetTypeCode29012021]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetTypeCode29012021](
	[AssetTypeCodeId] [int] IDENTITY(1,1) NOT NULL,
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
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[Active] [bit] NOT NULL,
	[BuiltIn] [bit] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[LifeExpectancy] [int] NULL,
	[ExpectedLifeSpan] [int] NOT NULL,
	[AssetTypeCodeId_mappingTo_SeviceDB] [int] NULL,
	[Criticality] [nvarchar](200) NULL
) ON [PRIMARY]
GO
