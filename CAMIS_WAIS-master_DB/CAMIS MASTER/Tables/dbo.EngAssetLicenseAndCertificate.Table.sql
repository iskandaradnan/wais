USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetLicenseAndCertificate]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetLicenseAndCertificate](
	[AssetLicenseAndCertificateId] [int] IDENTITY(1,1) NOT NULL,
	[AssetId] [int] NOT NULL,
	[LicenseId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[Active] [bit] NOT NULL,
	[BuiltIn] [bit] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngAssetLicenseAndCertificate] PRIMARY KEY CLUSTERED 
(
	[AssetLicenseAndCertificateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetLicenseAndCertificate] ADD  CONSTRAINT [DF_EngAssetLicenseAndCertificate_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetLicenseAndCertificate] ADD  CONSTRAINT [DF_EngAssetLicenseAndCertificate_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetLicenseAndCertificate] ADD  CONSTRAINT [DF_EngAssetLicenseAndCertificate_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetLicenseAndCertificate]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetLicenseAndCertificate_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[EngAssetLicenseAndCertificate] CHECK CONSTRAINT [FK_EngAssetLicenseAndCertificate_EngAsset_AssetId]
GO
ALTER TABLE [dbo].[EngAssetLicenseAndCertificate]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetLicenseAndCertificate_EngLicenseandCertificateTxn_LicenseId] FOREIGN KEY([LicenseId])
REFERENCES [dbo].[EngLicenseandCertificateTxn] ([LicenseId])
GO
ALTER TABLE [dbo].[EngAssetLicenseAndCertificate] CHECK CONSTRAINT [FK_EngAssetLicenseAndCertificate_EngLicenseandCertificateTxn_LicenseId]
GO
