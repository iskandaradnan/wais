USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[PorteringTransaction]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PorteringTransaction](
	[PorteringId] [int] IDENTITY(1,1) NOT NULL,
	[FromCustomerId] [int] NOT NULL,
	[FromFacilityId] [int] NOT NULL,
	[FromBlockId] [int] NOT NULL,
	[FromLevelId] [int] NOT NULL,
	[FromUserAreaId] [int] NOT NULL,
	[FromUserLocationId] [int] NOT NULL,
	[RequestorId] [int] NOT NULL,
	[RequestTypeLovId] [int] NOT NULL,
	[MovementCategory] [int] NOT NULL,
	[SubCategory] [int] NULL,
	[ModeOfTransport] [int] NOT NULL,
	[ToCustomerId] [int] NULL,
	[ToFacilityId] [int] NULL,
	[ToBlockId] [int] NULL,
	[ToLevelId] [int] NULL,
	[ToUserAreaId] [int] NULL,
	[ToUserLocationId] [int] NULL,
	[AssignPorterId] [int] NULL,
	[ConsignmentNo] [nvarchar](250) NULL,
	[PorteringStatus] [int] NULL,
	[ReceivedBy] [int] NULL,
	[CurrentWorkFlowId] [int] NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[AssetId] [int] NULL,
	[PorteringDate] [datetime] NULL,
	[PorteringNo] [nvarchar](50) NULL,
	[WorkOrderId] [int] NULL,
	[SupplierLovId] [int] NULL,
	[SupplierId] [int] NULL,
	[ScanAsset] [nvarchar](100) NULL,
	[ConsignmentDate] [datetime] NULL,
	[CourierName] [nvarchar](200) NULL,
	[WFStatusApprovedDate] [datetime] NULL,
	[LoanerTestEquipmentBookingId] [int] NULL,
	[MaintenanceWorkNo] [nvarchar](100) NULL,
	[MobileGuid] [nvarchar](max) NULL,
	[IsMailSent] [bit] NULL,
	[AssigneeLovId] [int] NULL,
	[SignImage] [varbinary](max) NULL,
 CONSTRAINT [PK_PorteringTransaction] PRIMARY KEY CLUSTERED 
(
	[PorteringId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PorteringTransaction] ADD  CONSTRAINT [DF_PorteringTransaction_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[PorteringTransaction]  WITH CHECK ADD  CONSTRAINT [FK_PorteringTransaction_EngLoanerTestEquipmentBookingTxn_LoanerTestEquipmentBookingId] FOREIGN KEY([LoanerTestEquipmentBookingId])
REFERENCES [dbo].[EngLoanerTestEquipmentBookingTxn] ([LoanerTestEquipmentBookingId])
GO
ALTER TABLE [dbo].[PorteringTransaction] CHECK CONSTRAINT [FK_PorteringTransaction_EngLoanerTestEquipmentBookingTxn_LoanerTestEquipmentBookingId]
GO
ALTER TABLE [dbo].[PorteringTransaction]  WITH CHECK ADD  CONSTRAINT [FK_PorteringTransaction_UMUserRegistration_AssignPorterId] FOREIGN KEY([AssignPorterId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[PorteringTransaction] CHECK CONSTRAINT [FK_PorteringTransaction_UMUserRegistration_AssignPorterId]
GO
