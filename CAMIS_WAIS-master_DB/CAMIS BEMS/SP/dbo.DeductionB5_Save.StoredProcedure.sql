USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionB5_Save]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from DedTransactionMappingTxnDet where IndicatorName='b5'    
    
    
          
--SELECT * FROM MstDedIndicatorDet          
          
--EXEC DedTransactionMappingTxnB5_Save 2020,1          
CREATE PROCEDURE [dbo].[DeductionB5_Save]          
(          
 @YEAR INT          
,@MONTH INT          
)          
          
AS          
BEGIN          
          
          
--DECLARE @YEAR INT                  
--DECLARE @MONTH INT                  
                  
--SET @YEAR=2020                  
--SET @MONTH=5                
          
    
DELETE FROM DedGenerationTxnDet WHERE YEAR=@YEAR AND MONTH=@MONTH AND IndicatorDetId IN (5)    
DELETE FROM DedTransactionMappingTxn WHERE YEAR=@YEAR AND MONTH=@MONTH AND IndicatorDetId IN (5)    
DELETE FROM DedTransactionMappingTxnDet WHERE YEAR=@YEAR AND MONTH=@MONTH AND IndicatorDetId IN (5)    
    
          
SELECT                    
 157 AS CustomerId                  
,144 AS FacilityId                  
,2 AS ServiceId                  
,[Month]                   
,[Year]                  
,BemsMSF AS MonthlyServiceFee                  
,'P' AS DeductionStatus                  
,NULL AS DocumentNo                  
,NULL AS Remarks                  
,19 AS CreatedBy                  
,GETDATE() AS CreatedDate                  
,GETUTCDATE() AS CreatedDateUTC                  
,19 AS ModifiedBy                  
,GETDATE() AS ModifiedDate                  
,GETUTCDATE() AS ModifiedDateUTC                  
                  
FROM FinMonthlyFeeTxnDet  WITH (NOLOCK)                
WHERE [Year]=@YEAR                  
AND [Month]=@MONTH-- IN (2,3,4,5)                  
          
          
          
---------------************** NEED TO RUN THE QUERY FOR EACH INDICATOR FOR EACH MONTH AND YEAR ****************-----------------------                  
                  
INSERT INTO DedTransactionMappingTxn                  
(                  
 CustomerId                  
,FacilityId                  
,ServiceId                  
,Month                  
,Year                  
,DedGenerationId                  
,IndicatorDetId                  
,CreatedBy                  
,CreatedDate                  
,CreatedDateUTC                  
,ModifiedBy                  
,ModifiedDate                  
,ModifiedDateUTC                  
,IsAdjustmentSaved                  
)                  
                  
SELECT                   
 157 AS CustomerId                  
,144 AS FacilityId                  
,2 AS ServiceId                  
,@MONTH AS Month                  
,@YEAR AS Year                  
,NULL AS DedGenerationId                  
,5 AS IndicatorDetId                  
,19 AS CreatedBy                  
,GETDATE() AS CreatedDate                  
,GETUTCDATE() AS CreatedDateUTC                  
,19 AS ModifiedBy                  
,GETDATE() AS ModifiedDate                  
,GETUTCDATE() AS ModifiedDateUTC                  
,0 AS IsAdjustmentSaved                   
          
          
          
INSERT INTO DedTransactionMappingTxnDet                  
(                  
CustomerId                  
,FacilityId                  
,DedTxnMappingId                  
,Date                  
,DocumentNo                  
,Details                  
,AssetNo                  
,AssetDescription                  
,ScreenName                  
,DemeritPoint                  
,FinalDemeritPoint                  
,IsValid                  
,DisputedDemeritPoints                  
,Remarks                  
,DeductionValue                  
,CreatedBy                  
,CreatedDate                  
,CreatedDateUTC                  
,ModifiedBy                  
,ModifiedDate                  
,ModifiedDateUTC                  
,[YEAR]                  
,[MONTH]                  
,IndicatorDetId                  
,IndicatorName                  
,FLAG            
,NameofReport          
,SubmissionDueDate          
,DateSubmitted          
,Frequency          
,ReportID      
)                  
                
                
                
                
SELECT      
 157 AS CustomerId                  
,144 AS FacilityId                  
,NULL AS DedTxnMappingId                  
,NULL AS MaintenanceWorkDateTime                
,NULL AS MaintenanceWorkNo                
,NULL AS Details                
,NULL AS AssetNo          
,NULL AS AssetDescription                  
,'B5 Dedcution' AS ScreenName--Unschduleworkorder                  
,DemeritPoint AS DemeritPoint                  
,NULL AS FinalDemeritPoint                  
,1 AS IsValid---'Y'                  
,NULL AS DisputedPendingResolution ----update                  
,NULL AS Remarks                  
,DeductionFigureProHawk AS DeductionValue                  
,19 AS CreatedBy                  
,GETDATE() AS CreatedDate                  
,GETUTCDATE() AS CreatedDateUTC                  
,19 AS ModifiedBy                  
,GETDATE() AS ModifiedDate                  
,GETUTCDATE() AS ModifiedDateUTC                  
,@YEAR AS [YEAR]                  
,@MONTH AS [MONTH]                  
,5 AS IndicatorDetId                  
,'B5' AS IndicatorName                  
,NULL AS FLAG                   
,ReportName          
,SubmissionDueDate          
,SubmissionDate          
,Frequency        
,ReportID      
FROM DeductionReportB5_Base                
WHERE Year=@YEAR    
AND MONTH=@MONTH    

