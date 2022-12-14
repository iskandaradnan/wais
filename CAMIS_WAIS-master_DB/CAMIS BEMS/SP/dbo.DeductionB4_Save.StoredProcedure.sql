USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionB4_Save]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
--EXEC  DeductionB4_Save 2020,12  
                  
CREATE PROCEDURE [dbo].[DeductionB4_Save]                  
(                  
 @YEAR INT                  
,@MONTH INT                  
                  
)                  
                  
AS                  
BEGIN                                
--DECLARE @YEAR INT              
--DECLARE @MONTH INT              
              
--SET @YEAR=2020              
--SET @MONTH=5            
              
    
DELETE FROM DedGenerationTxnDet WHERE YEAR=@YEAR AND MONTH=@MONTH AND IndicatorDetId IN (4)    
DELETE FROM DedTransactionMappingTxn WHERE YEAR=@YEAR AND MONTH=@MONTH AND IndicatorDetId IN (4)    
DELETE FROM DedTransactionMappingTxnDet WHERE YEAR=@YEAR AND MONTH=@MONTH AND IndicatorDetId IN (4)    
    
    
              
SET NOCOUNT ON                            
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                            
BEGIN TRY                     
              
    
    
            
--SELECT * FROM MstDedIndicatorDet            
              
--INSERT INTO DedGenerationTxn              
--(              
-- CustomerId              
--,FacilityId              
--,ServiceId              
--,Month              
--,Year              
--,MonthlyServiceFee              
--,DeductionStatus              
--,DocumentNo              
--,Remarks              
--,CreatedBy              
--,CreatedDate              
--,CreatedDateUTC              
--,ModifiedBy              
--,ModifiedDate              
--,ModifiedDateUTC              
----,IndicatorDetId              
--)              
              
----------****************RESPONSE TIME QUERY (B1) ******************-----------------              
              
SELECT                
 157 AS CustomerId              
,144 AS FacilityId              
,2 AS ServiceId              
,[Month]               
,[Year]              
,BemsMSF AS MonthlyServiceFee              
,'P' AS DeductionStatus              
,NULL AS DocumentNo              
,NULL AS Remarks              
,19 AS CreatedBy              
,GETDATE() AS CreatedDate              
,GETUTCDATE() AS CreatedDateUTC              
,19 AS ModifiedBy              
,GETDATE() AS ModifiedDate              
,GETUTCDATE() AS ModifiedDateUTC              
              
FROM FinMonthlyFeeTxnDet   WITH (NOLOCK)           
WHERE [Year]=@YEAR              
AND [Month]=@MONTH-- IN (2,3,4,5)              
              
     
     
              
---------------************** NEED TO RUN THE QUERY FOR EACH INDICATOR FOR EACH MONTH AND YEAR ****************-----------------------              
              
INSERT INTO DedTransactionMappingTxn              
(              
 CustomerId              
,FacilityId              
,ServiceId              
,Month              
,Year              
,DedGenerationId              
,IndicatorDetId              
,CreatedBy              
,CreatedDate              
,CreatedDateUTC              
,ModifiedBy              
,ModifiedDate              
,ModifiedDateUTC              
,IsAdjustmentSaved              
)              
              
SELECT               
 157 AS CustomerId              
,144 AS FacilityId              
,2 AS ServiceId              
,@MONTH AS Month              
,@YEAR AS Year              
,NULL AS DedGenerationId              
,4 AS IndicatorDetId              
,19 AS CreatedBy              
,GETDATE() AS CreatedDate              
,GETUTCDATE() AS CreatedDateUTC              
,19 AS ModifiedBy              
,GETDATE() AS ModifiedDate              
,GETUTCDATE() AS ModifiedDateUTC              
,0 AS IsAdjustmentSaved               
              
UNION ALL              
              
SELECT               
 157 AS CustomerId              
,144 AS FacilityId              
,2 AS ServiceId              
,@MONTH AS Month              
,@YEAR AS Year              
,NULL AS DedGenerationId              
,2 AS IndicatorDetId              
,19 AS CreatedBy              
,GETDATE() AS CreatedDate              
,GETUTCDATE() AS CreatedDateUTC              
,19 AS ModifiedBy              
,GETDATE() AS ModifiedDate              
,GETUTCDATE() AS ModifiedDateUTC              
,0 AS IsAdjustmentSaved               
            
            
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
    
