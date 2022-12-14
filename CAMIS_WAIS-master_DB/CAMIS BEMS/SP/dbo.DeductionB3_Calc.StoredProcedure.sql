USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionB3_Calc]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT * FROM EngAsset WHERE AssetNo='WB439000896A'    
    
--SELECT * FROM EngMaintenanceWorkOrderTxn WHERE AssetId=4984    
    
--EXEC BEMSDeductionB3_Calc    
    
CREATE PROCEDURE [dbo].[DeductionB3_Calc]    
(
@YEAR INT      
,@MONTH INT      
)
AS    
    
/*Dropping the temp table and creatinf the same again*/    
BEGIN              
    
SET NOCOUNT ON              
SET TRANSACTION ISOLATION LEVEL READ COMMITTED              
BEGIN TRY    
    
    
IF OBJECT_ID('tempdb.dbo.#TEMP_MAIN', 'U') IS NOT NULL        
DROP TABLE #TEMP_MAIN       
    
IF OBJECT_ID('tempdb.dbo.#TEMP_MAIN_CALC', 'U') IS NOT NULL        
DROP TABLE #TEMP_MAIN_CALC       
    
    
IF OBJECT_ID('tempdb.dbo.#TEMP_ASSET', 'U') IS NOT NULL        
DROP TABLE #TEMP_ASSET       
    
IF OBJECT_ID('tempdb.dbo.#TEMP_IMP', 'U') IS NOT NULL        
DROP TABLE #TEMP_IMP    
       
IF OBJECT_ID('tempdb.dbo.#TEMP_ASSET_INFO', 'U') IS NOT NULL        
DROP TABLE #TEMP_ASSET_INFO    
    
IF OBJECT_ID('tempdb.dbo.#TEMP_ASSET', 'U') IS NOT NULL        
DROP TABLE #TEMP_ASSET    
    
    
IF OBJECT_ID('tempdb.dbo.#TEMP_CALC', 'U') IS NOT NULL        
DROP TABLE #TEMP_CALC    
    
IF OBJECT_ID('tempdb.dbo.#TEMP_UPTIME', 'U') IS NOT NULL        
DROP TABLE #TEMP_UPTIME    
    
IF OBJECT_ID('tempdb.dbo.#TEMP_UPTIME_CALC', 'U') IS NOT NULL        
DROP TABLE #TEMP_UPTIME_CALC    
    
    
IF OBJECT_ID('tempdb.dbo.#TEMP_REPORT_CALC', 'U') IS NOT NULL        
DROP TABLE #TEMP_REPORT_CALC    
    
IF OBJECT_ID('tempdb.dbo.#TEMP_CALC_1', 'U') IS NOT NULL        
DROP TABLE #TEMP_CALC_1    
    
IF OBJECT_ID('tempdb.dbo.#TEMPD1', 'U') IS NOT NULL        
DROP TABLE #TEMPD1    
    
IF OBJECT_ID('tempdb.dbo.#TEMPD2', 'U') IS NOT NULL        
DROP TABLE #TEMPD2    
    
IF OBJECT_ID('tempdb.dbo.#TEMPDEMERITCALC_IMP', 'U') IS NOT NULL        
DROP TABLE #TEMPDEMERITCALC_IMP    
    
IF OBJECT_ID('tempdb.dbo.#TEMP_REPORT_CALC', 'U') IS NOT NULL        
DROP TABLE #TEMP_REPORT_CALC    
    
    
    
    
    
--DECLARE @YEAR INT      
--DECLARE @MONTH INT      
DECLARE @PREV_YEAR INT       
DECLARE @PREV_MONTH INT      
DECLARE @LEAPYEAR VARCHAR(10)      
      
      
--DECLARE @MONTHCALC INT      
      
--SET @YEAR=(SELECT YEAR(GETDATE()))      
--SET @MONTH=6--(SELECT MONTH(GETDATE()))    
      
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
      
