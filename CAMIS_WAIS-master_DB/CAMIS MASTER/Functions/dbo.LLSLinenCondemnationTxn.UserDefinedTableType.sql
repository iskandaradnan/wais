USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSLinenCondemnationTxn]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSLinenCondemnationTxn] AS TABLE(
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[DocumentNo] [nvarchar](50) NOT NULL,
	[DocumentDate] [datetime] NOT NULL,
	[InspectedBy] [int] NULL,
	[VerifiedBy] [int] NULL,
	[TotalCondemns] [int] NOT NULL,
	[Value] [numeric](24, 2) NULL,
	[LocationOfCondemnation] [nvarchar](25) NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[ModifiedBy] [int] NOT NULL
)
GO
