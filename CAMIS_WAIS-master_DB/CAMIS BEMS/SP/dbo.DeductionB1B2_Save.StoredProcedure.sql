USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionB1B2_Save]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
--ALTER TABLE DedTransactionMappingTxnDet ADD LastDateOf7thDay DATETIME  
--EXEC DeductionB1B2_Save 2020,10    
    
  
                
CREATE PROCEDURE [dbo].[DeductionB1B2_Save]                
(                
 @YEAR INT                
,@MONTH INT                
                
)                
                
AS                
BEGIN                              
--DECLARE @YEAR INT                
--DECLARE @MONTH INT                
                
--SET @YEAR=2020                
--SET @MONTH=3                
DELETE FROM DedGenerationTxnDet WHERE YEAR=@YEAR AND MONTH=@MONTH AND IndicatorDetId IN (1,2)            
DELETE FROM DedTransactionMappingTxnDet WHERE YEAR=@YEAR AND MONTH=@MONTH AND IndicatorDetId IN (1,2)    
DELETE FROM DedTransactionMappingTxn WHERE YEAR=@YEAR AND MONTH=@MONTH AND IndicatorDetId IN (1,2)    
    
    
DECLARE @DEDID INT    
SET @DEDID=(SELECT ISNULL(MAX(DedGenerationId),0) FROM DedGenerationTxn WHERE YEAR=@YEAR AND Month=@MONTH)    
    
    
    
    
    
                
SET NOCOUNT ON                              
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                              
BEGIN TRY                       
          
          
 IF(@DEDID=0)    
 BEGIN    
                
INSERT INTO DedGenerationTxn                
(                
 CustomerId                
,FacilityId                
,ServiceId                
,Month                
,Year                
,MonthlyServiceFee                
,DeductionStatus                
,DocumentNo                
,Remarks                
,CreatedBy                
,CreatedDate                
,CreatedDateUTC                
,ModifiedBy                
,ModifiedDate                
,ModifiedDateUTC                
--,IndicatorDetId                
)                
                
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
                
FROM FinMonthlyFeeTxnDet                
WHERE [Year]=@YEAR                
AND [Month]=@MONTH-- IN (2,3,4,5)                
END    
    
ELSE     
BEGIN    
SELECT 'DATA ALEADY EXISTS'    
END    
    
                
                
-----------------************** NEED TO RUN THE QUERY FOR EACH INDICATOR FOR EACH MONTH AND YEAR ****************-----------------------                
                
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
,1 AS IndicatorDetId                
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
,0 AS DedGenerationId                
,2 AS IndicatorDetId                
,19 AS CreatedBy                
,GETDATE() AS CreatedDate                
,GETUTCDATE() AS CreatedDateUTC                
,19 AS ModifiedBy                
,GETDATE() AS ModifiedDate                
,GETUTCDATE() AS ModifiedDateUTC                
,0 AS IsAdjustmentSaved                 
                
                
------------------************INSERT INTO DedTransactionMappingTxnDet ******************-------------                
                
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
      
SET @STARTOFYEAR='2020-08-01'  
  
--SET @STARTOFYEAR=(SELECT CASE WHEN @MONTH=12 THEN DATEADD(YEAR,-1,DATEFROMPARTS(YEAR(GETDATE()), 1, 1)) ELSE   
--DATEFROMPARTS(YEAR(GETDATE()), 1, 1)  
--END)       
           
                
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
SET @EndDate=CAST((CASE WHEN @MONTH IN (1,3,5,7,8,10,12) THEN CONCAT(CONCAT(CONCAT(@MONTH,'-31'),'-'),@YEAR)                
WHEN @MONTH IN (2) AND @LEAPYEAR='YES' THEN CONCAT(CONCAT(CONCAT(@MONTH,'-29'),'-'),@YEAR)                
WHEN @MONTH IN (2) AND @LEAPYEAR='NO' THEN CONCAT(CONCAT(CONCAT(@MONTH,'-28'),'-'),@YEAR)                
ELSE CONCAT(CONCAT(CONCAT(@MONTH,'-30'),'-'),@YEAR) END) AS DATE)                
                
