USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DedNCRValidationTxnDet_Save06022021]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  ---EXEC DedNCRValidationTxnDet_Save 2020,5             
              
CREATE PROCEDURE [dbo].[DedNCRValidationTxnDet_Save06022021]       
(       
 @YEAR INT       
,@MONTH INT       
)              
AS BEGIN         
        
--DECLARE @YEAR INT                   
--DECLARE @MONTH INT                    
      
--SET @YEAR=2020                    
--SET @MONTH=11       
      
DELETE FROM DeductionNCRB5Base WHERE OperationalYear=@YEAR AND OperationalMonth=@MONTH        
DELETE FROM DedNCRValidationTxnDet WHERE YEAR=@YEAR AND MONTH=@MONTH        
--DedNCRValidationTxnDet      
      
IF OBJECT_ID('tempdb.dbo.#TEMP_MAIN', 'U') IS NOT NULL                      
DROP TABLE #TEMP_MAIN                    
                    
                    
IF OBJECT_ID('tempdb.dbo.#TEMP_CALC', 'U') IS NOT NULL                      
DROP TABLE #TEMP_CALC                    
                    
IF OBJECT_ID('tempdb.dbo.#TEMPOPENPREVMONTH', 'U') IS NOT NULL                      
DROP TABLE #TEMPOPENPREVMONTH                    
                    
IF OBJECT_ID('tempdb.dbo.#TEMPCURRCLOSED_CALC', 'U') IS NOT NULL                      
DROP TABLE #TEMPCURRCLOSED_CALC                    
                    
IF OBJECT_ID('tempdb.dbo.#TEMPPREVCLOSED_CALC', 'U') IS NOT NULL                      
DROP TABLE #TEMPPREVCLOSED_CALC                    
                    
                    
IF OBJECT_ID('tempdb.dbo.#TEMPCURROPEN_CALC', 'U') IS NOT NULL                      
DROP TABLE #TEMPCURROPEN_CALC                    
                    
                    
IF OBJECT_ID('tempdb.dbo.#TEMPPREVOPEN_CALC', 'U') IS NOT NULL                      
DROP TABLE #TEMPPREVOPEN_CALC                    
      
      
DECLARE @PREV_YEAR INT                     
DECLARE @PREV_MONTH INT                    
DECLARE @LEAPYEAR VARCHAR(10)                    
DECLARE @STARTOFYEAR DATETIME        
        
SET @STARTOFYEAR='2020-08-01'    
--SET @STARTOFYEAR=(SELECT DATEFROMPARTS(YEAR(GETDATE()), 1, 1))        
        
--SELECT @STARTOFYEAR        
                    
--DECLARE @MONTHCALC INT                    
                    
                   
                    
SET @LEAPYEAR=(                    
CASE                    
DAY(EOMONTH(DATEADD(DAY,31,DATEADD(YEAR,@YEAR-1900,0))))                    
WHEN 29 THEN 'YES' ELSE 'NO'                    
END)                    
                    
                    
SET @PREV_YEAR=(CASE WHEN @MONTH=1 THEN @YEAR-1 ELSE @YEAR END)                    
SET @PREV_MONTH=(CASE WHEN @MONTH=1 THEN 12 ELSE @MONTH-1 END)                    
                    
                    
--SET @MONTHCALC=(CASE WHEN @MONTH IN (1,2,3,4,5,6,7,8,9) THEN CONCAT('0',@MONTH) ELSE @MONTH END)                    
                    
DECLARE @StartDate DATETIME                    
DECLARE @EndDate DATETIME                    
                    
SET @StartDate=CAST(CONCAT(CONCAT(CONCAT(@MONTH,'-01'),'-'),@YEAR) AS DATE)                    
SET @EndDate=CAST((CASE WHEN @MONTH IN (1,3,5,7,8,10,12) THEN CONCAT(CONCAT(CONCAT(@MONTH,'-31'),'-'),@YEAR)                    
WHEN @MONTH IN (2) AND @LEAPYEAR='YES' THEN CONCAT(CONCAT(CONCAT(@MONTH,'-29'),'-'),@YEAR)                    
WHEN @MONTH IN (2) AND @LEAPYEAR='NO' THEN CONCAT(CONCAT(CONCAT(@MONTH,'-28'),'-'),@YEAR)                    
ELSE CONCAT(CONCAT(CONCAT(@MONTH,'-30'),'-'),@YEAR) END) AS DATE)                    
                    
