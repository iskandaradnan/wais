USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionDemeritPointB1B2PrevMonth_Calc]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[DeductionDemeritPointB1B2PrevMonth_Calc]
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
--SELECT @STARTOFYEAR  
              
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
              
DECLARE @StartDate DATETIME              
DECLARE @EndDate DATETIME              
              
SET @StartDate=CAST(CONCAT(CONCAT(CONCAT(@MONTH,'-01'),'-'),@YEAR) AS DATE)              
SET @EndDate=CAST((CASE WHEN @MONTH IN (1,3,5,7,8,10,12) THEN CONCAT(CONCAT(CONCAT(@MONTH,'-31'),'-'),@YEAR)              
WHEN @MONTH IN (2) AND @LEAPYEAR='YES' THEN CONCAT(CONCAT(CONCAT(@MONTH,'-29'),'-'),@YEAR)              
WHEN @MONTH IN (2) AND @LEAPYEAR='NO' THEN CONCAT(CONCAT(CONCAT(@MONTH,'-28'),'-'),@YEAR)              
ELSE CONCAT(CONCAT(CONCAT(@MONTH,'-30'),'-'),@YEAR) END) AS DATE)              
              
--SELECT @StartDate,@EndDate,@MONTH,@PREV_YEAR,@PREV_MONTH              
              
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
FROM dbo.EngMaintenanceWorkOrderTxn A  WITH (NOLOCK)            
INNER JOIN dbo.EngAsset B WITH (NOLOCK)              
ON A.AssetId = B.AssetId               
INNER JOIN dbo.MstLocationUserArea C   WITH (NOLOCK)            
ON B.UserAreaId = C.UserAreaId               
INNER JOIN dbo.FMLovMst D               
ON A.WorkOrderPriority = D.LovId               
INNER JOIN dbo.FMLovMst E    WITH (NOLOCK)            
ON A.WorkOrderStatus =E.LovId               
LEFT OUTER JOIN dbo.EngMwoCompletionInfoTxn F     WITH (NOLOCK)          
ON A.WorkOrderId = F.WorkOrderId               
LEFT OUTER JOIN dbo.EngMwoAssesmentTxn G   WITH (NOLOCK)           
ON A.WorkOrderId = G.WorkOrderId              
WHERE TypeOfWorkOrder IN ( 270,271,272,273,274)              
AND MaintenanceWorkDateTime >=@STARTOFYEAR AND   MaintenanceWorkDateTime<=@EndDate            
              
--SELECT * FROM #TEMP_MAIN WHERE WONo IN ('MWRWAC/B/2020/000547')            
              
---------------------------------- ALL WO created in previous month that are open --------------------               

INSERT INTO TEMPOPENPREVMONTH
(
AssetNo
,AssetDescription
,AssetPurchasePrice
,WONo
,WorkOrderId
,UserDept
,RequestDetails
,ResponseCategory
,WorkRequestDate
,WorkRequestYear
,WorkRequestMonth
,StartDateTime
,EndDateTime
,ResponseDateTime
,ResponseDuration
,WorkCompletedDate
,RepairTimeDays
,LastDateOf7thDay
,WOStatus
,B1_DeductionFigurePerAsset
,B2_DeductionFigurePerAsset
,ResponseDurationHHMM

)

              
SELECT AssetNo
,AssetDescription
,AssetPurchasePrice
,WONo
,WorkOrderId
,UserDept
,RequestDetails
,ResponseCategory
,WorkRequestDate
,WorkRequestYear
,WorkRequestMonth
,StartDateTime
,EndDateTime
,ResponseDateTime
,ResponseDuration
,WorkCompletedDate
,RepairTimeDays
,LastDateOf7thDay
,WOStatus
,B1_DeductionFigurePerAsset
,B2_DeductionFigurePerAsset
,ResponseDurationHHMM
--,@StartDate WO_StartDate
FROM #TEMP_MAIN              
WHERE YEAR(WorkRequestDate)=@PREV_YEAR              
--AND MONTH(WorkRequestDate)=@PREV_MONTH            
AND TRIM(WOStatus) IN ('Open','Work In Progress') 
AND WONo NOT IN (SELECT WONo FROM TEMPOPENPREVMONTH)


---UPDATE

UPDATE A
SET  WO_StartDate=@StartDate 
FROM TEMPOPENPREVMONTH A


END


GO
