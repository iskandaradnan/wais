USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_FMConfigCustomerValues]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_FMConfigCustomerValues] AS TABLE(
	[ConfigValueId] [int] NULL,
	[CustomerId] [int] NULL,
	[ConfigKeyId] [int] NULL,
	[ConfigKeyLovId] [int] NULL,
	[UserId] [int] NULL
)
GO