SET @StartDate=CAST(CONCAT(CONCAT(CONCAT('01','-01'),'-'),@YEAR) AS DATE)      
SET @EndDate=CAST((CASE WHEN @MONTH IN (1,3,5,7,10,12) THEN CONCAT(CONCAT(CONCAT(@MONTH,'-31'),'-'),@YEAR)      
WHEN @MONTH IN (2) AND @LEAPYEAR='YES' THEN CONCAT(CONCAT(CONCAT(@MONTH,'-29'),'-'),@YEAR)      
WHEN @MONTH IN (2) AND @LEAPYEAR='NO' THEN CONCAT(CONCAT(CONCAT(@MONTH,'-28'),'-'),@YEAR)      
ELSE CONCAT(CONCAT(CONCAT(@MONTH,'-30'),'-'),@YEAR) END) AS DATE)      
    
    
    
    
DELETE FROM DeductionB3_Base WHERE Year=@YEAR    
DELETE FROM DeductionB3OutPut WHERE Year=@YEAR    
DELETE FROM DeductionB3BaseDemerit WHERE Year=@YEAR    
    
/*****deduction date table calculation logic end ******/    
    
--DECLARE @StartDate1  date = '20190101';    
    
--DECLARE @CutoffDate date = DATEADD(DAY, -1, DATEADD(YEAR, 4, @StartDate1));    
    
--;WITH SEQ(N) AS     
--(    
--  SELECT 0 UNION ALL SELECT N + 1 FROM seq    
--  WHERE N < DATEDIFF(DAY, @StartDate1, @CutoffDate)    
--),    
--D(D) AS     
--(    
--  SELECT DATEADD(DAY, n, @StartDate1) FROM seq    
--),    
--SRC AS    
--(    
--  SELECT    
--    TheDate         = CONVERT(date, d),    
--    TheDay          = DATEPART(DAY,       d),    
--    TheDayName      = DATENAME(WEEKDAY,   d),    
--    TheWeek         = DATEPART(WEEK,      d),    
--    TheISOWeek      = DATEPART(ISO_WEEK,  d),    
--    TheDayOfWeek    = DATEPART(WEEKDAY,   d),    
--    TheMonth        = DATEPART(MONTH,     d),    
--    TheMonthName    = DATENAME(MONTH,     d),    
--    TheQuarter      = DATEPART(Quarter,   d),    
--    TheYear         = DATEPART(YEAR,      d),    
--    TheFirstOfMonth = DATEFROMPARTS(YEAR(d), MONTH(d), 1),    
--    TheLastOfYear   = DATEFROMPARTS(YEAR(d), 12, 31),    
--    TheDayOfYear    = DATEPART(DAYOFYEAR, d)    
--  FROM D    
--)    
--SELECT TheMonth AS Month,TheYear AS Year     
--INTO Deduction_Date    
--FROM SRC    
--ORDER BY TheDate    
--OPTION (MAXRECURSION 0);    
    
--;WITH CTE AS    
--(    
--SELECT *,ROW_NUMBER() OVER(PARTITION BY Month,Year ORDER BY YEAR ) AS RN FROM Deduction_Date    
--)    
--DELETE FROM CTE WHERE RN>1    
    
/*****deduction date table calculation logic end ******/    
    
    
    
    
/*** Base Data Calculation  ***/    
SELECT DISTINCT A.AssetNo    
      ,A.AssetId    
      ,B.AssetTypeCode    
   ,B.AssetTypeDescription    
   ,A.PurchaseCostRM    
   ,A.PurchaseDate    
   ,DATEDIFF(YEAR,A.PurchaseDate,GETDATE()) AS AssetAge      
      ,CASE WHEN DATEDIFF(YEAR,A.PurchaseDate,GETDATE())>=0 AND DATEDIFF(YEAR,A.PurchaseDate,GETDATE()) <5 THEN '0-5 Years'      
            WHEN DATEDIFF(YEAR,A.PurchaseDate,GETDATE())>=5 AND DATEDIFF(YEAR,A.PurchaseDate,GETDATE()) <=10 THEN '5-10 Years'      
            WHEN DATEDIFF(YEAR,A.PurchaseDate,GETDATE())> 10  THEN '>10 Years'      
            END AS AgeDiffBucket      
      ---WARRANTY      
  ,CASE WHEN GETDATE() < WarrantyEndDate THEN  'InWaranty' ELSE 'Out of Warranty'  END AS WarrantyStatus         
         
