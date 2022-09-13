USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_MstQAPQualityCauseDet]    Script Date: 20-09-2021 16:50:19 ******/
CREATE TYPE [dbo].[udt_MstQAPQualityCauseDet] AS TABLE(
	[QualityCauseDetId] [int] NULL,
	[QualityCauseId] [int] NULL,
	[ProblemCode] [int] NOT NULL,
	[QcCode] [nvarchar](25) NULL,
	[Details] [nvarchar](255) NULL,
	[Status] [int] NULL
)
GO
