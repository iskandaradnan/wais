USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSLinenRejectReplacementTxnDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSLinenRejectReplacementTxnDet](
	[LinenRejectReplacementDetId] [int] IDENTITY(1,1) NOT NULL,
	[LinenRejectReplacementId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[LinenItemId] [int] NOT NULL,
	[Ql01aTapeGlue] [int] NULL,
	[Ql01bChemical] [int] NULL,
	[Ql01cBlood] [int] NULL,
	[Ql01dPermanentStain] [int] NULL,
	[Ql02TornPatches] [int] NULL,
	[Ql03Button] [int] NULL,
	[Ql04String] [int] NULL,
	[Ql05Odor] [int] NULL,
	[Ql06aFaded] [int] NULL,
	[Ql06bThinMaterial] [int] NULL,
	[Ql06cWornOut] [int] NULL,
	[Ql06d3YrsOld] [int] NULL,
	[Ql07Shrink] [int] NULL,
	[Ql08Crumple] [int] NULL,
	[Ql09Lint] [int] NULL,
	[TotalRejectedQuantity] [int] NULL,
	[ReplacedQuantity] [int] NOT NULL,
	[ReplacedDateTime] [datetime] NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [int] NULL,
 CONSTRAINT [PK_LLSLinenRejectReplacementDetailsTxnDet] PRIMARY KEY CLUSTERED 
(
	[LinenRejectReplacementDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LLSLinenRejectReplacementTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_LLSLinenRejectReplacementTxnDet_LLSLinenRejectReplacementTxn_LinenRejectReplacementId] FOREIGN KEY([LinenRejectReplacementId])
REFERENCES [dbo].[LLSLinenRejectReplacementTxn] ([LinenRejectReplacementId])
GO
ALTER TABLE [dbo].[LLSLinenRejectReplacementTxnDet] CHECK CONSTRAINT [FK_LLSLinenRejectReplacementTxnDet_LLSLinenRejectReplacementTxn_LinenRejectReplacementId]
GO
