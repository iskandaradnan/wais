USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_ListofVendors]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_ListofVendors](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[VendorCode] [nvarchar](max) NULL,
	[VendorName] [nvarchar](max) NULL,
	[RegistrationNo] [nvarchar](max) NULL,
	[LicenseStartDate] [datetime] NULL,
	[LicenseEndDate] [datetime] NULL,
	[Status] [nvarchar](max) NULL,
 CONSTRAINT [PK_HWMS_ListofVendors] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
