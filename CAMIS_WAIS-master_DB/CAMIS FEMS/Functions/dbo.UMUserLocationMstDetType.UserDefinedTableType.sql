USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[UMUserLocationMstDetType]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[UMUserLocationMstDetType] AS TABLE(
	[LocationId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NOT NULL,
	[UserRegistrationId] [int] NOT NULL,
	[UserRoleId] [int] NOT NULL,
	[UserId] [int] NOT NULL
)
GO
