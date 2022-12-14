USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[DedGenerationParameterTxnDet]    Script Date: 20-09-2021 17:02:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DedGenerationParameterTxnDet](
	[DedGenerationPDetId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[DedGenerationId] [int] NOT NULL,
	[IndicatorDetId] [int] NOT NULL,
	[Parameter] [nvarchar](500) NOT NULL,
	[ParameterValue] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DedGenerationParameterTxnDet] PRIMARY KEY CLUSTERED 
(
	[DedGenerationPDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DedGenerationParameterTxnDet] ADD  CONSTRAINT [DF_DedGenerationParameterTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[DedGenerationParameterTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_DedGenerationParameterTxnDet_DedGenerationTxn_DedGenerationId] FOREIGN KEY([DedGenerationId])
REFERENCES [dbo].[DedGenerationTxn] ([DedGenerationId])
GO
ALTER TABLE [dbo].[DedGenerationParameterTxnDet] CHECK CONSTRAINT [FK_DedGenerationParameterTxnDet_DedGenerationTxn_DedGenerationId]
GO
ALTER TABLE [dbo].[DedGenerationParameterTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_DedGenerationParameterTxnDet_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[DedGenerationParameterTxnDet] CHECK CONSTRAINT [FK_DedGenerationParameterTxnDet_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[DedGenerationParameterTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_DedGenerationParameterTxnDet_MstDedIndicatorDet_IndicatorDetId] FOREIGN KEY([IndicatorDetId])
REFERENCES [dbo].[MstDedIndicatorDet] ([IndicatorDetId])
GO
ALTER TABLE [dbo].[DedGenerationParameterTxnDet] CHECK CONSTRAINT [FK_DedGenerationParameterTxnDet_MstDedIndicatorDet_IndicatorDetId]
GO
ALTER TABLE [dbo].[DedGenerationParameterTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_DedGenerationParameterTxnDet_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[DedGenerationParameterTxnDet] CHECK CONSTRAINT [FK_DedGenerationParameterTxnDet_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[DedGenerationParameterTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_DedGenerationParameterTxnDet_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[DedGenerationParameterTxnDet] CHECK CONSTRAINT [FK_DedGenerationParameterTxnDet_MstService_ServiceId]
GO
