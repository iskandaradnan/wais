USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetPPMCheckListStatusHistoryMst]    Script Date: 20-09-2021 16:53:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetPPMCheckListStatusHistoryMst](
	[PPMCheckListStatusHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[PPMCheckListId] [int] NOT NULL,
	[DoneBy] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[Status] [int] NOT NULL,
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
 CONSTRAINT [PK_EngAssetPPMCheckListStatusHistoryMst] PRIMARY KEY CLUSTERED 
(
	[PPMCheckListStatusHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListStatusHistoryMst] ADD  CONSTRAINT [DF_EngAssetPPMCheckListStatusHistoryMst_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListStatusHistoryMst] ADD  CONSTRAINT [DF_EngAssetPPMCheckListStatusHistoryMst_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListStatusHistoryMst] ADD  CONSTRAINT [DF_EngAssetPPMCheckListStatusHistoryMst_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListStatusHistoryMst]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetPPMCheckListStatusHistoryMst_EngAssetPPMCheckList_PPMCheckListId] FOREIGN KEY([PPMCheckListId])
REFERENCES [dbo].[EngAssetPPMCheckList] ([PPMCheckListId])
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListStatusHistoryMst] CHECK CONSTRAINT [FK_EngAssetPPMCheckListStatusHistoryMst_EngAssetPPMCheckList_PPMCheckListId]
GO
