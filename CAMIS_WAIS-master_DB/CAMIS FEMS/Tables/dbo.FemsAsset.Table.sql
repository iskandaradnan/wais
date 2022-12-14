USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[FemsAsset]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FemsAsset](
	[NO#] [float] NULL,
	[ASSET NO#] [nvarchar](255) NULL,
	[SERVICE] [nvarchar](255) NULL,
	[ASSET CLASSIFICATION] [nvarchar](255) NULL,
	[TYPE CODE] [nvarchar](255) NULL,
	[TYPE NAME] [nvarchar](255) NULL,
	[TASK CODE] [nvarchar](255) NULL,
	[DESCRIPTION] [nvarchar](255) NULL,
	[ITEM CODE] [nvarchar](255) NULL,
	[ITEM NAME] [nvarchar](255) NULL,
	[CATEGORY] [nvarchar](255) NULL,
	[MODEL] [nvarchar](255) NULL,
	[SERIAL NO#] [nvarchar](255) NULL,
	[MANUFACTURER] [nvarchar](255) NULL,
	[DEPT#] [nvarchar](255) NULL,
	[DEPARTMENT NAME] [nvarchar](255) NULL,
	[AREA CODE] [nvarchar](255) NULL,
	[AREA NAME] [nvarchar](255) NULL,
	[LOCATION CODE] [nvarchar](255) NULL,
	[LOCATION NAME] [nvarchar](255) NULL,
	[REMARKS] [nvarchar](255) NULL,
	[PURCHASE COST] [float] NULL,
	[WORK GROUP] [nvarchar](255) NULL,
	[GROUP] [nvarchar](255) NULL,
	[PACKAGE] [nvarchar](255) NULL,
	[PACKAGE DESCRIPTION] [nvarchar](255) NULL,
	[PROCUREMENT AGENT] [nvarchar](255) NULL,
	[AUTHORISED AGENT] [nvarchar](255) NULL,
	[OPERATING HOURS] [float] NULL,
	[OPERATING HOURS/ WEEK (DAYS)] [float] NULL,
	[TOTAL OPERATING HOURS] [float] NULL,
	[MAINTENANCE TYPE] [nvarchar](255) NULL,
	[ESTIMATED LIFE SPAN] [float] NULL,
	[CRITICALITY] [nvarchar](255) NULL,
	[UPTIME TARGET <5 YEARS] [float] NULL,
	[UPTIME TARGET 5 - 10 YEARS] [float] NULL,
	[PPM FREQUENCY] [nvarchar](255) NULL,
	[REPLACEMENT] [nvarchar](255) NULL,
	[ServiceID] [float] NULL
) ON [PRIMARY]
GO
