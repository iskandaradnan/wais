USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[DeductionReportB5_Base05102020]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeductionReportB5_Base05102020](
	[ReportName] [nvarchar](1003) NULL,
	[SubmissionDate] [datetime] NULL,
	[SubmissionDueDate] [datetime] NULL,
	[Frequency] [nvarchar](100) NULL,
	[ValidateStatus] [varchar](1) NOT NULL,
	[DemeritPoint] [int] NULL,
	[DeductionFigurePerReport] [int] NOT NULL,
	[DeductionFigureProHawk] [int] NULL,
	[Year] [int] NULL,
	[Month] [int] NULL,
	[ReportTag] [varchar](13) NOT NULL,
	[ValidateStatusPost] [varchar](1) NULL,
	[DemeritPointPost] [int] NULL,
	[DeductionFigureProHawkPost] [int] NULL,
	[Remarks] [varchar](max) NULL,
	[ReportID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
