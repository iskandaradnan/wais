USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[UMScreenUserTypeMappingExcel]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UMScreenUserTypeMappingExcel](
	[ScreenPermissionUserTypeId] [int] NULL,
	[ScreenId] [int] NULL,
	[UserTypeId] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [varchar](500) NULL,
	[Active] [int] NULL,
	[BuiltIn] [int] NULL,
	[GuId] [varchar](500) NULL
) ON [PRIMARY]
GO
