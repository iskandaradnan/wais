USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSCleanLinenRequestTxn]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSCleanLinenRequestTxn](
	[CleanLinenRequestId] [int] IDENTITY(1,1) NOT NULL,
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
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[IsDeleted] [bit] NULL,
	[TxnStatus] [int] NULL,
 CONSTRAINT [PK_LLSCleanLinenRequestTxnNew] PRIMARY KEY CLUSTERED 
(
	[CleanLinenRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LLSCleanLinenRequestTxn] ADD  CONSTRAINT [DF_LLSCleanLinenRequestTxn_GuIdNew]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[LLSCleanLinenRequestTxn] ADD  DEFAULT ((10103)) FOR [TxnStatus]
GO
