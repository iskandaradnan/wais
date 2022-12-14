USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngFacilitiesWorkshopTxnDet]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngFacilitiesWorkshopTxnDet](
	[FacilitiesWorkshopDetId] [int] IDENTITY(1,1) NOT NULL,
	[FacilitiesWorkshopId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[AssetId] [int] NULL,
	[Description] [nvarchar](255) NOT NULL,
	[Manufacturer] [nvarchar](500) NULL,
	[Model] [nvarchar](500) NULL,
	[SerialNo] [nvarchar](50) NULL,
	[CalibrationDueDate] [datetime] NULL,
	[CalibrationDueDateUTC] [datetime] NULL,
	[Location] [int] NULL,
	[Quantity] [int] NULL,
	[SizeArea] [numeric](24, 2) NULL,
	[ListofFacility] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngFacilitiesWorkshopTxnDet] PRIMARY KEY CLUSTERED 
(
	[FacilitiesWorkshopDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngFacilitiesWorkshopTxnDet] ADD  CONSTRAINT [DF_EngFacilitiesWorkshopTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngFacilitiesWorkshopTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngFacilitiesWorkshopTxnDet_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[EngFacilitiesWorkshopTxnDet] CHECK CONSTRAINT [FK_EngFacilitiesWorkshopTxnDet_EngAsset_AssetId]
GO
ALTER TABLE [dbo].[EngFacilitiesWorkshopTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngFacilitiesWorkshopTxnDet_EngFacilitiesWorkshopTxn_FacilitiesWorkshopId] FOREIGN KEY([FacilitiesWorkshopId])
REFERENCES [dbo].[EngFacilitiesWorkshopTxn] ([FacilitiesWorkshopId])
GO
ALTER TABLE [dbo].[EngFacilitiesWorkshopTxnDet] CHECK CONSTRAINT [FK_EngFacilitiesWorkshopTxnDet_EngFacilitiesWorkshopTxn_FacilitiesWorkshopId]
GO
ALTER TABLE [dbo].[EngFacilitiesWorkshopTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngFacilitiesWorkshopTxnDet_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngFacilitiesWorkshopTxnDet] CHECK CONSTRAINT [FK_EngFacilitiesWorkshopTxnDet_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngFacilitiesWorkshopTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngFacilitiesWorkshopTxnDet_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngFacilitiesWorkshopTxnDet] CHECK CONSTRAINT [FK_EngFacilitiesWorkshopTxnDet_MstLocationFacility_FacilityId]
GO
