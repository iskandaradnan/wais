USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngLicenseandCertificateTxnDet]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngLicenseandCertificateTxnDet](
	[LicenseDetId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[LicenseId] [int] NOT NULL,
	[AssetId] [int] NULL,
	[UserId] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[StaffName] [nvarchar](100) NULL,
	[Designation] [nvarchar](100) NULL,
	[AssetTypeCode] [nvarchar](50) NULL,
 CONSTRAINT [PK_EngLicenseandCertificateTxnDet] PRIMARY KEY CLUSTERED 
(
	[LicenseDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngLicenseandCertificateTxnDet] ADD  CONSTRAINT [DF_EngLicenseandCertificateTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngLicenseandCertificateTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngLicenseandCertificateTxnDet_UMUserRegistration_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[EngLicenseandCertificateTxnDet] CHECK CONSTRAINT [FK_EngLicenseandCertificateTxnDet_UMUserRegistration_UserId]
GO
