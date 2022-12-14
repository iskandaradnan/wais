USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[EngMaintainceWorkOrderMigrationFEMS]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC EngMaintainceWorkOrderMigrationFEMS          
CREATE PROCEDURE [dbo].[EngMaintainceWorkOrderMigrationFEMS]          
AS          
          
BEGIN                          
SET NOCOUNT ON                          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                          
BEGIN TRY                   
          
          
IF OBJECT_ID('tempdb.dbo.#TEMP_WO', 'U') IS NOT NULL              
DROP TABLE #TEMP_WO          
          
          
-----PUTTING THE DATA IN THE TEMP TABLE           
          
SELECT *           
INTO #TEMP_WO          
FROM EngMaintenanceWorkOrderTxn          
WHERE MIGRATED_DATA=1          
          
          
          
---160 RECORDS INSERTED IN WORK OREDR TABLE FEMS          
--19 RECORDS INSERTED IN WORK OREDR TABLE  BEMS           
INSERT INTO EngMaintenanceWorkOrderTxn          
(          
          
          
CustomerId          
,FacilityId          
,ServiceId          
,AssetId          
,MaintenanceWorkNo          
,MaintenanceDetails          
,MaintenanceWorkCategory          
,MaintenanceWorkType          
,TypeOfWorkOrder          
,QRCode          
,MaintenanceWorkDateTime          
,TargetDateTime          
,EngineerUserId          
,RequestorUserId          
,WorkOrderPriority          
,Image1FMDocumentId          
,Image2FMDocumentId          
,Image3FMDocumentId          
,PlannerId          
,WorkGroupId          
,WorkOrderStatus          
,PlannerHistoryId          
,Remarks          
,CreatedBy          
,CreatedDate          
,CreatedDateUTC          
,ModifiedBy          
,ModifiedDate          
,ModifiedDateUTC          
,BreakDownRequestId          
,WOAssignmentId          
,UserAreaId          
,UserLocationId          
,StandardTaskDetId          
,AssignedUserId          
,AssigneeLovId          
,RescheduleRemarks          
,PreviousTargetDateTime          
,MobileGuid          
,Field1          
,Field2          
,Field3          
,Field4          
,Field5          
,Field6          
,Field7          
,Field8          
,Field9          
,Field10          
,WOImage          
,WOVideo          
,IsDelete          
,MIGRATED_DATA          
          
          
)          
SELECT           
157 AS CustomerId          
,144 AS FacilityId          
,1 AS ServiceId          
,B.AssetId AS AssetId          
,A.wr_no AS MaintenanceWorkNo          
,A.details AS MaintenanceDetails          
,188 AS MaintenanceWorkCategory          
,273 AS MaintenanceWorkType          
,273 AS TypeOfWorkOrder          
,NULL AS QRCode          
,wr_date AS MaintenanceWorkDateTime          
,NULL AS TargetDateTime          
,387 AS EngineerUserId          
,387 AS RequestorUserId          
,CASE WHEN priority_flag='N' THEN 227 ELSE 228 END AS  WorkOrderPriority          
,NULL AS Image1FMDocumentId          
,NULL AS Image2FMDocumentId          
,NULL AS Image3FMDocumentId          
,NULL AS PlannerId          
,1 AS WorkGroupId          
,195 AS WorkOrderStatus          
,NULL AS PlannerHistoryId          
,NULL AS Remarks          
,387 AS CreatedBy          
,GETDATE() AS CreatedDate          
,GETUTCDATE() AS CreatedDateUTC          
,387 AS ModifiedBy          
,GETDATE() AS ModifiedDate          
,GETUTCDATE() AS ModifiedDateUTC          
,NULL AS BreakDownRequestId          
,NULL AS WOAssignmentId          
,NULL AS UserAreaId          
,NULL AS UserLocationId          
,NULL AS StandardTaskDetId          
,NULL AS AssignedUserId          
,NULL AS AssigneeLovId          
,NULL AS RescheduleRemarks          
,NULL AS PreviousTargetDateTime          
,NULL AS MobileGuid          
,NULL AS Field1          
,NULL AS Field2          
,NULL AS Field3          
,NULL AS Field4          
,NULL AS Field5          
,NULL AS Field6          
,NULL AS Field7          
,NULL AS Field8          
,NULL AS Field9          
,NULL AS Field10          
,NULL AS WOImage          
,NULL AS WOVideo          
,NULL AS IsDelete           
,1 AS MIGRATED_DATA          
FROM [10.249.116.8].[eng_ipoh].[DBO].ENG_WORK_REQUEST_HDR A WITH(NOLOCK)          
INNER JOIN EngAsset B          
--ON A.asset_no=B.AssetNo          
ON A.asset_no COLLATE SQL_Latin1_General_CP1_CI_AS =B.AssetNo COLLATE SQL_Latin1_General_CP1_CI_AS          
--WHERE WG_CODE IN ('BMED','INVB')----THESE FOR BEMS--          
WHERE WG_CODE IN ('CIVL'          
,'MECH'          
,'ELEC'          
,'eFEMS'          
,'INVT')          
          
