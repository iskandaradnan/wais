USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngAssetPPMCheckListMaintTasksMstDet]    Script Date: 20-09-2021 17:00:55 ******/
CREATE TYPE [dbo].[udt_EngAssetPPMCheckListMaintTasksMstDet] AS TABLE(
	[PPMCheckListQTId] [int] NULL,
	[QualitativeTasks] [nvarchar](2000) NULL,
	[Active] [bit] NULL DEFAULT ((1))
)
GO
