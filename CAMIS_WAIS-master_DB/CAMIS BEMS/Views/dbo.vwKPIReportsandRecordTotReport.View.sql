USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[vwKPIReportsandRecordTotReport]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwKPIReportsandRecordTotReport]  
AS  
SELECT DISTINCT ReportsandRecordTxnId, COUNT(IsApplicable) AS TotalReport  
FROM            dbo.KPIReportsandRecordTxnDet  
WHERE        (IsApplicable <> 'false')  
GROUP BY ReportsandRecordTxnId  
GO
