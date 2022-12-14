USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[Sheet4$]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sheet4$](
	[ScreenId] [nvarchar](255) NULL,
	[ScreenName] [nvarchar](255) NULL,
	[ScreenDescription] [nvarchar](255) NULL,
	[SequenceNo] [nvarchar](255) NULL,
	[ParentMenuId] [nvarchar](255) NULL,
	[ControllerName] [nvarchar](255) NULL,
	[PageURL] [nvarchar](255) NULL,
	[LocationTypes] [nvarchar](255) NULL,
	[CreatedBy] [nvarchar](255) NULL,
	[CreatedDate] [nvarchar](255) NULL,
	[CreatedDateUTC] [nvarchar](255) NULL,
	[ModifiedBy] [nvarchar](255) NULL,
	[ModifiedDate] [nvarchar](255) NULL,
	[ModifiedDateUTC] [nvarchar](255) NULL,
	[Timestamp] [nvarchar](255) NULL,
	[Active] [nvarchar](255) NULL,
	[BuiltIn] [nvarchar](255) NULL,
	[GuId] [nvarchar](255) NULL,
	[ModuleId] [nvarchar](255) NULL
) ON [PRIMARY]
GO
