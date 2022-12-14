USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetClassification]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetClassification](
	[AssetClassificationId] [int] IDENTITY(1,1) NOT NULL,
	[ServiceId] [int] NOT NULL,
	[AssetClassificationCode] [nvarchar](25) NOT NULL,
	[AssetClassificationDescription] [nvarchar](100) NOT NULL,
	[Remarks] [nvarchar](500) NULL,
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
	[AssetClassification_mappingTo_SeviceDB] [int] NULL,
 CONSTRAINT [PK_EngAssetClassification] PRIMARY KEY CLUSTERED 
(
	[AssetClassificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetClassification] ADD  CONSTRAINT [DF_EngAssetClassification_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetClassification] ADD  CONSTRAINT [DF_EngAssetClassification_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetClassification] ADD  CONSTRAINT [DF_EngAssetClassification_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetClassification]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetClassification_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngAssetClassification] CHECK CONSTRAINT [FK_EngAssetClassification_MstService_ServiceId]
GO
