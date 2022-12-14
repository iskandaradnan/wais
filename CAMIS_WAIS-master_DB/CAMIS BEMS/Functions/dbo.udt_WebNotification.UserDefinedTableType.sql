USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_WebNotification]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[udt_WebNotification] AS TABLE(
	[NotificationId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[UserId] [int] NULL,
	[NotificationAlerts] [nvarchar](500) NULL,
	[Remarks] [nvarchar](500) NULL,
	[HyperLink] [nvarchar](500) NULL,
	[IsNew] [bit] NULL,
	[SessionUserId] [int] NULL,
	[NotificationDateTime] [datetime] NULL
)
GO
