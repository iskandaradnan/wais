USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[UMScreenUserTypeMapping]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UMScreenUserTypeMapping](
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
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_UMScreenUserTypeMapping] PRIMARY KEY CLUSTERED 
(
	[ScreenPermissionUserTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UMScreenUserTypeMapping] ADD  CONSTRAINT [DF_UMScreenUserTypeMapping_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[UMScreenUserTypeMapping] ADD  CONSTRAINT [DF_UMScreenUserTypeMapping_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[UMScreenUserTypeMapping] ADD  CONSTRAINT [DF_UMScreenUserTypeMapping_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[UMScreenUserTypeMapping]  WITH CHECK ADD  CONSTRAINT [FK_UMScreenUserTypeMapping_UMScreen_ScreenId] FOREIGN KEY([ScreenId])
REFERENCES [dbo].[UMScreen] ([ScreenId])
GO
ALTER TABLE [dbo].[UMScreenUserTypeMapping] CHECK CONSTRAINT [FK_UMScreenUserTypeMapping_UMScreen_ScreenId]
GO
ALTER TABLE [dbo].[UMScreenUserTypeMapping]  WITH CHECK ADD  CONSTRAINT [FK_UMScreenUserTypeMapping_UMUserType_UserTypeId] FOREIGN KEY([UserTypeId])
REFERENCES [dbo].[UMUserType] ([UserTypeId])
GO
ALTER TABLE [dbo].[UMScreenUserTypeMapping] CHECK CONSTRAINT [FK_UMScreenUserTypeMapping_UMUserType_UserTypeId]
GO
