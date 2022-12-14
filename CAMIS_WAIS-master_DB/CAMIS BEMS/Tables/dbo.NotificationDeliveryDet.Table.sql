USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[NotificationDeliveryDet]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationDeliveryDet](
	[NotificationDeliveryId] [int] IDENTITY(1,1) NOT NULL,
	[NotificationTemplateId] [int] NOT NULL,
	[RecepientType] [int] NULL,
	[UserRoleId] [int] NULL,
	[UserRegistrationId] [int] NULL,
	[FacilityId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[Status] [int] NULL,
	[EmailId] [nvarchar](100) NULL,
	[CompanyId] [int] NULL,
	[LocationId] [int] NULL,
 CONSTRAINT [PK_EDDEmailDeliveryId] PRIMARY KEY CLUSTERED 
(
	[NotificationDeliveryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NotificationDeliveryDet] ADD  CONSTRAINT [DF_NotificationDeliveryDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[NotificationDeliveryDet]  WITH CHECK ADD  CONSTRAINT [FK_EDDEmailTemplateId] FOREIGN KEY([NotificationTemplateId])
REFERENCES [dbo].[NotificationTemplate] ([NotificationTemplateId])
GO
ALTER TABLE [dbo].[NotificationDeliveryDet] CHECK CONSTRAINT [FK_EDDEmailTemplateId]
GO
ALTER TABLE [dbo].[NotificationDeliveryDet]  WITH CHECK ADD  CONSTRAINT [FK_EDDUserRoleId] FOREIGN KEY([UserRoleId])
REFERENCES [dbo].[UMUserRole] ([UMUserRoleId])
GO
ALTER TABLE [dbo].[NotificationDeliveryDet] CHECK CONSTRAINT [FK_EDDUserRoleId]
GO
ALTER TABLE [dbo].[NotificationDeliveryDet]  WITH CHECK ADD  CONSTRAINT [FK_NDDCompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[NotificationDeliveryDet] CHECK CONSTRAINT [FK_NDDCompanyId]
GO
ALTER TABLE [dbo].[NotificationDeliveryDet]  WITH CHECK ADD  CONSTRAINT [FK_NDDFacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[NotificationDeliveryDet] CHECK CONSTRAINT [FK_NDDFacilityId]
GO
ALTER TABLE [dbo].[NotificationDeliveryDet]  WITH CHECK ADD  CONSTRAINT [FK_NDDLocationId] FOREIGN KEY([LocationId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[NotificationDeliveryDet] CHECK CONSTRAINT [FK_NDDLocationId]
GO
ALTER TABLE [dbo].[NotificationDeliveryDet]  WITH CHECK ADD  CONSTRAINT [FK_NDDUserRegistrationId] FOREIGN KEY([UserRegistrationId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[NotificationDeliveryDet] CHECK CONSTRAINT [FK_NDDUserRegistrationId]
GO
