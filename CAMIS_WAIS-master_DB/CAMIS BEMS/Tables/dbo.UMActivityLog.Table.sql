USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[UMActivityLog]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UMActivityLog](
	[ActivityLogId] [int] IDENTITY(1,1) NOT NULL,
	[UserRegistrationId] [int] NOT NULL,
	[Activity] [int] NULL,
	[ActivityDateTime] [datetime] NULL,
	[ActivityDateTimeUTC] [datetime] NULL,
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
 CONSTRAINT [PK_UMActivityLog] PRIMARY KEY CLUSTERED 
(
	[ActivityLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UMActivityLog] ADD  CONSTRAINT [DF_UMActivityLog_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[UMActivityLog] ADD  CONSTRAINT [DF_UMActivityLog_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[UMActivityLog] ADD  CONSTRAINT [DF_UMActivityLog_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[UMActivityLog]  WITH CHECK ADD  CONSTRAINT [FK_UMActivityLog_UMUserRegistration_UserRegistrationId] FOREIGN KEY([UserRegistrationId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[UMActivityLog] CHECK CONSTRAINT [FK_UMActivityLog_UMUserRegistration_UserRegistrationId]
GO
