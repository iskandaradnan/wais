USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_FEClock_Mobile]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[udt_FEClock_Mobile] AS TABLE(
	[ClockId] [int] NULL,
	[UserRegistrationId] [int] NULL,
	[DateTime] [datetime] NULL,
	[DateTimeUTC] [datetime] NULL,
	[ClockIn] [datetime] NULL,
	[ClockInUTC] [datetime] NULL,
	[ClockInLatitude] [numeric](24, 15) NULL,
	[ClockInLongitude] [numeric](24, 15) NULL,
	[ClockOut] [datetime] NULL,
	[ClockOutUTC] [datetime] NULL,
	[ClockOutLatitude] [numeric](24, 15) NULL,
	[ClockOutLongitude] [numeric](24, 15) NULL,
	[Remarks] [nvarchar](1000) NULL,
	[UserId] [int] NULL
)
GO
