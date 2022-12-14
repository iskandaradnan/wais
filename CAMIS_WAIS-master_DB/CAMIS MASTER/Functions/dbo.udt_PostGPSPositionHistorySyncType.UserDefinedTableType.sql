USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_PostGPSPositionHistorySyncType]    Script Date: 20-09-2021 16:50:19 ******/
CREATE TYPE [dbo].[udt_PostGPSPositionHistorySyncType] AS TABLE(
	[GPSPositionHistoryId] [int] NULL,
	[UserRegistrationId] [int] NULL,
	[DateTime] [datetime] NULL,
	[DateTimeUTC] [datetime] NULL,
	[Latitude] [numeric](24, 11) NULL,
	[Longitude] [numeric](24, 11) NULL,
	[Remarks] [nvarchar](500) NULL,
	[UserId] [int] NULL
)
GO
