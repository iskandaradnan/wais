USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSLinenRejectReplacementTxn]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSLinenRejectReplacementTxn] AS TABLE(
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[DocumentNo] [nvarchar](50) NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[CleanLinenIssueId] [int] NULL,
	[LLSUserAreaId] [int] NOT NULL,
	[LLSUserLocationId] [int] NULL,
	[RejectedBy] [int] NOT NULL,
	[ReplacementReceivedBy] [int] NOT NULL,
	[ReceivedDateTime] [datetime] NULL,
	[TotalQuantityRejected] [numeric](24, 2) NULL,
	[TotalQuantityReplaced] [numeric](24, 2) NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[ModifiedBy] [int] NOT NULL
)
GO
