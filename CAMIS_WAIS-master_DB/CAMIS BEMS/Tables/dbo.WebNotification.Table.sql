USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[WebNotification]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WebNotification](
	[NotificationId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[NotificationAlerts] [nvarchar](500) NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[HyperLink] [nvarchar](500) NULL,
	[IsNew] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[DateTime] [datetime] NULL,
	[NotificationDateTime] [datetime] NULL,
	[IsNavigate] [bit] NULL,
 CONSTRAINT [PK_WebNotification] PRIMARY KEY CLUSTERED 
(
	[NotificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WebNotification] ADD  CONSTRAINT [DF_WebNotification_IsNew]  DEFAULT ((1)) FOR [IsNew]
GO
ALTER TABLE [dbo].[WebNotification] ADD  CONSTRAINT [DF_WebNotification_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[WebNotification]  WITH CHECK ADD  CONSTRAINT [FK_WebNotification_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[WebNotification] CHECK CONSTRAINT [FK_WebNotification_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[WebNotification]  WITH CHECK ADD  CONSTRAINT [FK_WebNotification_UMUserRegistration_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[WebNotification] CHECK CONSTRAINT [FK_WebNotification_UMUserRegistration_UserId]
GO
