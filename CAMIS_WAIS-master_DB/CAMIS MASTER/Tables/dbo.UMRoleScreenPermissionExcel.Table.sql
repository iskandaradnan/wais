USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[UMRoleScreenPermissionExcel]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UMRoleScreenPermissionExcel](
	[ScreenRoleId] [int] NULL,
	[ScreenId] [int] NULL,
	[UMUserRoleId] [int] NULL,
	[Permissions] [varchar](100) NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
	[ModifiedDate] [varchar](50) NULL,
	[ModifiedDateUTC] [varchar](50) NULL,
	[Timestamp] [varchar](500) NULL,
	[Active] [int] NULL,
	[BuiltIn] [int] NULL,
	[GuId] [varchar](500) NULL
) ON [PRIMARY]
GO