IF OBJECT_ID('tempdb.dbo.#ReschedulingTxnMain', 'U') IS NOT NULL                      
DROP TABLE #ReschedulingTxnMain                     
    
IF OBJECT_ID('tempdb.dbo.#ReschedulingTxn', 'U') IS NOT NULL                      
DROP TABLE #ReschedulingTxn                     
                    
    
    
                    
                    
                    
                    
--DECLARE @YEAR INT                    
--DECLARE @MONTH INT                    
DECLARE @PREV_YEAR INT                     
DECLARE @PREV_MONTH INT                    
DECLARE @LEAPYEAR VARCHAR(10)                    
                    
                    
--DECLARE @MONTHCALC INT                    
                    
--SET @YEAR=2020                    
--SET @MONTH=9                  
                    
SET @LEAPYEAR=(                    
CASE                    
DAY(EOMONTH(DATEADD(DAY,31,DATEADD(YEAR,@YEAR-1900,0))))                    
WHEN 29 THEN 'YES' ELSE 'NO'                    
END)                    
                    
                    
SET @PREV_YEAR=(CASE WHEN @MONTH=1 THEN @YEAR-1 ELSE @YEAR END)                    
SET @PREV_MONTH=(CASE WHEN @MONTH=1 THEN 12 ELSE @MONTH-1 END)                    
                    
                    
--SET @MONTHCALC=(CASE WHEN @MONTH IN (1,2,3,4,5,6,7,8,9) THEN CONCAT('0',@MONTH) ELSE @MONTH END)                    
      
DECLARE @STARTOFYEAR DATETIME ='2020-08-01 00:00:00.000'      
                    
DECLARE @StartDate DATETIME                    
DECLARE @EndDate DATETIME                    
                    
SET @StartDate=CAST(CONCAT(CONCAT(CONCAT(@MONTH,'-01'),'-'),@YEAR) AS DATE)                    
SET @EndDate=CAST((CASE WHEN @MONTH IN (1,3,5,7,10,12) THEN CONCAT(CONCAT(CONCAT(@MONTH,'-31'),'-'),@YEAR)                    
WHEN @MONTH IN (2) AND @LEAPYEAR='YES' THEN CONCAT(CONCAT(CONCAT(@MONTH,'-29'),'-'),@YEAR)                    
WHEN @MONTH IN (2) AND @LEAPYEAR='NO' THEN CONCAT(CONCAT(CONCAT(@MONTH,'-28'),'-'),@YEAR)                    
ELSE CONCAT(CONCAT(CONCAT(@MONTH,'-30'),'-'),@YEAR) END) AS DATE)                    
                    
--SELECT @StartDate,@EndDate,@MONTH                    
    
----MAX RESCHEDULE DATE     
    
SELECT WorkOrderId,MAX(RescheduleDate) RescheduleDate    
INTO #ReschedulingTxnMain    
FROM EngMwoReschedulingTxn     
--WHERE WorkOrderId=9351    
GROUP BY WorkOrderId    
    
------GETTING THE REMARKS    
    
SELECT A.WorkOrderId,A.Remarks     
INTO #ReschedulingTxn    
FROM EngMwoReschedulingTxn  A    
INNER JOIN #ReschedulingTxnMain B    
ON A.WorkOrderId=B.WorkOrderId    
AND A.RescheduleDate=B.RescheduleDate    
--WHERE A.WorkOrderId=9351    
    
    
    
                    
-------------MAIN RESULT SET                     
                    
