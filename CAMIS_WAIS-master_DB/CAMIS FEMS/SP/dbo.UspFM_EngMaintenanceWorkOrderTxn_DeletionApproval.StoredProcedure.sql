USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngMaintenanceWorkOrderTxn_Delete]    Script Date: 27-01-2022 14:43:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================      
Application Name : UETrack-BEMS                    
Version    : 1.0      
Procedure Name  : UspFM_EngMaintenanceWorkOrderTxn_DeletionApproval      
Description   : To Delete Work Order Details from EngMaintenanceWorkOrderTxn table based on Approval.      
Authors    : Balaganesh     
Date    : 27-Jan-2022
-----------------------------------------------------------------------------------------------------------      
      
Unit Test:      
EXEC UspFM_EngMaintenanceWorkOrderTxn_DeletionApproval  @pWorkOrderId=2 ,  @pWorkOrderStatus=1   
      
-----------------------------------------------------------------------------------------------------------      
Version History       
-----:------------:---------------------------------------------------------------------------------------      
Init : Date       : Details      
========================================================================================================*/      
DROP PROCEDURE  [dbo].[UspFM_EngMaintenanceWorkOrderTxn_DeletionApproval]  
GO
CREATE PROCEDURE  [dbo].[UspFM_EngMaintenanceWorkOrderTxn_DeletionApproval]                                 
 @pWorkOrderId INT       ,
 @pRemarks       NVARCHAR(500) = NULL,
 @pWorkOrderStatus     INT    = NULL
AS                                                    
      
BEGIN TRY      
      
 DECLARE @mTRANSCOUNT INT = @@TRANCOUNT      
      
 BEGIN TRANSACTION      
      
-- Paramter Validation       
      
 SET NOCOUNT ON;      
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;      
      
-- Declaration      
      
      
-- Default Values   
	IF @pRemarks='Approve'
	BEGIN
	update EngMaintenanceWorkOrderTxn set Isdelete=1,WorkOrderStatus=143 where WorkOrderId= @pWorkOrderId 
	END
    ELSE
      BEGIN
	  Declare @OrderHistoryId int
	  Declare @Prevstatusid int

	  set @OrderHistoryId = (select top 1 WorkOrderHistoryId from EngMaintenanceWorkOrderStatusHistory where WorkOrderid= @pWorkOrderId and Status =(
	  select LovId from fmlovmst where FieldValue = 'Request for Cancellation') order by WorkOrderHistoryId asc)

	  select @Prevstatusid = status from EngMaintenanceWorkOrderStatusHistory where WorkOrderId=@pWorkOrderId and WorkOrderHistoryId<@OrderHistoryId

	  if isnull(@Prevstatusid,0)<1
	  begin
	  set @Prevstatusid=192
	  end

	  update EngMaintenanceWorkOrderTxn set WorkOrderStatus=@Prevstatusid,Remarks=@pRemarks where WorkOrderId= @pWorkOrderId 
		END
-- Execution      
  
      
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
      
 SELECT 'This record can''t be deleted as it is referenced by another screen' AS ErrorMessage      
      
 INSERT INTO ErrorLog(      
    Spname,      
    ErrorMessage,      
    createddate)      
 VALUES(  OBJECT_NAME(@@PROCID),      
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),      
    getdate()      
     )      
      
END CATCH