,CASE WHEN A.PurchaseCostRM BETWEEN 0.00 AND 20000.00 THEN 300.00      
      WHEN A.PurchaseCostRM BETWEEN 20001.00 AND 50000.00 THEN 500.00      
   WHEN A.PurchaseCostRM BETWEEN 50001.00 AND 100000.00 THEN 1000.00      
   WHEN A.PurchaseCostRM BETWEEN 100001.00 AND 500000.00 THEN 2000.00      
   WHEN A.PurchaseCostRM BETWEEN 500001.00 AND 1000000.00 THEN 4000.00      
   WHEN A.PurchaseCostRM BETWEEN 1000001.00 AND 1000000000.00 THEN 6000.00      
   END AS DeductionFigurePerAsset          
,CASE WHEN A.PurchaseCostRM BETWEEN 0.00 AND 20000.00 THEN 600.00      
      WHEN A.PurchaseCostRM BETWEEN 20001.00 AND 50000.00 THEN 1000.00      
   WHEN A.PurchaseCostRM BETWEEN 50001.00 AND 100000.00 THEN 2000.00      
   WHEN A.PurchaseCostRM BETWEEN 100001.00 AND 500000.00 THEN 4000.00      
   WHEN A.PurchaseCostRM BETWEEN 500001.00 AND 1000000.00 THEN 8000.00      
   WHEN A.PurchaseCostRM BETWEEN 1000001.00 AND 1000000000.00 THEN 12000.00      
   END AS DeductionFigurePerAssetLessThenEighty      
  ,C.OPERATING_HOURS AS OperatingHours    
  ,C.[OPERATING HOURS_WK _DAYS] AS OperatingDaysWeeks    
  ,C.UPTIME_EQUIPMENT_5_10_YRS AS Uptime_5_10_Yrs    
  ,C.UPTIME_EQUIPMENT_5_YRS AS Uptime_0_5_Yrs    
  --,52*(DATEDIFF(YEAR,A.PurchaseDate,GETDATE()))*C.OPERATING_HOURS*C.[OPERATING HOURS_WK _DAYS] AS TotalAnnualHours    
  ,52*C.OPERATING_HOURS*C.[OPERATING HOURS_WK _DAYS] AS TotalAnnualHours    
  ,D.MaintenanceWorkNo    
  ,D.MaintenanceDetails    
  ,D.WorkOrderId    
  ,D.TypeOfWorkOrder    
  ,D.MaintenanceWorkDateTime    
  ,D.WorkOrderStatus    
  ,ISNULL(E.EndDateTime,@EndDate) AS EndDate    
  ,DATEDIFF(HOUR,D.MaintenanceWorkDateTime,ISNULL(E.EndDateTime,@EndDate))+1 AS DownTimeAging    
  ,DATEDIFF(DAY,D.MaintenanceWorkDateTime,ISNULL(E.EndDateTime,@EndDate))+1 AS DownTimeAgingdays--    
  ,(DATEDIFF(DAY,D.MaintenanceWorkDateTime,ISNULL(E.EndDateTime,@EndDate))+1)*C.OPERATING_HOURS AS TotalAccumDowtimeHours    
     ,YEAR(D.MaintenanceWorkDateTime) AS [Year]    
  ,MONTH(D.MaintenanceWorkDateTime) AS [Month]    
  --,DENSE_RANK() OVER (PARTITION BY A.AssetId     
  -- ORDER BY (DATEDIFF(DAY,D.MaintenanceWorkDateTime,ISNULL(E.EndDateTime,@EndDate))+1)*C.OPERATING_HOURS DESC) AS Rn    
      ,ROW_NUMBER() OVER(PARTITION BY A.AssetId ORDER BY A.AssetId) Asset_Rn    
