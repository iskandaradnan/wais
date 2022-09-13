USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetSoftware]    Script Date: 20-09-2021 16:53:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetSoftware](
	[AssetSoftwareId] [int] IDENTITY(1,1) NOT NULL,
	[AssetId] [int] NOT NULL,
	[SoftwareVersion] [nvarchar](50) NOT NULL,
	[SoftwareKey] [nvarchar](50) NOT NULL,
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
 CONSTRAINT [PK_EngAssetSoftware] PRIMARY KEY CLUSTERED 
(
	[AssetSoftwareId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetSoftware] ADD  CONSTRAINT [DF_EngAssetSoftware_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetSoftware] ADD  CONSTRAINT [DF_EngAssetSoftware_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetSoftware] ADD  CONSTRAINT [DF_EngAssetSoftware_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetSoftware]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetSoftware_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[EngAssetSoftware] CHECK CONSTRAINT [FK_EngAssetSoftware_EngAsset_AssetId]
GO