SELECT DISTINCT D.AssetNo                    
      ,A.AssetId                     
      ,D.AssetDescription                     
   ,D.PurchaseCostRM                    
   ,A.MaintenanceWorkNo                    
   ,A.MaintenanceWorkDateTime     
   ,A.MaintenanceDetails AS RequestDetails   
   ,CASE WHEN D.WarrantyEndDate >=GETDATE() THEN 'InWarranty' ELSE 'OutOfWarranty' END AS WarrantyStatus                    
   ,E.UserAreaCode                    
   ,F.FieldValue AS WOStatus                    
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
LEFT OUTER JOIN  #ReschedulingTxn G WITH (NOLOCK)                   
ON A.WorkOrderId=G.WorkOrderId                    
LEFT OUTER JOIN EngMwoCompletionInfoTxnDet C     WITH (NOLOCK)               
ON B.CompletionInfoId=C.CompletionInfoId                    
LEFT OUTER JOIN MstLocationUserArea E   WITH (NOLOCK)                 
ON D.UserAreaId = E.UserAreaId                     
WHERE A.TypeOfWorkOrder IN (34,35,36,198,82)       --82 out of warranty              
AND (CASE WHEN ISNULL(A.PreviousTargetDateTime,'')='' THEN A.TargetDateTime ELSE A.PreviousTargetDateTime END )>=@STARTOFYEAR       
AND (CASE WHEN ISNULL(A.PreviousTargetDateTime,'')='' THEN A.TargetDateTime ELSE A.PreviousTargetDateTime END) <=@EndDate      
--AND MaintenanceWorkNo<>'PMWWAC/B/2020/000275'       --TO BE REMOVED FOR MONTH OF AUG-2020         
                  
                  
--SELECT * FROM #TEMP_MAIN WHERE MaintenanceWorkNo='PMWWAC/20/016342'                    
                  
--SELECT * FROM EngMaintenanceWorkOrderTxn WHERE MaintenanceWorkNo='PMWWAC/20/016342'                  
--10481                  
--SELECT * FROM EngMwoCompletionInfoTxn WHERE WorkOrderId='10481'                  
                  
--SELECT * FROM EngMwoCompletionInfoTxnDet WHERE CompletionInfoId='3789'                  
                    
---------------------------------- ALL WO created in previous month that are open --------------------                     
                    
--SELECT *,@StartDate WO_StartDate                    
--INTO #TEMPOPENPREVMONTH                    
--FROM #TEMP_MAIN                    
--WHERE YEAR(TargetDateTime)=@PREV_YEAR                    
--AND MONTH(TargetDateTime)=@PREV_MONTH                    
--AND TRIM(WOStatus) IN ('Open','Work In Progress')                    
                    
----------------------------------------------------------                    
                    
-------------MAIN CALCULATION SET                     
                    
                    
SELECT AssetNo                    
      ,AssetId                    
   ,AssetDescription                    
      ,PurchaseCostRM                    
      ,MaintenanceWorkNo                    
      ,MaintenanceWorkDateTime             
      ,WarrantyStatus                    
      ,UserAreaCode                    
      ,ScheduleDate                    
      ,ReScheduleDate                    
      ,StartDateTime                    
   ,EndDateTime    
   ,RequestDetails  
      ,DeductionFigurePerAsset                   
   ,DATEADD(DAY,-6,ScheduleDate) AS [7thDaytoStart]                  
  ,TargetDateTime                    
  --,CASE  WHEN (CAST(StartDateTime AS DATE) NOT BETWEEN (DATEADD(DAY,-6,CAST(ScheduleDate AS DATE))) AND CAST(ScheduleDate AS DATE)) AND CAST(TargetDateTime AS DATE)  <  CAST(EndDateTime AS DATE) THEN 1                     
  --       WHEN (CAST(StartDateTime AS DATE) BETWEEN (DATEADD(DAY,-6,CAST(ScheduleDate AS DATE))) AND CAST(ScheduleDate AS DATE)) AND CAST(TargetDateTime AS DATE)  <  CAST(EndDateTime AS DATE) THEN 1                     
  --       WHEN (CAST(StartDateTime AS DATE) NOT BETWEEN (DATEADD(DAY,-6,CAST(ScheduleDate AS DATE))) AND CAST(ScheduleDate AS DATE)) AND CAST(TargetDateTime AS DATE)  <  CAST(EndDateTime AS DATE) THEN 1                      
  --       WHEN ISNULL(CAST(StartDateTime AS DATE),'')='' AND CAST(GETDATE() AS DATE) > CAST(TargetDateTime AS DATE)  THEN 1                    
  --       ELSE 0 END AS DemeritPoint                    
         
  -- ,CASE WHEN (CAST(StartDateTime AS DATE) NOT BETWEEN (DATEADD(DAY,-6,CAST(ScheduleDate AS DATE))) AND CAST(ScheduleDate AS DATE)) AND CAST(TargetDateTime AS DATE)  <  CAST(EndDateTime AS DATE) THEN 'Y'                     
  -- WHEN (CAST(StartDateTime AS DATE) BETWEEN (DATEADD(DAY,-6,CAST(ScheduleDate AS DATE))) AND CAST(ScheduleDate AS DATE)) AND CAST(TargetDateTime AS DATE)  <  CAST(EndDateTime AS DATE) THEN 'Y'               
  --       WHEN (CAST(StartDateTime AS DATE) NOT BETWEEN (DATEADD(DAY,-6,CAST(ScheduleDate AS DATE))) AND CAST(ScheduleDate AS DATE)) AND CAST(TargetDateTime AS DATE)  <  CAST(EndDateTime AS DATE) THEN 'Y'                      
  -- WHEN ISNULL(CAST(StartDateTime AS DATE),'')='' AND CAST(GETDATE() AS DATE) > CAST(TargetDateTime AS DATE)  THEN 'Y'                    
  --       ELSE 'N' END AS ValidateStatus                    
   ,WOStatus                    
   ,Remarks                    
