USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_WebNotificationNavigate]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[udt_WebNotificationNavigate] AS TABLE(
	[NotificationId] [int] NULL,
	[IsNavigate] [bit] NULL,
	[UserId] [int] NULL
)
GO
