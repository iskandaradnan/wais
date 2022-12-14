USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[AssetTypeCodeDeduction]    Script Date: 20-09-2021 17:02:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AssetTypeCodeDeduction](
	[THERAPEUTIC EQUIPMENT] [nvarchar](255) NULL,
	[TYPE CODE] [nvarchar](255) NULL,
	[DESCRIPTION] [nvarchar](255) NULL,
	[GROUP] [nvarchar](255) NULL,
	[OPERATING_HOURS] [float] NULL,
	[OPERATING HOURS_WK _DAYS] [float] NULL,
	[UPTIME_EQUIPMENT_5_YRS] [float] NULL,
	[UPTIME_EQUIPMENT_5_10_YRS] [float] NULL
) ON [PRIMARY]
GO
