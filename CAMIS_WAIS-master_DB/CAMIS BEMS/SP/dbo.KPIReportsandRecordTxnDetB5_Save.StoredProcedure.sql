USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[KPIReportsandRecordTxnDetB5_Save]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                
--EXEC KPIReportsandRecordTxnDetB5_Save 1,2020              
         
CREATE PROCEDURE [dbo].[KPIReportsandRecordTxnDetB5_Save]                
(                
@Year INT                
,@Month INT        
      
)                
AS                
BEGIN                
SELECT                 

 ReportsandRecordTxnId, ReportType, Month, Year, SubmissionDate, 
                         Submitted, SubmittedDate, Uploaded, IsApplicable, 
                         ReportsandRecordTxnDetId, Remarks, PIC, CustomerReportId, 
                         Status, Frequency, Justification, 
                         SubmissionDueDate, Approved, Rejected, Verified, 
                         VerifiedDate

FROM vwKPIReportsandRecordTxnDet               
WHERE Year=@YEAR              
AND Month=@MONTH       
      
--SELECT        dbo.KPIReportsandRecordTxn.ReportsandRecordTxnId, dbo.KPIReportsandRecordMst.ReportType, dbo.KPIReportsandRecordTxn.Month, dbo.KPIReportsandRecordTxn.Year, dbo.KPIReportsandRecordMst.SubmissionDate,       
--                         dbo.KPIReportsandRecordTxnDet.Submitted, dbo.KPIReportsandRecordTxnDet.SubmittedDate, dbo.KPIReportsandRecordTxnDet.Uploaded, dbo.KPIReportsandRecordTxnDet.IsApplicable,       
--                         dbo.KPIReportsandRecordTxnDet.ReportsandRecordTxnDetId, dbo.KPIReportsandRecordMst.Remarks, dbo.KPIReportsandRecordMst.PIC, dbo.KPIReportsandRecordTxnDet.CustomerReportId,       
--                         dbo.KPIReportsandRecordTxnDet.Verified, dbo.KPIReportsandRecordTxnDet.Approved, dbo.KPIReportsandRecordTxnDet.Rejected, dbo.KPIReportsandRecordTxnDet.VerifiedDate,       
--                         dbo.KPIReportsandRecordTxn.Status AS StatusId, FMLovMst_1.FieldValue AS Status, dbo.KPIReportsandRecordMst.Frequency AS FrequencyId, dbo.FMLovMst.FieldValue AS Frequency,       
--                         dbo.KPIReportsandRecordTxnDet.Justification, dbo.KPIReportsandRecordTxnDet.SubmissionDueDate      
--FROM            dbo.KPIReportsandRecordMst INNER JOIN      
--                         dbo.FMLovMst ON dbo.KPIReportsandRecordMst.Frequency = dbo.FMLovMst.LovId RIGHT OUTER JOIN      
--                         dbo.KPIReportsandRecordTxn INNER JOIN      
--                         dbo.KPIReportsandRecordTxnDet ON dbo.KPIReportsandRecordTxn.ReportsandRecordTxnId = dbo.KPIReportsandRecordTxnDet.ReportsandRecordTxnId LEFT OUTER JOIN      
--                         dbo.FMLovMst AS FMLovMst_1 ON dbo.KPIReportsandRecordTxn.Status = FMLovMst_1.LovId ON dbo.KPIReportsandRecordMst.CustomerReportId = dbo.KPIReportsandRecordTxnDet.CustomerReportId      
--WHERE Year=@YEAR                
--AND Month=@MONTH       
      
END                 
                
      
      
      
      
GO
