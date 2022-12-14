USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_FMLovMst_Mobile]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_FMLovMst_Mobile] AS TABLE(
	[LovId] [int] NULL,
	[ModuleName] [nvarchar](200) NULL,
	[ScreenName] [nvarchar](200) NULL,
	[FieldName] [nvarchar](200) NULL,
	[LovKey] [nvarchar](200) NULL,
	[FieldCode] [nvarchar](200) NULL,
	[FieldValue] [nvarchar](200) NULL,
	[Remarks] [nvarchar](200) NULL,
	[ParentId] [int] NULL,
	[SortNo] [int] NULL,
	[IsDefault] [bit] NULL,
	[IsEditable] [bit] NULL,
	[Active] [bit] NULL,
	[BuiltIn] [bit] NULL,
	[UserId] [int] NULL
)
GO
