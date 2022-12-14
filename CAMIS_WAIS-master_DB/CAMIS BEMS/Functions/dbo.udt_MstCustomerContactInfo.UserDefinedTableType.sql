USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_MstCustomerContactInfo]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[udt_MstCustomerContactInfo] AS TABLE(
	[CustomerContactInfoId] [int] NULL,
	[CustomerId] [int] NULL,
	[Name] [nvarchar](100) NULL,
	[Designation] [nvarchar](200) NULL,
	[ContactNo] [nvarchar](200) NULL,
	[Email] [nvarchar](200) NULL,
	[UserId] [int] NULL,
	[Active] [bit] NULL
)
GO
