USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[WpmTechServicePerfTxnDet]    Script Date: 20-09-2021 16:25:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WpmTechServicePerfTxnDet](
	[TechServicePerfDetId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[TechServicePerfId] [int] NOT NULL,
	[ItemId] [int] NULL,
	[IsApplicable] [bit] NULL,
	[IsVerified] [bit] NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_TechServicePerfDetId] PRIMARY KEY CLUSTERED 
(
	[TechServicePerfDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WpmTechServicePerfTxnDet] ADD  DEFAULT ((0)) FOR [IsApplicable]
GO
ALTER TABLE [dbo].[WpmTechServicePerfTxnDet] ADD  DEFAULT ((0)) FOR [IsVerified]
GO
ALTER TABLE [dbo].[WpmTechServicePerfTxnDet] ADD  CONSTRAINT [DF_WpmTechServicePerfTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[WpmTechServicePerfTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_WpmTechServicePerfTxnDet_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[WpmTechServicePerfTxnDet] CHECK CONSTRAINT [FK_WpmTechServicePerfTxnDet_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[WpmTechServicePerfTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_WpmTechServicePerfTxnDet_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[WpmTechServicePerfTxnDet] CHECK CONSTRAINT [FK_WpmTechServicePerfTxnDet_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[WpmTechServicePerfTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_WpmTechServicePerfTxnDet_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[WpmTechServicePerfTxnDet] CHECK CONSTRAINT [FK_WpmTechServicePerfTxnDet_MstService_ServiceId]
GO
ALTER TABLE [dbo].[WpmTechServicePerfTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_WpmTechServicePerfTxnDet_WpmTechServicePerfAssessmentItem_ItemId] FOREIGN KEY([ItemId])
REFERENCES [dbo].[WpmTechServicePerfAssessmentItem] ([ItemId])
GO
ALTER TABLE [dbo].[WpmTechServicePerfTxnDet] CHECK CONSTRAINT [FK_WpmTechServicePerfTxnDet_WpmTechServicePerfAssessmentItem_ItemId]
GO
ALTER TABLE [dbo].[WpmTechServicePerfTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_WpmTechServicePerfTxnDet_WpmTechServicePerfTxn_TechServicePerfId] FOREIGN KEY([TechServicePerfId])
REFERENCES [dbo].[WpmTechServicePerfTxn] ([TechServicePerfId])
GO
ALTER TABLE [dbo].[WpmTechServicePerfTxnDet] CHECK CONSTRAINT [FK_WpmTechServicePerfTxnDet_WpmTechServicePerfTxn_TechServicePerfId]
GO
