USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[KPIReportsandRecordTxnAttachment12012021]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KPIReportsandRecordTxnAttachment12012021](
	[ReportsandRecordTxnAttachId] [int] IDENTITY(1,1) NOT NULL,
	[ReportsandRecordTxnDetId] [int] NOT NULL,
	[CustomerReportId] [int] NOT NULL,
	[CRMNo] [nvarchar](100) NULL,
	[RequestDateTime] [datetime] NULL,
	[SubmissionDueDate] [datetime] NULL,
	[ReportName] [nvarchar](500) NOT NULL,
	[FileName] [nvarchar](255) NULL,
	[SubmissionDate] [datetime] NULL,
	[Verified] [bit] NULL,
	[VerifiedDate] [datetime] NULL,
	[Approved] [bit] NULL,
	[Rejected] [bit] NULL,
	[Justification] [nvarchar](500) NULL,
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
	[GuId] [uniqueidentifier] NOT NULL,
	[YEAR] [int] NULL,
	[MONTH] [int] NULL
) ON [PRIMARY]
GO
