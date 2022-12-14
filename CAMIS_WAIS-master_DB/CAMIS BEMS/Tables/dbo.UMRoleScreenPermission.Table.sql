USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[UMRoleScreenPermission]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UMRoleScreenPermission](
	[ScreenRoleId] [int] IDENTITY(1,1) NOT NULL,
	[ScreenId] [int] NOT NULL,
	[UMUserRoleId] [int] NOT NULL,
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
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_UMRoleScreenPermission] PRIMARY KEY CLUSTERED 
(
	[ScreenRoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UMRoleScreenPermission] ADD  CONSTRAINT [DF_UMRoleScreenPermission_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[UMRoleScreenPermission] ADD  CONSTRAINT [DF_UMRoleScreenPermission_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[UMRoleScreenPermission] ADD  CONSTRAINT [DF_UMRoleScreenPermission_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[UMRoleScreenPermission]  WITH CHECK ADD  CONSTRAINT [FK_UMRoleScreenPermission_UMScreen_ScreenId] FOREIGN KEY([ScreenId])
REFERENCES [dbo].[UMScreen] ([ScreenId])
GO
ALTER TABLE [dbo].[UMRoleScreenPermission] CHECK CONSTRAINT [FK_UMRoleScreenPermission_UMScreen_ScreenId]
GO
ALTER TABLE [dbo].[UMRoleScreenPermission]  WITH CHECK ADD  CONSTRAINT [FK_UMRoleScreenPermission_UMUserRole_UMUserRoleId] FOREIGN KEY([UMUserRoleId])
REFERENCES [dbo].[UMUserRole] ([UMUserRoleId])
GO
ALTER TABLE [dbo].[UMRoleScreenPermission] CHECK CONSTRAINT [FK_UMRoleScreenPermission_UMUserRole_UMUserRoleId]
GO
