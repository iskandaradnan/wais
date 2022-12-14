USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[UMScreenExcel]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UMScreenExcel](
	[ScreenId] [int] NULL,
	[ScreenName] [varchar](200) NULL,
	[ScreenDescription] [varchar](500) NULL,
	[SequenceNo] [int] NULL,
	[ParentMenuId] [int] NULL,
	[ControllerName] [varchar](400) NULL,
	[PageURL] [varchar](500) NULL,
	[LocationTypes] [varchar](50) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [varchar](500) NULL,
	[Active] [int] NULL,
	[BuiltIn] [int] NULL,
	[GuId] [varchar](500) NULL,
	[ModuleId] [int] NULL
) ON [PRIMARY]
GO
