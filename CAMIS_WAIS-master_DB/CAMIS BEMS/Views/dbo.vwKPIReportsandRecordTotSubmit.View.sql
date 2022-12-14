USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[vwKPIReportsandRecordTotSubmit]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwKPIReportsandRecordTotSubmit]
AS
SELECT DISTINCT ReportsandRecordTxnId, COUNT(Submitted) AS TotalSubmitted
FROM            dbo.KPIReportsandRecordTxnDet
WHERE        (Submitted <> 'false')
GROUP BY ReportsandRecordTxnId
GO
