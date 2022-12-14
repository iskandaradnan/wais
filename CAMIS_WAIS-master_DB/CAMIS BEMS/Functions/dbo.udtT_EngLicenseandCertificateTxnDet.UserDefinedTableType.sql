USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udtT_EngLicenseandCertificateTxnDet]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[udtT_EngLicenseandCertificateTxnDet] AS TABLE(
	[LicenseDetId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[AssetId] [int] NULL,
	[StaffId] [int] NULL,
	[Remarks] [nvarchar](1000) NULL,
	[StaffName] [nvarchar](100) NULL,
	[Designation] [nvarchar](100) NULL,
	[AssetTypeCode] [nvarchar](100) NULL
)
GO
