USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[KPIReportsandRecordTxnDet12012021]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KPIReportsandRecordTxnDet12012021](
	[ReportsandRecordTxnDetId] [int] IDENTITY(1,1) NOT NULL,
	[ReportsandRecordTxnId] [int] NULL,
	[CustomerReportId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[SubmissionDueDate] [datetime] NULL,
	[Submitted] [bit] NULL,
	[SubmittedDate] [datetime] NULL,
	[Uploaded] [bit] NULL,
	[Verified] [bit] NULL,
	[VerifiedDate] [datetime] NULL,
	[Approved] [bit] NULL,
	[Rejected] [bit] NULL,
	[Justification] [nvarchar](500) NULL,
	[IsApplicable] [bit] NULL,
	[GeneratedDP] [int] NULL,
	[IsValid] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[FinalDP] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[BuiltIn] [bit] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
