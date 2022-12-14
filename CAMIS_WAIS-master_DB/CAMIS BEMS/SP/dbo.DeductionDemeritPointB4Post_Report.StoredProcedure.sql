USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionDemeritPointB4Post_Report]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Text    
--EXEC DeductionDemeritPointB4Post_Report 2020,8             
            
/*TargetDateTime is PPM Agreed date in the Screen*/            
            
              
CREATE PROCEDURE [dbo].[DeductionDemeritPointB4Post_Report]              
(              
 @YEAR INT              
,@MONTH INT              
              
)              
              
              
AS              
              
BEGIN                            
SET NOCOUNT ON                            
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                            
BEGIN TRY                     
              
              
--SELECT * FROM #TEMP_MAIN              
--WHERE MaintenanceWorkNo IN               
--(              
--'PMWWAC/B/2021/000037'              
--,'PMWWAC/B/2020/003539'              
--,'PMWWAC/B/2020/003946'              
              
--)              
              
              
--SELECT * FROM EngMaintenanceWorkOrderTxn A              
--WHERE MaintenanceWorkNo IN (SELECT MaintenanceWorkNo FROM #TEMP_MAIN)              
--AND ISNULL(A.PreviousTargetDateTime,'')<>''              
              
              
SELECT AssetNo
,AssetId
,AssetDescription
,PurchaseCostRM
,MaintenanceWorkNo
,MaintenanceWorkDateTime
,WarrantyStatus
,UserAreaCode
,ScheduleDate
,ReScheduleDate
,StartDateTime
,DeductionFigurePerAsset
,DemeritPointPost
,ValidateStatusPost
,DeductionRMPost
,Category
,Remarks
,7thDaytoStart
,EndDateTime
,Year
,Month 
FROM DeductionDemeritPointB4_Base 
WHERE Year=@YEAR AND Month=@MONTH           
              
END TRY                            
BEGIN CATCH                            
                            
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                            
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                            
                            
THROW                            
                            
END CATCH                            
SET NOCOUNT OFF                            
END 
GO
