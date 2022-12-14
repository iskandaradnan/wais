USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[CRMRequestWorkOrderTxn]    Script Date: 20-09-2021 17:02:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CRMRequestWorkOrderTxn](
	[CRMRequestWOId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[CRMWorkOrderNo] [nvarchar](50) NOT NULL,
	[CRMWorkOrderDateTime] [datetime] NOT NULL,
	[CRMWorkOrderDateTimeUTC] [datetime] NOT NULL,
	[Description] [nvarchar](500) NULL,
	[TypeOfRequest] [int] NOT NULL,
	[CRMRequestId] [int] NULL,
	[AssetId] [int] NULL,
	[AssignedUserId] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[ManufacturerId] [int] NULL,
	[ModelId] [int] NULL,
	[Status] [int] NULL,
	[UserAreaId] [int] NULL,
	[UserLocationId] [int] NULL,
	[MasterGuid] [nvarchar](max) NULL,
 CONSTRAINT [PK_CRMRequestWorkOrderTxn] PRIMARY KEY CLUSTERED 
(
	[CRMRequestWOId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[CRMRequestWorkOrderTxn] ADD  CONSTRAINT [DF_CRMRequestWorkOrderTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[CRMRequestWorkOrderTxn]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestWorkOrderTxn_CRMRequest_CRMRequestId] FOREIGN KEY([CRMRequestId])
REFERENCES [dbo].[CRMRequest] ([CRMRequestId])
GO
ALTER TABLE [dbo].[CRMRequestWorkOrderTxn] CHECK CONSTRAINT [FK_CRMRequestWorkOrderTxn_CRMRequest_CRMRequestId]
GO
ALTER TABLE [dbo].[CRMRequestWorkOrderTxn]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestWorkOrderTxn_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[CRMRequestWorkOrderTxn] CHECK CONSTRAINT [FK_CRMRequestWorkOrderTxn_EngAsset_AssetId]
GO
ALTER TABLE [dbo].[CRMRequestWorkOrderTxn]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestWorkOrderTxn_EngAssetStandardizationManufacturer_ManufacturerId] FOREIGN KEY([ManufacturerId])
REFERENCES [dbo].[EngAssetStandardizationManufacturer] ([ManufacturerId])
GO
ALTER TABLE [dbo].[CRMRequestWorkOrderTxn] CHECK CONSTRAINT [FK_CRMRequestWorkOrderTxn_EngAssetStandardizationManufacturer_ManufacturerId]
GO
ALTER TABLE [dbo].[CRMRequestWorkOrderTxn]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestWorkOrderTxn_EngAssetStandardizationModel_ModelId] FOREIGN KEY([ModelId])
REFERENCES [dbo].[EngAssetStandardizationModel] ([ModelId])
GO
ALTER TABLE [dbo].[CRMRequestWorkOrderTxn] CHECK CONSTRAINT [FK_CRMRequestWorkOrderTxn_EngAssetStandardizationModel_ModelId]
GO
ALTER TABLE [dbo].[CRMRequestWorkOrderTxn]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestWorkOrderTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[CRMRequestWorkOrderTxn] CHECK CONSTRAINT [FK_CRMRequestWorkOrderTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[CRMRequestWorkOrderTxn]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestWorkOrderTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[CRMRequestWorkOrderTxn] CHECK CONSTRAINT [FK_CRMRequestWorkOrderTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[CRMRequestWorkOrderTxn]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestWorkOrderTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[CRMRequestWorkOrderTxn] CHECK CONSTRAINT [FK_CRMRequestWorkOrderTxn_MstService_ServiceId]
GO
ALTER TABLE [dbo].[CRMRequestWorkOrderTxn]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestWorkOrderTxn_UMUserRegistration_AssignedUserId] FOREIGN KEY([AssignedUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[CRMRequestWorkOrderTxn] CHECK CONSTRAINT [FK_CRMRequestWorkOrderTxn_UMUserRegistration_AssignedUserId]
GO
