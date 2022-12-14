USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[UMScreenUserTypeMapping220220208_03]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UMScreenUserTypeMapping220220208_03](
	[ScreenPermissionUserTypeId] [int] IDENTITY(1,1) NOT NULL,
	[ScreenId] [int] NOT NULL,
	[UserTypeId] [int] NOT NULL,
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
