USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[UMUserRole]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UMUserRole](
	[UMUserRoleId] [int] IDENTITY(1,1) NOT NULL,
	[UserTypeId] [int] NOT NULL,
	[Name] [nvarchar](100) NULL,
	[Status] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
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
 CONSTRAINT [PK_UMUserRole] PRIMARY KEY CLUSTERED 
(
	[UMUserRoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UMUserRole] ADD  CONSTRAINT [DF_UMUserRole_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[UMUserRole] ADD  CONSTRAINT [DF_UMUserRole_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[UMUserRole] ADD  CONSTRAINT [DF_UMUserRole_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[UMUserRole]  WITH CHECK ADD  CONSTRAINT [FK_UMUserRole_UMUserType_UserTypeId] FOREIGN KEY([UserTypeId])
REFERENCES [dbo].[UMUserType] ([UserTypeId])
GO
ALTER TABLE [dbo].[UMUserRole] CHECK CONSTRAINT [FK_UMUserRole_UMUserType_UserTypeId]
GO
