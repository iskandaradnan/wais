USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSVehicleDetailsMstDet]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSVehicleDetailsMstDet] AS TABLE(
	[VehicleId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[LicenseTypeDetId] [int] NOT NULL,
	[LicenseNo] [nvarchar](150) NOT NULL,
	[ClassGrade] [int] NULL,
	[IssuedBy] [int] NULL,
	[IssuedDate] [datetime] NULL,
	[ExpiryDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL
)
GO
