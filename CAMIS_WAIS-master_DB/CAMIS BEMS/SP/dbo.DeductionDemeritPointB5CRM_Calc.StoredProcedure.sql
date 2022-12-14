USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionDemeritPointB5CRM_Calc]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
--EXEC [DeductionDemeritPointB5CRM_Calc] 2021,3               
                
CREATE PROCEDURE [dbo].[DeductionDemeritPointB5CRM_Calc]                
(                
@YEAR INT                
,@MONTH INT                
                
)                
AS                
                
BEGIN                              
SET NOCOUNT ON                              
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                              
BEGIN TRY                       
    
DELETE FROM DeductionDemeritPointB5CRM WHERE YEAR=@YEAR AND MONTH=@MONTH    
  
--139 BEMS CRM CRMRequestStatus CRMRequestStatusValue 1  Open Open  
--140 BEMS CRM CRMRequestStatus CRMRequestStatusValue 2  Work In Progress Work In Progress  
--141 BEMS CRM CRMRequestStatus CRMRequestStatusValue 3  Completed Completed  
--142 BEMS CRM CRMRequestStatus CRMRequestStatusValue 4  Closed Closed  
--143 BEMS CRM CRMRequestStatus CRMRequestStatusValue 5  Cancelled Cancelled  
--251 BEMS CRM CRMRequestStatus CRMRequestStatusValue 6  Reassigned Reassigned  
  
  
IF OBJECT_ID('tempdb.dbo.#TEMP_MAIN', 'U') IS NOT NULL                  
DROP TABLE #TEMP_MAIN                
                
                
IF OBJECT_ID('tempdb.dbo.#TEMP_CALC', 'U') IS NOT NULL                  
DROP TABLE #TEMP_CALC                
                
IF OBJECT_ID('tempdb.dbo.#TEMPOPENPREVMONTH', 'U') IS NOT NULL                  
DROP TABLE #TEMPOPENPREVMONTH                
                
IF OBJECT_ID('tempdb.dbo.#TEMPCURRCLOSED_CALC', 'U') IS NOT NULL                  
DROP TABLE #TEMPCURRCLOSED_CALC                
                
IF OBJECT_ID('tempdb.dbo.#TEMPPREVCLOSED_CALC', 'U') IS NOT NULL                  
DROP TABLE #TEMPPREVCLOSED_CALC                
                
                
IF OBJECT_ID('tempdb.dbo.#TEMPCURROPEN_CALC', 'U') IS NOT NULL                  
DROP TABLE #TEMPCURROPEN_CALC                
                
                
IF OBJECT_ID('tempdb.dbo.#TEMPPREVOPEN_CALC', 'U') IS NOT NULL                  
DROP TABLE #TEMPPREVOPEN_CALC                
  
  
--DECLARE @YEAR INT               
--DECLARE @MONTH INT                
DECLARE @PREV_YEAR INT                 
DECLARE @PREV_MONTH INT                
DECLARE @LEAPYEAR VARCHAR(10)                
DECLARE @STARTOFYEAR DATETIME    
  
--SET @YEAR=2020                
--SET @MONTH=12                
  
SET @STARTOFYEAR='2020-08-01'    
--SET @STARTOFYEAR=(SELECT CASE WHEN @MONTH=12 THEN DATEADD(YEAR,-1,DATEFROMPARTS(YEAR(GETDATE()), 1, 1)) ELSE   
--DATEFROMPARTS(YEAR(GETDATE()), 1, 1)  
--END)    
--SELECT @STARTOFYEAR    
                
--DECLARE @MONTHCALC INT                
                
                
SET @LEAPYEAR=(                
CASE                
DAY(EOMONTH(DATEADD(DAY,31,DATEADD(YEAR,@YEAR-1900,0))))                
WHEN 29 THEN 'YES' ELSE 'NO'                
END)                
                
                
SET @PREV_YEAR=(CASE WHEN @MONTH=1 THEN @YEAR-1 ELSE @YEAR END)                
SET @PREV_MONTH=(CASE WHEN @MONTH=1 THEN 12 ELSE @MONTH-1 END)                
                
                
--SET @MONTHCALC=(CASE WHEN @MONTH IN (1,2,3,4,5,6,7,8,9) THEN CONCAT('0',@MONTH) ELSE @MONTH END)                
                
