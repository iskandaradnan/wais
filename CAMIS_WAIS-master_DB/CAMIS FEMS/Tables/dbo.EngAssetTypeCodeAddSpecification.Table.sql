USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetTypeCodeAddSpecification]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetTypeCodeAddSpecification](
	[AssetTypeCodeAddSpecId] [int] IDENTITY(1,1) NOT NULL,
	[AssetTypeCodeId] [int] NOT NULL,
	[SpecificationType] [int] NULL,
	[SpecificationUnit] [int] NULL,
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
 CONSTRAINT [PK_EngAssetTypeCodeAddSpecification] PRIMARY KEY CLUSTERED 
(
	[AssetTypeCodeAddSpecId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeAddSpecification] ADD  CONSTRAINT [DF_EngAssetTypeCodeAddSpecification_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeAddSpecification] ADD  CONSTRAINT [DF_EngAssetTypeCodeAddSpecification_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeAddSpecification] ADD  CONSTRAINT [DF_EngAssetTypeCodeAddSpecification_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeAddSpecification]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetTypeCodeAddSpecification_EngAssetTypeCode_AssetTypeCodeId] FOREIGN KEY([AssetTypeCodeId])
REFERENCES [dbo].[EngAssetTypeCode] ([AssetTypeCodeId])
GO
ALTER TABLE [dbo].[EngAssetTypeCodeAddSpecification] CHECK CONSTRAINT [FK_EngAssetTypeCodeAddSpecification_EngAssetTypeCode_AssetTypeCodeId]
GO
