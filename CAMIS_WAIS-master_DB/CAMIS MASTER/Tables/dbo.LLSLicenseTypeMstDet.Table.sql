USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSLicenseTypeMstDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSLicenseTypeMstDet](
	[LicenseTypeDetId] [int] IDENTITY(1,1) NOT NULL,
	[LicenseTypeId] [int] NOT NULL,
	[LicenseCode] [nvarchar](25) NOT NULL,
	[LicenseDescription] [nvarchar](255) NOT NULL,
	[IssuingBody] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
 CONSTRAINT [PK_LLSLicenseTypeMstDet] PRIMARY KEY CLUSTERED 
(
	[LicenseTypeDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LLSLicenseTypeMstDet]  WITH CHECK ADD  CONSTRAINT [FK_LLSLicenseTypeMstDet_LLSLicenseTypeMst_LicenseTypeId] FOREIGN KEY([LicenseTypeId])
REFERENCES [dbo].[LLSLicenseTypeMst] ([LicenseTypeId])
GO
ALTER TABLE [dbo].[LLSLicenseTypeMstDet] CHECK CONSTRAINT [FK_LLSLicenseTypeMstDet_LLSLicenseTypeMst_LicenseTypeId]
GO