DECLARE @StartDate DATETIME                
DECLARE @EndDate DATETIME                
                
SET @StartDate=CAST(CONCAT(CONCAT(CONCAT(@MONTH,'-01'),'-'),@YEAR) AS DATE)                
SET @EndDate=CAST((CASE WHEN @MONTH IN (1,3,5,7,8,10,12) THEN CONCAT(CONCAT(CONCAT(@MONTH,'-31'),'-'),@YEAR)                
WHEN @MONTH IN (2) AND @LEAPYEAR='YES' THEN CONCAT(CONCAT(CONCAT(@MONTH,'-29'),'-'),@YEAR)                
WHEN @MONTH IN (2) AND @LEAPYEAR='NO' THEN CONCAT(CONCAT(CONCAT(@MONTH,'-28'),'-'),@YEAR)                
ELSE CONCAT(CONCAT(CONCAT(@MONTH,'-30'),'-'),@YEAR) END) AS DATE)                
                
--SELECT @StartDate,@EndDate,@MONTH,@PREV_YEAR,@PREV_MONTH                
  
  
  
SELECT CRMRequestId  
,RequestNo  
,RequestDateTime   
,DATEADD(DAY,14,RequestDateTime)+1 AS SubmissionDueDate  
,Completed_Date AS SubmissionDate  
,RequestStatus  
,@EndDate AS EndDateMonth  
--,CASE WHEN ISNULL(Completed_Date,'')='' THEN 0 ELSE DATEDIFF(DAY,Completed_Date,(DATEADD(DAY,14,RequestDateTime)+1)) END AS RepairTimeDays                
--,CASE WHEN Completed_Date > DATEADD(DAY,14,RequestDateTime)+1 THEN DATEDIFF(DAY,Completed_Date,(DATEADD(DAY,14,RequestDateTime)+1))  
--      WHEN  ISNULL(Completed_Date,'')='' THEN DATEDIFF(DAY,DATEADD(DAY,14,RequestDateTime)+1,@EndDate)   
--   END AS DemeritPoint  
INTO #TEMP_MAIN  
FROM [uetrackMasterdbPreProd].[DBO].CRMRequest  
WHERE TypeOfRequest=132  
AND ServiceId=2  
AND RequestDateTime >=@STARTOFYEAR AND   RequestDateTime<=@EndDate              
AND RequestNo NOT IN 
(
 'CRMWAC/B/2020/000031'
,'CRMWAC/B/2020/000032'
)  
  
  
SELECT CRMRequestId  
,RequestNo  
,RequestDateTime  
,SubmissionDueDate  
,SubmissionDate  
,EndDateMonth  
,RequestStatus  
,50 AS DeductionValue  
,CASE WHEN SubmissionDate > DATEADD(DAY,14,RequestDateTime)+1   
      AND MONTH(RequestDateTime)=@MONTH AND SubmissionDueDate=@MONTH AND ISNULL(SubmissionDate,'')<>''  
   THEN DATEDIFF(DAY,SubmissionDate,(DATEADD(DAY,14,RequestDateTime)+1))  
        
      WHEN ISNULL(SubmissionDate,'')=''  
      AND MONTH(RequestDateTime)=@MONTH AND SubmissionDueDate=@MONTH   
   THEN DATEDIFF(DAY,(DATEADD(DAY,14,RequestDateTime)+1),@EndDate)  
   
   
   ----OLD LOGIC
   --WHEN MONTH(RequestDateTime)< @MONTH AND MONTH(SubmissionDueDate)< @MONTH AND ISNULL(SubmissionDate,'')=@MONTH  
   --THEN  DATEDIFF(DAY,@StartDate,ISNULL(SubmissionDate,''))+1  
  
   --WHEN MONTH(RequestDateTime)< @MONTH AND MONTH(SubmissionDueDate)< @MONTH AND ISNULL(SubmissionDate,'')=''  
   --THEN  DATEDIFF(DAY,@StartDate,@EndDate)+1  
  
   --WHEN MONTH(RequestDateTime)< @MONTH AND MONTH(SubmissionDueDate)=@MONTH AND ISNULL(SubmissionDate,'')=''  
   --THEN  DATEDIFF(DAY,@StartDate,@EndDate)+1  
   
   -----NEW LOGIC
   
   WHEN RequestDateTime < @EndDate AND SubmissionDueDate < @EndDate AND MONTH(ISNULL(SubmissionDate,''))=@MONTH  
   THEN  DATEDIFF(DAY,@StartDate,ISNULL(SubmissionDate,''))+1  
  
   WHEN RequestDateTime< @EndDate AND SubmissionDueDate < @EndDate AND ISNULL(SubmissionDate,'')=''  
   THEN  DATEDIFF(DAY,@StartDate,@EndDate)+1  
  
   WHEN RequestDateTime < @EndDate AND MONTH(SubmissionDueDate)=@MONTH AND ISNULL(SubmissionDate,'')=''  
   THEN  DATEDIFF(DAY,@StartDate,@EndDate)+1  

   END AS DemeritPoint  
  
  
