USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetTypeCodeStandardTasksHistoryDet]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetTypeCodeStandardTasksHistoryDet](
	[StandardTaskHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[StandardTaskDetId] [int] NOT NULL,
	[StandardTaskId] [int] NOT NULL,
	[Status] [nvarchar](25) NOT NULL,
	[EffectiveFrom] [datetime] NULL,
	[EffectiveFromUTC] [datetime] NULL,
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
 CONSTRAINT [PK_EngAssetTypeCodeStandardTasksHistoryDet] PRIMARY KEY CLUSTERED 
(
	[StandardTaskHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasksHistoryDet] ADD  CONSTRAINT [DF_EngAssetTypeCodeStandardTasksHistoryDet_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasksHistoryDet] ADD  CONSTRAINT [DF_EngAssetTypeCodeStandardTasksHistoryDet_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasksHistoryDet] ADD  CONSTRAINT [DF_EngAssetTypeCodeStandardTasksHistoryDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasksHistoryDet]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetTypeCodeStandardTasksHistoryDet_EngAssetTypeCodeStandardTasks_StandardTaskId] FOREIGN KEY([StandardTaskId])
REFERENCES [dbo].[EngAssetTypeCodeStandardTasks] ([StandardTaskId])
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasksHistoryDet] CHECK CONSTRAINT [FK_EngAssetTypeCodeStandardTasksHistoryDet_EngAssetTypeCodeStandardTasks_StandardTaskId]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasksHistoryDet]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetTypeCodeStandardTasksHistoryDet_EngAssetTypeCodeStandardTasksDet_StandardTaskDetId] FOREIGN KEY([StandardTaskDetId])
REFERENCES [dbo].[EngAssetTypeCodeStandardTasksDet] ([StandardTaskDetId])
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasksHistoryDet] CHECK CONSTRAINT [FK_EngAssetTypeCodeStandardTasksHistoryDet_EngAssetTypeCodeStandardTasksDet_StandardTaskDetId]
GO
