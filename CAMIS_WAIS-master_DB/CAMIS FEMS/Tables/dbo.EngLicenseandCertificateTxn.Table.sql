USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngLicenseandCertificateTxn]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngLicenseandCertificateTxn](
	[LicenseId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[LicenseNo] [nvarchar](50) NOT NULL,
	[Status] [int] NULL,
	[Category] [int] NULL,
	[IfOthersSpecify] [nvarchar](100) NULL,
	[Type] [int] NULL,
	[ClassGrade] [nvarchar](25) NULL,
	[ContactPersonUserId] [int] NULL,
	[IssuingBody] [int] NOT NULL,
	[IssuingDate] [datetime] NOT NULL,
	[IssuingDateUTC] [datetime] NOT NULL,
	[NotificationForInspection] [datetime] NULL,
	[NotificationForInspectionUTC] [datetime] NULL,
	[InspectionConductedOn] [datetime] NULL,
	[InspectionConductedOnUTC] [datetime] NULL,
	[NextInspectionDate] [datetime] NULL,
	[NextInspectionDateUTC] [datetime] NULL,
	[ExpireDate] [datetime] NULL,
	[ExpireDateUTC] [datetime] NULL,
	[PreviousExpiryDate] [datetime] NULL,
	[PreviousExpiryDateUTC] [datetime] NULL,
	[RegistrationNo] [nvarchar](25) NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[LicenseDescription] [nvarchar](500) NULL,
	[AssetTypeCodeId] [int] NULL,
 CONSTRAINT [PK_EngLicenseandCertificateTxn] PRIMARY KEY CLUSTERED 
(
	[LicenseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngLicenseandCertificateTxn] ADD  CONSTRAINT [DF_EngLicenseandCertificateTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngLicenseandCertificateTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngLicenseandCertificateTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngLicenseandCertificateTxn] CHECK CONSTRAINT [FK_EngLicenseandCertificateTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngLicenseandCertificateTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngLicenseandCertificateTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngLicenseandCertificateTxn] CHECK CONSTRAINT [FK_EngLicenseandCertificateTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngLicenseandCertificateTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngLicenseandCertificateTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngLicenseandCertificateTxn] CHECK CONSTRAINT [FK_EngLicenseandCertificateTxn_MstService_ServiceId]
GO
ALTER TABLE [dbo].[EngLicenseandCertificateTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngLicenseandCertificateTxn_UMUserRegistration_ContactPersonUserId] FOREIGN KEY([ContactPersonUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[EngLicenseandCertificateTxn] CHECK CONSTRAINT [FK_EngLicenseandCertificateTxn_UMUserRegistration_ContactPersonUserId]
GO
