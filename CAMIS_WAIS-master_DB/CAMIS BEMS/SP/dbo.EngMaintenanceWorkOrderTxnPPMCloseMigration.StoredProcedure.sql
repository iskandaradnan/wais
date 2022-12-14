USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[EngMaintenanceWorkOrderTxnPPMCloseMigration]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROCEDURE [dbo].[EngMaintenanceWorkOrderTxnPPMCloseMigration]  
AS  
BEGIN  
  
IF OBJECT_ID('tempdb.dbo.#TEMP_WO  ', 'U') IS NOT NULL        
DROP TABLE #TEMP_WO   
  
  
SELECT *   
INTO #TEMP_WO  
FROM EngMaintenanceWorkOrderTxn  
WHERE MIGRATED_DATA=1  
  
  
  
  
  
  
-----160 RECORDS INSERTED IN WORK OREDR TABLE FEMS  
----19 RECORDS INSERTED IN WORK OREDR TABLE  BEMS   
  
--SELECT * FROM EngMaintenanceWorkOrderTxn WHERE CAST(CreatedDate AS DATE)=CAST(GETDATE() AS DATE) AND WorkOrderStatus=195  
  
  
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
,A.AssetId AS AssetId  
,B.wr_no AS MaintenanceWorkNo  
,B.details AS MaintenanceDetails  
,187 AS MaintenanceWorkCategory  
,34 AS MaintenanceWorkType  
,34 AS TypeOfWorkOrder  
,NULL AS QRCode  
,wr_date AS MaintenanceWorkDateTime  
,B.CurrentTargetDate AS TargetDateTime  
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
,B.PreviousTargetDate AS PreviousTargetDateTime  
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
FROM EngAsset A  
INNER JOIN PPMWorkOrderMigrationBaseData B  
ON A.AssetNo COLLATE SQL_Latin1_General_CP1_CI_AS=B.asset_no COLLATE SQL_Latin1_General_CP1_CI_AS  
WHERE B.FLAG='CLOSE'  
---AND CAST(B.created_date AS DATE)=CAST(GETDATE() AS DATE)  --FOR INCREMENTAL  
AND B.WR_NO NOT IN (SELECT MaintenanceWorkNo COLLATE SQL_Latin1_General_CP1_CI_AS FROM #TEMP_WO)  
  
  
  
  
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
,ppm_agreed_date AS PPMAgreedDate  
,ppm_agreed_date AS PPMAgreedDateUTC  
,B.[start_date] AS StartDateTime  
,B.[start_date] AS StartDateTimeUTC  
,B.end_date AS EndDateTime  
,B.end_date AS EndDateTimeUTC  
,handover_date AS HandoverDateTime  
,handover_date AS HandoverDateTimeUTC  
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
,B.EmployeeID  
FROM EngMaintenanceWorkOrderTxn A  
INNER JOIN PPMWorkOrderMigrationBaseData B  
ON A.MaintenanceWorkNo COLLATE SQL_Latin1_General_CP1_CI_AS=B.wr_no COLLATE SQL_Latin1_General_CP1_CI_AS  
WHERE B.FLAG='CLOSE'  
AND CAST(A.createddate AS DATE)=CAST(GETDATE() AS date)---FOR INCREMENTAL  
AND CAST(B.end_date AS DATE)=CAST(GETDATE() AS DATE)--FOR INCREMENTAL  
  

 
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
,remarks
)  
  
SELECT   
CustomerId  
,FacilityId  
,ServiceId  
,CompletionInfoId  
,387 AS UserId  
,NULL AS StandardTaskDetId  
,ISNULL(StartDateTime,HandoverDateTime)  
,ISNULL(StartDateTimeUTC,HandoverDateTime)  
,ISNULL(EndDateTime,HandoverDateTime)  
,ISNULL(EndDateTimeUTC,HandoverDateTime)  
,RepairHours  
,CreatedBy  
,CreatedDate  
,CreatedDateUTC  
,ModifiedBy  
,ModifiedDate  
,ModifiedDateUTC  
,LabourCost  
,MobileGuid  
,case when ISNULL(StartDateTime,'')='' then 'Hand over date updated as Start Date as Its Is Blank' else 'ok' end 
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
 A.CustomerId  