INTO #TEMP_CALC                    
FROM #TEMP_MAIN                    
--WHERE WarrantyStatus='OutOfWarranty'                    
--WHERE WOStatus IN ('Closed','Completed')                    
                    
--SELECT * FROM   #TEMP_CALC  WHERE MaintenanceWorkNo='PMWWAC/B/2020/000207'                  
                    
-------------CURRENT MONTH CLOSED                     
                    
SELECT AssetNo                    
,AssetId                    
,AssetDescription                    
,PurchaseCostRM                    
,MaintenanceWorkNo                    
,MaintenanceWorkDateTime                    
,WarrantyStatus                    
,UserAreaCode                    
,ScheduleDate                    
,ReScheduleDate                    
,StartDateTime                    
,DeductionFigurePerAsset                    
,0 AS DemeritPoint                    
,'N' AS ValidateStatus                   
,[7thDaytoStart]                  
,EndDateTime   
,RequestDetails  
,(0*DeductionFigurePerAsset) AS DeductionRM                    
,'Completed Current Month PPM' AS Category                    
,Remarks                    
INTO #TEMPCURRCLOSED_CALC                    
FROM #TEMP_CALC                    
WHERE                     
YEAR(ScheduleDate)=@YEAR                    
AND MONTH(ScheduleDate)=@MONTH                    
AND TRIM(WOStatus) IN ('Closed','Completed')                                
                    
                    
                  
---------------OPEN  PREVIOUS MONTH CLOSED CURRENT MONTH                    
                    
