USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetPPMCheckListQuantasksMstDet]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetPPMCheckListQuantasksMstDet](
	[PPMCheckListQNId] [int] IDENTITY(1,1) NOT NULL,
	[PPMCheckListId] [int] NOT NULL,
	[QuantitativeTasks] [nvarchar](1000) NULL,
	[UOM] [int] NULL,
	[SetValues] [nvarchar](10) NULL,
	[LimitTolerance] [nvarchar](10) NULL,
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
 CONSTRAINT [PK_EngAssetPPMCheckListQuantasksMstDet] PRIMARY KEY CLUSTERED 
(
	[PPMCheckListQNId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListQuantasksMstDet] ADD  CONSTRAINT [DF_EngAssetPPMCheckListQuantasksMstDet_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListQuantasksMstDet] ADD  CONSTRAINT [DF_EngAssetPPMCheckListQuantasksMstDet_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListQuantasksMstDet] ADD  CONSTRAINT [DF_EngAssetPPMCheckListQuantasksMstDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListQuantasksMstDet]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetPPMCheckListQuantasksMstDet_EngAssetPPMCheckList_PPMCheckListId] FOREIGN KEY([PPMCheckListId])
REFERENCES [dbo].[EngAssetPPMCheckList] ([PPMCheckListId])
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListQuantasksMstDet] CHECK CONSTRAINT [FK_EngAssetPPMCheckListQuantasksMstDet_EngAssetPPMCheckList_PPMCheckListId]
GO
