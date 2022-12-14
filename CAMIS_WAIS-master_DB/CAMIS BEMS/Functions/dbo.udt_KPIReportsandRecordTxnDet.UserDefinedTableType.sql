USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_KPIReportsandRecordTxnDet]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[udt_KPIReportsandRecordTxnDet] AS TABLE(
	[ReportsandRecordTxnDetId] [int] NULL,
	[CustomerReportId] [int] NULL,
	[Submitted] [bit] NULL,
	[Verified] [bit] NULL,
	[ReportName] [nvarchar](200) NULL,
	[Remarks] [nvarchar](500) NULL,
	[UserId] [int] NOT NULL,
	[IsDeleted] [bit] NULL
)
GO
