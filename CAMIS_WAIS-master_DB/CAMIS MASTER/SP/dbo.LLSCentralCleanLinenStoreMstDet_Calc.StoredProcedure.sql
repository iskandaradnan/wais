USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCentralCleanLinenStoreMstDet_Calc]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--USE [uetrackMasterdbPreProd]
--GO
--/****** Object:  StoredProcedure [dbo].[LLSCentralCleanLinenStoreMstDet_Calc]    Script Date: 9/7/2020 12:31:41 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--SELECT * FROM LLSCentralCleanLinenStoreMstDet  
  
---3713+(11739-11669)  
--11742 REQ  
--11669--ISSEED  
---3713+11739=15452 --RIGHT--CURR STORE  
--PREV STORE BAL ===15452+11742  
  
--/*=====================================================================================================================        
--APPLICATION  : UETrack        
--NAME    : LLSCentralCleanLinenStoreMstDet_Calc        
--DESCRIPTION  : CALCULATE STORE BALANCE        
--AUTHORS   : SIDDHANT        
--DATE    : 09-JUN-2020        
-------------------------------------------------------------------------------------------------------------------------        
--VERSION HISTORY         
--------------------:---------------:---------------------------------------------------------------------------------------        
--Init    : Date          : Details        
--------------------:---------------:---------------------------------------------------------------------------------------        
--BIJU NB           : 09-JUN-2020 :         
-------:------------:----------------------------------------------------------------------------------------------------*/        
  
--EXEC LLSCentralCleanLinenStoreMstDet_Calc  
  
CREATE PROCEDURE [dbo].[LLSCentralCleanLinenStoreMstDet_Calc]  
AS  
  
BEGIN        
SET NOCOUNT ON        
SET TRANSACTION ISOLATION LEVEL READ COMMITTED        
BEGIN TRY        
  
  
  
IF OBJECT_ID('tempdb.dbo.#TEMP', 'U') IS NOT NULL    
DROP TABLE #TEMP;    
  
IF OBJECT_ID('tempdb.dbo.#TEMPCALC', 'U') IS NOT NULL    
DROP TABLE #TEMPCALC;    
  
  
IF OBJECT_ID('tempdb.dbo.#TEMPLINEN', 'U') IS NOT NULL    
DROP TABLE #TEMPLINEN  
  
IF OBJECT_ID('tempdb.dbo.#TEMPPAR', 'U') IS NOT NULL    
DROP TABLE #TEMPPAR  
  
IF OBJECT_ID('tempdb.dbo.#TEMPMAXID', 'U') IS NOT NULL    
DROP TABLE #TEMPMAXID  
  
  
  
  
;    
  
---FOR TEST PURPOSE  
  
--CAN USE OPENNING BAL  
  
---ONCE THE DATA INSERTED IN CCLS CHNAGE IT TO STORE BALANCA  
  
  
UPDATE A  
SET A.PrevStoreBalance = A.StoreBalance--CHANGE  
FROM LLSCentralCleanLinenStoreMstDet A  
  
  
SELECT A.LinenItemId  
      ,A.LinenDescription  
   ,A.LinenCode   
   ,SUM(ISNULL(F.Par1,0)) AS Par1  
   ,SUM(ISNULL(F.Par2,0)) AS Par2  
      ,COUNT(F.LinenItemId) AS [Count]  
   ,SUM(ISNULL(F.Par1,0))/(CASE WHEN COUNT(F.LinenItemId)=0 THEN 1 ELSE COUNT(F.LinenItemId) END)  AS Avg_Par1  
   ,SUM(ISNULL(F.Par2,0))/(CASE WHEN COUNT(F.LinenItemId)=0 THEN 1 ELSE COUNT(F.LinenItemId) END) AS Avg_Par2  
INTO #TEMPPAR  
FROM LLSLinenItemDetailsMst A  
LEFT  OUTER JOIN LLSUserAreaDetailsLinenItemMstDet F  
ON A.LinenItemId=F.LinenItemId  
GROUP BY  A.LinenItemId  
   ,A.LinenDescription  
   ,A.LinenCode   
  
  
  
  
  
  
