USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngAssetPPMCheckListStatusHistoryMst]    Script Date: 20-09-2021 16:50:19 ******/
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
