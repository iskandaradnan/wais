USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[vwKPIReportsandRecordTxnAttachment]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwKPIReportsandRecordTxnAttachment]
AS
SELECT        dbo.KPIReportsandRecordTxnAttachment.ReportsandRecordTxnAttachId, dbo.KPIReportsandRecordTxnAttachment.ReportsandRecordTxnDetId, dbo.KPIReportsandRecordTxnAttachment.CustomerReportId, 
                         dbo.KPIReportsandRecordTxnAttachment.CRMNo, dbo.KPIReportsandRecordTxnAttachment.ReportName, dbo.KPIReportsandRecordTxnAttachment.FileName, dbo.KPIReportsandRecordTxnAttachment.Remarks, 
                         dbo.KPIReportsandRecordTxnAttachment.CreatedBy, dbo.KPIReportsandRecordTxnAttachment.CreatedDate, dbo.KPIReportsandRecordTxnAttachment.CreatedDateUTC, dbo.KPIReportsandRecordTxnAttachment.ModifiedBy, 
                         dbo.KPIReportsandRecordTxnAttachment.ModifiedDate, dbo.KPIReportsandRecordTxnAttachment.ModifiedDateUTC, dbo.KPIReportsandRecordTxnAttachment.Timestamp, dbo.KPIReportsandRecordTxnAttachment.Active, 
                         dbo.KPIReportsandRecordTxnAttachment.BuiltIn, dbo.KPIReportsandRecordTxnAttachment.GuId, dbo.vwCRMRequest.RequestDateTime, dbo.KPIReportsandRecordMst.ReportType, dbo.KPIReportsandRecordTxn.Month, 
                         dbo.KPIReportsandRecordTxn.Year, 
                         CASE WHEN dbo.KPIReportsandRecordTxn.Month = 1 THEN 'January' WHEN dbo.KPIReportsandRecordTxn.Month = 2 THEN 'February' WHEN dbo.KPIReportsandRecordTxn.Month = 3 THEN 'March' WHEN dbo.KPIReportsandRecordTxn.Month
                          = 4 THEN 'April' WHEN dbo.KPIReportsandRecordTxn.Month = 5 THEN 'May' WHEN dbo.KPIReportsandRecordTxn.Month = 6 THEN 'June' WHEN dbo.KPIReportsandRecordTxn.Month = 7 THEN 'July' WHEN dbo.KPIReportsandRecordTxn.Month
                          = 8 THEN 'August' WHEN dbo.KPIReportsandRecordTxn.Month = 9 THEN 'September' WHEN dbo.KPIReportsandRecordTxn.Month = 10 THEN 'October' WHEN dbo.KPIReportsandRecordTxn.Month = 11 THEN 'November' WHEN
                          dbo.KPIReportsandRecordTxn.Month = 12 THEN 'December' END AS MonthName, dbo.KPIReportsandRecordTxnAttachment.Approved, dbo.KPIReportsandRecordTxnAttachment.VerifiedDate, 
                         dbo.KPIReportsandRecordTxnAttachment.Rejected, dbo.KPIReportsandRecordTxnAttachment.Justification, dbo.KPIReportsandRecordTxnAttachment.SubmissionDueDate
FROM            dbo.KPIReportsandRecordTxnAttachment INNER JOIN
                         dbo.KPIReportsandRecordMst ON dbo.KPIReportsandRecordTxnAttachment.CustomerReportId = dbo.KPIReportsandRecordMst.CustomerReportId INNER JOIN
                         dbo.KPIReportsandRecordTxnDet ON dbo.KPIReportsandRecordTxnAttachment.ReportsandRecordTxnDetId = dbo.KPIReportsandRecordTxnDet.ReportsandRecordTxnDetId INNER JOIN
                         dbo.KPIReportsandRecordTxn ON dbo.KPIReportsandRecordTxnDet.ReportsandRecordTxnId = dbo.KPIReportsandRecordTxn.ReportsandRecordTxnId LEFT OUTER JOIN
                         dbo.vwCRMRequest ON dbo.KPIReportsandRecordTxnAttachment.CRMNo = dbo.vwCRMRequest.RequestNo
GO