INTO #TEMP_MAIN    
FROM [uetrackbemsdbPreProd].[DBO].EngAsset A WITH (NOLOCK)     
LEFT OUTER JOIN [uetrackbemsdbPreProd].[DBO].EngAssetTypeCode B WITH (NOLOCK)    
ON A.AssetTypeCodeId=B.AssetTypeCodeId    
INNER JOIN (SELECT DISTINCT [TYPE CODE],[DESCRIPTION],OPERATING_HOURS,[OPERATING HOURS_WK _DAYS],UPTIME_EQUIPMENT_5_10_YRS,UPTIME_EQUIPMENT_5_YRS     
FROM [uetrackbemsdbPreProd].[DBO].AssetTypeCodeDeduction) C    
ON B.AssetTypeCode=C.[TYPE CODE]    
LEFT JOIN [uetrackbemsdbPreProd].[DBO].EngMaintenanceWorkOrderTxn D WITH (NOLOCK)    
ON A.AssetId=D.AssetId    
LEFT JOIN [uetrackbemsdbPreProd].[dbo].EngMwoCompletionInfoTxn E WITH (NOLOCK)    
ON D.WorkOrderId=E.WorkOrderId    
WHERE D.WorkOrderStatus IN (194,195)    
AND MaintenanceWorkType=273   
/*LOGIC ADDED ON 11-11-2020 AS PER Ainna to ingnore Function and Partial Functioning Assets*/
AND A.RealTimeStatusLovId NOT IN (1504,55)
    
--SELECT * FROM #TEMP_MAIN    
------WHERE Year=2019    
--WHERE AssetNo='WB549004938A'    
    
/*** Asset Info Calculation Data Calculation  ***/    
    
    
SELECT DISTINCT AssetNo    
,AssetTypeCode    
,AssetTypeDescription    
,PurchaseCostRM    
,AssetAge    
,OperatingHours    
,OperatingDaysWeeks     
,TotalAnnualHours    
,DeductionFigurePerAsset    
,DeductionFigurePerAssetLessThenEighty    
,SUM(TotalAccumDowtimeHours) AS TotalAccumDowtimeHours    
--,TotalAccumDowtimeHours    
,CASE WHEN AssetAge BETWEEN 0 AND 5 THEN Uptime_0_5_Yrs    
      WHEN AssetAge BETWEEN 5 AND 10 THEN Uptime_5_10_Yrs    
   END AS TargetUptime    
    
INTO #TEMP_ASSET_INFO    
FROM #TEMP_MAIN    
GROUP BY AssetNo    
,AssetTypeCode    
,AssetTypeDescription    
,PurchaseCostRM    
,AssetAge    
,OperatingHours    
,OperatingDaysWeeks     
,TotalAnnualHours    
,DeductionFigurePerAsset    
,DeductionFigurePerAssetLessThenEighty    
,CASE WHEN AssetAge BETWEEN 0 AND 5 THEN Uptime_0_5_Yrs    
      WHEN AssetAge BETWEEN 5 AND 10 THEN Uptime_5_10_Yrs    
   END    
    
--SELECT * FROM #TEMP_ASSET_INFO    
--WHERE AssetNo='WB325002207A'    
    
/*** Downtime Aging and Total Annual hours Calculation  ***/    
    
SELECT C.AssetNo    
,C.AssetTypeCode AS AssetTypeCode    
,C.PurchaseCostRM AS AssetPurchasePrice    
,C.AssetAge AS AssetAge    
,C.OperatingHours AS OperatingHours    
,C.OperatingDaysWeeks AS OperatingDaysWeeks    
,C.TotalAnnualHours AS TotalAnnualHours    
,C.PurchaseCostRM    
,SUM(DownTimeAging) AS  DownTimeAging    
,C.Year    
,C.Month    
INTO #TEMP_MAIN_CALC    
FROM #TEMP_MAIN C    
GROUP BY C.AssetNo    
,C.AssetTypeCode     
,C.PurchaseCostRM     
,C.AssetAge     
,C.OperatingHours     
,C.OperatingDaysWeeks     
,C.TotalAnnualHours     
,C.Year    
,C.Month    
,C.PurchaseCostRM    
--SELECT * FROM #TEMP_MAIN_CALC    
--WHERE AssetNo='WB325002207A'    
    
    
/*Logic to get 12 records for each Asset */    
    
