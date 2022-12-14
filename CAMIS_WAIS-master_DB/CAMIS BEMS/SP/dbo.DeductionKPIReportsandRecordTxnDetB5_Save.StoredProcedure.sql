USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionKPIReportsandRecordTxnDetB5_Save]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC KPIReportsandRecordTxnDetB5_Save 2020,5    
    
CREATE PROCEDURE [dbo].[DeductionKPIReportsandRecordTxnDetB5_Save]    
(    
 @YEAR INT     
,@MONTH INT     
)    
AS    
BEGIN                    
SET NOCOUNT ON                    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                    
BEGIN TRY             
    
DECLARE @ReportsandRecordTxnId INT     
SET @ReportsandRecordTxnId=(SELECT MAX(ReportsandRecordTxnId) FROM KPIReportsandRecordTxn    
WHERE YEAR=@YEAR    
AND MONTH=@MONTH)    
    
--DECLARE @YEAR INT     
--DECLARE @MONTH INT     
    
--SET @YEAR=2020    
--SET @MONTH=6    
    
--INSERT INTO KPIReportsandRecordTxnDet    
--(    
-- ReportsandRecordTxnId    
--,CustomerReportId    
--,CustomerId    
--,FacilityId    
--,Month    
--,Year    
--,SubmissionDueDate    
--,ReportType  
--,Frequency  
--,PIC  
--,Submitted    
--,SubmittedDate    
--,Uploaded    
--,Verified    
--,VerifiedDate    
--,Approved    
--,Rejected    
--,Justification    
--,IsApplicable    
--,GeneratedDP    
--,IsValid    
--,Remarks    
--,FinalDP    
--,CreatedBy    
--,CreatedDate    
--,CreatedDateUTC    
--,ModifiedBy    
--,ModifiedDate    
--,ModifiedDateUTC    
--,BuiltIn    
--)    
    
SELECT     
 @ReportsandRecordTxnId AS ReportsandRecordTxnId    
,A.CustomerReportId    
,A.CustomerId    
,A.FacilityId    
,B.ReportsandRecordTxnDetId  
,@MONTH AS [Month]    
,@YEAR AS [Year]    
,CASE WHEN @MONTH=1 THEN DATEADD(MONTH,1,A.SubmissionDate)    
      WHEN @MONTH=2 THEN DATEADD(MONTH,2,A.SubmissionDate)    
   WHEN @MONTH=3 THEN DATEADD(MONTH,3,A.SubmissionDate)    
   WHEN @MONTH=4 THEN DATEADD(MONTH,4,A.SubmissionDate)    
   WHEN @MONTH=5 THEN DATEADD(MONTH,5,A.SubmissionDate)    
   WHEN @MONTH=6 THEN DATEADD(MONTH,6,A.SubmissionDate)    
   WHEN @MONTH=7 THEN DATEADD(MONTH,7,A.SubmissionDate)    
   WHEN @MONTH=8 THEN DATEADD(MONTH,8,A.SubmissionDate)    
   WHEN @MONTH=9 THEN DATEADD(MONTH,9,A.SubmissionDate)    
   WHEN @MONTH=10 THEN DATEADD(MONTH,10,A.SubmissionDate)    
   WHEN @MONTH=11 THEN DATEADD(MONTH,11,A.SubmissionDate)    
   WHEN @MONTH=12 THEN DATEADD(MONTH,12,A.SubmissionDate)    
END AS SubmissionDueDate    
,ReportType  
,C.FieldValue AS Frequency  
,PIC  
,B.Submitted    
,B.SubmittedDate    
,NULL AS Uploaded    
,NULL AS Verified    
,NULL AS VerifiedDate    
,NULL AS Approved    
,NULL AS Rejected    
,NULL AS Justification    
,B.IsApplicable AS IsApplicable    
,0 AS GeneratedDP    
,0 AS IsValid    
,'NA' AS Remarks    
,0 AS FinalDP    
,19 AS CreatedBy    
,GETDATE() AS CreatedDate    
,GETUTCDATE() AS CreatedDateUTC    
,19 AS ModifiedBy    
,GETDATE() AS ModifiedDate    
,GETUTCDATE() AS ModifiedDateUTC    
FROM KPIReportsandRecordMst A  
INNER JOIN KPIReportsandRecordTxnDet B  
ON A.CustomerReportId = B.CustomerReportId  
INNER JOIN FMLovMst C  
ON A.Frequency=C.LovId  
WHERE B.ReportsandRecordTxnId=@ReportsandRecordTxnId  
  
    
IF(GETDATE()=DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))    
BEGIN     
    
UPDATE A    
SET A.SubmissionDate=DATEADD(YEAR,1,SubmissionDate)    
FROM KPIReportsandRecordMst A    
  
  
    
END    
    
    
END TRY                    
BEGIN CATCH                    
                    
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                    
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                    
                    
THROW                    
                    
END CATCH                    
SET NOCOUNT OFF                    
END          
    
--SELECT *,CASE WHEN @MONTH=12 THEN DATEADD(MONTH,12,SubmissionDate) END AS NewDate FROM KPIReportsandRecordMst    
GO