SELECT @StartDate,@EndDate,@MONTH,@PREV_YEAR,@PREV_MONTH                    
      
DELETE FROM TEMP_MAIN WHERE Year=@YEAR      
      
INSERT INTO TEMP_MAIN      
(      
 CustomerID      
,FacilityID      
,DedNCRValidationId      
,CRMRequestId      
,RequestNo      
,RequestStatus      
,RequestDateTime      
,AssetId      
,AssetNo      
,Completed_Date      
,DeductionFigureAsset      
,Year      
,Month      
,IndicatorDetId      
)      
      
      
SELECT '157' AS CustomerID      
,'144'  AS FacilityID      
,B.DedNCRValidationId       
,CRMRequestId       
,RequestNo       
,RequestStatus      
,RequestDateTime       
,A.AssetId       
,C.AssetNo   
,Completed_Date      
,50 AS DeductionFigureAsset      
,B.Year       
,B.Month       
,B.IndicatorDetId           
      
FROM [uetrackMasterdbPreProd].[dbo].CRMRequest A       
INNER JOIN DedNCRValidationTxn B       
ON A.Indicators_all=B.IndicatorDetId       
AND YEAR(A.RequestDateTime)=B.Year       
AND MONTH(A.RequestDateTime)=B.Month       
LEFT OUTER JOIN EngAsset C       
ON A.AssetId=C.AssetId       
WHERE TypeOfRequest=10020       
AND A.ServiceId=2       
--AND IndicatorDetId=5  ----NEED TO COMMENT     
AND B.Year=@YEAR       
      
      
/*CALCULATING PREVIOUS MONTH NCR*/      
      
INSERT INTO TEMPOPENPREVMONTH_NCR        
(        
 CustomerID      
,FacilityID      
,DedNCRValidationId      
,CRMRequestId      
,RequestNo      
,RequestDateTime      
,AssetId      
,AssetNo      
,Completed_Date      
,DeductionFigureAsset      
,RequestStatus      
,Year      
,Month      
,IndicatorDetId      
        
)        
        
                      
SELECT       
 CustomerID      
,FacilityID      
,DedNCRValidationId      
,CRMRequestId      
,RequestNo      
,RequestDateTime      
,AssetId      
,AssetNo      
,Completed_Date      
,DeductionFigureAsset      
,RequestStatus      
,Year      
,Month      
,IndicatorDetId      
      
--,@StartDate WO_StartDate        
FROM TEMP_MAIN                      
WHERE YEAR(RequestDateTime)=@PREV_YEAR                      
--AND MONTH(WorkRequestDate)=@PREV_MONTH                    
AND RequestStatus IN (139,140)         
--AND RequestNo NOT IN (SELECT RequestNo FROM TEMPOPENPREVMONTH_NCR)        
        
        
---UPDATE        
        
UPDATE A        
SET  Request_StartDate=@StartDate         
FROM TEMPOPENPREVMONTH_NCR A        
      
      
/*CALCULATING PREVIOUS MONTH NCR FINISHED*/      
      
      
      
-----LOGIC CALCULATION      
      
SELECT       
 CustomerID      
,FacilityID      
,DedNCRValidationId      
,CRMRequestId      
,RequestNo      
,RequestDateTime      
,AssetId      
,AssetNo      
,Completed_Date      
,DeductionFigureAsset      
,RequestStatus      
,Year      
,Month      
,IndicatorDetId      
,CASE WHEN ISNULL(Completed_Date,'')<>'' THEN DATEDIFF(DAY,RequestDateTime,Completed_Date)+1 ELSE 0 END AS DemeritPoint      
,CASE WHEN ISNULL(Completed_Date,'')<>'' THEN 1 ELSE 0 END AS Isvalid      
,DeductionFigureAsset*(CASE WHEN ISNULL(Completed_Date,'')<>'' THEN DATEDIFF(DAY,RequestDateTime,Completed_Date)+1 ELSE 0 END) AS Deduction      
,'Closed On Current Month' AS Flag      
INTO #TEMPCURRCLOSED_CALC                    
FROM TEMP_MAIN      
WHERE YEAR(RequestDateTime)=@YEAR      
AND YEAR(Completed_Date)=@YEAR      
AND MONTH(RequestDateTime )=@MONTH        
AND MONTH(Completed_Date)=@MONTH      
AND RequestStatus IN (141,142)                    
      
      
      
SELECT       
 CustomerID      
