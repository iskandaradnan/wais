USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSCleanLinenRequestTxn]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSCleanLinenRequestTxn] AS TABLE(
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[DocumentNo] [nvarchar](50) NOT NULL,
	[RequestDateTime] [datetime] NOT NULL,
	[LLSUserAreaId] [int] NOT NULL,
	[LLSUserAreaLocationId] [int] NOT NULL,
	[RequestedBy] [int] NOT NULL,
	[Priority] [int] NOT NULL,
	[TotalItemRequested] [int] NULL,
	[TotalBagRequested] [int] NULL,
	[IssueStatus] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[ModifiedBy] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL
)
GO
