USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionKPIReportsandRecordTxnDetB5_GetByID]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
          
--EXEC KPIReportsandRecordTxnDetB5_GetByID 18, 203,2,2020,7          
CREATE PROCEDURE [dbo].[DeductionKPIReportsandRecordTxnDetB5_GetByID]          
(          
 @ReportsandRecordTxnId INT       
,@ReportsandRecordTxnDetId INT    
,@CustomerReportId INT          
,@YEAR INT          
,@Month INT          
)          
AS          
BEGIN          
          
SET NOCOUNT ON                              
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                              
BEGIN TRY                       
          
          
--DECLARE @ReportsandRecordTxnId INT          
--DECLARE @ReportsandRecordTxnDetId INT        
--DECLARE @CustomerReportId INT          
--DECLARE @YEAR INT          
--DECLARE @Month INT          
          
          
SELECT B.Year          
,B.Month          
,A.ReportType          
,C.FieldValue AS Frequency          
,B.SubmissionDueDate          
,B.ReportsandRecordTxnDetId          
,A.PIC          
,B.SubmittedDate          
FROM KPIReportsandRecordTxnDet B            
LEFT OUTER JOIN KPIReportsandRecordMst  A         
ON A.CustomerReportId=B.CustomerReportId          
LEFT OUTER JOIN [uetrackMasterdbPreProd].[DBO].FMLovMst C            
ON A.Frequency=C.LovId            
WHERE B.ReportsandRecordTxnId=@ReportsandRecordTxnId           
AND B.ReportsandRecordTxnDetId=@ReportsandRecordTxnDetId    
AND B.CustomerReportId=@CustomerReportId          
AND Year=@YEAR          
AND Month=@Month          
AND B.IsApplicable=1      
      
          
END TRY                              
BEGIN CATCH                              
                              
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                              
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                              
                              
THROW                              
                              
END CATCH                              
SET NOCOUNT OFF                              
          
          
END
GO
