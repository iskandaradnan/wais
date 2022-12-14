USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[KPIReportsandRecordTxnDet]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KPIReportsandRecordTxnDet](
	[ReportsandRecordTxnDetId] [int] IDENTITY(1,1) NOT NULL,
	[ReportsandRecordTxnId] [int] NULL,
	[CustomerReportId] [int] NULL,
	[Submitted] [bit] NULL,
	[Verified] [bit] NULL,
	[ReportName] [nvarchar](500) NULL,
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
 CONSTRAINT [PK_KPIReportsandRecordTxnDet] PRIMARY KEY CLUSTERED 
(
	[ReportsandRecordTxnDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[KPIReportsandRecordTxnDet] ADD  CONSTRAINT [DF_KPIReportsandRecordTxnDet_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[KPIReportsandRecordTxnDet] ADD  CONSTRAINT [DF_KPIReportsandRecordTxnDet_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[KPIReportsandRecordTxnDet] ADD  CONSTRAINT [DF_KPIReportsandRecordTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[KPIReportsandRecordTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_KPIReportsandRecordTxn_MstCustomerReport_CustomerReportId] FOREIGN KEY([CustomerReportId])
REFERENCES [dbo].[MstCustomerReport] ([CustomerReportId])
GO
ALTER TABLE [dbo].[KPIReportsandRecordTxnDet] CHECK CONSTRAINT [FK_KPIReportsandRecordTxn_MstCustomerReport_CustomerReportId]
GO
ALTER TABLE [dbo].[KPIReportsandRecordTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_KPIReportsandRecordTxnDet_KPIReportsandRecordTxn_ReportsandRecordTxnId] FOREIGN KEY([ReportsandRecordTxnId])
REFERENCES [dbo].[KPIReportsandRecordTxn] ([ReportsandRecordTxnId])
GO
ALTER TABLE [dbo].[KPIReportsandRecordTxnDet] CHECK CONSTRAINT [FK_KPIReportsandRecordTxnDet_KPIReportsandRecordTxn_ReportsandRecordTxnId]
GO