--ADD BY AIDA 07022021
--DeductionReportB5_Base FETCH DATA FROM REPORT TXN MODULE ONLY
UNION ALL

SELECT      
 157 AS CustomerId                  
,144 AS FacilityId                  
,NULL AS DedTxnMappingId                  
,NULL AS MaintenanceWorkDateTime                
,NULL AS MaintenanceWorkNo                
,NULL AS Details                
,NULL AS AssetNo          
,NULL AS AssetDescription                  
,'B5 CRM Deduction' AS ScreenName                
,DemeritPoint AS DemeritPoint                  
,NULL AS FinalDemeritPoint                  
,1 AS IsValid---'Y'                  
,NULL AS DisputedPendingResolution ----update                  
,NULL AS Remarks                  
,Deduction AS DeductionValue                  
,19 AS CreatedBy                  
,GETDATE() AS CreatedDate                  
,GETUTCDATE() AS CreatedDateUTC                  
,19 AS ModifiedBy                  
,GETDATE() AS ModifiedDate                  
,GETUTCDATE() AS ModifiedDateUTC                  
,@YEAR AS [YEAR]                  
,@MONTH AS [MONTH]                  
,5 AS IndicatorDetId                  
,'B5' AS IndicatorName                  
,NULL AS FLAG                   
--,NULL AS ReportName          
,RequestNo
,SubmissionDueDate          
,SubmissionDate          
,NULL AS Frequency        
,NULL AS ReportID      
FROM DeductionDemeritPointB5CRM                
WHERE Year=@YEAR    
AND MONTH=@MONTH    


--END OF ADD BY AIDA 07022021
                
--------------UPDATING TXNID                  
                  
--SELECT B.DedTxnMappingId,A.IndicatorDetId,A.YEAR,A.MONTH                   
UPDATE A                  
SET A.DedTxnMappingId=B.DedTxnMappingId                  
FROM DedTransactionMappingTxnDet A  WITH (NOLOCK)                
INNER JOIN  DedTransactionMappingTxn B    WITH (NOLOCK)              
ON A.IndicatorDetId=B.IndicatorDetId                  
AND A.YEAR=B.Year                  
AND A.MONTH=B.Month                  
WHERE A.IndicatorDetId=5               
                
INSERT INTO DedGenerationTxnDet                  
(                  
 CustomerId                  
,FacilityId                  
,ServiceId                  
,DedGenerationId                  
,IndicatorDetId                  
,TotalParameter                  
,DeductionValue                  
,DeductionPercentage                  
,TransactionDemeritPoint                  
,NcrDemeritPoint                  
,SubParameterDetId                  
,PostTransactionDemeritPoint                  
,PostNcrDemeritPoint                  
,Remarks                  
,keyIndicatorValue                  
,Ringittequivalent                  
,GearingRatio                  
,PostDeductionValue                  
,PostDeductionPercentage                  
,CreatedBy                  
,CreatedDate                  
,CreatedDateUTC                  
,ModifiedBy                  
,ModifiedDate                  
,ModifiedDateUTC                  
,[Year]                  
,[Month]                  
)                  
SELECT                   
 157 AS CustomerId                  
,144 AS FacilityId                  
,2 AS ServiceId                  
,NULL AS DedGenerationId--CHANGE                  
,IndicatorDetId                  
,0 AS TotalParameter                  
,SUM(DeductionValue) AS DeductionValue                  
,0 AS DeductionPercentage                  
,SUM(DemeritPoint) AS TransactionDemeritPoint                  
,0 AS NcrDemeritPoint                  
,NULL AS SubParameterDetId                  
,0 AS PostTransactionDemeritPoint                  
,0 AS PostNcrDemeritPoint                  
,NULL AS Remarks                  
,NULL AS keyIndicatorValue                  
,NULL AS Ringittequivalent                  
,NULL AS GearingRatio                  
,NULL AS PostDeductionValue                  
,NULL AS PostDeductionPercentage                  
,19 AS CreatedBy                  
,GETDATE() AS CreatedDate                  
,GETUTCDATE() AS CreatedDateUTC                  
,19 AS ModifiedBy                  
,GETDATE() AS ModifiedDate                  
,GETUTCDATE() AS ModifiedDateUTC                  
,[Year]                  
,[Month]                  
--IndicatorDetId,[YEAR],[MONTH],SUM(DeductionValue) AS DeductionValue                   
FROM DedTransactionMappingTxnDet WITH (NOLOCK)                 
WHERE [YEAR]=@YEAR                  
AND [MONTH]=@MONTH--CHANGE                  
AND IndicatorDetId=5                
GROUP BY IndicatorDetId,[YEAR],[MONTH]                  
                  
                  
UPDATE A                  
SET A.DedGenerationId=B.DedGenerationId                  
FROM DedGenerationTxnDet A  WITH (NOLOCK)                 
INNER JOIN DedGenerationTxn B   WITH (NOLOCK)               
ON A.[Year]=B.[Year]                  
AND A.[Month]=B.[Month]                  
WHERE A.IndicatorDetId=5          
          
END
GO
