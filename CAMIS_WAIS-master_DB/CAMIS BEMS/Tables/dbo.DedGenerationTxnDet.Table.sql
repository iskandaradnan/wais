USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[DedGenerationTxnDet]    Script Date: 20-09-2021 17:02:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DedGenerationTxnDet](
	[DedGenerationDetId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[DedGenerationId] [int] NULL,
	[IndicatorDetId] [int] NOT NULL,
	[TotalParameter] [numeric](15, 2) NULL,
	[DeductionValue] [numeric](24, 2) NULL,
	[DeductionPercentage] [numeric](6, 2) NULL,
	[TransactionDemeritPoint] [numeric](8, 2) NULL,
	[NcrDemeritPoint] [numeric](6, 2) NULL,
	[SubParameterDetId] [int] NULL,
	[PostTransactionDemeritPoint] [numeric](8, 2) NULL,
	[PostNcrDemeritPoint] [numeric](8, 2) NULL,
	[Remarks] [nvarchar](500) NULL,
	[keyIndicatorValue] [numeric](24, 2) NULL,
	[Ringittequivalent] [numeric](24, 2) NULL,
	[GearingRatio] [numeric](24, 2) NULL,
	[PostDeductionValue] [numeric](13, 2) NULL,
	[PostDeductionPercentage] [numeric](5, 2) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[YEAR] [int] NULL,
	[MONTH] [int] NULL,
	[NCRDeductionValue] [numeric](18, 2) NULL,
	[PostNCRDeductionValue] [numeric](18, 2) NULL,
 CONSTRAINT [PK_DedGenerationTxnDet] PRIMARY KEY CLUSTERED 
(
	[DedGenerationDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DedGenerationTxnDet] ADD  CONSTRAINT [DF_DedGenerationTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[DedGenerationTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_DedGenerationTxnDet_DedGenerationTxn_DedGenerationId] FOREIGN KEY([DedGenerationId])
REFERENCES [dbo].[DedGenerationTxn] ([DedGenerationId])
GO
ALTER TABLE [dbo].[DedGenerationTxnDet] CHECK CONSTRAINT [FK_DedGenerationTxnDet_DedGenerationTxn_DedGenerationId]
GO
ALTER TABLE [dbo].[DedGenerationTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_DedGenerationTxnDet_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[DedGenerationTxnDet] CHECK CONSTRAINT [FK_DedGenerationTxnDet_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[DedGenerationTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_DedGenerationTxnDet_MstDedIndicatorDet_IndicatorDetId] FOREIGN KEY([IndicatorDetId])
REFERENCES [dbo].[MstDedIndicatorDet] ([IndicatorDetId])
GO
ALTER TABLE [dbo].[DedGenerationTxnDet] CHECK CONSTRAINT [FK_DedGenerationTxnDet_MstDedIndicatorDet_IndicatorDetId]
GO
ALTER TABLE [dbo].[DedGenerationTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_DedGenerationTxnDet_MstDedSubParameterDet_SubParameterDetId] FOREIGN KEY([SubParameterDetId])
REFERENCES [dbo].[MstDedSubParameterDet] ([SubParameterDetId])
GO
ALTER TABLE [dbo].[DedGenerationTxnDet] CHECK CONSTRAINT [FK_DedGenerationTxnDet_MstDedSubParameterDet_SubParameterDetId]
GO
ALTER TABLE [dbo].[DedGenerationTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_DedGenerationTxnDet_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[DedGenerationTxnDet] CHECK CONSTRAINT [FK_DedGenerationTxnDet_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[DedGenerationTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_DedGenerationTxnDet_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[DedGenerationTxnDet] CHECK CONSTRAINT [FK_DedGenerationTxnDet_MstService_ServiceId]
GO
