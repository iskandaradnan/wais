USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetProcessStatus]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetProcessStatus](
	[ProcessStatusId] [int] IDENTITY(1,1) NOT NULL,
	[AssetId] [int] NOT NULL,
	[ApplicationId] [int] NULL,
	[AdvisoryId] [int] NULL,
	[DateDone] [datetime] NULL,
	[DateDoneUTC] [datetime] NULL,
	[ProcessStatus] [int] NULL,
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
 CONSTRAINT [PK_EngAssetProcessStatus] PRIMARY KEY CLUSTERED 
(
	[ProcessStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetProcessStatus] ADD  CONSTRAINT [DF_EngAssetProcessStatus_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetProcessStatus] ADD  CONSTRAINT [DF_EngAssetProcessStatus_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetProcessStatus] ADD  CONSTRAINT [DF_EngAssetProcessStatus_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetProcessStatus]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetProcessStatus_BERApplicationTxn_ApplicationId] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[BERApplicationTxn] ([ApplicationId])
GO
ALTER TABLE [dbo].[EngAssetProcessStatus] CHECK CONSTRAINT [FK_EngAssetProcessStatus_BERApplicationTxn_ApplicationId]
GO
ALTER TABLE [dbo].[EngAssetProcessStatus]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetProcessStatus_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[EngAssetProcessStatus] CHECK CONSTRAINT [FK_EngAssetProcessStatus_EngAsset_AssetId]
GO
