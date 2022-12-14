USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSLinenRejectReplacementTxnDet]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSLinenRejectReplacementTxnDet] AS TABLE(
	[LinenRejectReplacementId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[LinenItemId] [int] NOT NULL,
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
	[ReplacedQuantity] [int] NOT NULL,
	[ReplacedDateTime] [datetime] NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL
)
GO
