USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionPrePostSummary_Base17022021]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
          
--EXEC [DeductionPrePostSummary_Base] 2020,9          
          
CREATE PROCEDURE [dbo].[DeductionPrePostSummary_Base17022021]          
(          
@YEAR INT                    
,@MONTH INT                    
--,@FEE VARCHAR(20)        
)          
AS          
          
          
BEGIN          
--DECLARE @YEAR INT                    
--DECLARE @MONTH INT                    
          
--SET  @YEAR =2020                   
--SET  @MONTH =5                   
          
          
IF OBJECT_ID('tempdb.dbo.#TEMP_NCR', 'U') IS NOT NULL              
DROP TABLE #TEMP_NCR           
          
IF OBJECT_ID('tempdb.dbo.#TEMP_NCR_DEDUCTION', 'U') IS NOT NULL              
DROP TABLE #TEMP_NCR_DEDUCTION           
          
DELETE FROM DeductionPrePostSummary WHERE Year=@YEAR AND Month=@MONTH        
        
--DECLARE @FEE_EDGENTA_PROHAWK NUMERIC(18,2)        
--SET @FEE_EDGENTA_PROHAWK=(SELECT MAX(CASE WHEN @FEE='Edgenta' THEN BemsMSF ELSE ProHawkBemsMSF END)  FROM FinMonthlyFeeTxnDet WHERE Year=@YEAR AND Month=@MONTH)        
        
          
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
--WHEN A.IndicatorDetId=5 THEN 50          
          
          
END AS DeductionFigurePerAsset          
,A.DemeritPoint          
,A.FinalDemeritPoint          
,A.DisputedDemeritPoints          
INTO #TEMP_NCR          
FROM DedNCRValidationTxnDet A          
LEFT OUTER JOIN EngAsset B          
ON A.AssetId=B.AssetId  
WHERE A.Year=@YEAR          
AND A.Month=@MONTH          
AND A.IndicatorDetId <> 5  
          
          
SELECT            
 Year          
,Month          
,IndicatorDetId          
,SUM(DeductionFigurePerAsset)  AS DeductionFigurePerAsset         
,SUM(DemeritPoint) as PreNCRDemeritPoint           
,SUM(FinalDemeritPoint) AS PostNCRDemeritPoint          
,SUM(DisputedDemeritPoints) AS DisputedDemeritPoints          
,SUM(DeductionFigurePerAsset) AS PreNCRDeduction          
,SUM(DeductionFigurePerAsset) AS PostNCRDeduction          
INTO #TEMP_NCR_DEDUCTION          
FROM #TEMP_NCR     
GROUP BY Year          
,Month          
,IndicatorDetId          
          
          
          
--SELECT *           
UPDATE B          
SET B.NcrDemeritPoint=A.PreNCRDemeritPoint          
,B.NCRDeductionValue=A.PreNCRDeduction          
,B.PostNcrDemeritPoint=A.PreNCRDemeritPoint          
,B.PostNCRDeductionValue=A.PreNCRDeduction         
    
--,B.PostNcrDemeritPoint=A.PostNCRDemeritPoint          
--,B.PostNCRDeductionValue=A.PostNCRDeduction          
FROM #TEMP_NCR_DEDUCTION A          
INNER JOIN DedGenerationTxnDet B          
ON A.IndicatorDetId=B.IndicatorDetId          
AND A.Year=B.Year          
AND A.Month=B.Month          
WHERE B.IndicatorDetId <> 5          
  
  
---CHNAGES DONE AS PER AINNA ON 12-12-2020  
  
UPDATE B          
SET B.NcrDemeritPoint=A.DemeritPoint  
,B.NCRDeductionValue=A.DeductionValue          
,B.PostNcrDemeritPoint=A.DemeritPoint  
,B.PostNCRDeductionValue=A.DeductionValue         
    
--,B.PostNcrDemeritPoint=A.PostNCRDemeritPoint          
--,B.PostNCRDeductionValue=A.PostNCRDeduction          
FROM DedNCRValidationTxnDet A          
INNER JOIN DedGenerationTxnDet B          
ON A.IndicatorDetId=B.IndicatorDetId          
AND A.Year=B.Year          
AND A.Month=B.Month          
WHERE B.IndicatorDetId = 5  
          
          
-------B1,B2,B3,B4,B5          
          
