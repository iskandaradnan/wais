USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSLicenseTypeMstDet_Update]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSLicenseTypeMstDet_Update] AS TABLE(
	[LicenseDescription] [nvarchar](550) NULL,
	[IssuingBody] [int] NULL,
	[LicenseTypeDetId] [int] NULL,
	[ModifiedBy] [int] NOT NULL
)
GO
