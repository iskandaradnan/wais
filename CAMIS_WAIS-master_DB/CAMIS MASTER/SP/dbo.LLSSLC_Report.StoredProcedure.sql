USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSSLC_Report]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[LLSSLC_Report]  
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
--CAST(B.CreatedDate AS DATE) AS [Date Of Collection]  
 CAST(DAY AS VARCHAR(10))+'-'+LEFT(A.MonthName,3)+'-'+CAST(A.Year AS VARCHAR(10)) AS [Date Of Collection]  
,D.UserAreaName AS [User Department Area]  
,C.UserAreaCode  
,B.LLSUserAreaId  
,TotalWhiteBag  
,TotalRedBag  
,TotalGreenBag  
,TotalBrownBag  
,TotalQuantity  
,[Weight]  
,E.CollectionDate  
,A.Year
,A.Month
INTO #TEMPBASEDATA
FROM LLSDate A  
INNER JOIN LLSSoiledLinenCollectionTxn E  
ON A.[Date]=CAST(E.CollectionDate AS DATE)  
LEFT OUTER JOIN LLSSoiledLinenCollectionTxnDet  B  
ON B.SoiledLinenCollectionId=E.SoiledLinenCollectionId  
LEFT OUTER JOIN LLSUserAreaDetailsMst C  
ON B.LLSUserAreaId=C.LLSUserAreaId  
LEFT OUTER JOIN MstLocationUserArea D  
ON C.UserAreaCode=D.UserAreaCode  


IF(@FREQUENCY='Yearly')
BEGIN  
SELECT   
CollectionDate  
,[Date Of Collection]  
,[User Department Area]  
,SUM(TotalWhiteBag) AS TotalWhiteBag  
,SUM(TotalRedBag) AS TotalRedBag  
,SUM(TotalGreenBag) AS TotalGreenBag  
,SUM(TotalBrownBag) AS TotalBrownBag  
,SUM(TotalQuantity) AS TotalQuantity  
,SUM([Weight]) AS [Weight]  
,ROW_NUMBER() OVER(ORDER BY CollectionDate) AS Rn  
FROM #TEMPBASEDATA
WHERE Year=@YEAR
GROUP BY [Date Of Collection]  
,[User Department Area]  
,CollectionDate  
ORDER BY CollectionDate  
END  
IF (@FREQUENCY='Monthly')
BEGIN
SELECT   
CollectionDate  
,[Date Of Collection]  
,[User Department Area]  
,SUM(TotalWhiteBag) AS TotalWhiteBag  
,SUM(TotalRedBag) AS TotalRedBag  
,SUM(TotalGreenBag) AS TotalGreenBag  
,SUM(TotalBrownBag) AS TotalBrownBag  
,SUM(TotalQuantity) AS TotalQuantity  
,SUM([Weight]) AS [Weight]  
,ROW_NUMBER() OVER(ORDER BY CollectionDate) AS Rn  
FROM #TEMPBASEDATA
WHERE Year=@YEAR
AND Month=@MONTH
GROUP BY [Date Of Collection]  
,[User Department Area]  
,CollectionDate  
END
END  
GO
