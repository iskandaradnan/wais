USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[EngAssetTypeCodeStandardTasksType]    Script Date: 20-09-2021 17:00:54 ******/
CREATE TYPE [dbo].[EngAssetTypeCodeStandardTasksType] AS TABLE(
	[StandardTaskDetId] [int] NULL,
	[TaskCode] [varchar](max) NULL,
	[TaskDescription] [varchar](max) NULL,
	[ModelId] [int] NULL,
	[PPMId] [int] NULL,
	[OGWI] [varchar](max) NULL,
	[EffectiveFrom] [datetime] NULL,
	[Active] [int] NULL,
	[Status] [int] NULL
)
GO