--SELECT * INTO Deduction_Date FROM [10.249.5.52].[uetrackbemsdbPreProd].[DBO].Deduction_Date    
    
SELECT DISTINCT AssetNo,B.Year,B.Month     
INTO #TEMP_IMP    
FROM #TEMP_MAIN A    
CROSS JOIN [uetrackbemsdbPreProd].[DBO].Deduction_Date B    
WHERE     
--AssetNo='WB102002220A'    
--AND     
    A.Year=@YEAR    
AND B.Year=@YEAR    
--SELECT * FROM #TEMP_IMP    
    
    
/*Asset Related Info*/    
    
SELECT A.AssetNo    
,ISNULL(B.AssetTypeCode,C.AssetTypeCode) AS AssetTypeCode    
,ISNULL(B.PurchaseCostRM,C.PurchaseCostRM) AS AssetPurchasePrice    
,ISNULL(B.AssetAge,C.AssetAge) AS AssetAge    
,ISNULL(B.OperatingHours,C.OperatingHours) AS OperatingHours    
,ISNULL(B.OperatingDaysWeeks,C.OperatingDaysWeeks) AS OperatingDaysWeeks    
,ISNULL(B.TotalAnnualHours,C.TotalAnnualHours) AS TotalAnnualHours    
,ISNULL(DownTimeAging,0) AS  DownTimeAging    
,C.TargetUptime    
,C.AssetTypeDescription    
,C.TotalAccumDowtimeHours    
,C.DeductionFigurePerAsset    
,C.DeductionFigurePerAssetLessThenEighty    
    
,A.Year    
,A.Month    
INTO #TEMP_ASSET    
FROM #TEMP_IMP A    
LEFT OUTER JOIN #TEMP_MAIN_CALC B    
ON A.AssetNo=B.AssetNo    
AND A.Month=B.Month    
AND A.Year=B.Year    
INNER JOIN #TEMP_ASSET_INFO C    
ON A.AssetNo=C.AssetNo    
    
--SELECT * FROM #TEMP_ASSET    
    
/*Uptime Calc Logic*/    
    
SELECT AssetNo    
,AssetTypeCode    
,AssetPurchasePrice    
,AssetAge    
,OperatingHours    
,OperatingDaysWeeks    
,TotalAnnualHours    
,DownTimeAging    
,CASE WHEN B.MONTH=1 THEN TotalAnnualHours ELSE 0 END AS Uptime_Calc    
,TargetUptime    
,AssetTypeDescription    
,TotalAccumDowtimeHours    
,DeductionFigurePerAsset    
,DeductionFigurePerAssetLessThenEighty    
,Year    
,Month    
INTO #TEMP_CALC    
FROM #TEMP_ASSET B    
ORDER BY Month    
    
    
/*Applying the Running Total Logic*/    
    
SELECT AssetNo    
,AssetTypeCode    
,AssetPurchasePrice    
,AssetAge    
,OperatingHours    
,OperatingDaysWeeks    
,TotalAnnualHours    
,DownTimeAging    
,Uptime_Calc    
,AssetTypeDescription    
,TotalAccumDowtimeHours    
    
,TargetUptime    
,DeductionFigurePerAsset    
,DeductionFigurePerAssetLessThenEighty    
    
,Year    
,Month    
,SUM (Uptime_Calc-DownTimeAging) OVER (PARTITION BY AssetNo ORDER BY Year,Month) AS RunningTotal     
INTO #TEMP_UPTIME     
FROM #TEMP_CALC    
ORDER BY MONTH    
    
    
--SELECT * FROM #TEMP_UPTIME    
    
    
/*UPTIME CALCULATION*/    
    
