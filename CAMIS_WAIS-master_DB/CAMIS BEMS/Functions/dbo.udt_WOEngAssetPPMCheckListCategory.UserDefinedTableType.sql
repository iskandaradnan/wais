USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_WOEngAssetPPMCheckListCategory]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[udt_WOEngAssetPPMCheckListCategory] AS TABLE(
	[WOCategoryId] [int] NULL,
	[CategoryId] [int] NULL,
	[Status] [int] NULL,
	[Remarks] [nvarchar](1000) NULL,
	[UserId] [int] NULL
)
GO
