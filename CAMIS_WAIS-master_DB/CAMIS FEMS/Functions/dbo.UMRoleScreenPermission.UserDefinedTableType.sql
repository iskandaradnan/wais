USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[UMRoleScreenPermission]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[UMRoleScreenPermission] AS TABLE(
	[ScreenId] [int] NOT NULL,
	[UMUserRoleId] [int] NOT NULL,
	[Permissions] [nvarchar](30) NOT NULL,
	[UserId] [int] NOT NULL
)
GO
