USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[DeductionDemeritPointB5CRM05022021]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeductionDemeritPointB5CRM05022021](
	[CRMRequestId] [int] NOT NULL,
	[RequestNo] [nvarchar](50) NULL,
	[RequestDateTime] [datetime] NULL,
	[SubmissionDueDate] [datetime] NULL,
	[SubmissionDate] [datetime] NULL,
	[EndDateMonth] [datetime] NULL,
	[RequestStatus] [int] NULL,
	[DeductionValue] [int] NOT NULL,
	[DemeritPoint] [int] NULL,
	[Deduction] [int] NULL,
	[Flag] [varchar](6) NOT NULL,
	[Year] [int] NULL,
	[Month] [int] NULL,
	[ValidateStatus] [varchar](20) NULL
) ON [PRIMARY]
GO
