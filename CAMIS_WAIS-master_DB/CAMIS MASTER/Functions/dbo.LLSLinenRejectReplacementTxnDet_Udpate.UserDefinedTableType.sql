USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSLinenRejectReplacementTxnDet_Udpate]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSLinenRejectReplacementTxnDet_Udpate] AS TABLE(
	[Ql01aTapeGlue] [int] NULL,
	[Ql01bChemical] [int] NULL,
	[Ql01cBlood] [int] NULL,
	[Ql01dPermanentStain] [int] NULL,
	[Ql02TornPatches] [int] NULL,
	[Ql03Button] [int] NULL,
	[Ql04String] [int] NULL,
	[Ql05Odor] [int] NULL,
	[Ql06aFaded] [int] NULL,
	[Ql06bThinMaterial] [int] NULL,
	[Ql06cWornOut] [int] NULL,
	[Ql06d3YrsOld] [int] NULL,
	[Ql07Shrink] [int] NULL,
	[Ql08Crumple] [int] NULL,
	[Ql09Lint] [int] NULL,
	[TotalRejectedQuantity] [int] NULL,
	[ReplacedQuantity] [int] NULL,
	[ReplacedDateTime] [datetime] NULL,
	[Remarks] [nvarchar](500) NULL,
	[LinenRejectReplacementDetId] [int] NULL,
	[ModifiedBy] [int] NOT NULL
)
GO