--SELECT @StartDate,@EndDate,@MONTH                
                
-------------MAIN RESULT SET                 
                
                
SELECT  B.AssetNo                   
,B.AssetDescription                   
,B.PurchaseCostRM AS AssetPurchasePrice                   
,A.MaintenanceWorkNo AS WONo                   
,A.WorkOrderId                  
,C.UserAreaCode AS UserDept                   
,A.MaintenanceDetails AS RequestDetails                   
,D.FieldValue AS ResponseCategory                   
,A.MaintenanceWorkDateTime AS WorkRequestDate                   
,YEAR(MaintenanceWorkDateTime) AS WorkRequestYear                  
,MONTH(MaintenanceWorkDateTime) AS WorkRequestMonth                  
,F.StartDateTime                  
,F.EndDateTime                  
,G.ResponseDateTime                   
,G.ResponseDuration                   
,F.EndDateTime AS WorkCompletedDate                  
,CASE WHEN ISNULL(F.EndDateTime,'')='' THEN 0 ELSE DATEDIFF(DAY,A.MaintenanceWorkDateTime,F.EndDateTime)+1 END AS RepairTimeDays                  
,DATEADD(day, 7, A.MaintenanceWorkDateTime)-1 AS LastDateOf7thDay                   
,E.FieldValue AS WOStatus                  
,CASE WHEN B.PurchaseCostRM BETWEEN 0 AND 30000 THEN 50                  
      WHEN B.PurchaseCostRM BETWEEN 30001 AND 50000 THEN 100                  
   WHEN B.PurchaseCostRM BETWEEN 50001 AND 1000000000 THEN 200                  
   END AS B1_DeductionFigurePerAsset                  
,CASE WHEN B.PurchaseCostRM BETWEEN 0 AND 5000 THEN 10                  
      WHEN B.PurchaseCostRM BETWEEN 5001 AND 10000 THEN 20                  
   WHEN B.PurchaseCostRM BETWEEN 10001 AND 15000 THEN 30                  
   WHEN B.PurchaseCostRM BETWEEN 15001 AND 20000 THEN 40                  
   WHEN B.PurchaseCostRM BETWEEN 20001 AND 30000 THEN 50                  
   WHEN B.PurchaseCostRM BETWEEN 30001 AND 50000 THEN 75                  
   WHEN B.PurchaseCostRM BETWEEN 50001 AND 100000 THEN 100                  
   WHEN B.PurchaseCostRM BETWEEN 100001 AND 500000 THEN 200                  
   WHEN B.PurchaseCostRM BETWEEN 500001 AND 1000000 THEN 500                  
   WHEN B.PurchaseCostRM > 1000000 THEN 1000                  
   END AS B2_DeductionFigurePerAsset                  
