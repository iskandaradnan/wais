USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngAssetPPMCheckListTestAppMstDet]    Script Date: 20-09-2021 17:09:18 ******/
CREATE TYPE [dbo].[udt_EngAssetPPMCheckListTestAppMstDet] AS TABLE(
	[PPMCheckListTAppId] [int] NULL,
	[Description] [nvarchar](2000) NULL,
	[Active] [bit] NULL DEFAULT ((1))
)
GO
