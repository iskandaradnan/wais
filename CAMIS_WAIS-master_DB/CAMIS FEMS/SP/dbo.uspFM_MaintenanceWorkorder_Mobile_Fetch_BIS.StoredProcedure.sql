USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MaintenanceWorkorder_Mobile_Fetch_BIS]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                
                
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
    
      
        
          
            
            
              
                
/*========================================================================================================                
Application Name : UETrack-BEMS                              
Version    : 1.0                
Procedure Name  : [uspFM_EngAsset_Mobile_Fetch_BIS]                
Description   : Asset number info                
Authors    : deepak A                
Date    : 13-Aug-2018                
-----------------------------------------------------------------------------------------------------------                
                
Unit Test:                
EXEC [uspFM_MaintenanceWorkorder_Mobile_Fetch_BIS]                
-----------------------------------------------------------------------------------------------------------                
Version History                 
-----:------------:---------------------------------------------------------------------------------------                
Init : Date       : Details                
========================================================================================================*/                
CREATE PROCEDURE  [dbo].[uspFM_MaintenanceWorkorder_Mobile_Fetch_BIS]                                           
                                            
             
              
                
AS                                                              
                
BEGIN TRY                
                
-- Paramter Validation                 
                
 SET NOCOUNT ON;                 
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;                
                
-- Declaration                
                
 DECLARE @TotalRecords INT                
                
-- Default Values                
                
                
-- Execution                
  select EngMaintenanceWorkOrderTxn.WorkOrderId, MaintenanceWorkNo,Lovval.FieldValue as Status,Lovvals.FieldValue as Priority,MaintenanceWorkDateTime,EngMaintenanceWorkOrderTxn.Module, COALESCE(BISN.Email_sent, 0) as Email_sent  from EngMaintenanceWorkOrderTxn       
  Left join FMLovMst as Lovval on      
   Lovval.LovId=EngMaintenanceWorkOrderTxn.WorkOrderStatus       
   Left join FMLovMst as Lovvals on      
   Lovvals.LovId=EngMaintenanceWorkOrderTxn.WorkOrderPriority      
   Left join BIS_Notification as BISN on  BISN.BISWOID =EngMaintenanceWorkOrderTxn.WorkOrderId      
    where EngMaintenanceWorkOrderTxn.Isbis=1        
               
  select  COUNT(EngMaintenanceWorkOrderTxn.WorkOrderStatus) as Total,WorkOrderStatus,Lovvals.FieldValue from EngMaintenanceWorkOrderTxn Left join FMLovMst as Lovvals on      
   Lovvals.LovId=EngMaintenanceWorkOrderTxn.WorkOrderStatus where EngMaintenanceWorkOrderTxn.Isbis=1        
    group by EngMaintenanceWorkOrderTxn.WorkOrderStatus,Lovvals.FieldValue order by EngMaintenanceWorkOrderTxn.WorkOrderStatus          
              
                
END TRY                
                
BEGIN CATCH                
                
 INSERT INTO ErrorLog(                
    Spname,                
    ErrorMessage,                
    createddate)                
 VALUES(  OBJECT_NAME(@@PROCID),                
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),                
    getdate()                
     )                
                
END CATCH
GO