,CASE WHEN SubmissionDate > DATEADD(DAY,14,RequestDateTime)+1   
      AND MONTH(RequestDateTime)=@MONTH AND SubmissionDueDate=@MONTH AND ISNULL(SubmissionDate,'')<>''  
   THEN 'Y'  
        
      WHEN ISNULL(SubmissionDate,'')=''  
      AND MONTH(RequestDateTime)=@MONTH AND SubmissionDueDate=@MONTH   
   THEN 'Y'  
     
   --WHEN MONTH(RequestDateTime)< @MONTH AND MONTH(SubmissionDueDate)< @MONTH AND ISNULL(SubmissionDate,'')=@MONTH  
   --THEN  'Y'  
  
   --WHEN MONTH(RequestDateTime)< @MONTH AND MONTH(SubmissionDueDate)< @MONTH AND ISNULL(SubmissionDate,'')=''  
   --THEN  'Y'  
  
   --WHEN MONTH(RequestDateTime)< @MONTH AND MONTH(SubmissionDueDate)=@MONTH AND ISNULL(SubmissionDate,'')=''  
   --THEN  'Y'  
   
   WHEN RequestDateTime< @EndDate AND SubmissionDueDate < @EndDate AND MONTH(ISNULL(SubmissionDate,''))=@MONTH  
   THEN  'Y' 
  
   WHEN RequestDateTime< @EndDate AND SubmissionDueDate < @EndDate AND ISNULL(SubmissionDate,'')=''  
   THEN  'Y'  
  
   WHEN RequestDateTime < @EndDate AND MONTH(SubmissionDueDate)=@MONTH AND ISNULL(SubmissionDate,'')=''  
   THEN  'Y'
   
   ELSE 'N'  
   END AS ValidateStatus  
INTO #TEMP_CALC                
FROM #TEMP_MAIN  
  
  
  
------------------CURRENT MONTH CLOSED                 
  
SELECT   
 CRMRequestId  
,RequestNo  
,RequestDateTime  
,SubmissionDueDate  
,SubmissionDate  
,EndDateMonth  
,RequestStatus  
,DeductionValue  
,DemeritPoint  
,DemeritPoint*DeductionValue AS Deduction  
,ValidateStatus  
,'Others' AS Flag                
INTO #TEMPCURRCLOSED_CALC                
FROM #TEMP_CALC                
WHERE                 
YEAR(RequestDateTime)=@YEAR                
AND MONTH(RequestDateTime )=@MONTH                
AND RequestStatus IN (141,142)  
  
  
-------------OPEN  PREVIOUS MONTH CLOSED CURRENT MONTH                
  
SELECT   
 CRMRequestId  
