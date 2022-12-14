USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[CRMRequest]    Script Date: 20-09-2021 17:02:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CRMRequest](
	[CRMRequestId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[RequestNo] [nvarchar](50) NULL,
	[RequestDateTime] [datetime] NULL,
	[RequestDateTimeUTC] [datetime] NULL,
	[RequestStatus] [int] NULL,
	[RequestDescription] [nvarchar](500) NULL,
	[TypeOfRequest] [int] NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[IsWorkOrder] [bit] NULL,
	[ModelId] [int] NULL,
	[ManufacturerId] [int] NULL,
	[UserAreaId] [int] NULL,
	[UserLocationId] [int] NULL,
	[StatusValue] [nvarchar](100) NULL,
	[MobileGuid] [nvarchar](max) NULL,
	[TargetDate] [datetime] NULL,
	[RequestedPerson] [int] NULL,
	[AssigneeId] [int] NULL,
	[Requester] [int] NULL,
	[CRMRequest_PriorityId] [int] NULL,
	[Master_CRMRequestId] [int] NULL,
	[Responce_Date] [datetime] NULL,
	[Responce_By] [int] NULL,
	[AssetId] [int] NULL,
	[WorkGroup] [int] NULL,
	[WasteCategory] [int] NULL,
	[Requested_Date] [datetime] NULL,
 CONSTRAINT [PK_CRMRequest] PRIMARY KEY CLUSTERED 
(
	[CRMRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[CRMRequest] ADD  CONSTRAINT [DF_CRMRequest_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[CRMRequest]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequest_EngAssetStandardizationModel_Manufacturerid] FOREIGN KEY([ManufacturerId])
REFERENCES [dbo].[EngAssetStandardizationManufacturer] ([ManufacturerId])
GO
ALTER TABLE [dbo].[CRMRequest] CHECK CONSTRAINT [FK_CRMRequest_EngAssetStandardizationModel_Manufacturerid]
GO
ALTER TABLE [dbo].[CRMRequest]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequest_EngAssetStandardizationModel_ModelId] FOREIGN KEY([ModelId])
REFERENCES [dbo].[EngAssetStandardizationModel] ([ModelId])
GO
ALTER TABLE [dbo].[CRMRequest] CHECK CONSTRAINT [FK_CRMRequest_EngAssetStandardizationModel_ModelId]
GO
ALTER TABLE [dbo].[CRMRequest]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequest_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[CRMRequest] CHECK CONSTRAINT [FK_CRMRequest_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[CRMRequest]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequest_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[CRMRequest] CHECK CONSTRAINT [FK_CRMRequest_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[CRMRequest]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequest_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[CRMRequest] CHECK CONSTRAINT [FK_CRMRequest_MstService_ServiceId]
GO