,CASE WHEN CAST(DATEPART(HOUR, ResponseDateTime - MaintenanceWorkDateTime) AS VARCHAR(10)) IN                   
(0,1,2,3,4,5,6,7,8,9)  THEN CONCAT('0',CAST(DATEPART(HOUR, ResponseDateTime - MaintenanceWorkDateTime) AS VARCHAR(10)))                  
ELSE CAST(DATEPART(HOUR, ResponseDateTime - MaintenanceWorkDateTime) AS VARCHAR(10))                  
END                   
+':'+                  
CASE WHEN CAST(DATEPART(MINUTE, ResponseDateTime - MaintenanceWorkDateTime) AS VARCHAR(10)) IN                   
(0,1,2,3,4,5,6,7,8,9)  THEN CONCAT('0',CAST(DATEPART(MINUTE, ResponseDateTime - MaintenanceWorkDateTime) AS VARCHAR(10)))                  
ELSE CAST(DATEPART(MINUTE, ResponseDateTime - MaintenanceWorkDateTime) AS VARCHAR(10))                  
END                  
AS ResponseDurationHHMM                  
                  
                  
INTO #TEMP_MAIN                  
FROM dbo.EngMaintenanceWorkOrderTxn A                  
INNER JOIN dbo.EngAsset B                  
ON A.AssetId = B.AssetId                   
INNER JOIN dbo.MstLocationUserArea C                   
ON B.UserAreaId = C.UserAreaId                   
INNER JOIN dbo.FMLovMst D                   
ON A.WorkOrderPriority = D.LovId                   
INNER JOIN dbo.FMLovMst E                    
ON A.WorkOrderStatus =E.LovId                   
LEFT OUTER JOIN dbo.EngMwoCompletionInfoTxn F                   
ON A.WorkOrderId = F.WorkOrderId                   
LEFT OUTER JOIN dbo.EngMwoAssesmentTxn G                  
ON A.WorkOrderId = G.WorkOrderId                  
--WHERE TypeOfWorkOrder IN ( 270,271,272,273,274)                  
  
---10-11-2020 PROACIVE CATEGORY TO BE REMOVED...  
WHERE TypeOfWorkOrder IN ( 270,271,272,273)                  
AND MaintenanceWorkDateTime >=@STARTOFYEAR AND   MaintenanceWorkDateTime<=@EndDate                
                
--SELECT * FROM #TEMP_MAIN             
                
---------------------------------- ALL WO created in previous month that are open --------------------                 
                
---WROTE SEPERATE LOGIC FOR THE SAME  :DeductionDemeritPointB1B2PrevMonth_Calc    
    
--SELECT *,@StartDate WO_StartDate                
--INTO #TEMPOPENPREVMONTH                
--FROM #TEMP_MAIN                
--WHERE YEAR(WorkRequestDate)=@PREV_YEAR              
----AND MONTH(WorkRequestDate)=@PREV_MONTH                  
--AND TRIM(WOStatus) IN ('Open','Work In Progress')                    
                
--SELECT * FROM #TEMPOPENPREVMONTH                
                
----------------------------------------------------------                
                
-------------MAIN CALCULATION SET                 
                
SELECT AssetNo                
,AssetDescription                
,AssetPurchasePrice                
,WONo                
,UserDept                
,RequestDetails                
,ResponseCategory                
,WorkRequestDate                
,StartDateTime                
,EndDateTime                
,ResponseDateTime                
,ResponseDuration                
,WorkCompletedDate                
,LastDateOf7thDay                
,WOStatus                
,B1_DeductionFigurePerAsset                
,B2_DeductionFigurePerAsset                
,ResponseDurationHHMM                
,RepairTimeDays                
,LEFT(REPLACE(ResponseDurationHHMM,':',''),2) AS RepairTimeHours                
,CASE WHEN TRIM(ResponseCategory)='Critical' AND RIGHT(ResponseDurationHHMM,2) > 15 THEN 1                
      WHEN TRIM(ResponseCategory)='Normal' AND LEFT(REPLACE(ResponseDurationHHMM,':',''),2) > 2 THEN 1                
   ELSE 0 END DemeritPoint_B1                
,CASE WHEN TRIM(ResponseCategory)='Critical' AND RIGHT(ResponseDurationHHMM,2) > 15 THEN 'Y'                
      WHEN TRIM(ResponseCategory)='Normal' AND LEFT(REPLACE(ResponseDurationHHMM,':',''),2) > 2 THEN 'Y'                
   ELSE 'N' END Validate_Estatus_B1                
          
/** change in logic 08-05-2020  **/          
          
   -----NO +1 FOR WHEN THEIR IS AN ENDATE     
