USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_WOEngAssetPPMCheckListQuantasksMstDet]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[udt_WOEngAssetPPMCheckListQuantasksMstDet] AS TABLE(
	[WOPPMCheckListQNId] [int] NULL,
	[PPMCheckListQNId] [int] NULL,
	[Value] [nvarchar](1000) NULL,
	[Status] [int] NULL,
	[Remarks] [nvarchar](1000) NULL,
	[UserId] [int] NULL
)
GO
