USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[EngMaintenanceWorkOrderTxnPPMOpenMigration]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
--EXEC EngMaintenanceWorkOrderTxnPPMOpenMigration    
    
CREATE PROCEDURE [dbo].[EngMaintenanceWorkOrderTxnPPMOpenMigration]    
    
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
,192 AS WorkOrderStatus    
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
WHERE B.FLAG='OPEN'    
---AND CAST(B.created_date AS DATE)=CAST(GETDATE() AS DATE)  --FOR INCREMENTAL    
AND B.WR_NO NOT IN (SELECT MaintenanceWorkNo COLLATE SQL_Latin1_General_CP1_CI_AS FROM #TEMP_WO)    
    
    
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
WHERE MIGRATED_DATA=1 AND CAST(CreatedDate AS DATE)=CAST(GETDATE() AS DATE)  
AND A.MaintenanceWorkNo NOT IN (SELECT MaintenanceWorkNo FROM #TEMP_WO)    
  
  
  
    
END  
  
  
  
  
GO