,CASE WHEN RepairTimeDays > 7  AND WorkRequestMonth=@MONTH  AND WorkRequestYear=@YEAR AND MONTH(EndDateTime)=@MONTH THEN DATEDIFF(DAY,LastDateOf7thDay,EndDateTime)    
      WHEN RepairTimeDays > 7  AND WorkRequestMonth < @MONTH AND WorkRequestYear=@YEAR AND @MONTH=MONTH(LastDateOf7thDay) AND MONTH(EndDateTime)=@MONTH THEN DATEDIFF(DAY,LastDateOf7thDay,EndDateTime)                         
      ---SEPEARTE LOGIC AS THE WORKORDER REQUEST MONTH AND THE 7TH ALLOWABLE DAY IS OF PREVIOUS MONTH AND END DATE IS OF CURRENT MONTH    
       
   WHEN RepairTimeDays > 7  AND WorkRequestMonth < @MONTH AND WorkRequestYear=@YEAR AND MONTH(LastDateOf7thDay)< @MONTH  AND MONTH(EndDateTime)=@MONTH THEN DATEDIFF(DAY,@StartDate,EndDateTime)+1                      
     
   --CHANGES MADE IN QUERY REMOVDE +1 FOR THE 7TH ALLOWABLE DAY LOGIC   
  
 ---DON HAVE ANY END DATE           
   WHEN RepairTimeDays=0 AND WorkRequestMonth=@MONTH AND @MONTH=MONTH(LastDateOf7thDay) THEN DATEDIFF(DAY,LastDateOf7thDay,@EndDate)          
   WHEN RepairTimeDays=0 AND WorkRequestMonth<@MONTH  AND MONTH(LastDateOf7thDay)<@MONTH THEN DATEDIFF(DAY,@StartDate,@EndDate)+1
   WHEN RepairTimeDays=0 AND WorkRequestMonth<@MONTH  AND MONTH(LastDateOf7thDay)=@MONTH THEN DATEDIFF(DAY,LastDateOf7thDay,@EndDate)          
             
   
             
   ELSE 0 END DemeritPoint_B2                
          
  
--,CASE WHEN RepairTimeDays > 7  AND WorkRequestMonth=@MONTH  AND WorkRequestYear=@YEAR AND MONTH(EndDateTime)=@MONTH THEN 'Y'    
--      WHEN RepairTimeDays > 7  AND WorkRequestMonth < @MONTH AND WorkRequestYear=@YEAR AND MONTH(EndDateTime)=@MONTH THEN 'Y'    
              
-- ---DON HAVE ANY END DATE           
--   WHEN RepairTimeDays=0 AND WorkRequestMonth=@MONTH AND @MONTH=MONTH(LastDateOf7thDay) THEN 'Y'    
--   WHEN RepairTimeDays=0 AND WorkRequestMonth<@MONTH  AND MONTH(LastDateOf7thDay)<@MONTH THEN 'Y'    
--   WHEN RepairTimeDays=0 AND WorkRequestMonth<@MONTH  AND MONTH(LastDateOf7thDay)=@MONTH THEN 'Y'    
             
--   ELSE 'N' END Validate_Estatus_B2                
  
,CASE WHEN RepairTimeDays > 7  AND WorkRequestMonth=@MONTH  AND WorkRequestYear=@YEAR AND MONTH(EndDateTime)=@MONTH THEN 'Y'   
      WHEN RepairTimeDays > 7  AND WorkRequestMonth < @MONTH AND WorkRequestYear=@YEAR AND @MONTH=MONTH(LastDateOf7thDay) AND MONTH(EndDateTime)=@MONTH THEN  'Y'                        
      ---SEPEARTE LOGIC AS THE WORKORDER REQUEST MONTH AND THE 7TH ALLOWABLE DAY IS OF PREVIOUS MONTH AND END DATE IS OF CURRENT MONTH    
       
    WHEN RepairTimeDays > 7  AND WorkRequestMonth < @MONTH AND WorkRequestYear=@YEAR AND MONTH(LastDateOf7thDay)< @MONTH  AND MONTH(EndDateTime)=@MONTH THEN 'Y'                      
     
   --CHANGES MADE IN QUERY REMOVDE +1 FOR THE 7TH ALLOWABLE DAY LOGIC   
  
 ---DON HAVE ANY END DATE           
   WHEN RepairTimeDays=0 AND WorkRequestMonth=@MONTH AND @MONTH=MONTH(LastDateOf7thDay) THEN 'Y'          
   WHEN RepairTimeDays=0 AND WorkRequestMonth<@MONTH  AND MONTH(LastDateOf7thDay)<@MONTH THEN 'Y'  
   WHEN RepairTimeDays=0 AND WorkRequestMonth<@MONTH  AND MONTH(LastDateOf7thDay)=@MONTH THEN 'Y'  
             
   ELSE 'N' END Validate_Estatus_B2                
        
