USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[DeductionTransactionMappingMst]    Script Date: 20-09-2021 16:53:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeductionTransactionMappingMst](
	[DedTxnMappingId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[DedGenerationId] [int] NULL,
	[IndicatorDetId] [int] NOT NULL,
	[Group] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[IsAdjustmentSaved] [int] NULL,
 CONSTRAINT [PK_DeductionTransactionMappingMst] PRIMARY KEY CLUSTERED 
(
	[DedTxnMappingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DeductionTransactionMappingMst] ADD  CONSTRAINT [DF_DeductionTransactionMappingMst_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[DeductionTransactionMappingMst] ADD  DEFAULT ((0)) FOR [IsAdjustmentSaved]
GO
