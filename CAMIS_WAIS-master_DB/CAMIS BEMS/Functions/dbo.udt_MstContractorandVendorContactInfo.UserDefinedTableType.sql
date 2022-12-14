USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_MstContractorandVendorContactInfo]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[udt_MstContractorandVendorContactInfo] AS TABLE(
	[ContractorContactInfoId] [int] NULL,
	[ContractorId] [int] NULL,
	[Name] [nvarchar](100) NULL,
	[Designation] [nvarchar](200) NULL,
	[ContactNo] [nvarchar](200) NULL,
	[Email] [nvarchar](200) NULL,
	[Active] [bit] NULL
)
GO