INTO #TEMP_CALC                
FROM #TEMP_MAIN                
                
-------------CURRENT MONTH CLOSED                 
                
SELECT AssetNo                
,AssetDescription                
,AssetPurchasePrice                
,WONo                
,UserDept                
,RequestDetails                
,ResponseCategory                
,WorkRequestDate                
,StartDateTime                
,EndDateTime                
,ResponseDateTime                
,ResponseDuration                
,WorkCompletedDate                
,LastDateOf7thDay                
,WOStatus                
,B1_DeductionFigurePerAsset                
,B2_DeductionFigurePerAsset                
,ResponseDurationHHMM                
,RepairTimeDays                
,RepairTimeHours                
,DemeritPoint_B1                
,Validate_Estatus_B1                
,DemeritPoint_B2                
,Validate_Estatus_B2                
,'Closed On Current Month' AS Flag                
,(ISNULL(B1_DeductionFigurePerAsset,0)*DemeritPoint_B1) AS DeductionProHawkRM_B1                
,(ISNULL(B1_DeductionFigurePerAsset,0)*DemeritPoint_B1) AS DeductionEdgentaRM_B1                
,(ISNULL(B2_DeductionFigurePerAsset,0)*DemeritPoint_B2) AS DeductionProHawkRM_B2                
,(ISNULL(B2_DeductionFigurePerAsset,0)*DemeritPoint_B2) AS DeductionEdgentaRM_B2                
INTO #TEMPCURRCLOSED_CALC                
FROM #TEMP_CALC                
WHERE                 
YEAR(WorkRequestDate)=@YEAR                
AND MONTH(WorkRequestDate )=@MONTH                
AND TRIM(WOStatus) IN ('Closed','Completed')                    
                
                
                
                
                
-------------OPEN  PREVIOUS MONTH CLOSED CURRENT MONTH                
                
SELECT AssetNo                
,AssetDescription                
,AssetPurchasePrice                
,WONo                
,UserDept        ,RequestDetails                
,ResponseCategory                
,WorkRequestDate                
,StartDateTime                
,EndDateTime                
,ResponseDateTime                
,ResponseDuration                
,WorkCompletedDate                
,LastDateOf7thDay                
,WOStatus                
,B1_DeductionFigurePerAsset                
,B2_DeductionFigurePerAsset                
,ResponseDurationHHMM                
,RepairTimeDays                
,RepairTimeHours                
,DemeritPoint_B1                
,Validate_Estatus_B1                
--,DemeritPoint_B2        DISABLE BY AIDA 07022021   
,DATEPART(DAY, EndDateTime) AS DemeritPoint_B2 
--,Validate_Estatus_B2        DISABLE BY AIDA 07022021   
,'Y' AS Validate_Estatus_B2 
,'Prev Month Open Closed Current Month' AS Flag                
,(ISNULL(B1_DeductionFigurePerAsset,0)*DemeritPoint_B1) AS DeductionProHawkRM_B1                
,(ISNULL(B1_DeductionFigurePerAsset,0)*DemeritPoint_B1) AS DeductionEdgentaRM_B1                
--,(ISNULL(B2_DeductionFigurePerAsset,0)*DemeritPoint_B2) AS DeductionProHawkRM_B2      DISABLE BY AIDA 07022021          
--,(ISNULL(B2_DeductionFigurePerAsset,0)*DemeritPoint_B2) AS DeductionEdgentaRM_B2           DISABLE BY AIDA 07022021     
,B2_DeductionFigurePerAsset * DATEPART(DAY, EndDateTime) AS DeductionProHawkRM_B2 
,B2_DeductionFigurePerAsset * DATEPART(DAY, EndDateTime) AS DeductionEdgentaRM_B2