SELECT AssetNo    
,AssetTypeCode    
,AssetPurchasePrice    
,AssetAge    
,OperatingHours    
,OperatingDaysWeeks    
,TotalAnnualHours    
,DownTimeAging    
,Uptime_Calc    
,RunningTotal    
,TargetUptime    
,AssetTypeDescription    
,TotalAccumDowtimeHours    
    
,CAST((RunningTotal/TotalAnnualHours) AS NUMERIC(18,2))  AS Uptime    
,DeductionFigurePerAsset    
,DeductionFigurePerAssetLessThenEighty    
,Year    
,Month     
INTO #TEMP_UPTIME_CALC    
FROM #TEMP_UPTIME     
    
    
SELECT AssetNo    
,AssetTypeCode    
,AssetPurchasePrice    
,AssetAge    
,OperatingHours    
,OperatingDaysWeeks    
,TotalAnnualHours    
,DownTimeAging    
,Uptime_Calc    
,RunningTotal    
,TargetUptime    
,AssetTypeDescription    
,TotalAccumDowtimeHours    
,Uptime    
,DeductionFigurePerAsset    
,DeductionFigurePerAssetLessThenEighty    
,Year    
,Month    
INTO #TEMP_CALC_1    
FROM #TEMP_UPTIME_CALC    
    
    
/***Creating Base Data**/    
    
INSERT INTO DeductionB3_Base    
(    
 AssetNo    
,AssetTypeCode    
,AssetPurchasePrice    
,AssetAge    
,OperatingHours    
,OperatingDaysWeeks    
,TotalAnnualHours    
,DownTimeAging    
,Uptime_Calc    
,RunningTotal    
,TargetUptime    
,AssetTypeDescription    
,TotalAccumDowtimeHours    
,Uptime    
,DeductionFigurePerAsset    
,DeductionFigurePerAssetLessThenEighty    
,Year    
,Month    
)    
    
SELECT  AssetNo    
,AssetTypeCode    
,AssetPurchasePrice    
,AssetAge    
,OperatingHours    
,OperatingDaysWeeks    
,TotalAnnualHours    
,DownTimeAging    
,Uptime_Calc    
,RunningTotal    
,TargetUptime    
,AssetTypeDescription    
,TotalAccumDowtimeHours    
,Uptime    
,DeductionFigurePerAsset    
,DeductionFigurePerAssetLessThenEighty    
,Year    
,Month      
--INTO DeductionB3_Base    
FROM #TEMP_CALC_1    
    
    
---------CALCULATING THE FIRST OCCURENCE    
--SELECT * ,ROW_NUMBER()OVER(PARTITION BY AssetNo,DemeritPoint1 ORDER BY Month) AS RNFirstOcuurence  INTO #TEMP_CALC_FO FROM #TEMP_CALC_1    
    
----SELECT * FROM #TEMP_CALC_FO    
    
---------CALCULATING THE FIRST OCCURENCE MONTH    
--SELECT *,CASE WHEN RNFirstOcuurence=1 AND DemeritPoint1=1 THEN Month ELSE 0 END AS FirstOccurenceMonth INTO #TEMP_CALC_FOM FROM #TEMP_CALC_FO    
    
    
    
--SELECT *     
--UPDATE A    
--SET Uptime=0.91    
--FROM DEEPAK_TEST A WHERE ASSETNO='WB102002220A' AND MONTH=3    
    
    
----Calculating the min month for asset no falling with in the bucket---    
    
SELECT MIN([MONTH]) AS Min_Month    
,AssetNo     
INTO #TEMPD1     
FROM DeductionB3_Base     
WHERE (Uptime<1.0 AND Uptime>0.80 AND Uptime<TargetUptime) OR Uptime<0.80     
GROUP BY AssetNo    
    
    
--SELECT * FROM #TEMPD1     
--WHERE AssetNo='WB101002537A'    
    
    
SELECT MIN([MONTH]) AS MinMonth    
,AssetNo INTO #TEMPD2     
FROM DeductionB3_Base     
WHERE  Uptime<0.80     
GROUP BY AssetNo    
    
    
---------DEMERIT POINT CALCULATION    
    
