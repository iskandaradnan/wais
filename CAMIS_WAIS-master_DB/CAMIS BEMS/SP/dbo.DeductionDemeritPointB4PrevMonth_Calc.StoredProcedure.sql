USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionDemeritPointB4PrevMonth_Calc]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
    
    
CREATE PROCEDURE [dbo].[DeductionDemeritPointB4PrevMonth_Calc]    
(    
 @YEAR INT                 
,@MONTH INT                  
)    
    
AS    
    
BEGIN    
    
    
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
                    
IF OBJECT_ID('tempdb.dbo.#TEMP_ASSET', 'U') IS NOT NULL                      
DROP TABLE #TEMP_ASSET                    
                    
IF OBJECT_ID('tempdb.dbo.#TEMP_FINAL', 'U') IS NOT NULL                      
DROP TABLE #TEMP_FINAL                     
                    
                    
                    
                    
                    
--DECLARE @YEAR INT                    
--DECLARE @MONTH INT                    
DECLARE @PREV_YEAR INT                     
DECLARE @PREV_MONTH INT                    
DECLARE @LEAPYEAR VARCHAR(10)                    
                    
                    
--DECLARE @MONTHCALC INT                    
                    
--SET @YEAR=2020                    
--SET @MONTH=10                  
                    
SET @LEAPYEAR=(                    
CASE                    
DAY(EOMONTH(DATEADD(DAY,31,DATEADD(YEAR,@YEAR-1900,0))))                    
WHEN 29 THEN 'YES' ELSE 'NO'                    
END)                    
                    
                    
SET @PREV_YEAR=(CASE WHEN @MONTH=1 THEN @YEAR-1 ELSE @YEAR END)                    
SET @PREV_MONTH=(CASE WHEN @MONTH=1 THEN 12 ELSE @MONTH-1 END)                    
                    
                    
--SET @MONTHCALC=(CASE WHEN @MONTH IN (1,2,3,4,5,6,7,8,9) THEN CONCAT('0',@MONTH) ELSE @MONTH END)                    
      
--DECLARE @STARTOFYEAR DATETIME ='2020-08-01 00:00:00.000'      
  
DECLARE @STARTOFYEAR DATETIME    
    
SET @STARTOFYEAR='2020-08-01'  
                    
DECLARE @StartDate DATETIME                    
DECLARE @EndDate DATETIME                    
                    
SET @StartDate=CAST(CONCAT(CONCAT(CONCAT(@MONTH,'-01'),'-'),@YEAR) AS DATE)                    
SET @EndDate=CAST((CASE WHEN @MONTH IN (1,3,5,7,10,12) THEN CONCAT(CONCAT(CONCAT(@MONTH,'-31'),'-'),@YEAR)                    
WHEN @MONTH IN (2) AND @LEAPYEAR='YES' THEN CONCAT(CONCAT(CONCAT(@MONTH,'-29'),'-'),@YEAR)                    
WHEN @MONTH IN (2) AND @LEAPYEAR='NO' THEN CONCAT(CONCAT(CONCAT(@MONTH,'-28'),'-'),@YEAR)                    
ELSE CONCAT(CONCAT(CONCAT(@MONTH,'-30'),'-'),@YEAR) END) AS DATE)                    
                    
--SELECT @StartDate,@EndDate,@MONTH                    
                    
-------------MAIN RESULT SET                     
                    
SELECT DISTINCT D.AssetNo                    
      ,A.AssetId                     
      ,D.AssetDescription                     
   ,D.PurchaseCostRM                    
   ,A.MaintenanceWorkNo                    
   ,A.MaintenanceWorkDateTime                    
   ,CASE WHEN D.WarrantyEndDate >=GETDATE() THEN 'InWarranty' ELSE 'OutOfWarranty' END AS WarrantyStatus                    
   ,E.UserAreaCode                       ,F.FieldValue AS WOStatus                    
   ,A.TargetDateTime                    
   ,YEAR(A.TargetDateTime) AS [Year]                    
   ,MONTH(A.TargetDateTime) AS [Month]                
   ,CASE WHEN ISNULL(A.PreviousTargetDateTime,'')='' THEN A.TargetDateTime ELSE A.PreviousTargetDateTime END AS ScheduleDate                    
   ,CASE WHEN ISNULL(A.PreviousTargetDateTime,'')='' THEN '' ELSE a.TargetDateTime END AS ReScheduleDate                    
   ,C.StartDateTime                  
   ,C.EndDateTime                  
   ,CASE WHEN D.PurchaseCostRM BETWEEN 0 AND 5000 THEN 50                    
      WHEN D.PurchaseCostRM BETWEEN 5001 AND 10000 THEN 100                    
   WHEN D.PurchaseCostRM BETWEEN 10001 AND 15000 THEN 150                    
   WHEN D.PurchaseCostRM BETWEEN 15001 AND 20000 THEN 200                    
   WHEN D.PurchaseCostRM BETWEEN 20001 AND 30000 THEN 250                    
   WHEN D.PurchaseCostRM BETWEEN 30001 AND 50000 THEN 300                    
   WHEN D.PurchaseCostRM BETWEEN 50001 AND 100000 THEN 500                    
   WHEN D.PurchaseCostRM BETWEEN 100001 AND 500000 THEN 2000                    
   WHEN D.PurchaseCostRM BETWEEN 500001 AND 1000000 THEN 5000                    
   WHEN D.PurchaseCostRM > 1000000 THEN 7500                    
   END AS DeductionFigurePerAsset                    
                    
