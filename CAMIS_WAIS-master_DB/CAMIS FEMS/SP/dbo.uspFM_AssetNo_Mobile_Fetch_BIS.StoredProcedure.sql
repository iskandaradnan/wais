USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_AssetNo_Mobile_Fetch_BIS]    Script Date: 20-09-2021 16:56:52 ******/
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
EXEC [uspFM_MaintenanceWorkNo_Mobile_Fetch_BIS]  @pMaintenanceWorkNo='FMWR/WCH/202003/000015'        
-----------------------------------------------------------------------------------------------------------          
Version History           
-----:------------:---------------------------------------------------------------------------------------          
Init : Date       : Details          
========================================================================================================*/          
CREATE PROCEDURE  [dbo].[uspFM_AssetNo_Mobile_Fetch_BIS]                                     
                                      
  @pAssetNo   NVARCHAR(100) = NULL        
        
          
AS                                                        
          
BEGIN TRY          
          
-- Paramter Validation           
          
 SET NOCOUNT ON;           
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;          
          
-- Declaration          
          
 DECLARE @TotalRecords INT          
 DECLARE @pAssetId INT          
-- Default Values          
      --select * from EngMaintenanceWorkOrderTxn    
   set @pAssetId =( select AssetId from EngAsset where AssetNo= @pAssetNo)  
          
-- Execution          
  select MaintenanceWorkNo,Lovval.FieldValue as Status,Lovvals.FieldValue as Priority ,EngMaintenanceWorkOrderTxn.CreatedDate as CreatedDate from EngMaintenanceWorkOrderTxn Left join FMLovMst as Lovval on Lovval.LovId=EngMaintenanceWorkOrderTxn.WorkOrderStatus Left join FMLovMst as Lovvals on Lovvals.LovId=EngMaintenanceWorkOrderTxn.WorkOrderPriority      
 where EngMaintenanceWorkOrderTxn.AssetId=@pAssetId and Isbis=1        
        
        
          
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
