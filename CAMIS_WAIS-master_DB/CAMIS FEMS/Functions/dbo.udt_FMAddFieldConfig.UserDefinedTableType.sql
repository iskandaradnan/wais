USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_FMAddFieldConfig]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_FMAddFieldConfig] AS TABLE(
	[AddFieldConfigId] [int] NULL,
	[CustomerId] [int] NULL,
	[ScreenNameLovId] [int] NULL,
	[FieldTypeLovId] [int] NULL,
	[FieldName] [nvarchar](100) NULL,
	[Name] [nvarchar](100) NULL,
	[DropDownValues] [nvarchar](1000) NULL,
	[RequiredLovId] [int] NULL,
	[PatternLovId] [int] NULL,
	[MaxLength] [int] NULL,
	[UserId] [int] NULL,
	[IsDeleted] [bit] NULL
)
GO
