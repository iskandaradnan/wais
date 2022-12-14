USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[KPIReportsandRecordMst]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KPIReportsandRecordMst](
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
	[MonthDay] [int] NULL,
 CONSTRAINT [PK_MstCustomerReportNew] PRIMARY KEY CLUSTERED 
(
	[CustomerReportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[KPIReportsandRecordMst] ADD  CONSTRAINT [DF_KPIReportsandRecordMst_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[KPIReportsandRecordMst] ADD  CONSTRAINT [DF_KPIReportsandRecordMst_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[KPIReportsandRecordMst] ADD  CONSTRAINT [DF_KPIReportsandRecordMst_GuId]  DEFAULT (newid()) FOR [GuId]
GO
