USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[UMUserRole22022020702]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UMUserRole22022020702](
	[UMUserRoleId] [int] IDENTITY(1,1) NOT NULL,
	[UserTypeId] [int] NOT NULL,
	[Name] [nvarchar](100) NULL,
	[Status] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[Active] [bit] NOT NULL,
	[BuiltIn] [bit] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
