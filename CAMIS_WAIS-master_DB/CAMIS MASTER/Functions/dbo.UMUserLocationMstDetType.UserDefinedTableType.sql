USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[UMUserLocationMstDetType]    Script Date: 20-09-2021 16:50:20 ******/
CREATE TYPE [dbo].[UMUserLocationMstDetType] AS TABLE(
	[LocationId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NOT NULL,
	[UserRegistrationId] [int] NOT NULL,
	[UserRoleId] [int] NOT NULL,
	[UserId] [int] NOT NULL
)
GO
