USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngAssetPPMCheckListCategory]    Script Date: 20-09-2021 17:09:18 ******/
CREATE TYPE [dbo].[udt_EngAssetPPMCheckListCategory] AS TABLE(
	[CategoryId] [int] NULL,
	[PPMCheckListId] [int] NULL,
	[PPMCheckListCategoryId] [int] NULL,
	[Number] [int] NULL,
	[Description] [nvarchar](1000) NULL,
	[IsWorkOrder] [bit] NULL,
	[Active] [bit] NULL DEFAULT ((1)),
	[BuiltIn] [bit] NULL DEFAULT ((1))
)
GO