INSERT INTO DeductionPrePostSummary           
(          
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
,IndicatorDetId    
--,[PreDeduction_%]          
--,[PostDeduction_%]          
        
)          
          
SELECT                     
'BEMS' AS ServiceType                    
,A.[Year]                    
,A.[Month]                    
,MonthlyServiceFee                    
,C.IndicatorNo                    
,C.IndicatorName                    
--DEMERITS POINT          
,ISNULL(A.TransactionDemeritPoint,0)  AS TransactionDemeritPoint                  
,ISNULL(A.NcrDemeritPoint,0) AS NcrDemeritPoint                     
,ISNULL(A.TransactionDemeritPoint,0)+ISNULL(A.NcrDemeritPoint,0) AS PreTotalDemeritsPoints                    
          
,ISNULL(A.PostTransactionDemeritPoint,0)  AS PostTransactionDemeritPoint                  
,ISNULL(A.PostNcrDemeritPoint,0)  AS PostNcrDemeritPoint                  
,ISNULL(A.PostTransactionDemeritPoint,0)+ISNULL(A.PostNcrDemeritPoint,0) AS PostTotalDemeritsPoints            
          
--DEDUCTION          
,ISNULL(A.DeductionValue,0) AS DeductionValue                    
,ISNULL(A.NCRDeductionValue,0) AS NCRDeductionValue          
,(ISNULL(A.DeductionValue,0) + ISNULL(A.NCRDeductionValue,0)) AS PreTotalDeductionValue          
          
,ISNULL(A.PostDeductionValue,0) AS  PostDeductionValue                   
,ISNULL(A.PostNCRDeductionValue,0) AS  PostNCRDeductionValue         
,(ISNULL(A.PostDeductionValue,0) + ISNULL(A.PostNCRDeductionValue,0)) AS PostTotalDeductionValue          
          
--,CONCAT(CAST((ISNULL(A.DeductionValue,0)/@FEE_EDGENTA_PROHAWK)*100 AS NUMERIC(18,2)),'') AS [PreDeduction_%]           
--,CONCAT(CAST((ISNULL(A.PostDeductionValue,0)/@FEE_EDGENTA_PROHAWK)*100 AS NUMERIC(18,2)),'') AS [PostDeduction_%]           
,1 AS IndicatorDetId        
FROM DedGenerationTxnDet A                    
INNER JOIN DedGenerationTxn B                    
ON A.DedGenerationId=B.DedGenerationId                    
INNER JOIN MstDedIndicatorDet C                    
ON A.IndicatorDetId=C.IndicatorDetId                    
WHERE A.Year=@YEAR                    
AND A.Month=@MONTH                    
AND A.IndicatorDetId IN (1)          
    
UNION ALL    
    
SELECT                     
'BEMS' AS ServiceType                    
,A.[Year]                    
,A.[Month]                    
,MonthlyServiceFee                    
,C.IndicatorNo                    
,C.IndicatorName                    
--DEMERITS POINT          
,ISNULL(A.TransactionDemeritPoint,0)  AS TransactionDemeritPoint                  
,ISNULL(A.NcrDemeritPoint,0) AS NcrDemeritPoint                     
,ISNULL(A.TransactionDemeritPoint,0)+ISNULL(A.NcrDemeritPoint,0) AS PreTotalDemeritsPoints                    
          
,ISNULL(A.PostTransactionDemeritPoint,0)  AS PostTransactionDemeritPoint                  
,ISNULL(A.PostNcrDemeritPoint,0)  AS PostNcrDemeritPoint                  
,ISNULL(A.PostTransactionDemeritPoint,0)+ISNULL(A.PostNcrDemeritPoint,0) AS PostTotalDemeritsPoints            
          
--DEDUCTION          
,ISNULL(A.DeductionValue,0) AS DeductionValue                    
,ISNULL(A.NCRDeductionValue,0) AS NCRDeductionValue          
,(ISNULL(A.DeductionValue,0) + ISNULL(A.NCRDeductionValue,0)) AS PreTotalDeductionValue          
          
,ISNULL(A.PostDeductionValue,0) AS  PostDeductionValue                   
,ISNULL(A.PostNCRDeductionValue,0) AS  PostNCRDeductionValue         
,(ISNULL(A.PostDeductionValue,0) + ISNULL(A.PostNCRDeductionValue,0)) AS PostTotalDeductionValue          
          
