USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[KPIReportsandRecordMst02112020]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KPIReportsandRecordMst02112020](
	[CustomerReportId] [int] IDENTITY(1,1) NOT NULL,
	[ServiceId] [int] NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ReportType] [nvarchar](500) NOT NULL,
	[Frequency] [int] NOT NULL,
	[SubmissionDate] [date] NULL,
	[Remarks] [nvarchar](500) NULL,
	[PIC] [nvarchar](15) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NULL,
	[Active] [bit] NOT NULL,
	[BuiltIn] [bit] NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[MonthDay] [int] NULL
) ON [PRIMARY]
GO
