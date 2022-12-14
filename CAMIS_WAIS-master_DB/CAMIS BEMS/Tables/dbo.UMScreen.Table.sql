USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[UMScreen]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UMScreen](
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
	[ModuleId] [int] NULL,
 CONSTRAINT [PK_UMScreen] PRIMARY KEY CLUSTERED 
(
	[ScreenId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UMScreen] ADD  CONSTRAINT [DF_UMScreen_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[UMScreen] ADD  CONSTRAINT [DF_UMScreen_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[UMScreen] ADD  CONSTRAINT [DF_UMScreen_GuId]  DEFAULT (newid()) FOR [GuId]
GO