INSERT INTO DeductionB3BaseDemerit    
(    
 AssetNo    
,AssetTypeCode    
,AssetPurchasePrice    
,AssetAge    
,OperatingHours    
,OperatingDaysWeeks    
,TotalAnnualHours    
,DownTimeAging    
,Uptime_Calc    
,RunningTotal    
,TargetUptime    
,AssetTypeDescription    
,TotalAccumDowtimeHours    
,Uptime    
,DeductionFigurePerAsset    
,DeductionFigurePerAssetLessThenEighty    
,Year    
,Month    
,DemritPoint_1    
,DemritPoint_2    
)    
    
SELECT A.AssetNo    
,AssetTypeCode    
,AssetPurchasePrice    
,AssetAge    
,OperatingHours    
,OperatingDaysWeeks    
,TotalAnnualHours    
,DownTimeAging    
,Uptime_Calc    
,RunningTotal    
,TargetUptime    
,AssetTypeDescription    
,TotalAccumDowtimeHours    
,Uptime    
,DeductionFigurePerAsset    
,DeductionFigurePerAssetLessThenEighty    
,A.Year    
,A.Month    
,CASE WHEN A.MONTH=B.Min_Month THEN 1 ELSE 0 END AS DemritPoint_1    
,CASE WHEN A.MONTH=C.MinMonth THEN 1 ELSE 0 END AS DemritPoint_2    
    
--,CASE WHEN A.Uptime > 0.80  AND A.Uptime < A.TargetUptime AND A.FirstOccurenceMonth=@MONTH AND A.RNFirstOcuurence=1 THEN 1     
--WHEN A.Uptime<0.80 AND A.FirstOccurenceMonth=@MONTH AND A.RNFirstOcuurence=1 THEN 1    
--ELSE 0 END AS DemritPoint_1    
    
    
--,CASE     
--WHEN A.Uptime < 0.80 AND A.FirstOccurenceMonth=@MONTH AND A.RNFirstOcuurence=1 THEN 1     
--WHEN @MONTH>B.FirstOccurenceMonth AND Uptime< 0.80 THEN 1    
--ELSE 0 END AS DemritPoint_2    
--INTO DeductionB3BaseDemerit    
FROM DeductionB3_Base A    
LEFT OUTER JOIN #TEMPD1 B    
ON A.AssetNo=B.AssetNo    
LEFT OUTER JOIN #TEMPD2 C    
ON A.AssetNo=C.AssetNo    
    
    
    
--SELECT * FROM #TEMPDEMERITCALC_IMP    
    
----------------------------------------------------------------FINAL PART OF THE CODE -------------------------------------    
    
    
SELECT AssetNo    
,AssetTypeCode    
,AssetPurchasePrice    
,AssetAge    
,OperatingHours    
,OperatingDaysWeeks    
,TotalAnnualHours    
,CASE WHEN [Month]=@MONTH THEN DownTimeAging ELSE 0 END AS DownTimeAging--NO NEED    
,Uptime_Calc    
,TargetUptime    
,AssetTypeDescription    
,TotalAccumDowtimeHours    
,RunningTotal    
,Uptime    
,DeductionFigurePerAsset    
,DeductionFigurePerAssetLessThenEighty    
,CASE WHEN [Month]=1 THEN Uptime ELSE 0 END AS [Jan]    
,CASE WHEN [Month]=2 THEN Uptime ELSE 0 END AS [Feb]    
,CASE WHEN [Month]=3 THEN Uptime ELSE 0 END AS [Mar]    
,CASE WHEN [Month]=4 THEN Uptime ELSE 0 END AS [Apr]    
    
