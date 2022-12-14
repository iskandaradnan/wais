USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSLinenInventoryTxnDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSLinenInventoryTxnDet](
	[LlsLinenInventoryTxnDetId] [int] IDENTITY(1,1) NOT NULL,
	[LinenInventoryId] [int] NOT NULL,
	[LinenItemId] [int] NOT NULL,
	[InUse] [numeric](18, 0) NULL,
	[Shelf] [numeric](18, 0) NULL,
	[CCLSInUse] [numeric](18, 0) NULL,
	[CCLSShelf] [numeric](18, 0) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[LLSUserAreaLocationId] [int] NULL,
 CONSTRAINT [PK_LLSLinenInventoryTxnDet] PRIMARY KEY CLUSTERED 
(
	[LlsLinenInventoryTxnDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LLSLinenInventoryTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_LLSLinenInventoryTxnDet_LLSLinenInventoryTxn_LinenInventoryId] FOREIGN KEY([LinenInventoryId])
REFERENCES [dbo].[LLSLinenInventoryTxn] ([LinenInventoryId])
GO
ALTER TABLE [dbo].[LLSLinenInventoryTxnDet] CHECK CONSTRAINT [FK_LLSLinenInventoryTxnDet_LLSLinenInventoryTxn_LinenInventoryId]
GO
