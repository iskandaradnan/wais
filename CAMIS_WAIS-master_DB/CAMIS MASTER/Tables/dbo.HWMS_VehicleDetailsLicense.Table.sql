USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_VehicleDetailsLicense]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_VehicleDetailsLicense](
	[LicenseCodeId] [int] IDENTITY(1,1) NOT NULL,
	[LicenseCode] [nvarchar](50) NULL,
	[LicenseDescription] [nvarchar](50) NULL,
	[LicenseNo] [nvarchar](50) NULL,
	[ClassGrade] [nvarchar](50) NULL,
	[IssuedBy] [nvarchar](50) NULL,
	[IssuedDate] [datetime] NULL,
	[ExpiryDate] [datetime] NULL,
	[VehicleId] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HWMS_VehicleDetailsLicense]  WITH CHECK ADD FOREIGN KEY([VehicleId])
REFERENCES [dbo].[HWMS_VehicleDetails] ([VehicleId])
GO
