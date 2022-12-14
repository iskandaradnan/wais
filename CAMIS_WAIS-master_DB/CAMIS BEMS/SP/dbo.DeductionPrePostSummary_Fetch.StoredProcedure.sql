USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionPrePostSummary_Fetch]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
          
----before running the DeductionPrePostSummaryFetch populate the data with these query DeductionPrePostSummarysp          
          
--EXEC [DeductionPrePostSummary_Fetch] 2020,10,'Edgenta',3          
          
CREATE PROCEDURE [dbo].[DeductionPrePostSummary_Fetch]          
(          
 @YEAR INT                    
,@MONTH INT            
,@FEE VARCHAR(20)     
,@IndicatorID INT NULL  
)          
AS          
          
          
BEGIN          
          
DECLARE @FEE_EDGENTA_PROHAWK NUMERIC(18,2)          
SET @FEE_EDGENTA_PROHAWK=(SELECT MAX(CASE WHEN @FEE='Edgenta' THEN BemsMSF ELSE ProHawkBemsMSF END)  FROM FinMonthlyFeeTxnDet WHERE Year=@YEAR AND Month=@MONTH)          
          
--SELECT * FROM DedGenerationTxnDet      
      
IF OBJECT_ID('tempdb.dbo.#TEMP_NCR', 'U') IS NOT NULL                
DROP TABLE #TEMP_NCR             
            
IF OBJECT_ID('tempdb.dbo.#TEMP_NCR_DEDUCTION', 'U') IS NOT NULL                
DROP TABLE #TEMP_NCR_DEDUCTION             
      
      
SELECT            
 A.[Year]            
,A.[Month]            
,A.IndicatorDetId            
--,CASE WHEN A.IndicatorDetId=6 THEN A.DemeritPoint*50            
--     WHEN A.IndicatorDetId=1 THEN A.DemeritPoint*50            
            
--B1            
,CASE WHEN B.PurchaseCostRM BETWEEN 0 AND 30000 AND A.IndicatorDetId=1THEN 50            
      WHEN B.PurchaseCostRM BETWEEN 30001 AND 50000 AND A.IndicatorDetId=1 THEN 100            
   WHEN B.PurchaseCostRM BETWEEN 50001 AND 1000000000 AND A.IndicatorDetId=1 THEN 200            
            
---B2            
   WHEN B.PurchaseCostRM BETWEEN 0 AND 5000 AND A.IndicatorDetId=2 THEN 10            
   WHEN B.PurchaseCostRM BETWEEN 5001 AND 10000 AND A.IndicatorDetId=2 THEN 20            
   WHEN B.PurchaseCostRM BETWEEN 10001 AND 15000 AND A.IndicatorDetId=2 THEN 30            
   WHEN B.PurchaseCostRM BETWEEN 15001 AND 20000 AND A.IndicatorDetId=2 THEN 40            
   WHEN B.PurchaseCostRM BETWEEN 20001 AND 30000 AND A.IndicatorDetId=2 THEN 50            
   WHEN B.PurchaseCostRM BETWEEN 30001 AND 50000 AND A.IndicatorDetId=2 THEN 75            
   WHEN B.PurchaseCostRM BETWEEN 50001 AND 100000 AND A.IndicatorDetId=2 THEN 100            
   WHEN B.PurchaseCostRM BETWEEN 100001 AND 500000 AND A.IndicatorDetId=2 THEN 200            
   WHEN B.PurchaseCostRM BETWEEN 500001 AND 1000000 AND A.IndicatorDetId=2 THEN 500            
   WHEN B.PurchaseCostRM > 1000000 AND A.IndicatorDetId=2 THEN 1000            
            
-----B3            
  WHEN B.PurchaseCostRM BETWEEN 0.00 AND 20000.00  AND A.IndicatorDetId=3 THEN 300.00              
  WHEN B.PurchaseCostRM BETWEEN 20001.00 AND 50000.00 AND A.IndicatorDetId=3 THEN 500.00              
  WHEN B.PurchaseCostRM BETWEEN 50001.00 AND 100000.00 AND A.IndicatorDetId=3 THEN 1000.00              
  WHEN B.PurchaseCostRM BETWEEN 100001.00 AND 500000.00 AND A.IndicatorDetId=3 THEN 2000.00              
  WHEN B.PurchaseCostRM BETWEEN 500001.00 AND 1000000.00 AND A.IndicatorDetId=3 THEN 4000.00              
  WHEN B.PurchaseCostRM BETWEEN 1000001.00 AND 1000000000.00 AND A.IndicatorDetId=3 THEN 6000.00             
              
  --WHEN B.PurchaseCostRM BETWEEN 0.00 AND 20000.00 AND C.UptimeAchieved<=0.80 THEN 600.00              
  --WHEN B.PurchaseCostRM BETWEEN 20001.00 AND 50000.00 AND C.UptimeAchieved<=0.80 THEN 1000.00              
  --WHEN B.PurchaseCostRM BETWEEN 50001.00 AND 100000.00 AND C.UptimeAchieved<=0.80 THEN 2000.00              
  --WHEN B.PurchaseCostRM BETWEEN 100001.00 AND 500000.00 AND C.UptimeAchieved<=0.80 THEN 4000.00              
  --WHEN B.PurchaseCostRM BETWEEN 500001.00 AND 1000000.00 AND C.UptimeAchieved<=0.80 THEN 8000.00              
  --WHEN B.PurchaseCostRM BETWEEN 1000001.00 AND 1000000000.00 AND C.UptimeAchieved<=0.80 THEN 12000.00            
             
            
