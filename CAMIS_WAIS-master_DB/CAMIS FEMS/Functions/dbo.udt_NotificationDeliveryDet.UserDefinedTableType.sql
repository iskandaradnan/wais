USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_NotificationDeliveryDet]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_NotificationDeliveryDet] AS TABLE(
	[NotificationDeliveryId] [int] NULL,
	[NotificationTemplateId] [int] NULL,
	[RecepientType] [int] NULL,
	[UserRoleId] [int] NULL,
	[UserRegistrationId] [int] NULL,
	[FacilityId] [int] NULL,
	[UserId] [int] NULL,
	[EmailId] [nvarchar](100) NULL,
	[CompanyId] [int] NULL
)
GO
