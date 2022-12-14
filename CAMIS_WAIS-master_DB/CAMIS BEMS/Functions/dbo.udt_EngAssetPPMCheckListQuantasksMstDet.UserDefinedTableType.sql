USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngAssetPPMCheckListQuantasksMstDet]    Script Date: 20-09-2021 17:09:18 ******/
CREATE TYPE [dbo].[udt_EngAssetPPMCheckListQuantasksMstDet] AS TABLE(
	[PPMCheckListQNId] [int] NULL,
	[QuantitativeTasks] [nvarchar](2000) NULL,
	[UOM] [int] NULL,
	[SetValues] [nvarchar](20) NULL,
	[LimitTolerance] [nvarchar](20) NULL,
	[Active] [bit] NULL DEFAULT ((1))
)
GO
