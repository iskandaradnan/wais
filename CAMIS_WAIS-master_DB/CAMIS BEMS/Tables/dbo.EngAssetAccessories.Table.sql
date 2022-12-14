USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetAccessories]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetAccessories](
	[AccessoriesId] [int] IDENTITY(1,1) NOT NULL,
	[AssetId] [int] NOT NULL,
	[AccessoriesDescription] [nvarchar](255) NULL,
	[SerialNo] [nvarchar](50) NULL,
	[Manufacturer] [nvarchar](200) NULL,
	[Model] [nvarchar](200) NULL,
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
	[DocumentTitle] [nvarchar](300) NULL,
	[DocumentExtension] [nvarchar](255) NULL,
	[FileName] [nvarchar](255) NULL,
	[DocumentRemarks] [nvarchar](500) NULL,
	[FilePath] [nvarchar](500) NULL,
	[DocumentGuid] [nvarchar](500) NULL,
 CONSTRAINT [PK_EngAssetAccessories] PRIMARY KEY CLUSTERED 
(
	[AccessoriesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetAccessories] ADD  CONSTRAINT [DF_EngAssetAccessories_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetAccessories] ADD  CONSTRAINT [DF_EngAssetAccessories_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetAccessories] ADD  CONSTRAINT [DF_EngAssetAccessories_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetAccessories]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetAccessories_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[EngAssetAccessories] CHECK CONSTRAINT [FK_EngAssetAccessories_EngAsset_AssetId]
GO
