USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSLinenCondemnationTxnDet]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSLinenCondemnationTxnDet] AS TABLE(
	[LinenCondemnationId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[LinenItemId] [int] NULL,
	[BatchNo] [nvarchar](25) NULL,
	[Total] [int] NULL,
	[Torn] [int] NULL,
	[Stained] [int] NULL,
	[Faded] [int] NULL,
	[Vandalism] [int] NULL,
	[WearTear] [int] NULL,
	[StainedByChemical] [int] NULL,
	[CreatedBy] [int] NOT NULL
)
GO
