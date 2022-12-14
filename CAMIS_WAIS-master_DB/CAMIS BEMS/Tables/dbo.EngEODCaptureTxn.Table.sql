USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngEODCaptureTxn]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngEODCaptureTxn](
	[CaptureId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[CaptureDocumentNo] [nvarchar](50) NOT NULL,
	[RecordDate] [datetime] NOT NULL,
	[RecordDateUTC] [datetime] NOT NULL,
	[AssetClassificationId] [int] NULL,
	[AssetTypeCodeId] [int] NOT NULL,
	[CaptureStatusLovId] [int] NULL,
	[AssetId] [int] NOT NULL,
	[UserAreaId] [int] NULL,
	[UserLocationId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[NextCaptureDate] [datetime] NULL,
	[MobileGuid] [nvarchar](max) NULL,
 CONSTRAINT [PK_EngEodCaptureTxn] PRIMARY KEY CLUSTERED 
(
	[CaptureId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngEODCaptureTxn] ADD  CONSTRAINT [DF_EngEodCaptureTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngEODCaptureTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngEodCaptureTxn_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[EngEODCaptureTxn] CHECK CONSTRAINT [FK_EngEodCaptureTxn_EngAsset_AssetId]
GO
ALTER TABLE [dbo].[EngEODCaptureTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngEodCaptureTxn_EngAssetClassification_AssetClassificationId] FOREIGN KEY([AssetClassificationId])
REFERENCES [dbo].[EngAssetClassification] ([AssetClassificationId])
GO
ALTER TABLE [dbo].[EngEODCaptureTxn] CHECK CONSTRAINT [FK_EngEodCaptureTxn_EngAssetClassification_AssetClassificationId]
GO
ALTER TABLE [dbo].[EngEODCaptureTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngEodCaptureTxn_EngAssetTypeCode_AssetTypeCodeId] FOREIGN KEY([AssetTypeCodeId])
REFERENCES [dbo].[EngAssetTypeCode] ([AssetTypeCodeId])
GO
ALTER TABLE [dbo].[EngEODCaptureTxn] CHECK CONSTRAINT [FK_EngEodCaptureTxn_EngAssetTypeCode_AssetTypeCodeId]
GO
ALTER TABLE [dbo].[EngEODCaptureTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngEodCaptureTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngEODCaptureTxn] CHECK CONSTRAINT [FK_EngEodCaptureTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngEODCaptureTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngEodCaptureTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngEODCaptureTxn] CHECK CONSTRAINT [FK_EngEodCaptureTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngEODCaptureTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngEodCaptureTxn_MstLocationUserArea_UserAreaId] FOREIGN KEY([UserAreaId])
REFERENCES [dbo].[MstLocationUserArea] ([UserAreaId])
GO
ALTER TABLE [dbo].[EngEODCaptureTxn] CHECK CONSTRAINT [FK_EngEodCaptureTxn_MstLocationUserArea_UserAreaId]
GO
ALTER TABLE [dbo].[EngEODCaptureTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngEodCaptureTxn_MstLocationUserLocation_UserLocationId] FOREIGN KEY([UserLocationId])
REFERENCES [dbo].[MstLocationUserLocation] ([UserLocationId])
GO
ALTER TABLE [dbo].[EngEODCaptureTxn] CHECK CONSTRAINT [FK_EngEodCaptureTxn_MstLocationUserLocation_UserLocationId]
GO
ALTER TABLE [dbo].[EngEODCaptureTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngEodCaptureTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngEODCaptureTxn] CHECK CONSTRAINT [FK_EngEodCaptureTxn_MstService_ServiceId]
GO
