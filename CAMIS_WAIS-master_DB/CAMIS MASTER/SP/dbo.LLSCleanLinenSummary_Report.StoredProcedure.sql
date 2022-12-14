USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenSummary_Report]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
  
  
  
--EXEC LLSCleanLinenSummary_Report 2020,1  
  
CREATE PROCEDURE [dbo].[LLSCleanLinenSummary_Report]  
(  
 @YEAR INT   
,@MONTH INT   
)  
AS  
  
--DECLARE @YEAR INT   
--DECLARE @MONTH INT   
  
--SET @YEAR=2020  
--SET @MONTH=4  
BEGIN  
  
DECLARE @NUMBER NUMERIC(18,2)  
SET @NUMBER=(SELECT SUM(DeliveryWeight1st) FROM LLSCleanLinenIssueTxn WHERE YEAR(DeliveryDate1st)=@YEAR  
AND MONTH(DeliveryDate1st)=@MONTH  
)  
  
DECLARE @FUN1 VARCHAR(MAX)  
DECLARE @FUN2 VARCHAR(MAX)  
  
SET @FUN1=(SELECT DBO.[fnNumberToWords](@NUMBER))  
SET @FUN2=(SELECT [dbo].[fnNumberToWordsAfterPoint](RIGHT(@NUMBER,2)))  
  
  
DECLARE @ANSWER VARCHAR(MAX)  
SET @ANSWER=(SELECT CONCAT(CONCAT(@FUN1,''),@FUN2))  
  
--SELECT @ANSWER  
  
  
;WITH CTE AS   
(  
SELECT COUNT(CleanLinenIssueId) AS TotalCLI  
,SUM(DeliveryWeight1st) AS [Weight]  
,SUM(DeliveryWeight1st)*4.04 as RM   -----4.04 IS 1KG EQUIVALENT VALUE
,CAST(A.DeliveryDate1st AS DATE) AS [IssuedDate]  
,B.MonthName AS [MonthName]  
,B.Year AS [Year]  
,CAST(B.DAY AS VARCHAR(10))+'-'+LEFT(B.MonthName,3)+'-'+CAST(B.Year AS VARCHAR(10)) AS [IssuedDate1ST]  
FROM LLSCleanLinenIssueTxn  A  
INNER JOIN LLSDate B   
ON CAST(A.DeliveryDate1st AS DATE)=B.Date  
GROUP BY CAST(B.DAY AS VARCHAR(10))+'-'+LEFT(B.MonthName,3)+'-'+CAST(B.Year AS VARCHAR(10))  
,CAST(A.DeliveryDate1st AS DATE)   
,B.MonthName   
,B.Year   
)  
SELECT TotalCLI   
,Weight   
,RM   
,MonthName  
,Year  
,IssuedDate   
,[IssuedDate1ST]  
,@ANSWER AS GrandTotalWeight  
FROM CTE  
WHERE YEAR(IssuedDate)=@YEAR  
AND MONTH(IssuedDate)=@MONTH  
ORDER BY IssuedDate  
    
END  
GO
