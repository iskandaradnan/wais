USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[FinAmendmentFeeTxnDet]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FinAmendmentFeeTxnDet](
	[AmendmentFeeDetId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[AmendmentFeeId] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[FemsPMF] [numeric](10, 2) NOT NULL,
	[FemsNMF] [numeric](10, 2) NULL,
	[FemsCF] [numeric](10, 2) NULL,
	[BemsPMF] [numeric](10, 2) NOT NULL,
	[BemsNMF] [numeric](10, 2) NULL,
	[BemsCF] [numeric](10, 2) NULL,
	[CLSPMF] [numeric](10, 2) NOT NULL,
	[CLSNMF] [numeric](10, 2) NULL,
	[CLSCF] [numeric](10, 2) NULL,
	[MonthlyFeeDetId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_FinAmendmentFeeTxnDet] PRIMARY KEY CLUSTERED 
(
	[AmendmentFeeDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FinAmendmentFeeTxnDet] ADD  CONSTRAINT [DF_FinAmendmentFeeTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[FinAmendmentFeeTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_FinAmendmentFeeTxnDet_FinAmendmentFeeTxn_AmendmentFeeId] FOREIGN KEY([AmendmentFeeId])
REFERENCES [dbo].[FinAmendmentFeeTxn] ([AmendmentFeeId])
GO
ALTER TABLE [dbo].[FinAmendmentFeeTxnDet] CHECK CONSTRAINT [FK_FinAmendmentFeeTxnDet_FinAmendmentFeeTxn_AmendmentFeeId]
GO
ALTER TABLE [dbo].[FinAmendmentFeeTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_FinAmendmentFeeTxnDet_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[FinAmendmentFeeTxnDet] CHECK CONSTRAINT [FK_FinAmendmentFeeTxnDet_MstLocationFacility_FacilityId]
GO
