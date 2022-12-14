USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngLoanerTestEquipmentBookingTxn]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngLoanerTestEquipmentBookingTxn](
	[LoanerTestEquipmentBookingId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[AssetId] [int] NOT NULL,
	[WorkOrderId] [int] NULL,
	[BookingStartFrom] [datetime] NOT NULL,
	[BookingEnd] [datetime] NOT NULL,
	[MovementCategory] [int] NOT NULL,
	[ToFacility] [int] NOT NULL,
	[ToBlock] [int] NOT NULL,
	[ToLevel] [int] NOT NULL,
	[ToUserArea] [int] NOT NULL,
	[ToUserLocation] [int] NOT NULL,
	[RequestorId] [int] NOT NULL,
	[RequestType] [int] NOT NULL,
	[BookingStatus] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[IsMailSent] [bit] NULL,
 CONSTRAINT [PK_LoanerTestEquipmentBookingId] PRIMARY KEY CLUSTERED 
(
	[LoanerTestEquipmentBookingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngLoanerTestEquipmentBookingTxn] ADD  CONSTRAINT [DF_EngLoanerTestEquipmentBooking_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngLoanerTestEquipmentBookingTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngLoanerTestEquipmentBooking_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngLoanerTestEquipmentBookingTxn] CHECK CONSTRAINT [FK_EngLoanerTestEquipmentBooking_CustomerId]
GO
ALTER TABLE [dbo].[EngLoanerTestEquipmentBookingTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngLoanerTestEquipmentBooking_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[EngLoanerTestEquipmentBookingTxn] CHECK CONSTRAINT [FK_EngLoanerTestEquipmentBooking_EngAsset_AssetId]
GO
ALTER TABLE [dbo].[EngLoanerTestEquipmentBookingTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngLoanerTestEquipmentBooking_EngMaintenanceWorkOrderTxn_WorkOrderId] FOREIGN KEY([WorkOrderId])
REFERENCES [dbo].[EngMaintenanceWorkOrderTxn] ([WorkOrderId])
GO
ALTER TABLE [dbo].[EngLoanerTestEquipmentBookingTxn] CHECK CONSTRAINT [FK_EngLoanerTestEquipmentBooking_EngMaintenanceWorkOrderTxn_WorkOrderId]
GO
ALTER TABLE [dbo].[EngLoanerTestEquipmentBookingTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngLoanerTestEquipmentBooking_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngLoanerTestEquipmentBookingTxn] CHECK CONSTRAINT [FK_EngLoanerTestEquipmentBooking_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngLoanerTestEquipmentBookingTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngLoanerTestEquipmentBooking_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngLoanerTestEquipmentBookingTxn] CHECK CONSTRAINT [FK_EngLoanerTestEquipmentBooking_MstService_ServiceId]
GO
