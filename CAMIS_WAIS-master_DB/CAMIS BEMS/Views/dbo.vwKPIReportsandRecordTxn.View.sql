USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[vwKPIReportsandRecordTxn]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwKPIReportsandRecordTxn]  
AS  
SELECT        dbo.KPIReportsandRecordTxn.Year,   
                         CASE WHEN dbo.KPIReportsandRecordTxn.Month = 1 THEN 'Jan' WHEN dbo.KPIReportsandRecordTxn.Month = 2 THEN 'Feb' WHEN dbo.KPIReportsandRecordTxn.Month = 3 THEN 'Mar' WHEN dbo.KPIReportsandRecordTxn.Month  
                          = 4 THEN 'Apr' WHEN dbo.KPIReportsandRecordTxn.Month = 5 THEN 'May' WHEN dbo.KPIReportsandRecordTxn.Month = 6 THEN 'Jun' WHEN dbo.KPIReportsandRecordTxn.Month = 7 THEN 'Jul' WHEN dbo.KPIReportsandRecordTxn.Month  
                          = 8 THEN 'Aug' WHEN dbo.KPIReportsandRecordTxn.Month = 9 THEN 'Sep' WHEN dbo.KPIReportsandRecordTxn.Month = 10 THEN 'Oct' WHEN dbo.KPIReportsandRecordTxn.Month = 11 THEN 'Nov' ELSE 'Dec' END AS Month,   
                         dbo.vwKPIReportsandRecordTotReport.TotalReport, dbo.vwKPIReportsandRecordTotSubmit.TotalSubmitted, dbo.vwKPIReportsandRecordTotUpload.TotalUploaded, dbo.KPIReportsandRecordTxn.ReportsandRecordTxnId,   
                         dbo.FMLovMst.FieldValue AS Status, dbo.KPIReportsandRecordTxn.Month AS MonthId  
FROM            dbo.KPIReportsandRecordTxn LEFT OUTER JOIN  
                         dbo.FMLovMst ON dbo.KPIReportsandRecordTxn.Status = dbo.FMLovMst.LovId LEFT OUTER JOIN  
                         dbo.vwKPIReportsandRecordTotUpload ON dbo.KPIReportsandRecordTxn.ReportsandRecordTxnId = dbo.vwKPIReportsandRecordTotUpload.ReportsandRecordTxnId LEFT OUTER JOIN  
                         dbo.vwKPIReportsandRecordTotReport ON dbo.KPIReportsandRecordTxn.ReportsandRecordTxnId = dbo.vwKPIReportsandRecordTotReport.ReportsandRecordTxnId LEFT OUTER JOIN  
                         dbo.vwKPIReportsandRecordTotSubmit ON dbo.KPIReportsandRecordTxn.ReportsandRecordTxnId = dbo.vwKPIReportsandRecordTotSubmit.ReportsandRecordTxnId  
GO
