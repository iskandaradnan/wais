USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSDriverDetailsMstDet]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSDriverDetailsMstDet] AS TABLE(
	[DriverId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[LicenseTypeDetId] [int] NULL,
	[LicenseNo] [nvarchar](150) NOT NULL,
	[ClassGrade] [int] NULL,
	[IssuedBy] [int] NULL,
	[IssuedDate] [datetime] NULL,
	[ExpiryDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL
)
GO