,RequestNo  
,RequestDateTime  
,SubmissionDueDate  
,SubmissionDate  
,EndDateMonth  
,RequestStatus  
,DeductionValue  
,DemeritPoint  
,DemeritPoint*DeductionValue AS Deduction  
,ValidateStatus  
,'Others' AS Flag                
INTO #TEMPPREVCLOSED_CALC                
FROM #TEMP_CALC                
WHERE                 
YEAR(SubmissionDate)=@YEAR                
AND MONTH(SubmissionDate)=@MONTH          
AND RequestNo IN (SELECT RequestNo FROM [uetrackbemsdbPreProd].[dbo].TEMPOPENPREVMONTHCRMREQUEST)                
AND RequestNo NOT IN (SELECT RequestNo FROM #TEMPCURRCLOSED_CALC)    
AND RequestStatus IN (141,142)  
  
  
-------------CURRENT MONTH OPEN                
  
SELECT   
 CRMRequestId  
,RequestNo  
,RequestDateTime  
,SubmissionDueDate  
,SubmissionDate  
,EndDateMonth  
,RequestStatus  
,DeductionValue  
,DemeritPoint  
,DemeritPoint*DeductionValue AS Deduction  
,ValidateStatus  
,'Others' AS Flag                
INTO #TEMPCURROPEN_CALC                
FROM #TEMP_CALC                
WHERE                 
YEAR(RequestDateTime)=@YEAR                
AND MONTH(RequestDateTime )=@MONTH                
AND RequestStatus IN (139,140)               
  
  
-----------------------Prev Month Work Order but still open in current  month                
  
SELECT   
 CRMRequestId  
,RequestNo  
,RequestDateTime  
,SubmissionDueDate  
,SubmissionDate  
,EndDateMonth  
,RequestStatus  
,DeductionValue  
--,DemeritPoint  -DISABLE BY AIDA 07022021
,CASE 
        WHEN ISNULL(SubmissionDate,'')<>'' THEN DATEDIFF(DAY,@StartDate,SubmissionDate)+1 
        WHEN ISNULL(SubmissionDate,'')='' THEN DATEDIFF(DAY,@StartDate,@EndDate)+1 
        ELSE 0
        END AS DemeritPoint  
,(DeductionValue*(CASE 
        WHEN ISNULL(SubmissionDate,'')<>'' THEN DATEDIFF(DAY,@StartDate,SubmissionDate)+1 
        WHEN ISNULL(SubmissionDate,'')='' THEN DATEDIFF(DAY,@StartDate,@EndDate)+1 
        ELSE 0
        END )) AS Deduction  
--,ValidateStatus  -DISABLE BY AIDA 07022021
,'Y' AS ValidateStatus 
,'Others' AS Flag                
INTO #TEMPPREVOPEN_CALC                
FROM #TEMP_CALC                
WHERE @YEAR=(SELECT YEAR(MAX(CRM_StartDate)) FROM [uetrackbemsdbPreProd].[dbo].TEMPOPENPREVMONTHCRMREQUEST)                
AND @MONTH=(SELECT MONTH(MAX(CRM_StartDate)) FROM [uetrackbemsdbPreProd].[dbo].TEMPOPENPREVMONTHCRMREQUEST)                
AND RequestNo IN (SELECT RequestNo FROM [uetrackbemsdbPreProd].[dbo].TEMPOPENPREVMONTHCRMREQUEST)                
AND RequestNo NOT IN (SELECT RequestNo FROM #TEMPCURROPEN_CALC)    
AND RequestStatus IN (139,140)  
--AND WONo IN ('MWRWAC/B/2020/000574')                
  
  
  
INSERT INTO DeductionDemeritPointB5CRM  
(  
 CRMRequestId  
,RequestNo  
,RequestDateTime  
,SubmissionDueDate  
,SubmissionDate  
,EndDateMonth  
,RequestStatus  
,DeductionValue  
,DemeritPoint  
,Deduction  
,ValidateStatus  
,Flag  
,Year  
,Month  
)  
  
  
SELECT   
 CRMRequestId  
,RequestNo  
,RequestDateTime  
,SubmissionDueDate  
,SubmissionDate  
,EndDateMonth  
,RequestStatus  
,DeductionValue  
,DemeritPoint  
,Deduction  
,ValidateStatus  
,Flag                
,@Year AS Year  
,@MONTH AS Month  
--INTO DeductionDemeritPointB5CRM  
FROM (                
SELECT * FROM #TEMPCURRCLOSED_CALC                 
UNION ALL                 
SELECT * FROM #TEMPPREVCLOSED_CALC                
UNION ALL                 
SELECT * FROM #TEMPCURROPEN_CALC                
UNION ALL                
SELECT * FROM #TEMPPREVOPEN_CALC                
) AA    
  
  
END TRY                              
BEGIN CATCH                              
                              
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                              
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                              
                              
THROW                              
                              
END CATCH                              
SET NOCOUNT OFF                              
END     
    
GO
