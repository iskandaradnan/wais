USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetPPMCheckListCategoryWorkOrder]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetPPMCheckListCategoryWorkOrder](
	[WOCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[WOPPMCheckListId] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
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
 CONSTRAINT [PK_EngAssetPPMCheckListCategoryWorkOrder] PRIMARY KEY CLUSTERED 
(
	[WOCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListCategoryWorkOrder] ADD  CONSTRAINT [DF_EngAssetPPMCheckListCategoryWorkOrder_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListCategoryWorkOrder] ADD  CONSTRAINT [DF_EngAssetPPMCheckListCategoryWorkOrder_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListCategoryWorkOrder] ADD  CONSTRAINT [DF_EngAssetPPMCheckListCategoryWorkOrder_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListCategoryWorkOrder]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetPPMCheckListCategoryWorkOrder_EngAssetPPMCheckListCategory_CategoryId] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[EngAssetPPMCheckListCategory] ([CategoryId])
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListCategoryWorkOrder] CHECK CONSTRAINT [FK_EngAssetPPMCheckListCategoryWorkOrder_EngAssetPPMCheckListCategory_CategoryId]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListCategoryWorkOrder]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetPPMCheckListCategoryWorkOrder_EngAssetPPMCheckListWorkOrder_WOPPMCheckListId] FOREIGN KEY([WOPPMCheckListId])
REFERENCES [dbo].[EngAssetPPMCheckListWorkOrder] ([WOPPMCheckListId])
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListCategoryWorkOrder] CHECK CONSTRAINT [FK_EngAssetPPMCheckListCategoryWorkOrder_EngAssetPPMCheckListWorkOrder_WOPPMCheckListId]
GO
