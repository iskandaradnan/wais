USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionDemeritPointB5_Report]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
          
          
          
--EXEC [DeductionDemeritPointB5_Report] 2020,8          
CREATE PROCEDURE [dbo].[DeductionDemeritPointB5_Report]          
(          
 @Year INT          
,@Month INT          
)          
AS           
BEGIN          
SET NOCOUNT ON                              
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                              
BEGIN TRY                       
          
          
SELECT ReportName          
,CAST(SubmissionDate AS DATE) AS SubmissionDate          
,CAST(SubmissionDueDate AS DATE) AS SubmissionDueDate          
,Frequency          
,ValidateStatus          
,DemeritPoint          
,DeductionFigurePerReport          
,DeductionFigureProHawk          
,Year          
,Month           
,ReportTag      
,IsApplicable    
FROM DeductionReportB5_Base           
WHERE Year=@Year          
AND Month=@Month          
AND (ISNULL(SubmissionDate,'')<>'' AND ReportTag='Other Reports')          
    
--to be uncommented on 1st feb    
          
UNION ALL    
    
    
SELECT     
RequestNo AS ReportName          
,CAST(SubmissionDate AS DATE) AS SubmissionDate          
,CAST(SubmissionDueDate AS DATE) AS SubmissionDueDate          
,'' AS Frequency          
,ValidateStatus          
,DemeritPoint          
,DeductionValue AS  DeductionFigurePerReport          
,Deduction AS DeductionFigureProHawk          
,Year          
,Month           
,'Other Reports' AS ReportTag      
,'1' AS IsApplicable    --set 1 as default value
FROM DeductionDemeritPointB5CRM    
WHERE Year=@Year          
AND Month=@Month          
    
    
    
    
UNION ALL          
          
          
          
SELECT ReportName          
        
,CAST(SubmissionDate AS DATE) AS SubmissionDate          
,CAST(SubmissionDueDate AS DATE) AS SubmissionDueDate          
,Frequency          
,ValidateStatus          
,DemeritPoint          
,DeductionFigurePerReport          
,DeductionFigureProHawk          
,Year          
,Month           
,ReportTag       
,IsApplicable    
FROM DeductionReportB5_Base           
WHERE Year=@Year          
AND Month=@Month          
AND ReportTag='Main Reports'          
          
          
--SELECT * FROM DeductionReportB5_Base          
          
END TRY                              
BEGIN CATCH                              
                              
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                              
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                              
                              
THROW                              
                              
END CATCH                              
SET NOCOUNT OFF                              
          
          
END 
GO
