USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngLicenseandCertificateTxnAttachment]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngLicenseandCertificateTxnAttachment](
	[LicenseAttachmentId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[LicenseId] [int] NULL,
	[DocumentId] [int] NOT NULL,
	[FileType] [int] NOT NULL,
	[FileName] [nvarchar](255) NOT NULL,
	[AttachedBy] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngLicenseandCertificateTxnAttachment] PRIMARY KEY CLUSTERED 
(
	[LicenseAttachmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngLicenseandCertificateTxnAttachment] ADD  CONSTRAINT [DF_EngLicenseandCertificateTxnAttachment_GuId]  DEFAULT (newid()) FOR [GuId]
GO
