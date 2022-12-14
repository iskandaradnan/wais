USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[fmlovmst_bk_8oct2018]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fmlovmst_bk_8oct2018](
	[LovId] [int] IDENTITY(1,1) NOT NULL,
	[ModuleName] [nvarchar](50) NOT NULL,
	[ScreenName] [nvarchar](50) NOT NULL,
	[FieldName] [nvarchar](50) NOT NULL,
	[LovKey] [nvarchar](50) NOT NULL,
	[FieldCode] [nvarchar](10) NOT NULL,
	[FieldValue] [nvarchar](100) NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[ParentId] [int] NULL,
	[SortNo] [int] NOT NULL,
	[IsDefault] [bit] NOT NULL,
	[IsEditable] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[Active] [bit] NOT NULL,
	[BuiltIn] [bit] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[LovType] [int] NULL
) ON [PRIMARY]
GO
