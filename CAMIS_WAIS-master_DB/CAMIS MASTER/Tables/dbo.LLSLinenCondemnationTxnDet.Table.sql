USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSLinenCondemnationTxnDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSLinenCondemnationTxnDet](
	[LinenCondemnationDetId] [int] IDENTITY(1,1) NOT NULL,
	[LinenCondemnationId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[LinenItemId] [int] NULL,
	[BatchNo] [nvarchar](25) NULL,
	[Total] [int] NULL,
	[Torn] [int] NULL,
	[Stained] [int] NULL,
	[Faded] [int] NULL,
	[Vandalism] [int] NULL,
	[WearTear] [int] NULL,
	[StainedByChemical] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [int] NULL,
 CONSTRAINT [PK_LLSLinenCondemnationTxnDet] PRIMARY KEY CLUSTERED 
(
	[LinenCondemnationDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LLSLinenCondemnationTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_LLSLinenCondemnationTxnDet_LLSLinenCondemnationTxn_LinenCondemnationId] FOREIGN KEY([LinenCondemnationId])
REFERENCES [dbo].[LLSLinenCondemnationTxn] ([LinenCondemnationId])
GO
ALTER TABLE [dbo].[LLSLinenCondemnationTxnDet] CHECK CONSTRAINT [FK_LLSLinenCondemnationTxnDet_LLSLinenCondemnationTxn_LinenCondemnationId]
GO