--,CONCAT(CAST((ISNULL(A.DeductionValue,0)/@FEE_EDGENTA_PROHAWK)*100 AS NUMERIC(18,2)),'') AS [PreDeduction_%]           
--,CONCAT(CAST((ISNULL(A.PostDeductionValue,0)/@FEE_EDGENTA_PROHAWK)*100 AS NUMERIC(18,2)),'') AS [PostDeduction_%]           
,2 AS IndicatorDetId        
FROM DedGenerationTxnDet A                    
INNER JOIN DedGenerationTxn B                    
ON A.DedGenerationId=B.DedGenerationId                    
INNER JOIN MstDedIndicatorDet C                    
ON A.IndicatorDetId=C.IndicatorDetId                    
WHERE A.Year=@YEAR                    
AND A.Month=@MONTH                    
AND A.IndicatorDetId IN (2)     
    
              
UNION ALL              
            
SELECT        
'BEMS' AS ServiceType                    
,A.[Year]                    
,A.[Month]                    
,MonthlyServiceFee        
,C.IndicatorNo                    
,C.IndicatorName                    
--DEMERITS POINT          
,ISNULL(A.TransactionDemeritPoint,0)  AS TransactionDemeritPoint                  
,ISNULL(A.NcrDemeritPoint,0) AS NcrDemeritPoint                     
,ISNULL(A.TransactionDemeritPoint,0)+ISNULL(A.NcrDemeritPoint,0) AS PreTotalDemeritsPoints                    
          
,ISNULL(A.PostTransactionDemeritPoint,0)  AS PostTransactionDemeritPoint                  
,ISNULL(A.PostNcrDemeritPoint,0)  AS PostNcrDemeritPoint                  
,ISNULL(A.PostTransactionDemeritPoint,0)+ISNULL(A.PostNcrDemeritPoint,0) AS PostTotalDemeritsPoints            
          
--DEDUCTION          
,ISNULL(A.DeductionValue,0) AS DeductionValue                    
,ISNULL(A.NCRDeductionValue,0) AS NCRDeductionValue          
,(ISNULL(A.DeductionValue,0) + ISNULL(A.NCRDeductionValue,0)) AS PreTotalDeductionValue          
          
,ISNULL(A.PostDeductionValue,0) AS  PostDeductionValue                   
,ISNULL(A.PostNCRDeductionValue,0) AS  PostNCRDeductionValue         
,(ISNULL(A.PostDeductionValue,0) + ISNULL(A.PostNCRDeductionValue,0)) AS PostTotalDeductionValue          
          
--,CONCAT(CAST((ISNULL(A.DeductionValue,0)/@FEE_EDGENTA_PROHAWK)*100 AS NUMERIC(18,2)),'') AS [PreDeduction_%]           
--,CONCAT(CAST((ISNULL(A.PostDeductionValue,0)/@FEE_EDGENTA_PROHAWK)*100 AS NUMERIC(18,2)),'') AS [PostDeduction_%]           
    
,3 AS IndicatorDetId            
FROM DedGenerationTxnDet A                    
INNER JOIN DedGenerationTxn B                    
ON A.DedGenerationId=B.DedGenerationId                    
INNER JOIN MstDedIndicatorDet C                    
ON A.IndicatorDetId=C.IndicatorDetId                    
WHERE A.Year=@YEAR                    
AND A.Month=@MONTH                    
AND A.IndicatorDetId IN (3)                
            
            
            
            
UNION ALL              
              
SELECT                       
'BEMS' AS ServiceType                    
,A.[Year]                    
,A.[Month]                    
,MonthlyServiceFee                    
,C.IndicatorNo                    
,C.IndicatorName                    
--DEMERITS POINT          
,ISNULL(A.TransactionDemeritPoint,0)  AS TransactionDemeritPoint                  
,ISNULL(A.NcrDemeritPoint,0) AS NcrDemeritPoint                     
,ISNULL(A.TransactionDemeritPoint,0)+ISNULL(A.NcrDemeritPoint,0) AS PreTotalDemeritsPoints                    
          
,ISNULL(A.PostTransactionDemeritPoint,0)  AS PostTransactionDemeritPoint                  
,ISNULL(A.PostNcrDemeritPoint,0)  AS PostNcrDemeritPoint                  
,ISNULL(A.PostTransactionDemeritPoint,0)+ISNULL(A.PostNcrDemeritPoint,0) AS PostTotalDemeritsPoints            
          