INTO #TEMPPREVCLOSED_CALC                
FROM #TEMP_CALC   
WHERE                 
YEAR(EndDateTime)=@YEAR                
AND MONTH(EndDateTime)=@MONTH                
AND WONo IN (SELECT WONo FROM TEMPOPENPREVMONTH)                    
AND WONo NOT IN (SELECT WONo FROM #TEMPCURRCLOSED_CALC)        
AND TRIM(WOStatus) IN ('Closed','Completed')        
                
                
                
-------------CURRENT MONTH OPEN                
                
SELECT AssetNo                
,AssetDescription                
,AssetPurchasePrice                
,WONo                
,UserDept                
,RequestDetails                
,ResponseCategory                
,WorkRequestDate         
,StartDateTime                
,EndDateTime                
,ResponseDateTime                
,ResponseDuration                
,WorkCompletedDate                
,LastDateOf7thDay                
,WOStatus                
,B1_DeductionFigurePerAsset                
,B2_DeductionFigurePerAsset                
,ResponseDurationHHMM                
,RepairTimeDays                
,RepairTimeHours                
,DemeritPoint_B1                
,Validate_Estatus_B1                
,DemeritPoint_B2                
,Validate_Estatus_B2                
,'Open On Current Month' AS Flag                
,(ISNULL(B1_DeductionFigurePerAsset,0)*DemeritPoint_B1) AS DeductionProHawkRM_B1                
,(ISNULL(B1_DeductionFigurePerAsset,0)*DemeritPoint_B1) AS DeductionEdgentaRM_B1                
,(ISNULL(B2_DeductionFigurePerAsset,0)*DemeritPoint_B2) AS DeductionProHawkRM_B2                
,(ISNULL(B2_DeductionFigurePerAsset,0)*DemeritPoint_B2) AS DeductionEdgentaRM_B2                
INTO #TEMPCURROPEN_CALC                
FROM #TEMP_CALC                
WHERE                 
YEAR(WorkRequestDate)=@YEAR                
AND MONTH(WorkRequestDate )=@MONTH                    
AND TRIM(WOStatus) IN ('Open','Work In Progress')                    
                
                
                
                
-----------------------Prev Month Work Order but still open in current  month                
                
SELECT AssetNo                
,AssetDescription                
,AssetPurchasePrice                
,WONo                
,UserDept                
,RequestDetails                
,ResponseCategory                
,WorkRequestDate                
,StartDateTime                
,EndDateTime                
,ResponseDateTime                
,ResponseDuration                
,WorkCompletedDate                
,LastDateOf7thDay                
,WOStatus                
,B1_DeductionFigurePerAsset                
,B2_DeductionFigurePerAsset                
,ResponseDurationHHMM                
,RepairTimeDays                
,RepairTimeHours                
,DemeritPoint_B1                
,Validate_Estatus_B1    
--,DemeritPoint_B2        DISABLE BY AIDA 07022021  
,CASE
	WHEN Month(LastDateOf7thDay) = @MONTH AND Year(LastDateOf7thDay) = @YEAR THEN DATEPART(DAY, @EndDate) - DATEPART(DAY, LastDateOf7thDay) 
	WHEN Month(LastDateOf7thDay) <> @MONTH AND Year(LastDateOf7thDay) <> @YEAR THEN DATEPART(DAY, @EndDate)
	WHEN Month(LastDateOf7thDay) <> @MONTH AND Year(LastDateOf7thDay) = @YEAR THEN DATEPART(DAY, @EndDate)
	END AS DemeritPoint_B2
--,Validate_Estatus_B2        DISABLE BY AIDA 07022021   
,'Y' AS Validate_Estatus_B2 



,'Prev Month Open And Still Open In Current Month' AS Flag                
,(ISNULL(B1_DeductionFigurePerAsset,0)*DemeritPoint_B1) AS DeductionProHawkRM_B1                
,(ISNULL(B1_DeductionFigurePerAsset,0)*DemeritPoint_B1) AS DeductionEdgentaRM_B1                
--,(ISNULL(B2_DeductionFigurePerAsset,0)*DemeritPoint_B2) AS DeductionProHawkRM_B2                
--,(ISNULL(B2_DeductionFigurePerAsset,0)*DemeritPoint_B2) AS DeductionEdgentaRM_B2            

,CASE
	WHEN Month(LastDateOf7thDay) = @MONTH AND Year(LastDateOf7thDay) = @YEAR THEN B2_DeductionFigurePerAsset * (DATEPART(DAY, @EndDate) - DATEPART(DAY, LastDateOf7thDay))
	WHEN Month(LastDateOf7thDay) <> @MONTH AND Year(LastDateOf7thDay) <> @YEAR THEN B2_DeductionFigurePerAsset * DATEPART(DAY, @EndDate)
	WHEN Month(LastDateOf7thDay) <> @MONTH AND Year(LastDateOf7thDay) = @YEAR THEN B2_DeductionFigurePerAsset * DATEPART(DAY, @EndDate)
	END AS DeductionProHawkRM_B2
,CASE
	WHEN Month(LastDateOf7thDay) = @MONTH AND Year(LastDateOf7thDay) = @YEAR THEN B2_DeductionFigurePerAsset * (DATEPART(DAY, @EndDate) - DATEPART(DAY, LastDateOf7thDay))
	WHEN Month(LastDateOf7thDay) <> @MONTH AND Year(LastDateOf7thDay) <> @YEAR THEN B2_DeductionFigurePerAsset * DATEPART(DAY, @EndDate)
	WHEN Month(LastDateOf7thDay) <> @MONTH AND Year(LastDateOf7thDay) = @YEAR THEN B2_DeductionFigurePerAsset * DATEPART(DAY, @EndDate)
	END AS DeductionEdgentaRM_B2

INTO #TEMPPREVOPEN_CALC                
FROM #TEMP_CALC                
WHERE @YEAR=(SELECT YEAR(MAX(WO_StartDate)) FROM TEMPOPENPREVMONTH)                
AND @MONTH=(SELECT MONTH(MAX(WO_StartDate)) FROM TEMPOPENPREVMONTH)                
AND WONo IN (SELECT WONo FROM TEMPOPENPREVMONTH)                
AND WONo NOT IN (SELECT WONo FROM #TEMPCURROPEN_CALC)    
AND TRIM(WOStatus) IN ('Open','Work In Progress')                  
                
                
---FINAL OUTPUT                
                
                
SELECT * INTO #TEMPFINAL FROM (                
SELECT * FROM #TEMPCURRCLOSED_CALC                 
UNION ALL                 
SELECT * FROM #TEMPPREVCLOSED_CALC                
UNION ALL                
SELECT * FROM #TEMPCURROPEN_CALC                
UNION ALL                
SELECT * FROM #TEMPPREVOPEN_CALC                
) AA                
                
    
                
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
,FLAG              
,LastDateOf7thDay  
)                
                
