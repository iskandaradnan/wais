USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[FENotification]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FENotification](
	[NotificationId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[NotificationAlerts] [nvarchar](500) NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[SyncWithMobile] [bit] NOT NULL,
	[ScreenName] [nvarchar](50) NULL,
	[DocumentId] [nvarchar](50) NULL,
	[SingleRecord] [bit] NULL,
 CONSTRAINT [PK_FENotification] PRIMARY KEY CLUSTERED 
(
	[NotificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FENotification] ADD  CONSTRAINT [DF_FENotification_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[FENotification] ADD  CONSTRAINT [DF_FENotification_SyncWithMobile]  DEFAULT ((0)) FOR [SyncWithMobile]
GO
ALTER TABLE [dbo].[FENotification]  WITH CHECK ADD  CONSTRAINT [FK_FENotification_UMUserRegistration_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[FENotification] CHECK CONSTRAINT [FK_FENotification_UMUserRegistration_UserId]
GO
