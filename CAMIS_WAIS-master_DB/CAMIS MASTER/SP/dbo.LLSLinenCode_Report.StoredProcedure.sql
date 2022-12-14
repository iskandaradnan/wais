USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenCode_Report]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
--EXEC LLSLinenCode_Report 'Yearly',2020,12    
CREATE PROCEDURE [dbo].[LLSLinenCode_Report]    
(    
@FREQUENCY VARCHAR(30)  
,@YEAR INT    
,@MONTH INT NULL  
)    
AS    
BEGIN    
  
  
IF OBJECT_ID('tempdb.dbo.#TEMPBASEDATA', 'U') IS NOT NULL          
DROP TABLE #TEMPBASEDATA         
      
  
--DECLARE @FREQUENCY VARCHAR(30)  
--SET @FREQUENCY='MONTHLY'  
  
--DECLARE @YEAR INT   
--SET @YEAR=2020  
    
--DECLARE @MONTH INT   
--SET @MONTH=10  
    
    
SELECT     
 C.LinenCode    
,C.LinenDescription    
,SUM(B.RequestedQuantity) AS RequestedQuantity    
,SUM(A.DeliveryIssuedQty1st) AS DeliveryIssuedQty1st    
,SUM(B.RequestedQuantity-A.DeliveryIssuedQty1st) AS ShortFall    
,SUM(ISNULL(E.TotalRejectedQuantity,0)) AS TotalRejectedQuantity    
,SUM(ISNULL(E.ReplacedQuantity,0)) AS ReplacedQuantity    
--bag added on 27-1-2021

,SUM(ISNULL(Z.RequestedQuantity,0)) AS RequestedQuantityBag
,SUM(ISNULL(Y.TotalBagIssued,0)) AS TotalBagIssued
,SUM(ISNULL(Y.TotalBagShortfall,0)) AS TotalBagShortfall

,YEAR(A.CreatedDate) AS YEAR  
,MONTH(A.CreatedDate) AS MONTH  
INTO #TEMPBASEDATA  
FROM LLSCleanLinenIssueLinenItemTxnDet A WITH (NOLOCK)    
LEFT OUTER JOIN LLSCleanLinenRequestLinenItemTxnDet B WITH (NOLOCK)    
ON A.CleanLinenIssueId=B.CleanLinenIssueId    
AND A.LinenitemId=B.LinenItemId  
LEFT OUTER JOIN LLSCleanLinenIssueTxn Y
ON A.CleanLinenIssueId=Y.CleanLinenIssueId
LEFT OUTER JOIN LLSCleanLinenRequestLinenBagTxnDet Z
ON Y.CleanLinenRequestId=Z.CleanLinenRequestId
LEFT OUTER JOIN LLSLinenItemDetailsMst C WITH (NOLOCK)    
ON A.LinenitemId=C.LinenItemId    
LEFT OUTER JOIN LLSLinenRejectReplacementTxn D WITH (NOLOCK)    
ON D.CleanLinenIssueId=A.CleanLinenIssueId    
LEFT OUTER JOIN LLSLinenRejectReplacementTxnDet E WITH (NOLOCK)    
ON D.LinenRejectReplacementId=E.LinenRejectReplacementId    
AND C.LinenItemId=E.LinenItemId    
WHERE ISNULL(B.CleanLinenIssueId,'')<>''    
  
GROUP BY C.LinenCode    
,C.LinenDescription    
,YEAR(A.CreatedDate)  
,MONTH(A.CreatedDate)  
  
IF (@FREQUENCY='Yearly')  
BEGIN  
  
  
SELECT    
 LinenCode     
,LinenDescription     
,SUM(RequestedQuantity) AS RequestedQuantity    
,SUM(DeliveryIssuedQty1st) AS DeliveryIssuedQty1st    
,SUM(ShortFall) AS ShortFall    
,SUM(TotalRejectedQuantity) AS TotalRejectedQuantity    
,SUM(ReplacedQuantity) AS ReplacedQuantity
,SUM(RequestedQuantityBag) AS RequestedQuantityBag
,SUM(TotalBagIssued) AS TotalBagIssued
,SUM(TotalBagShortfall) AS TotalBagShortfall
,ROW_NUMBER() OVER(ORDER BY LinenCode) AS Rn    
FROM #TEMPBASEDATA    
WHERE YEAR=@YEAR      
GROUP BY LinenCode     
,LinenDescription     


END  
IF(@FREQUENCY='Monthly')  
BEGIN  
  
SELECT    
 LinenCode     
,LinenDescription     
,RequestedQuantity     
,DeliveryIssuedQty1st     
,ShortFall     
,TotalRejectedQuantity     
,ReplacedQuantity 
,RequestedQuantityBag
,TotalBagIssued
,TotalBagShortfall
,ROW_NUMBER() OVER(ORDER BY LinenCode) AS Rn    
FROM #TEMPBASEDATA     
WHERE YEAR=@YEAR      
AND MONTH=@MONTH  
END  
END
GO