----B4            
   WHEN B.PurchaseCostRM BETWEEN 0 AND 5000 AND A.IndicatorDetId=4 THEN 50              
   WHEN B.PurchaseCostRM BETWEEN 5001 AND 10000 AND A.IndicatorDetId=4 THEN 100     
   WHEN B.PurchaseCostRM BETWEEN 10001 AND 15000 AND A.IndicatorDetId=4 THEN 150              
   WHEN B.PurchaseCostRM BETWEEN 15001 AND 20000 AND A.IndicatorDetId=4 THEN 200              
   WHEN B.PurchaseCostRM BETWEEN 20001 AND 30000 AND A.IndicatorDetId=4 THEN 250              
   WHEN B.PurchaseCostRM BETWEEN 30001 AND 50000 AND A.IndicatorDetId=4 THEN 300              
   WHEN B.PurchaseCostRM BETWEEN 50001 AND 100000 AND A.IndicatorDetId=4 THEN 500              
   WHEN B.PurchaseCostRM BETWEEN 100001 AND 500000 AND A.IndicatorDetId=4 THEN 2000              
   WHEN B.PurchaseCostRM BETWEEN 500001 AND 1000000 AND A.IndicatorDetId=4 THEN 5000              
   WHEN B.PurchaseCostRM > 1000000 AND A.IndicatorDetId=4 THEN 7500              
            
---B5            
WHEN A.IndicatorDetId=5 THEN 50            
            
            
END AS DeductionFigurePerAsset            
,A.DemeritPoint            
,A.FinalDemeritPoint            
,A.DisputedDemeritPoints    
,A.DeductionValue 
INTO #TEMP_NCR            
FROM DedNCRValidationTxnDet A            
INNER JOIN EngAsset B            
ON A.AssetNo=B.AssetNo            
WHERE A.Year=@YEAR            
AND A.Month=@MONTH            
            
            
SELECT              
 Year            
,Month            
,IndicatorDetId            
,SUM(DeductionFigurePerAsset)  AS DeductionFigurePerAsset           
--,SUM(DemeritPoint) as PreNCRDemeritPoint             
,ISNULL(SUM(FinalDemeritPoint),0) AS PostNCRDemeritPoint            
--,SUM(DisputedDemeritPoints) AS DisputedDemeritPoints            
--,SUM(DeductionFigurePerAsset)*SUM(DemeritPoint) AS PreNCRDeduction            
--,SUM(DeductionFigurePerAsset)*SUM(FinalDemeritPoint) AS PostNCRDeduction       
--,SUM(DeductionFigurePerAsset) AS PostNCRDeduction   aida amend1702   
,ISNULL(SUM(CASE WHEN FinalDemeritPoint = 1 THEN DeductionValue END),0) AS PostNCRDeduction     
INTO #TEMP_NCR_DEDUCTION            
FROM #TEMP_NCR       
GROUP BY Year            
,Month            
,IndicatorDetId            
      
      
      
      
;WITH CTE AS       
(      
SELECT ISNULL(SUM(FinalDemeritPoint),0) AS PostDeneritPoint      
,ISNULL(SUM(DeductionValue),0) AS PostDeductionValue      
,B.IndicatorDetId      
,B.IndicatorNo      
,Year      
,Month       
FROM DedTransactionMappingTxnDet A      
INNER JOIN MstDedIndicatorDet B      
ON A.IndicatorDetId=B.IndicatorDetId      
WHERE IsValid=1      
GROUP BY  B.IndicatorDetId      
         ,B.IndicatorNo      
         ,Year      
         ,Month       
)      
      
UPDATE A       
SET A.PostDeductionValue =ISNULL(B.PostDeductionValue,0)      
   ,A.PostNCRDeductionValue=ISNULL(C.PostNCRDeduction,0)      
   ,A.PostTotalDeductionValue=ISNULL(B.PostDeductionValue,0)+ISNULL(C.PostNCRDeduction,0)      
      
   ,A.PostTransactionDemeritPoint=ISNULL(B.PostDeneritPoint,0)      
   ,A.PostNcrDemeritPoint=ISNULL(C.PostNCRDemeritPoint,0)      
   ,A.PostTotalDemeritsPoints=ISNULL(B.PostDeneritPoint,0)+ISNULL(C.PostNCRDemeritPoint,0)          
FROM DeductionPrePostSummary   A      
INNER JOIN CTE B      
ON A.Year=B.Year      
AND A.Month=B.Month      
AND A.IndicatorDetId=B.IndicatorDetId      
INNER JOIN #TEMP_NCR_DEDUCTION  C      
ON A.Year=C.Year      
AND A.Month=C.Month      
AND A.IndicatorDetId=C.IndicatorDetId      
      
