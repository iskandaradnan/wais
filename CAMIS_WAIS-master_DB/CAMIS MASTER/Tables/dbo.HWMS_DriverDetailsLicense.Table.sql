USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_DriverDetailsLicense]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_DriverDetailsLicense](
	[LicenseCodeId] [int] IDENTITY(1,1) NOT NULL,
	[DriverId] [int] NOT NULL,
	[LicenseCode] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
	[LicenseNo] [nvarchar](50) NULL,
	[ClassGrade] [nvarchar](50) NULL,
	[IssuedBy] [nvarchar](50) NULL,
	[IssuedDate] [datetime] NULL,
	[ExpiryDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HWMS_DriverDetailsLicense]  WITH CHECK ADD  CONSTRAINT [Driver_FK_Idno] FOREIGN KEY([DriverId])
REFERENCES [dbo].[HWMS_DriverDetails] ([DriverId])
GO
ALTER TABLE [dbo].[HWMS_DriverDetailsLicense] CHECK CONSTRAINT [Driver_FK_Idno]
GO
