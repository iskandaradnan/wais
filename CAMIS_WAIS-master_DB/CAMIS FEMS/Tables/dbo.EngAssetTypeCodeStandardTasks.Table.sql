USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetTypeCodeStandardTasks]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetTypeCodeStandardTasks](
	[StandardTaskId] [int] IDENTITY(1,1) NOT NULL,
	[ServiceId] [int] NOT NULL,
	[WorkGroupId] [int] NOT NULL,
	[AssetTypeCodeId] [int] NULL,
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
 CONSTRAINT [PK_EngAssetTypeCodeStandardTasks] PRIMARY KEY CLUSTERED 
(
	[StandardTaskId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasks] ADD  CONSTRAINT [DF_EngAssetTypeCodeStandardTasks_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasks] ADD  CONSTRAINT [DF_EngAssetTypeCodeStandardTasks_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasks] ADD  CONSTRAINT [DF_EngAssetTypeCodeStandardTasks_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasks]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetTypeCodeStandardTasks_EngAssetTypeCode_AssetTypeCodeId] FOREIGN KEY([AssetTypeCodeId])
REFERENCES [dbo].[EngAssetTypeCode] ([AssetTypeCodeId])
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasks] CHECK CONSTRAINT [FK_EngAssetTypeCodeStandardTasks_EngAssetTypeCode_AssetTypeCodeId]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasks]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetTypeCodeStandardTasks_EngAssetWorkGroup_WorkGroupId] FOREIGN KEY([WorkGroupId])
REFERENCES [dbo].[EngAssetWorkGroup] ([WorkGroupId])
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasks] CHECK CONSTRAINT [FK_EngAssetTypeCodeStandardTasks_EngAssetWorkGroup_WorkGroupId]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasks]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetTypeCodeStandardTasks_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasks] CHECK CONSTRAINT [FK_EngAssetTypeCodeStandardTasks_MstService_ServiceId]
GO
