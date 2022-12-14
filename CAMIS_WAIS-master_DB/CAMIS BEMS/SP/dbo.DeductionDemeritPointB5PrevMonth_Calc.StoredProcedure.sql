USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionDemeritPointB5PrevMonth_Calc]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--USE [uetrackbemsdbPreProd]  
--GO  
--/****** Object:  StoredProcedure [dbo].[DeductionDemeritPointB1B2PrevMonth_Calc]    Script Date: 27/1/2021 1:20:23 PM ******/  
--SET ANSI_NULLS ON  
--GO  
--SET QUOTED_IDENTIFIER ON  
--GO  
  
  
  --exec DeductionDemeritPointB5PrevMonth_Calc 2020,12
CREATE PROCEDURE [dbo].[DeductionDemeritPointB5PrevMonth_Calc]  
(  
 @YEAR INT               
,@MONTH INT                
)  
  
AS  
  
BEGIN  
  
  
IF OBJECT_ID('tempdb.dbo.#TEMP_MAIN', 'U') IS NOT NULL                  
DROP TABLE #TEMP_MAIN                
                
                
----IF OBJECT_ID('tempdb.dbo.#TEMP_CALC', 'U') IS NOT NULL                  
--DROP TABLE #TEMP_CALC                
                
--IF OBJECT_ID('tempdb.dbo.#TEMPOPENPREVMONTH', 'U') IS NOT NULL                  
--DROP TABLE #TEMPOPENPREVMONTH                
                
--IF OBJECT_ID('tempdb.dbo.#TEMPCURRCLOSED_CALC', 'U') IS NOT NULL                  
--DROP TABLE #TEMPCURRCLOSED_CALC                
                
--IF OBJECT_ID('tempdb.dbo.#TEMPPREVCLOSED_CALC', 'U') IS NOT NULL                  
--DROP TABLE #TEMPPREVCLOSED_CALC                
                
                
--IF OBJECT_ID('tempdb.dbo.#TEMPCURROPEN_CALC', 'U') IS NOT NULL                  
--DROP TABLE #TEMPCURROPEN_CALC                
                
                
--IF OBJECT_ID('tempdb.dbo.#TEMPPREVOPEN_CALC', 'U') IS NOT NULL                  
--DROP TABLE #TEMPPREVOPEN_CALC                
                
                
                
                
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
                
-------------MAIN RESULT SET                 
 SELECT CRMRequestId  
,RequestNo  
,RequestDateTime  
,DATEADD(DAY,14,RequestDateTime)+1 AS SubmissionDueDate  
,Completed_Date  
,RequestStatus  
INTO #TEMP_MAIN  
FROM [uetrackMasterdbPreProd].[DBO].CRMRequest  
WHERE TypeOfRequest=132  
AND ServiceId=2  
AND RequestDateTime >=@STARTOFYEAR AND   RequestDateTime<=@EndDate     
  
                
                
 ---------------------------------- ALL WO created in previous month that are open --------------------                 
 SET IDENTITY_INSERT TEMPOPENPREVMONTHCRMREQUEST ON
 
 
 INSERT INTO TEMPOPENPREVMONTHCRMREQUEST  
 (  
 CRMRequestId  
,RequestNo  
,RequestDateTime  
,SubmissionDueDate  
,Completed_Date  
,RequestStatus  
 )  
  
  
                
SELECT CRMRequestId   
,RequestNo   
,RequestDateTime   
,SubmissionDueDate   
,Completed_Date   
,RequestStatus  
--INTO TEMPOPENPREVMONTHCRMREQUEST  
FROM #TEMP_MAIN  
WHERE YEAR(RequestDateTime)=@PREV_YEAR                
--AND MONTH(WorkRequestDate)=@PREV_MONTH              
AND RequestStatus IN (139,140)   
AND RequestNo NOT IN (SELECT RequestNo FROM TEMPOPENPREVMONTHCRMREQUEST)  
  
  
SET IDENTITY_INSERT TEMPOPENPREVMONTHCRMREQUEST OFF 
  
-----UPDATE  
  
UPDATE A  
SET  CRM_StartDate=@StartDate   
FROM TEMPOPENPREVMONTHCRMREQUEST A  
  
  
END  
  
  
GO
