USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetTypeCode]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetTypeCode](
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
	[Criticality] [nvarchar](200) NULL,
 CONSTRAINT [PK_EngAssetTypeCode] PRIMARY KEY CLUSTERED 
(
	[AssetTypeCodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetTypeCode] ADD  CONSTRAINT [DF_EngAssetTypeCode_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetTypeCode] ADD  CONSTRAINT [DF_EngAssetTypeCode_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetTypeCode] ADD  CONSTRAINT [DF_EngAssetTypeCode_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetTypeCode]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetTypeCode_EngAssetClassification_AssetClassificationId] FOREIGN KEY([AssetClassificationId])
REFERENCES [dbo].[EngAssetClassification] ([AssetClassificationId])
GO
ALTER TABLE [dbo].[EngAssetTypeCode] CHECK CONSTRAINT [FK_EngAssetTypeCode_EngAssetClassification_AssetClassificationId]
GO
ALTER TABLE [dbo].[EngAssetTypeCode]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetTypeCode_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngAssetTypeCode] CHECK CONSTRAINT [FK_EngAssetTypeCode_MstService_ServiceId]
GO
