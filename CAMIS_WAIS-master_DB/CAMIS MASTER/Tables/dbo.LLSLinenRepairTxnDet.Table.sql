USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSLinenRepairTxnDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSLinenRepairTxnDet](
	[LinenRepairDetId] [int] IDENTITY(1,1) NOT NULL,
	[LinenRepairId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[LinenItemId] [int] NULL,
	[RepairQuantity] [numeric](24, 2) NULL,
	[RepairCompletedQuantity] [numeric](24, 2) NULL,
	[DescriptionOfProblem] [varchar](100) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [int] NULL,
	[BalanceRepairQuantity] [numeric](24, 2) NULL,
 CONSTRAINT [PK_LLSLinenRepairTxnDet] PRIMARY KEY CLUSTERED 
(
	[LinenRepairDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LLSLinenRepairTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_LLSLinenRepairTxnDet_LLSLinenRepairTxn_LinenRepairId] FOREIGN KEY([LinenRepairId])
REFERENCES [dbo].[LLSLinenRepairTxn] ([LinenRepairId])
GO
ALTER TABLE [dbo].[LLSLinenRepairTxnDet] CHECK CONSTRAINT [FK_LLSLinenRepairTxnDet_LLSLinenRepairTxn_LinenRepairId]
GO
