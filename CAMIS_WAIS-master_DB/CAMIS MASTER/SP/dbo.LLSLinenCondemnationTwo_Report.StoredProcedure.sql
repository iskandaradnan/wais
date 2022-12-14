USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenCondemnationTwo_Report]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
--SELECT LinenCode,LinenItemId FROM LLSLinenItemDetailsMst WHERE LinenCode LIKE @Search+N'%'    
    
--EXEC LLSLinenCondemnationTwo_Report 2020,10    
    
CREATE PROCEDURE [dbo].[LLSLinenCondemnationTwo_Report]    
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
 B.LinenItemId    
,B.LinenCode    
,LinenDescription    
,C.DocumentDate    
,SUM(Torn) AS Torn    
,SUM(Stained) AS Stained    
,SUM(Faded) AS Faded    
,SUM(Vandalism) AS Vandalism    
,SUM(WearTear) AS WearTear    
,SUM(StainedByChemical) AS StainedByChemical    
,SUM(A.Total) AS QuantityCondemned     
,SUM(ISNULL(B.LinenPrice,0))*33.33*SUM(A.Total) AS DepreciationValue
,YEAR(A.CreatedDate) AS YEAR  
,MONTH(A.CreatedDate) AS MONTH  
INTO #TEMPBASEDATA  
FROM [10.249.5.52].[uetrackMasterdbPreProd].[dbo].LLSLinenCondemnationTxnDet A    
INNER JOIN [10.249.5.52].[uetrackMasterdbPreProd].[dbo].LLSLinenItemDetailsMst B    
ON A.LinenItemId=B.LinenItemId    
INNER JOIN [10.249.5.52].[uetrackMasterdbPreProd].[dbo].LLSLinenCondemnationTxn C    
ON A.LinenCondemnationId=C.LinenCondemnationId    
WHERE YEAR(GETDATE())=@YEAR    
AND A.LinenItemId=@LINENITEMID    
GROUP BY B.LinenItemId    
,B.LinenCode    
,LinenDescription    
,C.DocumentDate    
,YEAR(A.CreatedDate)  
,MONTH(A.CreatedDate)  
  
 IF(@FREQUENCY='Yearly')  
BEGIN  
SELECT     
LinenCode     
,LinenDescription     
,SUM(QuantityCondemned) AS  QuantityCondemned  
,SUM(Torn) AS Torn   
,SUM(Stained) AS  Stained   
,SUM(Faded) AS Faded    
,SUM(Vandalism) AS Vandalism   
,SUM(WearTear) AS WearTear     
,SUM(StainedByChemical) AS StainedByChemical   
,SUM(DepreciationValue) AS DepreciationValue
,DocumentDate    
,ROW_NUMBER() OVER(ORDER BY LinenCode) AS Rn     
FROM #TEMPBASEDATA  
WHERE YEAR=@YEAR  
GROUP BY DocumentDate 
,LinenCode     
,LinenDescription     

END  
IF(@FREQUENCY='Monthly')  
BEGIN  
  
  
SELECT     
LinenCode     
,LinenDescription     
,QuantityCondemned    
,Torn    
,Stained    
,Faded    
,Vandalism    
,WearTear    
,StainedByChemical    
,DocumentDate    
,DepreciationValue
,ROW_NUMBER() OVER(ORDER BY LinenCode) AS Rn     
FROM #TEMPBASEDATA  
WHERE YEAR=@YEAR  
AND MONTH=@MONTH  
END    
END    
    
    
GO
