USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[VmVariationTxnDet]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VmVariationTxnDet](
	[VariationDetId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[VariationId] [int] NOT NULL,
	[VariationWFStatus] [int] NULL,
	[DoneBy] [int] NULL,
	[DoneDate] [datetime] NULL,
	[DoneRemarks] [nvarchar](500) NULL,
	[IsVerify] [bit] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_VmVariationTxnDet] PRIMARY KEY CLUSTERED 
(
	[VariationDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VmVariationTxnDet] ADD  CONSTRAINT [DF_VmVariationTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[VmVariationTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_VmVariationTxnDet_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[VmVariationTxnDet] CHECK CONSTRAINT [FK_VmVariationTxnDet_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[VmVariationTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_VmVariationTxnDet_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[VmVariationTxnDet] CHECK CONSTRAINT [FK_VmVariationTxnDet_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[VmVariationTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_VmVariationTxnDet_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[VmVariationTxnDet] CHECK CONSTRAINT [FK_VmVariationTxnDet_MstService_ServiceId]
GO
ALTER TABLE [dbo].[VmVariationTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_VmVariationTxnDet_UMUserRegistration_DoneBy] FOREIGN KEY([DoneBy])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[VmVariationTxnDet] CHECK CONSTRAINT [FK_VmVariationTxnDet_UMUserRegistration_DoneBy]
GO
ALTER TABLE [dbo].[VmVariationTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_VmVariationTxnDet_VmVariationTxn_VariationId] FOREIGN KEY([VariationId])
REFERENCES [dbo].[VmVariationTxn] ([VariationId])
GO
ALTER TABLE [dbo].[VmVariationTxnDet] CHECK CONSTRAINT [FK_VmVariationTxnDet_VmVariationTxn_VariationId]
GO