--DEDUCTION          
,ISNULL(A.DeductionValue,0) AS DeductionValue                    
,ISNULL(A.NCRDeductionValue,0) AS NCRDeductionValue          
,(ISNULL(A.DeductionValue,0) + ISNULL(A.NCRDeductionValue,0)) AS PreTotalDeductionValue          
          
,ISNULL(A.PostDeductionValue,0) AS  PostDeductionValue                   
,ISNULL(A.PostNCRDeductionValue,0) AS  PostNCRDeductionValue         
,(ISNULL(A.PostDeductionValue,0) + ISNULL(A.PostNCRDeductionValue,0)) AS PostTotalDeductionValue          
          
--,CONCAT(CAST((ISNULL(A.DeductionValue,0)/@FEE_EDGENTA_PROHAWK)*100 AS NUMERIC(18,2)),'') AS [PreDeduction_%]           
--,CONCAT(CAST((ISNULL(A.PostDeductionValue,0)/@FEE_EDGENTA_PROHAWK)*100 AS NUMERIC(18,2)),'') AS [PostDeduction_%]           
        
,4 AS IndicatorDetId            
FROM DedGenerationTxnDet A                      
INNER JOIN DedGenerationTxn B                      
ON A.DedGenerationId=B.DedGenerationId                      
INNER JOIN MstDedIndicatorDet C                      
ON A.IndicatorDetId=C.IndicatorDetId                      
WHERE A.Year=@YEAR                      
AND A.Month=@MONTH                      
AND A.IndicatorDetId IN (4)                  
              
UNION ALL            
            
SELECT                       
'BEMS' AS ServiceType                    
,A.[Year]                    
,A.[Month]                    
,MonthlyServiceFee                    
,C.IndicatorNo                    
,C.IndicatorName                    
--DEMERITS POINT          
,ISNULL(A.TransactionDemeritPoint,0)  AS TransactionDemeritPoint                  
,ISNULL(A.NcrDemeritPoint,0) AS NcrDemeritPoint                     
,ISNULL(A.TransactionDemeritPoint,0)+ISNULL(A.NcrDemeritPoint,0) AS PreTotalDemeritsPoints                    
          
,ISNULL(A.PostTransactionDemeritPoint,0)  AS PostTransactionDemeritPoint                  
,ISNULL(A.PostNcrDemeritPoint,0)  AS PostNcrDemeritPoint                  
,ISNULL(A.PostTransactionDemeritPoint,0)+ISNULL(A.PostNcrDemeritPoint,0) AS PostTotalDemeritsPoints            
          
--DEDUCTION          
,ISNULL(A.DeductionValue,0) AS DeductionValue                    
,ISNULL(A.NCRDeductionValue,0) AS NCRDeductionValue          
,(ISNULL(A.DeductionValue,0) + ISNULL(A.NCRDeductionValue,0)) AS PreTotalDeductionValue          
          
,ISNULL(A.PostDeductionValue,0) AS  PostDeductionValue                   
,ISNULL(A.PostNCRDeductionValue,0) AS  PostNCRDeductionValue         
,(ISNULL(A.PostDeductionValue,0) + ISNULL(A.PostNCRDeductionValue,0)) AS PostTotalDeductionValue          
          
--,CONCAT(CAST((ISNULL(A.DeductionValue,0)/@FEE_EDGENTA_PROHAWK)*100 AS NUMERIC(18,2)),'') AS [PreDeduction_%]           
--,CONCAT(CAST((ISNULL(A.PostDeductionValue,0)/@FEE_EDGENTA_PROHAWK)*100 AS NUMERIC(18,2)),'') AS [PostDeduction_%]           
        
,5 AS IndicatorDetId         
FROM DedGenerationTxnDet A                      
INNER JOIN DedGenerationTxn B                      
ON A.DedGenerationId=B.DedGenerationId                      
INNER JOIN MstDedIndicatorDet C                      
ON A.IndicatorDetId=C.IndicatorDetId                      
WHERE A.Year=@YEAR                      
AND A.Month=@MONTH                      
AND A.IndicatorDetId IN (5)                  
        
          
END          
          
          
    
    
    
    
GO
