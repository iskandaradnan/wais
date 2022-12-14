USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[UserLocationType]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[UserLocationType] AS TABLE(
	[UserLocationId] [int] NULL,
	[UserAreaId] [int] NULL,
	[LevelId] [int] NULL,
	[CustomerId] [int] NULL,
	[BlockId] [int] NULL,
	[FacilityId] [int] NULL,
	[UserLocationCode] [varchar](max) NULL,
	[UserLocationName] [varchar](max) NULL,
	[Active] [bit] NULL,
	[ActiveFromDate] [datetime] NULL,
	[ActiveTodate] [datetime] NULL,
	[AuthorizedStaffId] [int] NULL,
	[UserId] [int] NULL
)
GO
