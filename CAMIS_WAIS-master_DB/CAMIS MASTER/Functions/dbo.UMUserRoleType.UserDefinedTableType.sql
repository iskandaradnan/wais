USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[UMUserRoleType]    Script Date: 20-09-2021 16:50:20 ******/
CREATE TYPE [dbo].[UMUserRoleType] AS TABLE(
	[UMUserRoleId] [int] NOT NULL,
	[UserTypeId] [int] NOT NULL,
	[Name] [nvarchar](100) NULL,
	[Status] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[UserId] [int] NOT NULL
)
GO
