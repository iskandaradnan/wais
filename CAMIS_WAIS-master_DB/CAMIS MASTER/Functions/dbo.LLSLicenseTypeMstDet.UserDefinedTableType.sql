USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSLicenseTypeMstDet]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSLicenseTypeMstDet] AS TABLE(
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[LicenseTypeId] [int] NOT NULL,
	[LicenseCode] [nvarchar](25) NOT NULL,
	[LicenseDescription] [nvarchar](255) NOT NULL,
	[IssuingBody] [int] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL
)
GO