SELECT                 
 157 AS CustomerId                
,144 AS FacilityId                
,NULL AS DedTxnMappingId                
,WorkRequestDate AS Date---workorderdate                
,WONo AS DocumentNo---workorderno                
,RequestDetails AS Details---maintaincedetails                
,AssetNo                
,AssetDescription                
,'Unscheduled Work Order' AS ScreenName--Unschduleworkorder                
,DemeritPoint_B1 AS DemeritPoint                
,NULL AS FinalDemeritPoint                
,1 AS IsValid---'Y'                
,NULL AS DisputedPendingResolution ----update                
,NULL AS Remarks                
,DeductionEdgentaRM_B1 AS DeductionValue                
,19 AS CreatedBy                
,GETDATE() AS CreatedDate                
,GETUTCDATE() AS CreatedDateUTC                
,19 AS ModifiedBy                
,GETDATE() AS ModifiedDate                
,GETUTCDATE() AS ModifiedDateUTC                
,@YEAR AS [YEAR]                
,@MONTH AS [MONTH]                
,1 AS IndicatorDetId                
,'B1' AS IndicatorName                
,FLAG              
,LastDateOf7thDay  
FROM #TEMPFINAL                
                
UNION ALL                 
                
SELECT                 
 157 AS CustomerId                
,144 AS FacilityId                
,NULL AS DedTxnMappingId                
,WorkRequestDate AS Date---workorderdate                
,WONo AS DocumentNo---workorderno                
,RequestDetails AS Details---maintaincedetails                
,AssetNo                
,AssetDescription                
,'Unscheduled Work Order' AS ScreenName--Unschduleworkorder                
,DemeritPoint_B2 AS DemeritPoint                
,NULL AS FinalDemeritPoint                
,1 AS IsValid                
,NULL AS DisputedPendingResolution                
,NULL AS Remarks                
,DeductionEdgentaRM_B2 AS DeductionValue                
,19 AS CreatedBy                
,GETDATE() AS CreatedDate                
,GETUTCDATE() AS CreatedDateUTC                
,19 AS ModifiedBy                
,GETDATE() AS ModifiedDate                
,GETUTCDATE() AS ModifiedDateUTC                
,@YEAR AS [YEAR]                
,@MONTH AS [MONTH]                
,2 AS IndicatorDetId                
,'B2' AS IndicatorName                
,FLAG              
,LastDateOf7thDay  
FROM #TEMPFINAL                
                
                
                
