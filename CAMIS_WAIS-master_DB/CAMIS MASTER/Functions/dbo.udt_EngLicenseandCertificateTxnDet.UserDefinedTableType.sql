USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngLicenseandCertificateTxnDet]    Script Date: 20-09-2021 16:50:19 ******/
CREATE TYPE [dbo].[udt_EngLicenseandCertificateTxnDet] AS TABLE(
	[LicenseDetId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[AssetId] [int] NULL,
	[StaffId] [int] NULL,
	[Remarks] [nvarchar](1000) NULL,
	[StaffName] [nvarchar](100) NULL,
	[Designation] [nvarchar](100) NULL
)
GO
