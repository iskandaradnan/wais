USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetPPMCheckListQuantasksWorkOrderMstDet]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetPPMCheckListQuantasksWorkOrderMstDet](
	[WOPPMCheckListQNId] [int] IDENTITY(1,1) NOT NULL,
	[WOPPMCheckListId] [int] NOT NULL,
	[PPMCheckListQNId] [int] NOT NULL,
	[Value] [nvarchar](1000) NULL,
	[Status] [int] NULL,
	[Remarks] [nvarchar](1000) NULL,
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
 CONSTRAINT [PK_EngAssetPPMCheckListQuantasksWorkOrderMstDet] PRIMARY KEY CLUSTERED 
(
	[WOPPMCheckListQNId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListQuantasksWorkOrderMstDet] ADD  CONSTRAINT [DF_EngAssetPPMCheckListQuantasksWorkOrderMstDet_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListQuantasksWorkOrderMstDet] ADD  CONSTRAINT [DF_EngAssetPPMCheckListQuantasksWorkOrderMstDet_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListQuantasksWorkOrderMstDet] ADD  CONSTRAINT [DF_EngAssetPPMCheckListQuantasksWorkOrderMstDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListQuantasksWorkOrderMstDet]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetPPMCheckListQuantasksWorkOrderMstDet_EngAssetPPMCheckListQuantasksMstDet_PPMCheckListQNId] FOREIGN KEY([PPMCheckListQNId])
REFERENCES [dbo].[EngAssetPPMCheckListQuantasksMstDet] ([PPMCheckListQNId])
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListQuantasksWorkOrderMstDet] CHECK CONSTRAINT [FK_EngAssetPPMCheckListQuantasksWorkOrderMstDet_EngAssetPPMCheckListQuantasksMstDet_PPMCheckListQNId]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListQuantasksWorkOrderMstDet]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetPPMCheckListQuantasksWorkOrderMstDet_EngAssetPPMCheckListWorkOrder_WOPPMCheckListId] FOREIGN KEY([WOPPMCheckListId])
REFERENCES [dbo].[EngAssetPPMCheckListWorkOrder] ([WOPPMCheckListId])
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListQuantasksWorkOrderMstDet] CHECK CONSTRAINT [FK_EngAssetPPMCheckListQuantasksWorkOrderMstDet_EngAssetPPMCheckListWorkOrder_WOPPMCheckListId]
GO
