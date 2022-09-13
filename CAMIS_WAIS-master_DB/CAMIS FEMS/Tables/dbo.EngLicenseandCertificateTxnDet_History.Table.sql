USE [UetrackFemsdbPreProd]
GO

/****** Object:  Table [dbo].[EngLicenseandCertificateTxnDet_History]    Script Date: 30-11-2021 19:08:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EngLicenseandCertificateTxnDet_History](
	[DetAutoId] [bigint] IDENTITY(1,1) NOT NULL,
	[LicenseDetId] [int] NOT NULL,
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
	[GuId] [uniqueidentifier] NULL,
	[StaffName] [nvarchar](100) NULL,
	[Designation] [nvarchar](100) NULL,
	[AssetTypeCode] [nvarchar](50) NULL
) ON [PRIMARY]
GO


