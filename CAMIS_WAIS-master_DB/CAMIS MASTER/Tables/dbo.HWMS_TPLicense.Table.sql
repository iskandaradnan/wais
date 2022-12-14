USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_TPLicense]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_TPLicense](
	[LicenseCode] [varchar](max) NULL,
	[LicenseDescription] [varchar](max) NULL,
	[LicenseNo] [varchar](max) NULL,
	[Class] [varchar](max) NULL,
	[IssueDate] [datetime] NULL,
	[ExpiryDate] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
