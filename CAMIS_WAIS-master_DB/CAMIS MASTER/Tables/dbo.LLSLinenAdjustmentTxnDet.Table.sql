USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSLinenAdjustmentTxnDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSLinenAdjustmentTxnDet](
	[LinenAdjustmentDetId] [int] IDENTITY(1,1) NOT NULL,
	[LinenAdjustmentId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[LinenItemId] [int] NOT NULL,
	[ActualQuantity] [int] NOT NULL,
	[StoreBalance] [int] NULL,
	[AdjustQuantity] [int] NULL,
	[Justification] [nvarchar](150) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NULL,
	[StoreBalFlag] [int] NULL,
 CONSTRAINT [PK_LLSLinenAdjustmentTxnDet] PRIMARY KEY CLUSTERED 
(
	[LinenAdjustmentDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LLSLinenAdjustmentTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_LLSLinenAdjustmentTxnDet_LLSLinenAdjustmentTxn_LinenAdjustmentId] FOREIGN KEY([LinenAdjustmentId])
REFERENCES [dbo].[LLSLinenAdjustmentTxn] ([LinenAdjustmentId])
GO
ALTER TABLE [dbo].[LLSLinenAdjustmentTxnDet] CHECK CONSTRAINT [FK_LLSLinenAdjustmentTxnDet_LLSLinenAdjustmentTxn_LinenAdjustmentId]
GO
