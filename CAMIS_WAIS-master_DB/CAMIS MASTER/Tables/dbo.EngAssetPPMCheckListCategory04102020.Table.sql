USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetPPMCheckListCategory04102020]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetPPMCheckListCategory04102020](
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
	[IsWorkOrder] [bit] NULL
) ON [PRIMARY]
GO
