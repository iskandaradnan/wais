USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[MstXL_14_2]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstXL_14_2](
	[Location Code] [nvarchar](100) NOT NULL,
	[Location Name] [nvarchar](100) NOT NULL,
	[Area Code] [nvarchar](100) NOT NULL,
	[Area Name] [nvarchar](100) NOT NULL,
	[Block Code] [nvarchar](100) NOT NULL,
	[Block Name] [nvarchar](100) NOT NULL,
	[Level Code] [nvarchar](100) NOT NULL,
	[Level Name] [nvarchar](100) NOT NULL,
	[Status] [nvarchar](100) NOT NULL,
	[Start Service Date] [datetime] NULL,
	[Stopt Service Date] [nvarchar](100) NULL,
	[Location Incharge] [nvarchar](100) NULL,
	[Company Representative] [nvarchar](100) NULL,
	[Status Location for CLS] [nvarchar](100) NULL
) ON [PRIMARY]
GO
