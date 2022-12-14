USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenCondemnation_Report]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--SELECT LinenCode,LinenItemId FROM LLSLinenItemDetailsMst WHERE LinenCode LIKE @Search+N'%'  
  
--EXEC LLSLinenCondemnation_Report 2020  
  
CREATE PROCEDURE [dbo].[LLSLinenCondemnation_Report]  
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
 B.LinenItemId  
,B.LinenCode  
,LinenDescription  
,SUM(A.Total) AS QuantityCondemned   
INTO #TEMPBASEDATA
FROM [10.249.5.52].[uetrackMasterdbPreProd].[dbo].LLSLinenCondemnationTxnDet A  
INNER JOIN [10.249.5.52].[uetrackMasterdbPreProd].[dbo].LLSLinenItemDetailsMst B  
ON A.LinenItemId=B.LinenItemId  

GROUP BY B.LinenItemId  
,B.LinenCode  
,LinenDescription  

IF(@FREQUENCY='Yearly')
BEGIN  
SELECT   
LinenCode   
,LinenDescription   
,QuantityCondemned  
,ROW_NUMBER() OVER(ORDER BY LinenCode) AS Rn   
FROM #TEMPBASEDATA   
WHERE YEAR(GETDATE())=@YEAR    
END  
IF(@FREQUENCY='Monthly')
BEGIN  
SELECT   
LinenCode   
,LinenDescription   
,QuantityCondemned  
,ROW_NUMBER() OVER(ORDER BY LinenCode) AS Rn   
FROM #TEMPBASEDATA   
WHERE YEAR(GETDATE())=@YEAR    
AND MONTH(GETDATE())=@MONTH
END  
END
  
  
  
GO
