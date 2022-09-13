USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[temp1]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[temp1](
	[ScreenName] [nvarchar](100) NOT NULL,
	[ScreenDescription] [nvarchar](250) NULL,
	[SequenceNo] [int] NOT NULL,
	[ParentMenuId] [int] NULL,
	[ControllerName] [nvarchar](200) NULL,
	[PageURL] [nvarchar](250) NULL,
	[id] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]
GO
