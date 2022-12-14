USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionB3_Save]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
--EXEC BEMSDeductionTxnMappingB3 2020,1    
CREATE PROCEDURE [dbo].[DeductionB3_Save]    
(    
@YEAR INT    
,@MONTH INT    
)    
    
AS    
    
BEGIN         
    
SET NOCOUNT ON                          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                          
BEGIN TRY                   
    
    
    
--DECLARE @YEAR INT     
--DECLARE @MONTH INT     
    
    
--SET @YEAR=(SELECT YEAR(GETDATE()))--2020    
--SET @MONTH=(SELECT MONTH(GETDATE()))--4    
    


DELETE FROM DedGenerationTxnDet WHERE YEAR=@YEAR AND MONTH=@MONTH AND IndicatorDetId IN (3)
DELETE FROM DedTransactionMappingTxn WHERE YEAR=@YEAR AND MONTH=@MONTH AND IndicatorDetId IN (3)
DELETE FROM DedTransactionMappingTxnDet WHERE YEAR=@YEAR AND MONTH=@MONTH AND IndicatorDetId IN (3)    
    
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
            
FROM FinMonthlyFeeTxnDet            
WHERE [Year]=@YEAR            
AND [Month]=@MONTH    
    
    
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
,3 AS IndicatorDetId            
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
,UptimeAchieved    
,TypeCode    
,TRPIUptime    
)            
          
          
          
          
SELECT           
 157 AS CustomerId            
,144 AS FacilityId            
,NULL AS DedTxnMappingId            
,NULL AS MaintenanceWorkDateTime          
,NULL AS MaintenanceWorkNo          
,NULL AS Details          
,AssetNo          
,AssetTypeDescription            
,'Scheduled Work Order' AS ScreenName--Unschduleworkorder            
,DemeritPointValue1+DemeritPointValue2 AS DemeritPoint            
,NULL AS FinalDemeritPoint            
,1 AS IsValid---'Y'            
,NULL AS DisputedPendingResolution ----update            
,NULL AS Remarks            
,TotalProHawkDeduction AS DeductionValue            
,19 AS CreatedBy            
,GETDATE() AS CreatedDate            
,GETUTCDATE() AS CreatedDateUTC            
,19 AS ModifiedBy            
,GETDATE() AS ModifiedDate            
,GETUTCDATE() AS ModifiedDateUTC            
,@YEAR AS [YEAR]            
,@MONTH AS [MONTH]            
,3 AS IndicatorDetId            
,'B3' AS IndicatorName            
,NULL AS FLAG     
,CurrentUptime    
,AssetTypeCode    
,TargetUptime    
FROM DeductionB3Base          
WHERE YEAR=@YEAR
AND Month=@MONTH
    
--------------UPDATING TXNID            
            
--SELECT B.DedTxnMappingId,A.IndicatorDetId,A.YEAR,A.MONTH             
UPDATE A            
SET A.DedTxnMappingId=B.DedTxnMappingId            
FROM DedTransactionMappingTxnDet A            
INNER JOIN  DedTransactionMappingTxn B            
ON A.IndicatorDetId=B.IndicatorDetId      
AND A.YEAR=B.Year            
AND A.MONTH=B.Month            
WHERE A.IndicatorDetId=3         
          
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
FROM DedTransactionMappingTxnDet            
WHERE [YEAR]=@YEAR            
AND [MONTH]=@MONTH--CHANGE            
AND IndicatorDetId=3          
GROUP BY IndicatorDetId,[YEAR],[MONTH]            
            
            
UPDATE A            
SET A.DedGenerationId=B.DedGenerationId            
FROM DedGenerationTxnDet A             
INNER JOIN DedGenerationTxn B            
ON A.[Year]=B.[Year]            
AND A.[Month]=B.[Month]            
WHERE A.IndicatorDetId=3          
    
    
END TRY                              
BEGIN CATCH                              
                              
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                              
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                              
                              
THROW                              
                              
END CATCH                              
SET NOCOUNT OFF                              
END 
GO