,CASE WHEN [Month]=5 THEN Uptime ELSE 0 END AS [May]    
,CASE WHEN [Month]=6 THEN Uptime ELSE 0 END AS [Jun]    
,CASE WHEN [Month]=7 THEN Uptime ELSE 0 END AS [Jul]    
,CASE WHEN [Month]=8 THEN Uptime ELSE 0 END AS [Aug]    
    
,CASE WHEN [Month]=9 THEN Uptime ELSE 0 END AS [Sep]    
,CASE WHEN [Month]=10 THEN Uptime ELSE 0 END AS [Oct]    
,CASE WHEN [Month]=11 THEN Uptime ELSE 0 END AS [Nov]    
,CASE WHEN [Month]=12 THEN Uptime ELSE 0 END AS [Dec]    
    
,CASE WHEN [Month]=@MONTH THEN Uptime ELSE 0 END AS CurrentUptime    
    
,Year    
,Month    
INTO #TEMP_REPORT_CALC    
FROM DeductionB3BaseDemerit    
    
----SELECT * FROM #TEMP_REPORT_CALC    
    
INSERT INTO DeductionB3OutPut    
(    
 AssetNo    
,AssetTypeCode    
,AssetPurchasePrice    
,AssetAge    
,OperatingHours    
,OperatingDaysWeeks    
,DownTimeAging    
,TotalAnnualHours    
,TargetUptime    
,AssetTypeDescription    
,TotalAccumDowtimeHours    
,DeductionFigurePerAsset1    
,DeductionFigurePerAsset2    
,CurrentUptime    
,Jan    
,Feb    
,Mar    
,Apr    
,May    
,Jun    
,Jul    
,Aug    
,Sep    
,Oct    
,Nov    
,Dec    
,DeductionForMonth1    
,DeductionForMonth2    
,DemeritPointForMonth1    
,DemeritPointForMonth2    
,TotalProHawkDeduction    
,Year    
,Remarks    
)    
    
    
    
SELECT     
 AssetNo     
,AssetTypeCode     
,AssetPurchasePrice     
,AssetAge     
,OperatingHours     
,OperatingDaysWeeks     
,SUM(DownTimeAging) AS DownTimeAging    
,TotalAnnualHours    
,TargetUptime     
,AssetTypeDescription     
,TotalAccumDowtimeHours    
,DeductionFigurePerAsset AS DeductionFigurePerAsset1    
,DeductionFigurePerAssetLessThenEighty AS DeductionFigurePerAsset2    
,SUM(CurrentUptime) AS CurrentUptime    
,SUM([Jan]) AS [Jan]    
,SUM([Feb]) AS [Feb]    
,SUM([Mar]) AS [Mar]    
    
,SUM([Apr]) AS [Apr]    
,SUM([May]) AS [May]    
,SUM([Jun]) AS [Jun]    
    
    
,SUM([Jul]) AS [Jul]    
,SUM([Aug]) AS [Aug]    
,SUM([Sep]) AS [Sep]    
    
    
,SUM([Oct]) AS [Oct]    
,SUM([Nov]) AS [Nov]    
,SUM([Dec]) AS [Dec]    
    
,0 AS DeductionForMonth1    
,0 AS DeductionForMonth2    
    
,0 AS DemeritPointForMonth1    
,0 AS DemeritPointForMonth2    
    
,0 AS TotalProHawkDeduction    
,@YEAR AS Year    
,'All Ok' AS Remarks    
--INTO DeductionB3OutPut    
FROM #TEMP_REPORT_CALC    
GROUP BY AssetNo     
,AssetTypeCode     
,AssetPurchasePrice     
,AssetAge     
,OperatingHours     
,OperatingDaysWeeks     
,TotalAnnualHours    
,TargetUptime     
,AssetTypeDescription     
,TotalAccumDowtimeHours    
,DeductionFigurePerAsset    
,DeductionFigurePerAssetLessThenEighty    
    
END TRY              
BEGIN CATCH              
              
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)              
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());              
              
THROW              
              
END CATCH              
SET NOCOUNT OFF              
END    
    
    
GO
