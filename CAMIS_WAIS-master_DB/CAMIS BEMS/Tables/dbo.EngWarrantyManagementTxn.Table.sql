USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngWarrantyManagementTxn]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngWarrantyManagementTxn](
	[WarrantyMgmtId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[WarrantyNo] [nvarchar](100) NOT NULL,
	[WarrantyDate] [datetime] NOT NULL,
	[WarrantyDateUTC] [datetime] NOT NULL,
	[AssetId] [int] NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngWarrantyManagementTxn] PRIMARY KEY CLUSTERED 
(
	[WarrantyMgmtId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngWarrantyManagementTxn] ADD  CONSTRAINT [DF_EngWarrantyManagementTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngWarrantyManagementTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngWarrantyManagementTxn_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[EngWarrantyManagementTxn] CHECK CONSTRAINT [FK_EngWarrantyManagementTxn_EngAsset_AssetId]
GO
ALTER TABLE [dbo].[EngWarrantyManagementTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngWarrantyManagementTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngWarrantyManagementTxn] CHECK CONSTRAINT [FK_EngWarrantyManagementTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngWarrantyManagementTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngWarrantyManagementTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngWarrantyManagementTxn] CHECK CONSTRAINT [FK_EngWarrantyManagementTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngWarrantyManagementTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngWarrantyManagementTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngWarrantyManagementTxn] CHECK CONSTRAINT [FK_EngWarrantyManagementTxn_MstService_ServiceId]
GO
