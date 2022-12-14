USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetPPMCheckListCategory]    Script Date: 20-09-2021 16:53:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetPPMCheckListCategory](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[PPMCheckListId] [int] NOT NULL,
	[PPMCheckListCategoryId] [int] NULL,
	[Number] [int] NULL,
	[Description] [nvarchar](1000) NULL,
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
	[IsWorkOrder] [bit] NULL,
 CONSTRAINT [PK_EngAssetPPMCheckListCategory] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListCategory] ADD  CONSTRAINT [DF_EngAssetPPMCheckListCategory_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListCategory]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetPPMCheckListCategory_EngAssetPPMCheckList_PPMCheckListId] FOREIGN KEY([PPMCheckListId])
REFERENCES [dbo].[EngAssetPPMCheckList] ([PPMCheckListId])
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListCategory] CHECK CONSTRAINT [FK_EngAssetPPMCheckListCategory_EngAssetPPMCheckList_PPMCheckListId]
GO
