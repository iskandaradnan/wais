USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngAssetPPMCheckListStatusHistoryMst]    Script Date: 20-09-2021 17:09:18 ******/
CREATE TYPE [dbo].[udt_EngAssetPPMCheckListStatusHistoryMst] AS TABLE(
	[PPMCheckListStatusHistoryId] [int] NULL,
	[PPMCheckListId] [int] NULL,
	[DoneBy] [int] NULL,
	[Date] [datetime] NULL,
	[Status] [int] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedBy] [int] NULL,
	[Active] [bit] NULL DEFAULT ((1)),
	[BuiltIn] [bit] NULL DEFAULT ((1))
)
GO