;WITH CTE AS   
(  
SELECT A.LinenItemId  
      ,A.LinenDescription  
   ,A.LinenCode   
   ,SUM(ISNULL(B.ReceivedQuantity,0)) AS ReceivedDispatch  
   ,0 AS TotalRejectedQuantity  
   ,0 AS QuantityInjected  
   ,0 AS TotalIssuedQuantity  
   ,0 AS ReplacedQuantity  
   ,0 AS TotalCondemnation  
   ,0 AS Par1  
   ,0 AS Par2  
  
FROM LLSLinenItemDetailsMst A  
LEFT OUTER JOIN LLSCleanLinenDespatchTxnDet B  
ON A.LinenItemId=B.LinenItemId    
WHERE ISNULL(B.IsDeleted,'')=''
GROUP BY A.LinenItemId  
      ,A.LinenDescription  
   ,A.LinenCode   
  
UNION ALL  
  
  
  
SELECT A.LinenItemId  
      ,A.LinenDescription  
   ,A.LinenCode   
   ,0 AS ReceivedDispatch  
   ,SUM(ISNULL(C.TotalRejectedQuantity,0)) AS TotalRejectedQuantity  
   ,0 AS QuantityInjected  
   ,0 AS TotalIssuedQuantity  
   ,0 AS ReplacedQuantity  
   ,0 AS TotalCondemnation  
   ,0 AS Par1  
   ,0 AS Par2  
      
FROM LLSLinenItemDetailsMst A  
  
LEFT OUTER JOIN LLSLinenRejectReplacementTxnDet C  
ON A.LinenItemId=C.LinenItemId   
WHERE ISNULL(C.IsDeleted,'')=''
GROUP BY  A.LinenItemId  
   ,A.LinenDescription  
   ,A.LinenCode   
  
UNION ALL  
  
  
SELECT A.LinenItemId  
      ,A.LinenDescription  
   ,A.LinenCode   
   ,0 AS ReceivedDispatch  
   ,0 AS TotalRejectedQuantity  
   ,SUM(ISNULL(E.QuantityInjected,0)) AS QuantityInjected  
   ,0 AS TotalIssuedQuantity  
   ,0 AS ReplacedQuantity  
   ,0 AS TotalCondemnation  
   ,0 AS Par1  
   ,0 AS Par2  
      
FROM LLSLinenItemDetailsMst A  
LEFT OUTER JOIN LLSLinenInjectionTxnDet E  
ON A.LinenitemId=E.LinenitemId    
WHERE ISNULL(E.IsDeleted,'')=''
GROUP BY  A.LinenItemId  
   ,A.LinenDescription  
   ,A.LinenCode   
  
  
UNION ALL  
  
  
SELECT A.LinenItemId  
      ,A.LinenDescription  
   ,A.LinenCode   
   ,0 AS ReceivedDispatch  
   ,0 AS TotalRejectedQuantity  
   ,0 AS QuantityInjected  
   ,(SUM(ISNULL(DeliveryIssuedQty1st,0))+SUM(ISNULL(DeliveryIssuedQty2nd,0))) AS TotalIssuedQuantity  
   ,0 AS ReplacedQuantity  
   ,0 AS TotalCondemnation  
   ,0 AS Par1  
   ,0 AS Par2  
      
FROM LLSLinenItemDetailsMst A  
LEFT OUTER JOIN LLSCleanLinenIssueLinenItemTxnDet D  
ON A.LinenitemId=D.LinenitemId    
WHERE ISNULL(D.IsDeleted,'')=''
GROUP BY  A.LinenItemId  
   ,A.LinenDescription  
   ,A.LinenCode   
  
  
UNION ALL  
  
  
SELECT A.LinenItemId  
      ,A.LinenDescription  
   ,A.LinenCode   
   ,0 AS ReceivedDispatch  
   ,0 AS TotalRejectedQuantity  
   ,0 AS QuantityInjected  
   ,0 AS TotalIssuedQuantity  
   ,SUM(ISNULL(C.ReplacedQuantity,0)) AS ReplacedQuantity  
   ,0 AS TotalCondemnation  
   ,0 AS Par1  
   ,0 AS Par2  
      
FROM LLSLinenItemDetailsMst A  
LEFT OUTER JOIN LLSLinenRejectReplacementTxnDet C  
ON A.LinenItemId=C.LinenItemId   
WHERE ISNULL(C.IsDeleted,'')=''
GROUP BY  A.LinenItemId  
   ,A.LinenDescription  
   ,A.LinenCode   
  
  
UNION ALL  
  
  
SELECT A.LinenItemId  
      ,A.LinenDescription  
   ,A.LinenCode   
   ,0 AS ReceivedDispatch  
   ,0 AS TotalRejectedQuantity  
   ,0 AS QuantityInjected  
   ,0 AS TotalIssuedQuantity  
   ,0 AS ReplacedQuantity  
   ,SUM(ISNULL(F.Total,0)) AS TotalCondemnation  
   ,0 AS Par1  
   ,0 AS Par2  
  
      
FROM LLSLinenItemDetailsMst A  
LEFT  OUTER JOIN LLSLinenCondemnationTxnDet F  
ON A.LinenItemId=F.LinenItemId  
WHERE ISNULL(F.IsDeleted,'')=''
GROUP BY  A.LinenItemId  
   ,A.LinenDescription  
   ,A.LinenCode   
  
  
UNION ALL  
  
SELECT A.LinenItemId  
      ,A.LinenDescription  
   ,A.LinenCode   
   ,0 AS ReceivedDispatch  
   ,0 AS TotalRejectedQuantity  
   ,0 AS QuantityInjected  
   ,0 AS TotalIssuedQuantity  
   ,0 AS ReplacedQuantity  
   ,0 AS TotalCondemnation  
   ,CAST(Avg_Par1 AS NUMERIC(18,2)) AS Par1  
   ,CAST(Avg_Par2 AS NUMERIC(18,2)) AS Par2  
  
FROM #TEMPPAR A     
--FROM LLSLinenItemDetailsMst A  
--LEFT  OUTER JOIN LLSUserAreaDetailsLinenItemMstDet F  
--ON A.LinenItemId=F.LinenItemId  
--GROUP BY  A.LinenItemId  
--   ,A.LinenDescription  
--   ,A.LinenCode   
  
  
  
)  
  