SELECT AssetNo                    
,AssetId         
,AssetDescription                    
,PurchaseCostRM                    
,MaintenanceWorkNo                    
,MaintenanceWorkDateTime                    
,WarrantyStatus                    
,UserAreaCode                    
,ScheduleDate                    
,ReScheduleDate                    
,StartDateTime                    
,DeductionFigurePerAsset                    
,CASE WHEN MONTH(ReScheduleDate)>=@MONTH THEN 0 ELSE 1 END AS DemeritPoint                    
,CASE WHEN MONTH(ReScheduleDate)>=@MONTH THEN 'N' ELSE 'Y' END AS ValidateStatus     
--,'Y' AS ValidateStatus                   
,[7thDaytoStart]                  
,EndDateTime     
,RequestDetails  
,((CASE WHEN MONTH(ReScheduleDate)>=@MONTH THEN 0 ELSE 1 END)*DeductionFigurePerAsset) AS DeductionRM                    
,'Closed Previous Month PPM' AS Category                    
,Remarks                    
INTO #TEMPPREVCLOSED_CALC                    
FROM #TEMP_CALC                    
WHERE                     
YEAR(ScheduleDate)=@YEAR                    
AND MONTH(ScheduleDate)=@MONTH-1    
AND MONTH(EndDateTime)=@MONTH    
AND MaintenanceWorkNo IN (SELECT MaintenanceWorkNo FROM TEMPOPENPREVMONTHB4)        
AND MaintenanceWorkNo NOT IN (SELECT MaintenanceWorkNo FROM #TEMPCURRCLOSED_CALC)      
AND TRIM(WOStatus) IN ('Closed','Completed')                    
                    
                    
-------------CURRENT MONTH OPEN                    
                    
SELECT AssetNo                    
,AssetId                    
,AssetDescription                    
,PurchaseCostRM                    
,MaintenanceWorkNo                    
,MaintenanceWorkDateTime               
,WarrantyStatus                    
,UserAreaCode                    
,ScheduleDate                    
,ReScheduleDate                    
,StartDateTime                    
,DeductionFigurePerAsset                    
,1 AS DemeritPoint                    
,'Y' AS ValidateStatus                   
,[7thDaytoStart]                  
,EndDateTime     
,RequestDetails  
,(1*DeductionFigurePerAsset) AS DeductionRM                    
,'Open Current Month PPM' AS Category                    
,Remarks                    
INTO #TEMPCURROPEN_CALC                    
FROM #TEMP_CALC                    
WHERE                     
YEAR(ScheduleDate)=@YEAR                    
AND MONTH(ScheduleDate)=@MONTH         
AND MONTH(ReScheduleDate)=@MONTH ---LOGIC ADDED TO IGNORE WORK ORDER RESCH FOR MONTH OF SEPT      
AND TRIM(WOStatus) IN ('Open','Work In Progress')                    
                    
--SELECT * FROM #TEMPCURROPEN_CALC WHERE MaintenanceWorkNo='PMWWAC/B/2020/000167'                    
                    
                    
-----------------------Prev Month Work Order but still open in current  month                    
                    
SELECT AssetNo                    
,AssetId                    
,AssetDescription                    
,PurchaseCostRM                    
,MaintenanceWorkNo                    
,MaintenanceWorkDateTime                    
,WarrantyStatus                    
,UserAreaCode                    
,ScheduleDate                    
,ReScheduleDate                    
,StartDateTime                    
,DeductionFigurePerAsset                    
,CASE WHEN MONTH(ReScheduleDate)>=@MONTH THEN 0 ELSE 1 END AS DemeritPoint     
,CASE WHEN MONTH(ReScheduleDate)>=@MONTH THEN 'N' ELSE 'Y' END AS ValidateStatus                  
,[7thDaytoStart]                  
,EndDateTime     
,RequestDetails  
,((CASE WHEN MONTH(ReScheduleDate)>=@MONTH THEN 0 ELSE 1 END )*DeductionFigurePerAsset) AS DeductionRM                    
,'Open Previous Month PPM' AS Category                    
,Remarks                    
INTO #TEMPPREVOPEN_CALC                    
FROM #TEMP_CALC                    
WHERE     
@YEAR=(SELECT YEAR(MAX(ScheduleDate)) FROM TEMPOPENPREVMONTHB4)                    
AND @MONTH=(SELECT MONTH(MAX(ScheduleDate)) FROM TEMPOPENPREVMONTHB4)                  
    
--/logic change as per aida on 5-11-2020/    
--YEAR(ScheduleDate)=@YEAR                    
--AND MONTH(ScheduleDate)=@MONTH         
--AND MONTH(ReScheduleDate)=@MONTH ---LOGIC ADDED TO IGNORE WORK ORDER RESCH FOR MONTH OF SEPT      
AND MaintenanceWorkNo IN (SELECT MaintenanceWorkNo FROM TEMPOPENPREVMONTHB4)                    
AND MaintenanceWorkNo NOT IN (SELECT MaintenanceWorkNo FROM #TEMPCURROPEN_CALC)      
AND TRIM(WOStatus) IN ('Open','Work In Progress')                    
                    
                  
                  
                    
-------------UNSCHEDULE WORKORDER LOGIC                    
-----LOGIC DISABLED ON 07-09-2020                    
      
--SELECT A.AssetId                     
--INTO #TEMP_ASSET                    
--FROM EngMaintenanceWorkOrderTxn A                    
--WHERE A.AssetId IN (SELECT AssetId FROM #TEMP_MAIN)                    
--AND A.TypeOfWorkOrder IN (270,271,273)                    
--AND WorkOrderStatus IN (192,193)                    
                    
                    
---FINAL OUTPUT                    
SELECT * INTO #TEMP_FINAL       
FROM (                    
SELECT * FROM #TEMPCURRCLOSED_CALC                     
UNION ALL                     
SELECT * FROM #TEMPPREVCLOSED_CALC                    
UNION ALL                     
SELECT * FROM #TEMPCURROPEN_CALC                    
UNION ALL                    
SELECT * FROM #TEMPPREVOPEN_CALC                    
)A             
            
--ALTER TABLE #TEMP_FINAL ALTER COLUMN REMARKS VARCHAR(100)            
            
--UPDATE A            
--SET A.DemeritPoint=0            
--   ,A.DeductionRM=0            
--   ,A.REMARKS='Asset Under Repair'            
--FROM #TEMP_FINAL A            
--WHERE A.AssetId IN (SELECT AssetId FROM #TEMP_ASSET)            
            
            
INSERT INTO DedTransactionMappingTxnDet              
(              
CustomerId              
,FacilityId              
,DedTxnMappingId              
,Date              
,DocumentNo              
,Details              
,AssetNo              
,AssetDescription              
,ScreenName              
,DemeritPoint              
,FinalDemeritPoint              
,IsValid              
,DisputedDemeritPoints              
,Remarks              
,DeductionValue              
,CreatedBy              
,CreatedDate              
,CreatedDateUTC              
,ModifiedBy              
,ModifiedDate              
,ModifiedDateUTC              
,[YEAR]              
,[MONTH]              
,IndicatorDetId              
,IndicatorName    
,ReScheduledDate    
,ScheduledDate    
,FLAG              
)              
            
            
            
            
SELECT             
 157 AS CustomerId              
,144 AS FacilityId              
,NULL AS DedTxnMappingId              
,MaintenanceWorkDateTime            
,MaintenanceWorkNo            
,RequestDetails AS Details            
,AssetNo            
,AssetDescription              
,'Scheduled Work Order' AS ScreenName--Unschduleworkorder              
,DemeritPoint AS DemeritPoint              
,NULL AS FinalDemeritPoint              
,1 AS IsValid---'Y'              
,NULL AS DisputedPendingResolution ----update              
,NULL AS Remarks              
,DeductionRM AS DeductionValue              
,19 AS CreatedBy              
,GETDATE() AS CreatedDate              
,GETUTCDATE() AS CreatedDateUTC              
,19 AS ModifiedBy              
,GETDATE() AS ModifiedDate              
,GETUTCDATE() AS ModifiedDateUTC              
,@YEAR AS [YEAR]              
,@MONTH AS [MONTH]              
,4 AS IndicatorDetId              
,'B4' AS IndicatorName              
,ReScheduleDate    
,ScheduleDate    
,Category AS FLAG               
FROM #TEMP_FINAL            
            
--------------UPDATING TXNID              
              
--SELECT B.DedTxnMappingId,A.IndicatorDetId,A.YEAR,A.MONTH               
UPDATE A              
SET A.DedTxnMappingId=B.DedTxnMappingId              
FROM DedTransactionMappingTxnDet A              
INNER JOIN  DedTransactionMappingTxn B              
ON A.IndicatorDetId=B.IndicatorDetId              
AND A.YEAR=B.Year              
AND A.MONTH=B.Month              
WHERE A.IndicatorDetId=4            
    
    
    
INSERT INTO DedGenerationTxnDet              
(              
 CustomerId              
,FacilityId              
,ServiceId              
,DedGenerationId              
,IndicatorDetId              
,TotalParameter              
,DeductionValue              
,DeductionPercentage              
,TransactionDemeritPoint              
,NcrDemeritPoint              
,SubParameterDetId              
,PostTransactionDemeritPoint              
,PostNcrDemeritPoint              
,Remarks              
,keyIndicatorValue              
,Ringittequivalent              
,GearingRatio              
,PostDeductionValue              
,PostDeductionPercentage              
,CreatedBy              
,CreatedDate              
,CreatedDateUTC              
,ModifiedBy              
,ModifiedDate              
,ModifiedDateUTC              
,[Year]              
,[Month]              
)              
SELECT               
 157 AS CustomerId              
,144 AS FacilityId              
,2 AS ServiceId              
,NULL AS DedGenerationId--CHANGE              
,IndicatorDetId              
,0 AS TotalParameter              
,SUM(DeductionValue) AS DeductionValue              
,0 AS DeductionPercentage              
,SUM(DemeritPoint) AS TransactionDemeritPoint              
,0 AS NcrDemeritPoint              
,NULL AS SubParameterDetId              
,0 AS PostTransactionDemeritPoint              
,0 AS PostNcrDemeritPoint              
,NULL AS Remarks              
,NULL AS keyIndicatorValue              
,NULL AS Ringittequivalent              
,NULL AS GearingRatio              
,NULL AS PostDeductionValue              
,NULL AS PostDeductionPercentage              
,19 AS CreatedBy              
,GETDATE() AS CreatedDate              
,GETUTCDATE() AS CreatedDateUTC              
,19 AS ModifiedBy              
,GETDATE() AS ModifiedDate              
,GETUTCDATE() AS ModifiedDateUTC              
,[Year]              
,[Month]              
--IndicatorDetId,[YEAR],[MONTH],SUM(DeductionValue) AS DeductionValue               
FROM DedTransactionMappingTxnDet              
WHERE [YEAR]=@YEAR              
AND [MONTH]=@MONTH--CHANGE              
AND IndicatorDetId=4            
GROUP BY IndicatorDetId,[YEAR],[MONTH]              
              
              
UPDATE A              
SET A.DedGenerationId=B.DedGenerationId              
FROM DedGenerationTxnDet A  WITH (NOLOCK)             
INNER JOIN DedGenerationTxn B   WITH (NOLOCK)           
ON A.[Year]=B.[Year]              
AND A.[Month]=B.[Month]              
WHERE A.IndicatorDetId=4            
        
        
/*LOGIC ADDED IN MONTH OF AUG 2020*/        
        
UPDATE A SET A.PurchaseCost=B.PurchaseCostRM FROM DedTransactionMappingTxnDet A WITH (NOLOCK) INNER JOIN EngAsset B WITH (NOLOCK) ON A.AssetNo=B.AssetNo        
        
UPDATE A         
SET A.DeductionFigureperAsset=(        
CASE WHEN D.PurchaseCostRM BETWEEN 0 AND 5000 THEN 50          
     WHEN D.PurchaseCostRM BETWEEN 5001 AND 10000 THEN 100          
     WHEN D.PurchaseCostRM BETWEEN 10001 AND 15000 THEN 150          
     WHEN D.PurchaseCostRM BETWEEN 15001 AND 20000 THEN 200          
     WHEN D.PurchaseCostRM BETWEEN 20001 AND 30000 THEN 250          
     WHEN D.PurchaseCostRM BETWEEN 30001 AND 50000 THEN 300          
     WHEN D.PurchaseCostRM BETWEEN 50001 AND 100000 THEN 500          
     WHEN D.PurchaseCostRM BETWEEN 100001 AND 500000 THEN 2000          
     WHEN D.PurchaseCostRM BETWEEN 500001 AND 1000000 THEN 5000          
     WHEN D.PurchaseCostRM > 1000000 THEN 7500          
   END ) ,A.ReScheduledDate=(CASE WHEN ISNULL(C.PreviousTargetDateTime,'')='' THEN '' ELSE C.TargetDateTime END) ,A.StartDate=E.StartDateTime FROM DedTransactionMappingTxnDet A WITH(NOLOCK) INNER JOIN EngAsset D WITH(NOLOCK) ON A.AssetNo=D.AssetNo INNER 
  
    
      
JOIN EngMaintenanceWorkOrderTxn C WITH(NOLOCK) ON A.DocumentNo=C.MaintenanceWorkNo INNER JOIN EngMwoCompletionInfoTxn E WITH(NOLOCK) ON C.WorkOrderId=E.WorkOrderId WHERE A.IndicatorName='B4'         
                
                
                 
END TRY                                
BEGIN CATCH                                
                                
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                                
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                                
                                
THROW                                
                                
END CATCH                                
SET NOCOUNT OFF                                
END 
GO
