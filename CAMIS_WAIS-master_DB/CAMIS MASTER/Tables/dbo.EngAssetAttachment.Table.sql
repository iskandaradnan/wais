USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetAttachment]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetAttachment](
	[AttachmentId] [int] IDENTITY(1,1) NOT NULL,
	[AssetId] [int] NOT NULL,
	[DocumentId] [int] NOT NULL,
	[FileType] [int] NOT NULL,
	[FileName] [nvarchar](100) NOT NULL,
	[FilePath] [nvarchar](500) NOT NULL,
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
 CONSTRAINT [PK_EngAssetAttachment] PRIMARY KEY CLUSTERED 
(
	[AttachmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetAttachment] ADD  CONSTRAINT [DF_EngAssetAttachment_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetAttachment] ADD  CONSTRAINT [DF_EngAssetAttachment_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetAttachment] ADD  CONSTRAINT [DF_EngAssetAttachment_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetAttachment]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetAttachment_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[EngAssetAttachment] CHECK CONSTRAINT [FK_EngAssetAttachment_EngAsset_AssetId]
GO
ALTER TABLE [dbo].[EngAssetAttachment]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetAttachment_FmDocument_DocumentId] FOREIGN KEY([DocumentId])
REFERENCES [dbo].[FMDocument] ([DocumentId])
GO
ALTER TABLE [dbo].[EngAssetAttachment] CHECK CONSTRAINT [FK_EngAssetAttachment_FmDocument_DocumentId]
GO