WHERE A.Year=@YEAR      
AND A.Month=@MONTH      
      
      
UPDATE A       
SET A.PostDeductionValue =ISNULL(B.PostDeductionValue,0)      
   ,A.PostNCRDeductionValue=ISNULL(C.PostNCRDeduction,0)      
         
      
   ,A.PostTransactionDemeritPoint=ISNULL(B.PostTransactionDemeritPoint,0)      
   ,A.PostNcrDemeritPoint=ISNULL(C.PostNCRDemeritPoint,0)      
         
FROM DedGenerationTxnDet  A      
INNER JOIN DeductionPrePostSummary B      
ON A.Year=B.Year      
AND A.Month=B.Month      
AND A.IndicatorDetId=B.IndicatorDetId      
INNER JOIN #TEMP_NCR_DEDUCTION  C      
ON A.Year=C.Year      
AND A.Month=C.Month      
AND A.IndicatorDetId=C.IndicatorDetId      
WHERE A.Year=@YEAR      
AND A.MONTH=@MONTH      
      
      
IF(@IndicatorID IN (3,4,5))  
BEGIN  
          
SELECT           
ServiceType          
,Year          
,Month          
,MonthlyServiceFee          
,IndicatorNo          
,IndicatorName          
,TransactionDemeritPoint          
,NcrDemeritPoint          
,PreTotalDemeritsPoints          
,PostTransactionDemeritPoint          
,PostNcrDemeritPoint          
,PostTotalDemeritsPoints          
,DeductionValue          
,NCRDeductionValue          
,PreTotalDeductionValue          
,PostDeductionValue          
,PostNCRDeductionValue          
,PostTotalDeductionValue          
--,[PreDeduction_%]          
--,[PostDeduction_%]           
          
,CONCAT(CAST((ISNULL(PreTotalDeductionValue,0)/@FEE_EDGENTA_PROHAWK)*100 AS NUMERIC(18,2)),'') AS [PreDeduction_%]             
,CONCAT(CAST((ISNULL(PostTotalDeductionValue,0)/@FEE_EDGENTA_PROHAWK)*100 AS NUMERIC(18,2)),'') AS [PostDeduction_%]             
      
          
FROM DeductionPrePostSummary          
WHERE Year=@YEAR          
AND MONTH=@MONTH          
AND IndicatorDetId=@IndicatorID  
  
END  
IF(@IndicatorID IN (1,2))  
BEGIN  
SELECT           
ServiceType          
,Year          
,Month          
,MonthlyServiceFee          
,IndicatorNo          
,IndicatorName          
,TransactionDemeritPoint          
,NcrDemeritPoint          
,PreTotalDemeritsPoints          
,PostTransactionDemeritPoint          
,PostNcrDemeritPoint          
,PostTotalDemeritsPoints          
,DeductionValue          
,NCRDeductionValue          
,PreTotalDeductionValue          
,PostDeductionValue          
,PostNCRDeductionValue          
,PostTotalDeductionValue          
--,[PreDeduction_%]          
--,[PostDeduction_%]           
          
,CONCAT(CAST((ISNULL(PreTotalDeductionValue,0)/@FEE_EDGENTA_PROHAWK)*100 AS NUMERIC(18,2)),'') AS [PreDeduction_%]             
,CONCAT(CAST((ISNULL(PostTotalDeductionValue,0)/@FEE_EDGENTA_PROHAWK)*100 AS NUMERIC(18,2)),'') AS [PostDeduction_%]             
      
          
FROM DeductionPrePostSummary          
WHERE Year=@YEAR          
AND MONTH=@MONTH          
AND IndicatorDetId IN (1,2)  
  
END  
  
ELSE  
  
SELECT           
ServiceType          
,Year          
,Month          
,MonthlyServiceFee          
,IndicatorNo          
,IndicatorName          
,TransactionDemeritPoint          
,NcrDemeritPoint          
,PreTotalDemeritsPoints          
,PostTransactionDemeritPoint          
,PostNcrDemeritPoint          
,PostTotalDemeritsPoints          
,DeductionValue          
,NCRDeductionValue          
,PreTotalDeductionValue          
,PostDeductionValue          
,PostNCRDeductionValue          
,PostTotalDeductionValue          
--,[PreDeduction_%]          
--,[PostDeduction_%]           
          
,CONCAT(CAST((ISNULL(PreTotalDeductionValue,0)/@FEE_EDGENTA_PROHAWK)*100 AS NUMERIC(18,2)),'') AS [PreDeduction_%]             
,CONCAT(CAST((ISNULL(PostTotalDeductionValue,0)/@FEE_EDGENTA_PROHAWK)*100 AS NUMERIC(18,2)),'') AS [PostDeduction_%]             
      
          
FROM DeductionPrePostSummary          
WHERE Year=@YEAR          
AND MONTH=@MONTH          
AND @IndicatorID=0  
  
END        
      
      
      
      
GO
