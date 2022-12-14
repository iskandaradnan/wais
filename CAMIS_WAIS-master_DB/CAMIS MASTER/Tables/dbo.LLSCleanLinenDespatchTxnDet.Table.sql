USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSCleanLinenDespatchTxnDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSCleanLinenDespatchTxnDet](
	[CleanLinenDespatchDetId] [int] IDENTITY(1,1) NOT NULL,
	[CleanLinenDespatchId] [int] NOT NULL,
	[LinenItemId] [int] NOT NULL,
	[ReceivedQuantity] [int] NOT NULL,
	[DespatchedQuantity] [int] NOT NULL,
	[Variance] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NULL,
	[LinenDescription] [nvarchar](500) NULL,
 CONSTRAINT [PK_LLSCleanLinenDespatchTxnDetNew] PRIMARY KEY CLUSTERED 
(
	[CleanLinenDespatchDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LLSCleanLinenDespatchTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_LLSCleanLinenDespatchTxnDet_LLSCleanLinenDespatchTxn_CleanLinenDespatchIdNew] FOREIGN KEY([CleanLinenDespatchId])
REFERENCES [dbo].[LLSCleanLinenDespatchTxn] ([CleanLinenDespatchId])
GO
ALTER TABLE [dbo].[LLSCleanLinenDespatchTxnDet] CHECK CONSTRAINT [FK_LLSCleanLinenDespatchTxnDet_LLSCleanLinenDespatchTxn_CleanLinenDespatchIdNew]
GO
ALTER TABLE [dbo].[LLSCleanLinenDespatchTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_LLSCleanLinenDespatchTxnDet_LLSLinenItemDetailsMstNew] FOREIGN KEY([LinenItemId])
REFERENCES [dbo].[LLSLinenItemDetailsMst] ([LinenItemId])
GO
ALTER TABLE [dbo].[LLSCleanLinenDespatchTxnDet] CHECK CONSTRAINT [FK_LLSCleanLinenDespatchTxnDet_LLSLinenItemDetailsMstNew]
GO
