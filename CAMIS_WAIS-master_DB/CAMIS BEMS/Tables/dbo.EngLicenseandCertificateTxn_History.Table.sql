USE [UetrackBemsdbPreProd]
GO

/****** Object:  Table [dbo].[EngLicenseandCertificateTxn_History]    Script Date: 30-11-2021 19:07:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EngLicenseandCertificateTxn_History](
	[AutoId] [bigint] IDENTITY(1,1) NOT NULL,
	[LicenseId] [int] NOT NULL,
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
	[GuId] [uniqueidentifier] NULL,
	[LicenseDescription] [nvarchar](500) NULL,
	[AssetTypeCodeId] [nvarchar](50) NULL,
	[AssetTypeCode] [nvarchar](50) NULL
) ON [PRIMARY]
GO


