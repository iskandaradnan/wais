USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCCLSBalanceCalc]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--EXEC  LLSCCLSBalanceCalc
CREATE PROCEDURE [dbo].[LLSCCLSBalanceCalc]
AS

BEGIN          
SET NOCOUNT ON          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
BEGIN TRY          

--SELECT * FROM LLSCentralCleanLinenStoreMstDet

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


UPDATE LLSCentralCleanLinenStoreMstDet
SET StoreBalance=0,ReorderQuantity=0,CurrStoreCal=0,PrevCurrStoreCal=0,PrevStoreBalance=0


UPDATE A
SET A.PrevStoreBalance = A.OpeningBalance--CHANGE
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
FROM LLSLinenItemDetailsMst A WITH (NOLOCK) 
LEFT  OUTER JOIN LLSUserAreaDetailsLinenItemMstDet F WITH (NOLOCK) 
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

FROM LLSLinenItemDetailsMst A WITH (NOLOCK)
LEFT OUTER JOIN LLSCleanLinenDespatchTxnDet B WITH (NOLOCK)
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
    
FROM LLSLinenItemDetailsMst A WITH (NOLOCK)
LEFT OUTER JOIN LLSLinenRejectReplacementTxnDet C WITH (NOLOCK)
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
    
FROM LLSLinenItemDetailsMst A WITH (NOLOCK)
LEFT OUTER JOIN LLSLinenInjectionTxnDet E WITH (NOLOCK)
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
    
FROM LLSLinenItemDetailsMst A WITH (NOLOCK)
LEFT OUTER JOIN LLSCleanLinenIssueLinenItemTxnDet D WITH (NOLOCK)
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
    
FROM LLSLinenItemDetailsMst A WITH (NOLOCK)
LEFT OUTER JOIN LLSLinenRejectReplacementTxnDet C WITH (NOLOCK)
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

    
FROM LLSLinenItemDetailsMst A WITH (NOLOCK)
LEFT  OUTER JOIN LLSLinenCondemnationTxnDet F WITH (NOLOCK)
ON A.LinenItemId=F.LinenItemId
WHERE ISNULL(F.IsDeleted,'')=''
GROUP BY  A.LinenItemId
		 ,A.LinenDescription
		 ,A.LinenCode 


--UNION ALL

--SELECT A.LinenItemId
--      ,A.LinenDescription
--	  ,A.LinenCode 
--	  ,0 AS ReceivedDispatch
--	  ,0 AS TotalRejectedQuantity
--	  ,0 AS QuantityInjected
--	  ,0 AS TotalIssuedQuantity
--	  ,0 AS ReplacedQuantity
--	  ,0 AS TotalCondemnation
--	  ,CAST(Avg_Par1 AS NUMERIC(18,2)) AS Par1
--	  ,CAST(Avg_Par2 AS NUMERIC(18,2)) AS Par2

--FROM #TEMPPAR A   
--FROM LLSLinenItemDetailsMst A
--LEFT  OUTER JOIN LLSUserAreaDetailsLinenItemMstDet F
--ON A.LinenItemId=F.LinenItemId
--GROUP BY  A.LinenItemId
--		 ,A.LinenDescription
--		 ,A.LinenCode 



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

---SELECT * FROM CTE_STORE_CALC

SELECT LinenItemId
       ,LinenDescription
       ,LinenCode 
	   --,Par2*4 AS StockLevel
	   ,Par2 AS Par2
	   ,Par1 AS Par1
	   ,(ReceivedDispatch+TotalRejectedQuantity+QuantityInjected)-(TotalIssuedQuantity+ReplacedQuantity+TotalCondemnation) AS StoreCal
	   ,(Par2*4)-((ReceivedDispatch+TotalRejectedQuantity+QuantityInjected)-(TotalIssuedQuantity+ReplacedQuantity+TotalCondemnation)) AS ReorderQuantity
INTO #TEMP
FROM CTE_STORE_CALC
--SELECT * FROM #TEMP

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
	   ,B.Par2*4 AS StockLevel
	   ,B.Par2
	   ,B.Par1
	   ,ISNULL(B.PrevStoreBalance,0) AS PrevStoreBalance
	   ,ISNULL(B.CurrStoreCal,0) AS CurrStoreCal
	   ,ISNULL(B.PrevCurrStoreCal,0) AS PrevCurrStoreCal
	  
   -----PUT PrevStoreBalance FOR THE FISRT TIME  
    ---CHANGE INTO STORE BALANACE  
  
    ,CASE WHEN PrevCurrStoreCal=0.00 THEN ISNULL(((B.CurrStoreCal)+B.PrevStoreBalance),0)  
          WHEN CurrStoreCal=PrevCurrStoreCal THEN B.PrevStoreBalance   
          ELSE ISNULL(((B.CurrStoreCal-B.PrevCurrStoreCal)+B.PrevStoreBalance),0) END AS StoreBalance  --THESE CONDITION FOR TEST PURPOSE ONLY
	  
	  ,A.ReorderQuantity
INTO #TEMPCALC
FROM #TEMP A
LEFT OUTER JOIN LLSCentralCleanLinenStoreMstDet B WITH (NOLOCK)
ON A.LinenItemId=B.LinenItemId

--SELECT * FROM #TEMPCALC

-------****************** CHECK FOR LINEN ADJUSTMENT ************************--------------------------------

SELECT MAX(LinenAdjustmentId) AS Max_LinenID,LinenItemId 
INTO #TEMPMAXID
FROM LLSLinenAdjustmentTxnDet WITH (NOLOCK)
GROUP BY LinenItemId


SELECT A.LinenItemId,A.AdjustQuantity,A.ActualQuantity 
INTO #TEMPLINEN
FROM LLSLinenAdjustmentTxnDet A WITH (NOLOCK)
WHERE ISNULL(ActualQuantity,0)>0
AND A.LinenAdjustmentDetId IN (SELECT Max_LinenID FROM #TEMPMAXID)


--SELECT * FROM #TEMPLINEN

UPDATE A
SET A.StoreBalance=B.ActualQuantity
FROM #TEMPCALC A
INNER JOIN #TEMPLINEN B
ON A.LinenItemId=B.LinenItemId

----------------********************FINAL OUTPUT**************************--------------------------


--SELECT * FROM #TEMPCALC
--WHERE LinenItemId=48

------UPDATE STATEMENT TO RUN
UPDATE A
SET A.StoreBalance=B.StoreBalance
   ,A.ReorderQuantity=B.ReorderQuantity
   ,A.CurrStoreCal=B.CurrStoreCal
   ,A.PrevCurrStoreCal=B.PrevCurrStoreCal
   ,A.StockLevel=B.StockLevel
   ,A.ModifiedBy=19
   ,A.ModifiedDate=GETDATE()
   ,A.ModifiedDateUTC=GETUTCDATE()
FROM LLSCentralCleanLinenStoreMstDet A WITH (NOLOCK)
INNER JOIN #TEMPCALC B
ON A.LinenItemId=B.LinenItemId



---SELECT * FROM LLSCentralCleanLinenStoreMstDet

--LLSCentralCleanLinenStoreMstDetTEMP

END TRY          
BEGIN CATCH          
          
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)          
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());          
          
THROW          
          
END CATCH          
SET NOCOUNT OFF          
END



--UPDATE LLSCentralCleanLinenStoreMstDet
--SET StoreBalance=0,ReorderQuantity=0,CurrStoreCal=0,PrevCurrStoreCal=0,PrevStoreBalance=0


GO
