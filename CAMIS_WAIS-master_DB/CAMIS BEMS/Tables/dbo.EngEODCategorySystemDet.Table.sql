USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngEODCategorySystemDet]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngEODCategorySystemDet](
	[CategorySystemDetId] [int] IDENTITY(1,1) NOT NULL,
	[CategorySystemId] [int] NOT NULL,
	[AssetTypeCodeId] [int] NOT NULL,
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
 CONSTRAINT [PK_EngEODCategorySystemDet] PRIMARY KEY CLUSTERED 
(
	[CategorySystemDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngEODCategorySystemDet] ADD  CONSTRAINT [DF_EngEODCategorySystemDet_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngEODCategorySystemDet] ADD  CONSTRAINT [DF_EngEODCategorySystemDet_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngEODCategorySystemDet] ADD  CONSTRAINT [DF_EngEODCategorySystemDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngEODCategorySystemDet]  WITH CHECK ADD  CONSTRAINT [FK_EngEODCategorySystemDet_EngAssetTypeCode_AssetTypeCodeId] FOREIGN KEY([AssetTypeCodeId])
REFERENCES [dbo].[EngAssetTypeCode] ([AssetTypeCodeId])
GO
ALTER TABLE [dbo].[EngEODCategorySystemDet] CHECK CONSTRAINT [FK_EngEODCategorySystemDet_EngAssetTypeCode_AssetTypeCodeId]
GO
ALTER TABLE [dbo].[EngEODCategorySystemDet]  WITH CHECK ADD  CONSTRAINT [FK_EngEODCategorySystemDet_EngEODCategorySystem_CategorySystemId] FOREIGN KEY([CategorySystemId])
REFERENCES [dbo].[EngEODCategorySystem] ([CategorySystemId])
GO
ALTER TABLE [dbo].[EngEODCategorySystemDet] CHECK CONSTRAINT [FK_EngEODCategorySystemDet_EngEODCategorySystem_CategorySystemId]
GO