,G.Remarks                    
INTO #TEMP_MAIN                    
FROM EngAsset D  WITH (NOLOCK)                   
INNER JOIN EngMaintenanceWorkOrderTxn A     WITH (NOLOCK)               
ON D.AssetId=A.AssetId                    
INNER JOIN dbo.FMLovMst F   WITH (NOLOCK)                   
ON A.WorkOrderStatus =F.LovId                     
LEFT OUTER JOIN EngMwoCompletionInfoTxn B   WITH (NOLOCK)                 
ON A.WorkOrderId=B.WorkOrderId                    
LEFT OUTER JOIN EngMwoReschedulingTxn G WITH (NOLOCK)                   
ON A.WorkOrderId=G.WorkOrderId                    
LEFT OUTER JOIN EngMwoCompletionInfoTxnDet C     WITH (NOLOCK)               
ON B.CompletionInfoId=C.CompletionInfoId                    
LEFT OUTER JOIN MstLocationUserArea E   WITH (NOLOCK)                 
ON D.UserAreaId = E.UserAreaId                     
WHERE A.TypeOfWorkOrder IN (34,35,36,198, 82)        --82 out of warranty            
AND (CASE WHEN ISNULL(A.PreviousTargetDateTime,'')='' THEN A.TargetDateTime ELSE A.PreviousTargetDateTime END )>=@STARTOFYEAR       
AND (CASE WHEN ISNULL(A.PreviousTargetDateTime,'')='' THEN A.TargetDateTime ELSE A.PreviousTargetDateTime END) <=@EndDate      
--AND MaintenanceWorkNo<>'PMWWAC/B/2020/000275'       --TO BE REMOVED FOR MONTH OF AUG-2020         
                  
                  
--SELECT * FROM #TEMP_MAIN WHERE MaintenanceWorkNo='PMWWAC/20/016342'                    
                  
--SELECT * FROM EngMaintenanceWorkOrderTxn WHERE MaintenanceWorkNo='PMWWAC/20/016342'                  
--10481                  
--SELECT * FROM EngMwoCompletionInfoTxn WHERE WorkOrderId='10481'                  
                  
--SELECT * FROM EngMwoCompletionInfoTxnDet WHERE CompletionInfoId='3789'                  
                    
---------------------------------- ALL WO created in previous month that are open --------------------                     
     
 INSERT INTO TEMPOPENPREVMONTHB4    
 (    
 AssetNo    
,AssetId    
,AssetDescription    
,PurchaseCostRM    
,MaintenanceWorkNo    
,MaintenanceWorkDateTime    
,WarrantyStatus    
,UserAreaCode    
,WOStatus    
,TargetDateTime    
,Year    
,Month    
,ScheduleDate    
,ReScheduleDate    
,StartDateTime    
,EndDateTime    
,DeductionFigurePerAsset    
,Remarks    
 )    
    
    
SELECT AssetNo    
,AssetId    
,AssetDescription    
,PurchaseCostRM    
,MaintenanceWorkNo    
,MaintenanceWorkDateTime    
,WarrantyStatus    
,UserAreaCode    
,WOStatus    
,TargetDateTime    
,Year    
,Month    
,ScheduleDate    
,ReScheduleDate    
,StartDateTime    
,EndDateTime    
,DeductionFigurePerAsset    
,Remarks    
---,@StartDate WO_StartDate                    
----INTO TEMPOPENPREVMONTHB4                    
FROM #TEMP_MAIN                    
WHERE YEAR(TargetDateTime)=@PREV_YEAR                    
---AND MONTH(TargetDateTime)=@PREV_MONTH                    
AND TRIM(WOStatus) IN ('Open','Work In Progress')        
AND  MaintenanceWorkNo NOT IN (SELECT MaintenanceWorkNo FROM TEMPOPENPREVMONTHB4)    
    
    
--SELECT * FROM     
  
/*DUPLICATE CHECK*/  
;WITH CTE   
AS  
(  
SELECT *,ROW_NUMBER()OVER(PARTITION BY MaintenanceWorkNo ORDER BY MaintenanceWorkNo) RN FROM TEMPOPENPREVMONTHB4  
)  
  
DELETE FROM CTE WHERE RN=2    
    
  
---UPDATE    
    
UPDATE A    
SET  WO_StartDate=@StartDate     
FROM TEMPOPENPREVMONTHB4 A    
    
  
  
    
END    
    
  
  
GO
