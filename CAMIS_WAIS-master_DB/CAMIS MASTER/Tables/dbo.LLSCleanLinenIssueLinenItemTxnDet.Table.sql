USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSCleanLinenIssueLinenItemTxnDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSCleanLinenIssueLinenItemTxnDet](
	[CLILinenItemId] [int] IDENTITY(1,1) NOT NULL,
	[CleanLinenIssueId] [int] NULL,
	[LinenitemId] [int] NOT NULL,
	[LinenitemId_test] [int] NULL,
	[RequestedQuantity] [int] NULL,
	[DeliveryIssuedQty1st] [int] NULL,
	[DeliveryIssuedQty2nd] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NULL,
	[unqkey] [varchar](500) NULL,
 CONSTRAINT [PK_LLSCleanLinenIssueLinenItemTxnDetNew] PRIMARY KEY CLUSTERED 
(
	[CLILinenItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
