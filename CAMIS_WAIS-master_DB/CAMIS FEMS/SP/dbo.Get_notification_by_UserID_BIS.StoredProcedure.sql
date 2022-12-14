USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Get_notification_by_UserID_BIS]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
-- Exec [Get_notification_by_UserID_BIS] '383     
    
    
CREATE PROCEDURE  [dbo].[Get_notification_by_UserID_BIS]                               
    
(    
 @pID int  
  
    
)          
    
AS          
    
BEGIN    
SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
BEGIN TRY    
select FENotification.NotificationAlerts,FENotification.DocumentId,EngMaintenanceWorkOrderTxn.WorkOrderId,FENotification.CreatedDate from FENotification left join EngMaintenanceWorkOrderTxn on FENotification.DocumentId=EngMaintenanceWorkOrderTxn.MaintenanceWorkNo where EngMaintenanceWorkOrderTxn.Isbis=1 and FENotification.UserId= @pID   
  
    
    
     
    
    
    
    
END TRY    
BEGIN CATCH    
    
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)    
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());    
    
THROW    
    
END CATCH    
SET NOCOUNT OFF    
END
GO