,CTE_STORE_CALC AS  
(  
SELECT LinenItemId  
       ,LinenDescription  
       ,LinenCode  
       ,SUM(ReceivedDispatch) AS ReceivedDispatch  
       ,SUM(TotalRejectedQuantity) AS TotalRejectedQuantity  
       ,SUM(QuantityInjected) AS QuantityInjected  
       ,SUM(TotalIssuedQuantity) AS TotalIssuedQuantity  
       ,SUM(ReplacedQuantity) AS ReplacedQuantity  
       ,SUM(TotalCondemnation) AS TotalCondemnation  
    ,SUM(Par1) AS Par1  
    ,SUM(Par2) AS Par2  
FROM CTE   
GROUP BY LinenItemId  
       ,LinenDescription  
       ,LinenCode  
)  
  
--SELECT * FROM CTE_STORE_CALC  
  
SELECT LinenItemId  
       ,LinenDescription  
       ,LinenCode   
    ,Par2*4 AS StockLevel  
    ,Par2 AS Par2  
    ,Par1 AS Par1  
    ,ReceivedDispatch  
    ,TotalRejectedQuantity  
    ,QuantityInjected  
    ,TotalIssuedQuantity  
    ,ReplacedQuantity  
    ,TotalCondemnation  
    ,ReceivedDispatch+TotalRejectedQuantity+QuantityInjected AS Total1  
    ,TotalIssuedQuantity+ReplacedQuantity+TotalCondemnation AS Total2  
    ,(ReceivedDispatch+TotalRejectedQuantity+QuantityInjected)-(TotalIssuedQuantity+ReplacedQuantity+TotalCondemnation)   
     AS StoreCal  
    ,(ReceivedDispatch+TotalRejectedQuantity+QuantityInjected)-(TotalIssuedQuantity+ReplacedQuantity+TotalCondemnation) AS ReorderQuantity  
INTO #TEMP  
FROM CTE_STORE_CALC  
--SELECT * FROM #TEMP  
--WHERE LinenCode='BL01'  
  
--***************** UPDATE CurrStoreCal AND PrevStoreCal  
  
--SELECT A.StoreCal,B.OpeningBalance,A.LinenCode,A.LinenDescription,A.LinenItemId   
UPDATE B  
SET  B.PrevCurrStoreCal=B.CurrStoreCal  
    ,B.CurrStoreCal=A.StoreCal  
FROM #TEMP A  
LEFT OUTER JOIN LLSCentralCleanLinenStoreMstDet B  
ON A.LinenItemId=B.LinenItemId  
  
  
  
SELECT  A.LinenItemId  
       ,A.LinenDescription  
