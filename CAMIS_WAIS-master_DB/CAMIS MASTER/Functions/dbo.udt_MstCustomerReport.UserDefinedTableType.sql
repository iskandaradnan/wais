USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_MstCustomerReport]    Script Date: 20-09-2021 16:50:19 ******/
CREATE TYPE [dbo].[udt_MstCustomerReport] AS TABLE(
	[CustomerReportId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[ReportName] [nvarchar](500) NULL,
	[UserId] [int] NOT NULL,
	[IsDeleted] [bit] NULL
)
GO
