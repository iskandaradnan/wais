USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[TEMPOPENPREVMONTHCRMREQUEST]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TEMPOPENPREVMONTHCRMREQUEST](
	[CRMRequestId] [int] IDENTITY(1,1) NOT NULL,
	[RequestNo] [nvarchar](50) NULL,
	[RequestDateTime] [datetime] NULL,
	[SubmissionDueDate] [datetime] NULL,
	[Completed_Date] [datetime] NULL,
	[RequestStatus] [int] NULL,
	[CRM_StartDate] [datetime] NULL
) ON [PRIMARY]
GO
