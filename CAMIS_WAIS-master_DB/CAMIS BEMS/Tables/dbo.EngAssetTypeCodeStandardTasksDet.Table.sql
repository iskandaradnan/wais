USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetTypeCodeStandardTasksDet]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetTypeCodeStandardTasksDet](
	[StandardTaskDetId] [int] IDENTITY(1,1) NOT NULL,
	[StandardTaskId] [int] NOT NULL,
	[TaskCode] [nvarchar](25) NOT NULL,
	[TaskDescription] [nvarchar](255) NOT NULL,
	[ModelId] [int] NULL,
	[PPMId] [int] NULL,
	[OGWI] [nvarchar](1000) NULL,
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
	[Status] [int] NOT NULL,
 CONSTRAINT [PK_EngAssetTypeCodeStandardTasksDet] PRIMARY KEY CLUSTERED 
(
	[StandardTaskDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasksDet] ADD  CONSTRAINT [DF_EngAssetTypeCodeStandardTasksDet_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasksDet] ADD  CONSTRAINT [DF_EngAssetTypeCodeStandardTasksDet_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasksDet] ADD  CONSTRAINT [DF_EngAssetTypeCodeStandardTasksDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasksDet]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetTypeCodeStandardTasksDet_EngAssetStandardizationModel_ModelId] FOREIGN KEY([ModelId])
REFERENCES [dbo].[EngAssetStandardizationModel] ([ModelId])
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasksDet] CHECK CONSTRAINT [FK_EngAssetTypeCodeStandardTasksDet_EngAssetStandardizationModel_ModelId]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasksDet]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetTypeCodeStandardTasksDet_EngAssetTypeCodeStandardTasks_StandardTaskId] FOREIGN KEY([StandardTaskId])
REFERENCES [dbo].[EngAssetTypeCodeStandardTasks] ([StandardTaskId])
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasksDet] CHECK CONSTRAINT [FK_EngAssetTypeCodeStandardTasksDet_EngAssetTypeCodeStandardTasks_StandardTaskId]
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasksDet]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetTypeCodeStandardTasksDet_EngPPMRegisterMst_PPMId] FOREIGN KEY([PPMId])
REFERENCES [dbo].[EngPPMRegisterMst] ([PPMId])
GO
ALTER TABLE [dbo].[EngAssetTypeCodeStandardTasksDet] CHECK CONSTRAINT [FK_EngAssetTypeCodeStandardTasksDet_EngPPMRegisterMst_PPMId]
GO