,FacilityID      
,DedNCRValidationId      
,CRMRequestId      
,RequestNo      
,RequestDateTime      
,AssetId      
,AssetNo      
,Completed_Date      
,DeductionFigureAsset      
,RequestStatus      
,Year      
,Month      
,IndicatorDetId      
,CASE WHEN ISNULL(Completed_Date,'')='' THEN DATEDIFF(DAY,RequestDateTime,@EndDate)+1 ELSE 0 END AS DemeritPoint      
,CASE WHEN ISNULL(Completed_Date,'')='' THEN 1 ELSE 0 END AS Isvalid      
,DeductionFigureAsset*(CASE WHEN ISNULL(Completed_Date,'')='' THEN DATEDIFF(DAY,RequestDateTime,@EndDate)+1 ELSE 0 END) AS Deduction      
,'Open On Current Month' AS Flag      
INTO #TEMPCURROPEN_CALC      
FROM TEMP_MAIN      
WHERE YEAR(RequestDateTime)=@YEAR      
--AND YEAR(Completed_Date)=@YEAR      
AND MONTH(RequestDateTime )=@MONTH        
--AND MONTH(Completed_Date)=@MONTH      
AND RequestStatus IN (139,140)                    
      
      
      
SELECT       
 CustomerID      
,FacilityID      
,DedNCRValidationId      
,CRMRequestId      
,RequestNo      
,RequestDateTime      
,AssetId      
,AssetNo      
,Completed_Date      
,DeductionFigureAsset      
,RequestStatus      
,Year      
,Month      
,IndicatorDetId      
,CASE WHEN ISNULL(Completed_Date,'')='' THEN DATEDIFF(DAY,@StartDate,@EndDate)+1 ELSE 0 END AS DemeritPoint      
,CASE WHEN ISNULL(Completed_Date,'')='' THEN 1 ELSE 0 END AS Isvalid      
,DeductionFigureAsset*(CASE WHEN ISNULL(Completed_Date,'')='' THEN DATEDIFF(DAY,@StartDate,@EndDate)+1 ELSE 0 END) AS Deduction      
,'Prev Month Open And Still Open In Current Month' AS Flag      
INTO #TEMPPREVOPEN_CALC                    
FROM TEMP_MAIN      
--WHERE YEAR(RequestDateTime)=@YEAR      
----AND YEAR(Completed_Date)=@YEAR      
--AND MONTH(RequestDateTime )=@MONTH        
----AND MONTH(Completed_Date)=@MONTH      
--AND RequestStatus IN (139,140)         
WHERE @YEAR=(SELECT YEAR(MAX(Request_StartDate)) FROM TEMPOPENPREVMONTH_NCR)                    
AND @MONTH=(SELECT MONTH(MAX(Request_StartDate)) FROM TEMPOPENPREVMONTH_NCR)                    
AND RequestNo IN (SELECT RequestNo FROM TEMPOPENPREVMONTH_NCR)                    
AND RequestNo NOT IN (SELECT RequestNo FROM #TEMPCURROPEN_CALC)        
AND RequestStatus IN (139,140)                                  
      
      
SELECT       
 CustomerID      
,FacilityID      
,DedNCRValidationId      
,CRMRequestId      
,RequestNo      
,RequestDateTime      
,AssetId      
,AssetNo      
,Completed_Date      
,DeductionFigureAsset      
,RequestStatus      
,Year      
,Month      
,IndicatorDetId      
,CASE WHEN ISNULL(Completed_Date,'')<>'' THEN DATEDIFF(DAY,@StartDate,Completed_Date)+1 ELSE 0 END AS DemeritPoint      
,CASE WHEN ISNULL(Completed_Date,'')<>'' THEN 1 ELSE 0 END AS Isvalid      
,DeductionFigureAsset*(CASE WHEN ISNULL(Completed_Date,'')<>'' THEN DATEDIFF(DAY,@StartDate,Completed_Date)+1 ELSE 0 END) AS Deduction      
,'Prev Month Open Closed Current Month' AS Flag      
INTO #TEMPPREVCLOSED_CALC                     
FROM TEMP_MAIN      
WHERE  YEAR(Completed_Date)=@YEAR                    
AND MONTH(Completed_Date)=@MONTH              
AND RequestNo IN (SELECT RequestNo FROM TEMPOPENPREVMONTH_NCR)                    
AND RequestNo NOT IN (SELECT RequestNo FROM #TEMPCURRCLOSED_CALC)        
AND RequestStatus IN (141,142)        
      
      
      
INSERT INTO DeductionNCRB5Base      
(      
 CustomerID      
,FacilityID      
,DedNCRValidationId      
,CRMRequestId      
,RequestNo      
,RequestDateTime      
,AssetId      
,AssetNo      
,Completed_Date      
,DeductionFigureAsset      
,RequestStatus      
,Year      
,Month      
,IndicatorDetId      
,DemeritPoint      
,Deduction      
,Flag      
,Isvalid      
,OperationalYear      
,OperationalMonth      
)      
      
      
      
SELECT       
 CustomerID      
,FacilityID      
,DedNCRValidationId      
,CRMRequestId      
,RequestNo      
,RequestDateTime      
,AssetId      
,AssetNo      
,Completed_Date      
,DeductionFigureAsset      
,RequestStatus      
,Year      
,Month      
,IndicatorDetId      
,DemeritPoint      
,Deduction      
,Flag      
,Isvalid      
,@YEAR AS OperationalYear      
,@MONTH AS OperationalMonth      
      
FROM (                    
SELECT * FROM #TEMPCURRCLOSED_CALC                     
UNION ALL                     
SELECT * FROM #TEMPPREVCLOSED_CALC                    
UNION ALL                     
SELECT * FROM #TEMPCURROPEN_CALC                    
UNION ALL                    
SELECT * FROM #TEMPPREVOPEN_CALC                    
) AA       
      
INSERT INTO DedNCRValidationTxnDet      
(      
 CustomerId      
,FacilityId      
,DedNCRValidationId      
,CRMRequestId      
,RequestNo      
,RequestDateTime      
,AssetId      
,AssetNo      
,DemeritPoint      
,FinalDemeritPoint      
,DisputedDemeritPoints      
,IsValid      
,Remarks      
,DeductionValue      
,CreatedBy      
,CreatedDate      
,CreatedDateUTC      
,ModifiedBy      
,ModifiedDate      
,ModifiedDateUTC      
,[Year]      
,[Month]      
,IndicatorDetId      
,[FileName]      
,RemarksJOHN      
,Completed_Date      
)      
      
      
      
SELECT       
 CustomerId      
,FacilityId      
,DedNCRValidationId      
,CRMRequestId      
,RequestNo      
,RequestDateTime      
,AssetId      
,AssetNo      
,DemeritPoint      
,0 AS FinalDemeritPoint      
,0 AS DisputedDemeritPoints      
,IsValid      
,'' AS Remarks      
,Deduction      
,19 AS CreatedBy      
,GETDATE() AS CreatedDate      
,GETDATE() AS CreatedDateUTC      
,19 AS ModifiedBy      
,GETDATE() AS ModifiedDate      
,GETDATE() AS ModifiedDateUTC      
,OperationalYear AS Year      
,OperationalMonth AS Month      
,IndicatorDetId      
,'' AS [FileName]      
,'' AS RemarksJOHN       
,Completed_Date      
FROM DeductionNCRB5Base      
WHERE OperationalYear=@YEAR    
AND OperationalMonth=@MONTH    
    
    
----NEED TO COMMENT OUT    
      
UNION ALL      
      
SELECT '157'      
,'144'       
,B.DedNCRValidationId       
,CRMRequestId       
,RequestNo       
,RequestDateTime       
,A.AssetId       
,C.AssetNo       
,1       
,1       
,1       
,1       
,NULL       
,NULL       
,'19'       
,GETDATE()       
,GETUTCDATE()       
,'19'       
,GETDATE()       
,GETUTCDATE()       
,B.Year       
,B.Month       
,B.IndicatorDetId           
,'' AS [FileName]      
,'' AS RemarksJOHN       
,Completed_Date      
FROM [uetrackMasterdbPreProd].[dbo].CRMRequest A       
INNER JOIN DedNCRValidationTxn B       
ON A.Indicators_all=B.IndicatorDetId       
AND YEAR(A.RequestDateTime)=B.Year       
AND MONTH(A.RequestDateTime)=B.Month       
LEFT OUTER JOIN EngAsset C       
ON A.AssetId=C.AssetId       
WHERE TypeOfRequest=10020       
AND A.ServiceId=2       
AND B.Year=@YEAR       
AND B.Month=@MONTH --- ALL THE DATA      
AND IndicatorDetId <> 5      
      
END 
GO
