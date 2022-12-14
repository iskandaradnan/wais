USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[BemsDeductionDemeritPointCalc_B4]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC BemsDeductionDemeritPointCalc_B4 2020,1    
  
/*TargetDateTime is PPM Agreed date in the Screen*/  
  
    
CREATE PROCEDURE [dbo].[BemsDeductionDemeritPointCalc_B4]    
(    
 @YEAR INT    
,@MONTH INT    
    
)    
    
    
AS    
    
BEGIN                  
SET NOCOUNT ON                  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                  
BEGIN TRY           
    
    
--SELECT * FROM #TEMP_MAIN    
--WHERE MaintenanceWorkNo IN     
--(    
--'PMWWAC/B/2021/000037'    
--,'PMWWAC/B/2020/003539'    
--,'PMWWAC/B/2020/003946'    
    
--)    
    
    
--SELECT * FROM EngMaintenanceWorkOrderTxn A    
--WHERE MaintenanceWorkNo IN (SELECT MaintenanceWorkNo FROM #TEMP_MAIN)    
--AND ISNULL(A.PreviousTargetDateTime,'')<>''    
    
    
    
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
--SET @MONTH=1    
    
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
   ,E.UserAreaCode    
   ,F.FieldValue AS WOStatus    
   ,A.TargetDateTime    
   ,YEAR(A.TargetDateTime) AS [Year]    
   ,MONTH(A.TargetDateTime) AS [Month]    
   ,CASE WHEN ISNULL(A.PreviousTargetDateTime,'')='' THEN A.TargetDateTime ELSE A.PreviousTargetDateTime END AS ScheduleDate    
   ,CASE WHEN ISNULL(A.PreviousTargetDateTime,'')='' THEN '' ELSE a.TargetDateTime END AS ReScheduleDate    
   ,C.StartDateTime    
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
FROM EngAsset D    WITH (NOLOCK)
INNER JOIN EngMaintenanceWorkOrderTxn A  WITH (NOLOCK)  
ON D.AssetId=A.AssetId    
INNER JOIN dbo.FMLovMst F      WITH (NOLOCK)
ON A.WorkOrderStatus =F.LovId     
LEFT OUTER JOIN EngMwoCompletionInfoTxn B    WITH (NOLOCK)
ON A.WorkOrderId=B.WorkOrderId    
LEFT OUTER JOIN EngMwoReschedulingTxn G    WITH (NOLOCK)
ON A.WorkOrderId=G.WorkOrderId    
LEFT OUTER JOIN EngMwoCompletionInfoTxnDet C    WITH (NOLOCK)
ON B.CompletionInfoId=C.CompletionInfoId    
LEFT OUTER JOIN MstLocationUserArea E    WITH (NOLOCK)
ON D.UserAreaId = E.UserAreaId     
WHERE A.TypeOfWorkOrder IN (34,35,36,198)    
    
    
---------------------------------- ALL WO created in previous month that are open --------------------     
    
SELECT *,@StartDate WO_StartDate    
INTO #TEMPOPENPREVMONTH    
FROM #TEMP_MAIN    
WHERE YEAR(TargetDateTime)=@PREV_YEAR    
AND MONTH(TargetDateTime)=@PREV_MONTH    
AND WOStatus IN ('Open','Completed','Work In Progress')    
    
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
      ,DeductionFigurePerAsset    
  ,TargetDateTime    
  ,CASE  WHEN StartDateTime > TargetDateTime THEN 1     
         WHEN ISNULL(StartDateTime,'')='' AND GETDATE() > TargetDateTime THEN 1    
         ELSE 0 END AS DemeritPoint    
   ,CASE WHEN StartDateTime > TargetDateTime THEN 'Y'     
         WHEN ISNULL(StartDateTime,'')='' AND GETDATE() > TargetDateTime THEN 'Y'    
    ELSE 'N' END AS ValidateStatus    
   ,WOStatus    
   ,Remarks    
INTO #TEMP_CALC    
FROM #TEMP_MAIN    
--WHERE WarrantyStatus='OutOfWarranty'    
--WHERE WOStatus IN ('Closed','Completed')    
    
    
    
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
,DemeritPoint    
,ValidateStatus    
,(DemeritPoint*DeductionFigurePerAsset) AS DeductionRM    
,'Completed Current Month PPM' AS Category    
,Remarks    
INTO #TEMPCURRCLOSED_CALC    
FROM #TEMP_CALC    
WHERE     
YEAR(TargetDateTime)=@YEAR    
AND MONTH(TargetDateTime)=@MONTH    
AND WOStatus='Closed'    
    
    
    
-------------OPEN  PREVIOUS MONTH CLOSED CURRENT MONTH    
    
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
,DemeritPoint    
,ValidateStatus    
,(DemeritPoint*DeductionFigurePerAsset) AS DeductionRM    
,'Closed Previous Month PPM' AS Category    
,Remarks    
INTO #TEMPPREVCLOSED_CALC    
FROM #TEMP_CALC    
WHERE     
YEAR(TargetDateTime)=@YEAR    
AND MONTH(TargetDateTime)=@MONTH    
AND MaintenanceWorkNo IN (SELECT MaintenanceWorkNo FROM #TEMPOPENPREVMONTH)    
AND WOStatus='Closed'    
    
    
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
,DemeritPoint    
,ValidateStatus    
,(DemeritPoint*DeductionFigurePerAsset) AS DeductionRM    
,'Open Current Month PPM' AS Category    
,Remarks    
INTO #TEMPCURROPEN_CALC    
FROM #TEMP_CALC    
WHERE     
YEAR(TargetDateTime)=@YEAR    
AND MONTH(TargetDateTime)=@MONTH    
AND WOStatus IN ('Open','Work In Progress')    
    
    
    
    
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
,DemeritPoint    
,ValidateStatus    
,(DemeritPoint*DeductionFigurePerAsset) AS DeductionRM    
,'Open Previous Month PPM' AS Category    
,Remarks    
INTO #TEMPPREVOPEN_CALC    
FROM #TEMP_CALC    
WHERE @YEAR=(SELECT YEAR(MAX(WO_StartDate)) FROM #TEMPOPENPREVMONTH)    
AND @MONTH=(SELECT MONTH(MAX(WO_StartDate)) FROM #TEMPOPENPREVMONTH)    
AND MaintenanceWorkNo IN (SELECT MaintenanceWorkNo FROM #TEMPOPENPREVMONTH)    
AND WOStatus IN ('Open','Work In Progress')    
    
    
-------------UNSCHEDULE WORKORDER LOGIC    
    
SELECT A.AssetId     
INTO #TEMP_ASSET    
FROM EngMaintenanceWorkOrderTxn A    
WHERE A.AssetId IN (SELECT AssetId FROM #TEMP_MAIN)    
AND A.TypeOfWorkOrder IN (270,271,273)    
AND WorkOrderStatus IN (192,193)    
    
    
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
    
UPDATE A    
SET A.DemeritPoint=0    
   ,A.DeductionRM=0    
   ,A.REMARKS='Asset Under Repair'    
FROM #TEMP_FINAL A    
WHERE A.AssetId IN (SELECT AssetId FROM #TEMP_ASSET)    
    
    
    
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
,DemeritPoint    
,ValidateStatus    
,DeductionRM    
,Category    
,REMARKS AS Remarks    
FROM #TEMP_FINAL    
    
END TRY                  
BEGIN CATCH                  
                  
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                  
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                  
                  
THROW                  
                  
END CATCH                  
SET NOCOUNT OFF                  
END        
GO
