USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[vwKPIReportsandRecordTotUpload]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwKPIReportsandRecordTotUpload]  
AS  
SELECT DISTINCT ReportsandRecordTxnId, COUNT(Uploaded) AS TotalUploaded  
FROM            dbo.KPIReportsandRecordTxnDet  
WHERE        (Uploaded <> 'false')  
GROUP BY ReportsandRecordTxnId  
GO
