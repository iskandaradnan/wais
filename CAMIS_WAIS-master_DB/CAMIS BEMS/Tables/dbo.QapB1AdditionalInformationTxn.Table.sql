USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[QapB1AdditionalInformationTxn]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QapB1AdditionalInformationTxn](
	[AdditionalInfoId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NULL,
	[CarId] [int] NULL,
	[AssetId] [int] NULL,
	[WorkOrderId] [int] NULL,
	[TargetDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[CauseCodeId] [int] NULL,
	[QcCodeId] [int] NULL,
 CONSTRAINT [PK_QapB1AdditionalInformationTxn] PRIMARY KEY CLUSTERED 
(
	[AdditionalInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QapB1AdditionalInformationTxn] ADD  CONSTRAINT [DF_QapB1AdditionalInformationTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[QapB1AdditionalInformationTxn]  WITH CHECK ADD  CONSTRAINT [FK_QapB1AdditionalInformationTxn_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[QapB1AdditionalInformationTxn] CHECK CONSTRAINT [FK_QapB1AdditionalInformationTxn_AssetId]
GO
ALTER TABLE [dbo].[QapB1AdditionalInformationTxn]  WITH CHECK ADD  CONSTRAINT [FK_QapB1AdditionalInformationTxn_EngMaintenanceWorkOrderTxn_WorkOrderId] FOREIGN KEY([WorkOrderId])
REFERENCES [dbo].[EngMaintenanceWorkOrderTxn] ([WorkOrderId])
GO
ALTER TABLE [dbo].[QapB1AdditionalInformationTxn] CHECK CONSTRAINT [FK_QapB1AdditionalInformationTxn_EngMaintenanceWorkOrderTxn_WorkOrderId]
GO
ALTER TABLE [dbo].[QapB1AdditionalInformationTxn]  WITH CHECK ADD  CONSTRAINT [FK_QapB1AdditionalInformationTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[QapB1AdditionalInformationTxn] CHECK CONSTRAINT [FK_QapB1AdditionalInformationTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[QapB1AdditionalInformationTxn]  WITH CHECK ADD  CONSTRAINT [FK_QapB1AdditionalInformationTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[QapB1AdditionalInformationTxn] CHECK CONSTRAINT [FK_QapB1AdditionalInformationTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[QapB1AdditionalInformationTxn]  WITH CHECK ADD  CONSTRAINT [FK_QapB1AdditionalInformationTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[QapB1AdditionalInformationTxn] CHECK CONSTRAINT [FK_QapB1AdditionalInformationTxn_MstService_ServiceId]
GO
ALTER TABLE [dbo].[QapB1AdditionalInformationTxn]  WITH CHECK ADD  CONSTRAINT [FK_QapB1AdditionalInformationTxn_QapCarTxn_CarId] FOREIGN KEY([CarId])
REFERENCES [dbo].[QAPCarTxn] ([CarId])
GO
ALTER TABLE [dbo].[QapB1AdditionalInformationTxn] CHECK CONSTRAINT [FK_QapB1AdditionalInformationTxn_QapCarTxn_CarId]
GO
