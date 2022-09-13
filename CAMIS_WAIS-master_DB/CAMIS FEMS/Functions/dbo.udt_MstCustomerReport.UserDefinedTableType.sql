USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_MstCustomerReport]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_MstCustomerReport] AS TABLE(
	[CustomerReportId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[ReportName] [nvarchar](500) NULL,
	[UserId] [int] NOT NULL,
	[IsDeleted] [bit] NULL
)
GO
