USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[UMScreenPermission22022020748]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UMScreenPermission22022020748](
	[ScreenPermissionId] [int] IDENTITY(1,1) NOT NULL,
	[ScreenId] [int] NOT NULL,
	[Permissions] [nvarchar](30) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[Active] [bit] NOT NULL,
	[BuiltIn] [bit] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
