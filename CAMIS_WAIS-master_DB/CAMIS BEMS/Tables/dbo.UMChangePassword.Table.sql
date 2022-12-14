USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[UMChangePassword]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UMChangePassword](
	[PasswordId] [int] IDENTITY(1,1) NOT NULL,
	[UserRegistrationId] [int] NOT NULL,
	[OldPassword] [nvarchar](max) NULL,
	[NewPassword] [nvarchar](max) NULL,
	[ExpiryDuration] [int] NULL,
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
 CONSTRAINT [PK_UMChangePassword] PRIMARY KEY CLUSTERED 
(
	[PasswordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[UMChangePassword] ADD  CONSTRAINT [DF_UMChangePassword_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[UMChangePassword] ADD  CONSTRAINT [DF_UMChangePassword_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[UMChangePassword] ADD  CONSTRAINT [DF_UMChangePassword_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[UMChangePassword]  WITH CHECK ADD  CONSTRAINT [FK_UMChangePassword_UMUserRegistration_UserRegistrationId] FOREIGN KEY([UserRegistrationId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[UMChangePassword] CHECK CONSTRAINT [FK_UMChangePassword_UMUserRegistration_UserRegistrationId]
GO
