USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[UMScreen_bk]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UMScreen_bk](
	[ScreenId] [int] IDENTITY(1,1) NOT NULL,
	[ScreenName] [nvarchar](100) NOT NULL,
	[ScreenDescription] [nvarchar](250) NULL,
	[SequenceNo] [int] NOT NULL,
	[ParentMenuId] [int] NULL,
	[ControllerName] [nvarchar](200) NULL,
	[PageURL] [nvarchar](250) NULL,
	[LocationTypes] [nvarchar](10) NULL,
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
	[ModuleId] [int] NULL
) ON [PRIMARY]
GO
