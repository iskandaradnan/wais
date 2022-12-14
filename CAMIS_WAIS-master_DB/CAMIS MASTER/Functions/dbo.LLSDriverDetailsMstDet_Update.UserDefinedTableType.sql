USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSDriverDetailsMstDet_Update]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSDriverDetailsMstDet_Update] AS TABLE(
	[DriverDetId] [int] NULL,
	[LicenseTypeDetId] [int] NULL,
	[LicenseNo] [nvarchar](300) NULL,
	[ClassGrade] [int] NULL,
	[IssuedBy] [int] NULL,
	[IssuedDate] [datetime] NULL,
	[ExpiryDate] [datetime] NULL,
	[DriverId] [int] NULL,
	[ModifiedBy] [int] NOT NULL
)
GO