,A.FacilityId  
,A.ServiceId  
,A.WorkOrderId  
,195 AS [Status]  
,A.CreatedBy  
,A.CreatedDate  
,A.CreatedDateUTC  
,A.ModifiedBy  
,A.ModifiedDate  
,A.ModifiedDateUTC  
FROM EngMaintenanceWorkOrderTxn A  
WHERE MIGRATED_DATA=1  
AND CAST(A.CreatedDate AS DATE)=CAST(GETDATE() AS DATE)  
AND A.WorkOrderId NOT IN (SELECT B.WorkOrderId FROM EngMaintenanceWorkOrderStatusHistory B)  
  
  
  
  
  
  
INSERT INTO EngMwoReschedulingTxn    
(    
 CustomerId    
,FacilityId    
,ServiceId    
,WorkOrderId    
,RescheduleDate    
,RescheduleDateUTC    
,RescheduleApprovedBy    
,Reasons    
,ImpactSchedulePlanner    
,CreatedBy    
,CreatedDate    
,CreatedDateUTC    
,ModifiedBy    
,ModifiedDate    
,ModifiedDateUTC    
,Remarks    
,AcceptedBy    
,Signature    
,Reason    
)    
    
SELECT     
CustomerId    
,FacilityId    
,ServiceId    
,WorkOrderId    
,A.TargetDateTime  AS RescheduleDate    
,A.TargetDateTime AS RescheduleDateUTC    
,NULL AS RescheduleApprovedBy    
,NULL AS Reasons    
,1 AS ImpactSchedulePlanner    
,CreatedBy    
,CreatedDate    
,CreatedDateUTC    
,ModifiedBy    
,ModifiedDate    
,ModifiedDateUTC    
,Remarks    
,NULL AS AcceptedBy -----CLOSE WE NEED TO UPDATE     
,NULL AS Signature    
,NULL AS Reason    
FROM EngMaintenanceWorkOrderTxn A     
WHERE MIGRATED_DATA=1   
AND CAST(CreatedDate AS DATE)=CAST(GETDATE() AS DATE)    
AND A.MaintenanceWorkNo NOT IN (SELECT MaintenanceWorkNo FROM #TEMP_WO)      
  
  
  
  
  
UPDATE A  
SET A.EngineerUserId=C.UserRegistrationId  
FROM EngMaintenanceWorkOrderTxn A  
INNER JOIN [10.249.116.8].[eng_ipoh].[DBO].eng_wr_completion_det B  
ON A.MaintenanceWorkNo COLLATE SQL_Latin1_General_CP1_CI_AS =B.WR_NO COLLATE SQL_Latin1_General_CP1_CI_AS  
INNER JOIN UMUserRegistration C  
ON C.Employee_ID COLLATE SQL_Latin1_General_CP1_CI_AS =B.Employee_ID COLLATE SQL_Latin1_General_CP1_CI_AS  
WHERE MIGRATED_DATA=1  
AND CAST(A.CreatedDate AS DATE)=CAST(GETDATE() AS DATE)  
  
  
UPDATE A  
SET A.CompletedBy=B.UserRegistrationId  
FROM EngMwoCompletionInfoTxn A  
INNER JOIN UMUserRegistration B  
ON A.Employee_ID=B.Employee_ID  
WHERE CAST(A.CreatedDate AS DATE)=CAST(GETDATE() AS DATE)  
  
  
UPDATE A  
SET A.UserId=B.CompletedBy  
FROM EngMwoCompletionInfoTxnDet A  
INNER JOIN EngMwoCompletionInfoTxn B  
ON A.CompletionInfoId=B.CompletionInfoId  
WHERE CAST(A.CreatedDate AS DATE)=CAST(GETDATE() AS DATE)  
  
END  
GO
