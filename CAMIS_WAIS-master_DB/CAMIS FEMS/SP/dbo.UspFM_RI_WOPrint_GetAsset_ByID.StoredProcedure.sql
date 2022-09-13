USE UetrackFemsdbPreProd
GO
DROP PROCEDURE  [dbo].[UspFM_RI_WOPrint_GetAsset_ByID]                               
GO
CREATE PROCEDURE  [dbo].[UspFM_RI_WOPrint_GetAsset_ByID]                               
(@WorkOrderNo INT )
AS                                                  
    
BEGIN TRY    
        
 SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;    
 
   
   select M.MaintenanceWorkNo,M.WorkOrderId,'ANNUALLY' AS Frequency,L.UserAreaCode,U.UserLocationCode as LocationCode,
   A.AssetNo,A.AssetDescription,A.Model,A.SerialNo 
   from EngMaintenanceWorkOrderTxn M
   JOIN MstLocationUserArea L ON M.Userareaid=L.Userareaid
   JOIN EngAsset A ON A.UserAreaid=L.Userareaid
   LEFT JOIN MstLocationUserLocation U ON M.UserLocationId=U.UserLocationId 
   where M.MaintenanceWorkNo=@WorkOrderNo
    --M.WorkOrderId=28115
	
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