,A.LinenCode   
    ,A.StockLevel  
    ,A.Par2  
    ,A.Par1  
    ,ISNULL(B.PrevStoreBalance,0) AS PrevStoreBalance  
    ,ISNULL(B.CurrStoreCal,0) AS CurrStoreCal  
    ,ISNULL(B.PrevCurrStoreCal,0) AS PrevCurrStoreCal  
     
   -----PUT PrevStoreBalance FOR THE FISRT TIME  
    ---CHANGE INTO STORE BALANACE  
  
    ,CASE WHEN PrevCurrStoreCal=0.00 THEN ISNULL(((B.CurrStoreCal)+B.PrevStoreBalance),0)  
          WHEN CurrStoreCal=PrevCurrStoreCal THEN B.PrevStoreBalance   
             ELSE ISNULL(((B.CurrStoreCal-B.PrevCurrStoreCal)+B.PrevStoreBalance),0) END AS StoreBalance  
    --ELSE ISNULL(((B.CurrStoreCal)+B.PrevStoreBalance),0) END AS StoreBalance   
   --,B.StockLevel-A.ReorderQuantity AS ReorderQuantity  
INTO #TEMPCALC  
FROM #TEMP A  
LEFT OUTER JOIN LLSCentralCleanLinenStoreMstDet B  
ON A.LinenItemId=B.LinenItemId  
  
--SELECT * FROM #TEMPCALC  
  
-------****************** CHECK FOR LINEN ADJUSTMENT ************************--------------------------------  
  
SELECT MAX(LinenAdjustmentId) AS Max_LinenID,LinenItemId   
INTO #TEMPMAXID  
FROM LLSLinenAdjustmentTxnDet  
WHERE ISNULL(StoreBalFlag,'')=''  
GROUP BY LinenItemId  
  
  
SELECT A.LinenItemId,A.AdjustQuantity,A.ActualQuantity   
INTO #TEMPLINEN  
FROM LLSLinenAdjustmentTxnDet A  
WHERE ISNULL(ActualQuantity,0)>0  
AND A.LinenAdjustmentId IN (SELECT Max_LinenID FROM #TEMPMAXID)  
  
  
--SELECT * FROM #TEMPLINEN  
  
UPDATE A  
SET A.StoreBalance=B.ActualQuantity  
FROM #TEMPCALC A  
INNER JOIN #TEMPLINEN B  
ON A.LinenItemId=B.LinenItemId  
  
  
----- UPDATING THE STORE BALANCE FLAG AS WE HAVE DONE WITH THE ONE TIME ADJUSTMENT FOR LINEN CODE  
UPDATE A  
SET A.StoreBalFlag=1  
FROM LLSLinenAdjustmentTxnDet A   
WHERE A.LinenItemId IN (SELECT LinenItemId FROM #TEMPMAXID)  
  
  
----------------********************FINAL OUTPUT**************************--------------------------  
  
  
  
UPDATE A  
SET A.StoreBalance=B.StoreBalance  
   ,A.ReorderQuantity=A.StockLevel-ABS(B.StoreBalance)  
   ,A.CurrStoreCal=B.CurrStoreCal  
   ,A.PrevCurrStoreCal=B.PrevCurrStoreCal  
FROM LLSCentralCleanLinenStoreMstDet A  
INNER JOIN #TEMPCALC B  
ON A.LinenItemId=B.LinenItemId  
  
  
  
  
SELECT LinenItemId  
    ,OpeningBalance  
    ,PrevStoreBalance  
    ,StoreBalance  
    ,StockLevel  
    ,ReorderQuantity  
    ,Par1  
    ,Par2  
    ,CreatedBy  
    ,CreatedDate  
    ,CreatedDateUTC  
    ,ModifiedBy  
    ,ModifiedDate  
    ,ModifiedDateUTC  
    ,[Timestamp]  
    ,IsDeleted  
    ,CustomerId  
    ,FacilityId  
    ,CurrStoreCal  
    ,PrevCurrStoreCal   
FROM LLSCentralCleanLinenStoreMstDet  
  
END TRY        
BEGIN CATCH        
        
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)        
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());        
        
THROW        
        
END CATCH        
SET NOCOUNT OFF        
  
  
END   
  
  
  
  
  
  
--UPDATE A  
--SET CurrStoreCal= 0.00  
--,PrevCurrStoreCal= 0.00  
----,StoreBalance=3713.00  
--FROM LLSCentralCleanLinenStoreMstDet A  
----WHERE A.LinenItemId=21  
  
  
--SELECT * FROM LLSLinenItemDetailsMst  
--WHERE LinenItemId=12  
  
----SELECT * FROM LLSCentralCleanLinenStoreMstDet  
----SELECT * FROM LLSCentralCleanLinenStoreMstDet09062020  
  
GO
