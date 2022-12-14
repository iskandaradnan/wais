USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSLinenRejectReplacementTxn]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSLinenRejectReplacementTxn](
	[LinenRejectReplacementId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[DocumentNo] [nvarchar](50) NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[CleanLinenIssueId] [int] NULL,
	[CLIDescription] [nvarchar](500) NULL,
	[LLSUserAreaId] [int] NOT NULL,
	[LLSUserLocationId] [int] NULL,
	[RejectedBy] [int] NOT NULL,
	[ReplacementReceivedBy] [int] NOT NULL,
	[ReceivedDateTime] [datetime] NULL,
	[TotalQuantityRejected] [numeric](24, 2) NULL,
	[TotalQuantityReplaced] [numeric](24, 2) NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_LLSLinenRejectReplacementDetailsTxn] PRIMARY KEY CLUSTERED 
(
	[LinenRejectReplacementId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
