USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngAssetPPMCheckListQualTasksMstDet]    Script Date: 20-09-2021 17:09:18 ******/
CREATE TYPE [dbo].[udt_EngAssetPPMCheckListQualTasksMstDet] AS TABLE(
	[PPMCheckListQualTasksId] [int] NULL,
	[QualTasks] [nvarchar](2000) NULL,
	[Active] [bit] NULL DEFAULT ((1))
)
GO
