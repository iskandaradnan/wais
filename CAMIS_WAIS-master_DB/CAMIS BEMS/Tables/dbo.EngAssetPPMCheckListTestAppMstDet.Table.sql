USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetPPMCheckListTestAppMstDet]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetPPMCheckListTestAppMstDet](
	[PPMCheckListTAppId] [int] IDENTITY(1,1) NOT NULL,
	[PPMCheckListId] [int] NOT NULL,
	[Description] [nvarchar](1000) NOT NULL,
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
 CONSTRAINT [PK_EngAssetPPMCheckListTestAppMstDet] PRIMARY KEY CLUSTERED 
(
	[PPMCheckListTAppId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListTestAppMstDet] ADD  CONSTRAINT [DF_EngAssetPPMCheckListTestAppMstDet_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListTestAppMstDet] ADD  CONSTRAINT [DF_EngAssetPPMCheckListTestAppMstDet_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListTestAppMstDet] ADD  CONSTRAINT [DF_EngAssetPPMCheckListTestAppMstDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListTestAppMstDet]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetPPMCheckListTestAppMstDet_EngAssetPPMCheckList_PPMCheckListId] FOREIGN KEY([PPMCheckListId])
REFERENCES [dbo].[EngAssetPPMCheckList] ([PPMCheckListId])
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListTestAppMstDet] CHECK CONSTRAINT [FK_EngAssetPPMCheckListTestAppMstDet_EngAssetPPMCheckList_PPMCheckListId]
GO
