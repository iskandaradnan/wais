USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngTestingandCommissioningTxnDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngTestingandCommissioningTxnDet](
	[TestingandCommissioningDetId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NULL,
	[TestingandCommissioningId] [int] NOT NULL,
	[AssetPreRegistrationNo] [nvarchar](25) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngTestingandCommissioningTxnDet] PRIMARY KEY CLUSTERED 
(
	[TestingandCommissioningDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxnDet] ADD  CONSTRAINT [DF_EngTestingandCommissioningTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngTestingandCommissioningTxnDet_EngTestingandCommissioningTxn_TestingandCommissioningId] FOREIGN KEY([TestingandCommissioningId])
REFERENCES [dbo].[EngTestingandCommissioningTxn] ([TestingandCommissioningId])
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxnDet] CHECK CONSTRAINT [FK_EngTestingandCommissioningTxnDet_EngTestingandCommissioningTxn_TestingandCommissioningId]
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngTestingandCommissioningTxnDet_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxnDet] CHECK CONSTRAINT [FK_EngTestingandCommissioningTxnDet_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngTestingandCommissioningTxnDet_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxnDet] CHECK CONSTRAINT [FK_EngTestingandCommissioningTxnDet_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngTestingandCommissioningTxnDet_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxnDet] CHECK CONSTRAINT [FK_EngTestingandCommissioningTxnDet_MstService_ServiceId]
GO
