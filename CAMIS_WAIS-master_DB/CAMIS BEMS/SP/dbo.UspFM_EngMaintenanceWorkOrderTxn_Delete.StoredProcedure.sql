USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngMaintenanceWorkOrderTxn_Delete]    Script Date: 27-01-2022 13:06:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================      
Application Name : UETrack-BEMS                    
Version    : 1.0      
Procedure Name  : uspFM_EngMaintenanceWorkOrderTxn_Delete      
Description   : To Delete Work Order Details from EngMaintenanceWorkOrderTxn table.      
Authors    : Balaji M S      
Date    : 04-April-2018      
-----------------------------------------------------------------------------------------------------------      
      
Unit Test:      
EXEC UspFM_EngMaintenanceWorkOrderTxn_Delete  @pWorkOrderId=2      
      
-----------------------------------------------------------------------------------------------------------      
Version History       
-----:------------:---------------------------------------------------------------------------------------      
Init : Date       : Details      
========================================================================================================*/      
DROP PROCEDURE  [dbo].[UspFM_EngMaintenanceWorkOrderTxn_Delete]                                 
GO
CREATE PROCEDURE  [dbo].[UspFM_EngMaintenanceWorkOrderTxn_Delete]                                 
 @pWorkOrderId INT ,      
 @pRemarks nvarchar(max) =null
AS                                                    
      
BEGIN TRY      
      
 DECLARE @mTRANSCOUNT INT = @@TRANCOUNT      
      
 BEGIN TRANSACTION      
      
-- Paramter Validation       
      
 SET NOCOUNT ON;      
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;      
      
-- Declaration      
      
-- Default Values  
 --   If Exists(select 1 from EngMaintenanceWorkOrderTxn where WorkOrderId= @pWorkOrderId  and MaintenanceWorkCategory=187)
	--BEGIN
    Declare @OrderStatusId int

	  
	select @OrderStatusId = LovId from fmlovmst where FieldValue = 'Request for Cancellation'

    update EngMaintenanceWorkOrderTxn set WorkOrderStatus=@OrderStatusId,Remarks=@pRemarks where WorkOrderId= @pWorkOrderId 
	
	INSERT INTO EngMaintenanceWorkOrderStatusHistory(CustomerId,FacilityId,ServiceId,WorkOrderId,Status,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)                      
    SELECT CustomerId,FacilityId,ServiceId,WorkOrderId,WorkOrderStatus,CreatedBy,GETDATE(),GETUTCDATE(),CreatedBy,GETDATE(),GETUTCDATE()  
	FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId = @pWorkOrderId                      

	--END
	--ELSE
	--BEGIN
	--update EngMaintenanceWorkOrderTxn set Isdelete=1,WorkOrderStatus=143 where WorkOrderId= @pWorkOrderId 
	--END

 IF @mTRANSCOUNT = 0      
        BEGIN      
            COMMIT TRANSACTION      
        END         
      
      
END TRY      
      
BEGIN CATCH      
      
 IF @mTRANSCOUNT = 0      
        BEGIN      
            ROLLBACK TRAN      
        END      
      
-- SELECT 'This record can''t be deleted as it is referenced by another screen' AS ErrorMessage      
      
 INSERT INTO ErrorLog(      
    Spname,      
    ErrorMessage,      
    createddate)      
 VALUES(  OBJECT_NAME(@@PROCID),      
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),      
    getdate()      
     )      
      
END CATCH