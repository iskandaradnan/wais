USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngAssetPPMCheckListQualTasksMstDet]    Script Date: 20-09-2021 17:00:55 ******/
CREATE TYPE [dbo].[udt_EngAssetPPMCheckListQualTasksMstDet] AS TABLE(
	[PPMCheckListQualTasksId] [int] NULL,
	[QualTasks] [nvarchar](2000) NULL,
	[Active] [bit] NULL DEFAULT ((1))
)
GO
