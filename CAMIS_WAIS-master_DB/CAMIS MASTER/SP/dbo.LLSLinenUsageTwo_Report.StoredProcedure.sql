USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenUsageTwo_Report]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT LinenCode FROM LLSLinenItemDetailsMst  
--EXEC LLSLinenUsageTwo_Report 2020,'BJ01M'  
  
CREATE PROCEDURE [dbo].[LLSLinenUsageTwo_Report]  
(  
 @FREQUENCY VARCHAR(30)
,@YEAR INT  
,@MONTH INT NULL
,@LINENITEMID INT  
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
  
--DECLARE @LINENCODE VARCHAR(50)  
--SET @LINENCODE='BJ01M'  
  
  

SELECT   
C.LinenCode  
,C.LinenDescription  
,H.UserAreaCode  
,H.UserAreaName  
,SUM(B.RequestedQuantity) AS RequestedQuantity  
,SUM(A.DeliveryIssuedQty1st) AS DeliveryIssuedQty1st  
,SUM(B.RequestedQuantity-A.DeliveryIssuedQty1st) AS ShortFall  
,SUM(ISNULL(E.TotalRejectedQuantity,0)) AS TotalRejectedQuantity  
,SUM(ISNULL(E.ReplacedQuantity,0)) AS ReplacedQuantity  
,YEAR(A.CreatedDate) AS YEAR
,MONTH(A.CreatedDate) AS MONTH
INTO #TEMPBASEDATA       
FROM LLSCleanLinenIssueLinenItemTxnDet A WITH (NOLOCK)  
LEFT OUTER JOIN LLSCleanLinenRequestLinenItemTxnDet B WITH (NOLOCK)  
ON A.CleanLinenIssueId=B.CleanLinenIssueId  
AND A.LinenitemId=B.LinenItemId  
LEFT OUTER JOIN LLSLinenItemDetailsMst C WITH (NOLOCK)  
ON A.LinenitemId=C.LinenItemId  
LEFT OUTER JOIN LLSCleanLinenRequestTxn F WITH (NOLOCK)  
ON B.CleanLinenRequestId=F.CleanLinenRequestId  
LEFT OUTER JOIN LLSUserAreaDetailsLocationMstDet G  
ON F.LLSUserAreaLocationId=G.LLSUserAreaLocationId  
LEFT OUTER JOIN MstLocationUserArea H  
ON G.UserAreaCode=H.UserAreaCode  
LEFT OUTER JOIN LLSLinenRejectReplacementTxn D WITH (NOLOCK)  
ON D.CleanLinenIssueId=A.CleanLinenIssueId  
LEFT OUTER JOIN LLSLinenRejectReplacementTxnDet E WITH (NOLOCK)  
ON D.LinenRejectReplacementId=E.LinenRejectReplacementId  
AND C.LinenItemId=E.LinenItemId  
WHERE ISNULL(B.CleanLinenIssueId,'')<>''  
AND C.LinenItemId=@LINENITEMID  
GROUP BY C.LinenCode  
,C.LinenDescription  
,H.UserAreaCode  
,H.UserAreaName  
,YEAR(A.CreatedDate)
,MONTH(A.CreatedDate)


IF(@FREQUENCY='Yearly')
BEGIN
SELECT  
 LinenCode   
,LinenDescription   
,UserAreaCode  
,UserAreaName  
,RequestedQuantity   
,DeliveryIssuedQty1st   
,ShortFall   
,TotalRejectedQuantity   
,ReplacedQuantity  
,ROW_NUMBER() OVER(ORDER BY LinenCode) AS Rn  
FROM #TEMPBASEDATA
WHERE YEAR=@YEAR
END
IF(@FREQUENCY='Monthly')
BEGIN
SELECT  
 LinenCode   
,LinenDescription   
,UserAreaCode  
,UserAreaName  
,RequestedQuantity   
,DeliveryIssuedQty1st   
,ShortFall   
,TotalRejectedQuantity   
,ReplacedQuantity  
,ROW_NUMBER() OVER(ORDER BY LinenCode) AS Rn  
FROM #TEMPBASEDATA
WHERE YEAR=@YEAR
and MONTH=@MONTH
END
  
END  
GO
