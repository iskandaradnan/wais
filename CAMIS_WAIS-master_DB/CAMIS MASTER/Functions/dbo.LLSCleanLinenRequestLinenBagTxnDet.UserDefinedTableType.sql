USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSCleanLinenRequestLinenBagTxnDet]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSCleanLinenRequestLinenBagTxnDet] AS TABLE(
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[CleanLinenRequestId] [int] NOT NULL,
	[CleanLinenIssueId] [int] NULL,
	[LaundryBag] [int] NOT NULL,
	[RequestedQuantity] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL
)
GO
