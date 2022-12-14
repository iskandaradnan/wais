USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetTypeCodeFlag]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetTypeCodeFlag](
	[AssetTypeCodeFlagId] [int] IDENTITY(1,1) NOT NULL,
	[AssetTypeCodeId] [int] NOT NULL,
	[MaintenanceFlag] [int] NOT NULL,
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
 CONSTRAINT [PK_EngAssetTypeCodeFlag] PRIMARY KEY CLUSTERED 
(
	[AssetTypeCodeFlagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeFlag] ADD  CONSTRAINT [DF_EngAssetTypeCodeFlag_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeFlag] ADD  CONSTRAINT [DF_EngAssetTypeCodeFlag_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeFlag] ADD  CONSTRAINT [DF_EngAssetTypeCodeFlag_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeFlag]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetTypeCodeFlag_EngAssetTypeCode_AssetTypeCodeId] FOREIGN KEY([AssetTypeCodeId])
REFERENCES [dbo].[EngAssetTypeCode] ([AssetTypeCodeId])
GO
ALTER TABLE [dbo].[EngAssetTypeCodeFlag] CHECK CONSTRAINT [FK_EngAssetTypeCodeFlag_EngAssetTypeCode_AssetTypeCodeId]
GO
