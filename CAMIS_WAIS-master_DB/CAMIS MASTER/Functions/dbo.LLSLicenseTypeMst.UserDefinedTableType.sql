USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSLicenseTypeMst]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSLicenseTypeMst] AS TABLE(
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[LicenseType] [nvarchar](25) NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL
)
GO
