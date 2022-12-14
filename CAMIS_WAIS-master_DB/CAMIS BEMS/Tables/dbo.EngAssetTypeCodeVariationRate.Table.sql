USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetTypeCodeVariationRate]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetTypeCodeVariationRate](
	[AssetTypeCodeVariationId] [int] IDENTITY(1,1) NOT NULL,
	[AssetTypeCodeId] [int] NOT NULL,
	[TypeCodeParameterId] [int] NOT NULL,
	[VariationRate] [numeric](24, 2) NOT NULL,
	[EffectiveFromDate] [datetime] NOT NULL,
	[EffectiveFromDateUTC] [datetime] NOT NULL,
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
 CONSTRAINT [PK_EngAssetTypeCodeVariationRate] PRIMARY KEY CLUSTERED 
(
	[AssetTypeCodeVariationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeVariationRate] ADD  CONSTRAINT [DF_EngAssetTypeCodeVariationRate_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeVariationRate] ADD  CONSTRAINT [DF_EngAssetTypeCodeVariationRate_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeVariationRate] ADD  CONSTRAINT [DF_EngAssetTypeCodeVariationRate_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeVariationRate]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetTypeCodeVariationRate_EngAssetTypeCode_AssetTypeCodeId] FOREIGN KEY([AssetTypeCodeId])
REFERENCES [dbo].[EngAssetTypeCode] ([AssetTypeCodeId])
GO
ALTER TABLE [dbo].[EngAssetTypeCodeVariationRate] CHECK CONSTRAINT [FK_EngAssetTypeCodeVariationRate_EngAssetTypeCode_AssetTypeCodeId]
GO