--------------UPDATING TXNID                
                
--SELECT B.DedTxnMappingId,A.IndicatorDetId,A.YEAR,A.MONTH                 
UPDATE A                
SET A.DedTxnMappingId=B.DedTxnMappingId                
FROM DedTransactionMappingTxnDet A                
INNER JOIN  DedTransactionMappingTxn B                
ON A.IndicatorDetId=B.IndicatorDetId                
AND A.YEAR=B.Year                
AND A.MONTH=B.Month                
WHERE A.IndicatorDetId IN (1,2)                
                
--------INSERT INTO DedGenerationTxnDet AFTER DedTransactionMappingTxnDet INSERT HAPPEN                 
                
                
                
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
AND IndicatorDetId IN (1,2)                
GROUP BY IndicatorDetId,[YEAR],[MONTH]                
                
                
UPDATE A                
SET A.DedGenerationId=B.DedGenerationId                
FROM DedGenerationTxnDet A                 
INNER JOIN DedGenerationTxn B                
ON A.[Year]=B.[Year]                
AND A.[Month]=B.[Month]                
WHERE A.IndicatorDetId IN (1,2)                
          
          
/*DEDUCTION LOGIC ADDED IN MONTH OF AUG 2020*/              
          
UPDATE A SET A.PurchaseCost=B.PurchaseCostRM FROM DedTransactionMappingTxnDet A INNER JOIN EngAsset B ON A.AssetNo=B.AssetNo           
              
               
END TRY                              
BEGIN CATCH                
                              
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                              
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                              
                              
THROW                              
                              
END CATCH                              
SET NOCOUNT OFF                              
END 
GO
