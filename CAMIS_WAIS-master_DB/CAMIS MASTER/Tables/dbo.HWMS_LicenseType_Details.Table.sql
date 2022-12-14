USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_LicenseType_Details]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_LicenseType_Details](
	[LicenseId] [int] IDENTITY(1,1) NOT NULL,
	[LicenseTypeId] [int] NOT NULL,
	[LicenseCode] [nvarchar](50) NULL,
	[LicenseDescription] [nvarchar](max) NULL,
	[IssuingBody] [nvarchar](50) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[HWMS_LicenseType_Details]  WITH CHECK ADD  CONSTRAINT [LicenseType_FK_Idno] FOREIGN KEY([LicenseTypeId])
REFERENCES [dbo].[HWMS_LicenseType] ([LicenseTypeId])
GO
ALTER TABLE [dbo].[HWMS_LicenseType_Details] CHECK CONSTRAINT [LicenseType_FK_Idno]
GO