AND STATUS IN ('C','P')     
AND TYPE='BD'          
--AND CAST(end_date AS DATE)=CAST(GETDATE() AS DATE)          
AND A.WR_NO NOT IN (SELECT MaintenanceWorkNo COLLATE SQL_Latin1_General_CP1_CI_AS FROM #TEMP_WO)          
          
          
          
INSERT INTO EngMwoCompletionInfoTxn          
(          
CustomerId          
,FacilityId          
,ServiceId          
,WorkOrderId          
,RepairDetails          
,PPMAgreedDate          
,PPMAgreedDateUTC          
,StartDateTime          
,StartDateTimeUTC          
,EndDateTime          
,EndDateTimeUTC          
,HandoverDateTime          
,HandoverDateTimeUTC          
,CompletedBy          
,AcceptedBy          
,[Signature]          
,ServiceAvailability          
,LoanerProvision          
,HandoverDelay          
,DowntimeHoursMin          
,CauseCode          
,QCCode          
,ResourceType          
,LabourCost          
,PartsCost          
,ContractorCost          
,TotalCost          
,ContractorId          
,ContractorHours          
,PartsRequired          
,Approved          
,AppType          
,CreatedBy          
,CreatedDate          
,CreatedDateUTC          
,ModifiedBy          
,ModifiedDate          
,ModifiedDateUTC          
,RepairHours          
,ProcessStatus          
,ProcessStatusDate          
,ProcessStatusReason          
,RunningHours          
,VendorCost          
,MobileGuid          
,DownTimeHours          
,WOSignature          
,CustomerFeedback          
,EMPLOYEE_ID          
)          
          
SELECT           
CustomerId          
,FacilityId          
,ServiceId          
,WorkOrderId          
,B.action_taken AS RepairDetails          
,NULL AS PPMAgreedDate          
,NULL AS PPMAgreedDateUTC          
,B.[start_date] AS StartDateTime          
,B.[start_date] AS StartDateTimeUTC          
,B.end_date AS EndDateTime          
,B.end_date AS EndDateTimeUTC          
,NULL AS HandoverDateTime          
,NULL AS HandoverDateTimeUTC          
,387 AS CompletedBy          
,387 AS AcceptedBy  -----AS DEFAULT HTA USER          
,NULL AS [Signature]          
,NULL AS ServiceAvailability          
,NULL AS LoanerProvision          
,NULL AS HandoverDelay          
,NULL AS DowntimeHoursMin          
,NULL AS CauseCode          
,NULL AS QCCode          
,NULL AS ResourceType          
,B.labour_cost AS LabourCost          
,B.parts_cost AS PartsCost          
,B.contractor_cost AS ContractorCost          
,B.labour_cost + B.parts_cost + B.contractor_cost AS TotalCost          
,NULL AS ContractorId          
,NULL AS ContractorHours          
,NULL AS PartsRequired          
,NULL AS Approved          
,NULL AS AppType          
,CreatedBy          
,CreatedDate          
,CreatedDateUTC          
,ModifiedBy          
,ModifiedDate          
,ModifiedDateUTC          
,NULL AS RepairHours          
,NULL AS ProcessStatus          
,NULL AS ProcessStatusDate          
,NULL AS ProcessStatusReason          
,NULL AS RunningHours          
,NULL AS VendorCost          
,NULL AS MobileGuid          
,NULL AS DownTimeHours          
,NULL AS WOSignature          
,NULL AS CustomerFeedback          
,C.EMPLOYEE_ID          
FROM EngMaintenanceWorkOrderTxn A          
INNER JOIN [10.249.116.8].[eng_ipoh].[DBO].ENG_WORK_REQUEST_HDR B          
ON A.MaintenanceWorkNo COLLATE SQL_Latin1_General_CP1_CI_AS=B.WR_NO COLLATE SQL_Latin1_General_CP1_CI_AS          
INNER JOIN [10.249.116.8].[eng_ipoh].[DBO].eng_wr_completion_det C          
ON B.WR_NO=C.WR_NO          
          
--WHERE WG_CODE IN ('BMED','INVB')          
WHERE WG_CODE IN ('CIVL'          
,'MECH'          
,'ELEC'          
,'eFEMS'          
,'INVT')          
          
AND STATUS IN ('C','P')          
AND TYPE='BD'          
AND A.MIGRATED_DATA=1          
AND B.WR_NO NOT IN (SELECT MaintenanceWorkNo COLLATE SQL_Latin1_General_CP1_CI_AS FROM #TEMP_WO)          
AND CAST(CreatedDate AS DATE)=CAST(GETDATE() AS date)          
--AND CAST(end_date AS DATE)=CAST(GETDATE() AS DATE)          
          
          
          
INSERT INTO EngMwoCompletionInfoTxnDet          
(          
          
CustomerId          
,FacilityId          
,ServiceId          
,CompletionInfoId          
,UserId          
,StandardTaskDetId          
,StartDateTime          
,StartDateTimeUTC          
,EndDateTime          
,EndDateTimeUTC          
,RepairHours          
,CreatedBy          
,CreatedDate          
,CreatedDateUTC          
,ModifiedBy          
,ModifiedDate          
,ModifiedDateUTC          
,LabourCost          
,MobileGuid          
)          
          
SELECT           
CustomerId          
,FacilityId          
,ServiceId          
,CompletionInfoId          
,387 AS UserId          
,NULL AS StandardTaskDetId          
,StartDateTime          
,StartDateTimeUTC          
,EndDateTime          
,EndDateTimeUTC          
,RepairHours          
,CreatedBy          
,CreatedDate          
,CreatedDateUTC          
,ModifiedBy          
,ModifiedDate          
,ModifiedDateUTC          
,LabourCost          
,MobileGuid          
FROM EngMwoCompletionInfoTxn          
WHERE CompletionInfoId NOT IN (SELECT CompletionInfoId FROM EngMwoCompletionInfoTxnDet)          
          
          
INSERT INTO EngMaintenanceWorkOrderStatusHistory          
(          
CustomerId          
,FacilityId          
,ServiceId          
,WorkOrderId          
,Status          
,CreatedBy          
,CreatedDate          
,CreatedDateUTC          
,ModifiedBy          
,ModifiedDate          
,ModifiedDateUTC          
)          
SELECT           
CustomerId          
,FacilityId          
,ServiceId          
,WorkOrderId          
,195 AS [Status]          
,CreatedBy          
,CreatedDate          
,CreatedDateUTC          
,ModifiedBy          
,ModifiedDate          
,ModifiedDateUTC          
FROM EngMaintenanceWorkOrderTxn          
WHERE MIGRATED_DATA=1          
AND CAST(CreatedDate AS DATE)=CAST(GETDATE() AS DATE)          
          
          
          
          
INSERT INTO EngMwoAssesmentTxn          
(          
CustomerId          
,FacilityId          
,ServiceId    ,WorkOrderId          
,UserId          
,Justification          
,ResponseDateTime          
,ResponseDateTimeUTC          
,ResponseDuration          
,CreatedBy          
,CreatedDate          
,CreatedDateUTC          
,ModifiedBy          
,ModifiedDate          
,ModifiedDateUTC          
,AssetRealtimeStatus          
,TargetDateTime          
,IsChangeToVendor          
,AssignedVendor          
,FMvendorApproveStatus          
,Signature          
)          
SELECT           
CustomerId          
,FacilityId          
,ServiceId          
,WorkOrderId          
,387 AS UserId          
,D.assessment_details AS Justification          
,D.[date] AS ResponseDateTime          
,D.[date] AS ResponseDateTimeUTC          
,CAST(DATEPART(HOUR, D.[date] - MaintenanceWorkDateTime) AS VARCHAR(10))           
+':'+          
CASE WHEN CAST(DATEPART(MINUTE, D.[date] - MaintenanceWorkDateTime) AS VARCHAR(10)) IN           
(1,2,3,4,5,6,7,8,9)  THEN CONCAT('0',CAST(DATEPART(MINUTE, D.[date] - MaintenanceWorkDateTime) AS VARCHAR(10)))          
ELSE CAST(DATEPART(MINUTE, D.[date] - MaintenanceWorkDateTime) AS VARCHAR(10))          
END AS ResponseDuration          
,CreatedBy          
,CreatedDate          
,CreatedDateUTC          
,ModifiedBy          
,ModifiedDate          
,ModifiedDateUTC          
,55 AS AssetRealtimeStatus          
,TargetDateTime          
,100 AS IsChangeToVendor          
,NULL AS AssignedVendor          
,NULL AS FMvendorApproveStatus          
,NULL AS Signature          
FROM EngMaintenanceWorkOrderTxn A          
INNER JOIN [10.249.116.8].[eng_ipoh].[DBO].eng_wr_assessment_details D          
ON A.MaintenanceWorkNo COLLATE SQL_Latin1_General_CP1_CI_AS=D.WR_NO COLLATE SQL_Latin1_General_CP1_CI_AS          
WHERE MIGRATED_DATA=1          
AND CAST(CreatedDate AS DATE)=CAST(GETDATE() AS DATE)       
          
          
          
INSERT INTO EngMwoAssesmentFeedbackHistory          
(          
AssesmentId          
,WorkOrderId          
,FeedBack          
,ResponseDateTime          
,ResponseDuration          
,DoneBy          
,DoneDate          
,CreatedBy          
,CreatedDate          
,CreatedDateUTC          
,ModifiedBy          
,ModifiedDate          
,ModifiedDateUTC          
)          
SELECT          
A.AssesmentId          
,A.WorkOrderId          
,A.Justification AS FeedBack          
,A.ResponseDateTime AS ResponseDateTime          
,A.ResponseDuration AS  ResponseDuration          
,387 AS DoneBy          
,NULL AS DoneDate          
,A.CreatedBy          
,A.CreatedDate          
,A.CreatedDateUTC          
,A.ModifiedBy          
,A.ModifiedDate          
,A.ModifiedDateUTC           
FROM EngMwoAssesmentTxn A          
INNER JOIN EngMaintenanceWorkOrderTxn C          
ON A.WorkOrderId=C.WorkOrderId          
--INNER JOIN [10.249.116.8].[eng_ipoh].[DBO].eng_wr_assessment_details D          
--ON C.MaintenanceWorkNo COLLATE SQL_Latin1_General_CP1_CI_AS=D.WR_NO COLLATE SQL_Latin1_General_CP1_CI_AS          
WHERE MIGRATED_DATA=1          
AND CAST(A.CreatedDate AS DATE)=CAST(GETDATE() AS DATE)          
          
          
          
-----NEED TO RIGHT THE UPDATE QUERY--------          
          
--SELECT * FROM EngMaintenanceWorkOrderTxn          
--WHERE EngineerUserId IS NULL          
          
--WORKORDER TABLE          
--SELECT A.MaintenanceWorkNo,A.EngineerUserId,B.EMPLOYEE_ID,C.UserRegistrationId           
UPDATE A          
SET A.EngineerUserId=C.UserRegistrationId          
FROM EngMaintenanceWorkOrderTxn A          
INNER JOIN [10.249.116.8].[eng_ipoh].[DBO].eng_wr_completion_det B          
ON A.MaintenanceWorkNo COLLATE SQL_Latin1_General_CP1_CI_AS =B.WR_NO COLLATE SQL_Latin1_General_CP1_CI_AS          
INNER JOIN UMUserRegistration C          
ON C.Employee_ID COLLATE SQL_Latin1_General_CP1_CI_AS =B.Employee_ID COLLATE SQL_Latin1_General_CP1_CI_AS          
WHERE MIGRATED_DATA=1          
AND CAST(A.CreatedDate AS DATE)=CAST(GETDATE() AS DATE)          
          
          
          
--SELECT *           
UPDATE A          
SET A.CompletedBy=B.UserRegistrationId          
FROM EngMwoCompletionInfoTxn A          
INNER JOIN UMUserRegistration B          
ON A.Employee_ID=B.Employee_ID          
WHERE CAST(A.CreatedDate AS DATE)=CAST(GETDATE() AS DATE)          
          
          
          
--SELECT A.*           
UPDATE A          
SET A.UserId=B.CompletedBy          
FROM EngMwoCompletionInfoTxnDet A          
INNER JOIN EngMwoCompletionInfoTxn B          
ON A.CompletionInfoId=B.CompletionInfoId          
WHERE CAST(A.CreatedDate AS DATE)=CAST(GETDATE() AS DATE)          
          
          
          
--SELECT A.WorkOrderId,A.UserId,D.assessed_by,C.UserRegistrationId           
          
UPDATE A          
SET A.UserId=C.UserRegistrationId          
FROM EngMwoAssesmentTxn A          
INNER JOIN EngMaintenanceWorkOrderTxn B          
ON A.WorkOrderId=B.WorkOrderId          
INNER JOIN [10.249.116.8].[eng_ipoh].[DBO].eng_wr_assessment_details D          
ON B.MaintenanceWorkNo COLLATE SQL_Latin1_General_CP1_CI_AS=D.WR_NO COLLATE SQL_Latin1_General_CP1_CI_AS          
INNER JOIN UMUserRegistration C          
ON C.Employee_ID COLLATE SQL_Latin1_General_CP1_CI_AS=D.assessed_by COLLATE SQL_Latin1_General_CP1_CI_AS          
WHERE B.MIGRATED_DATA=1          
AND CAST(B.CreatedDate AS DATE)=CAST(GETDATE() AS DATE)          
          
          
          
          
--SELECT *           
UPDATE B          
SET B.DoneBy=A.UserId          
FROM EngMwoAssesmentTxn A          
INNER JOIN EngMwoAssesmentFeedbackHistory B          
ON A.AssesmentId=B.AssesmentId          
WHERE CAST(B.CreatedDate AS DATE)=CAST(GETDATE() AS DATE)          
          
UPDATE A      
SET A.AssignedUserId=B.UserId      
FROM EngMaintenanceWorkOrderTxn A      
INNER JOIN EngMwoAssesmentTxn B      
ON A.WorkOrderId=B.WorkOrderId      
WHERE MIGRATED_DATA=1      
      
        
-------AFTER INSERT SEND EMAIL        
        
EXEC SendMailWorkOrderFEMS        
      
-- --------------IF ASSIGNE OR COMPLETED BY IS BLANK    
     
EXEC WorkOrderUserMappingIssueFEMS    
      
    
          
END TRY                          
BEGIN CATCH                          
                          
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                          
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                          
                          
THROW                          
                          
END CATCH                          
SET NOCOUNT OFF                          
END 
GO
