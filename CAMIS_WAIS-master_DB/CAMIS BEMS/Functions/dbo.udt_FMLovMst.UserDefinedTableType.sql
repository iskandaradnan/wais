USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_FMLovMst]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[udt_FMLovMst] AS TABLE(
	[LovId] [int] NULL,
	[ModuleName] [nvarchar](200) NULL,
	[ScreenName] [nvarchar](200) NULL,
	[FieldName] [nvarchar](200) NULL,
	[LovKey] [nvarchar](200) NULL,
	[FieldCode] [nvarchar](200) NULL,
	[FieldValue] [nvarchar](200) NULL,
	[Remarks] [nvarchar](500) NULL,
	[ParentId] [int] NULL,
	[SortNo] [int] NULL,
	[IsDefault] [bit] NULL,
	[IsEditable] [bit] NULL,
	[Active] [bit] NULL,
	[BuiltIn] [bit] NULL,
	[UserId] [int] NULL,
	[LovType] [int] NULL
)
GO
