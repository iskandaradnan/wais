USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMaintenanceWorkOrderTxn_UnSchedule_Export]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/*========================================================================================================  
Application Name : UETrack-BEMS                
Version    : 1.0  
Procedure Name  : uspFM_EngMaintenanceWorkOrderTxn_Export  
Description   : To export the Maintenance Work Order details  
Authors    : Dhilip V  
Date    : 16-May-2018  
-----------------------------------------------------------------------------------------------------------  
  
Unit Test:  
EXEC uspFM_EngMaintenanceWorkOrderTxn_UnSchedule_Export  @StrCondition='"([LocationName] LIKE ('%Newlocation%'))',@StrSorting=null,@pUserId=37,@pAccessLevel=4  
  
-----------------------------------------------------------------------------------------------------------  
Version History   
-----:------------:---------------------------------------------------------------------------------------  
Init : Date       : Details  
========================================================================================================*/  
  
CREATE PROCEDURE [dbo].[uspFM_EngMaintenanceWorkOrderTxn_UnSchedule_Export]  
  
 @StrCondition NVARCHAR(MAX) = NULL,  
 @StrSorting  NVARCHAR(MAX) = NULL,  
 @pUserId  INT     = NULL,  
 @pAccessLevel INT     = NULL  
  
AS   
  
BEGIN TRY  
  
-- Paramter Validation   
  
 SET NOCOUNT ON;   
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
-- Declaration  
 DECLARE @countQry NVARCHAR(MAX);  
 DECLARE @qry  NVARCHAR(MAX);  
 DECLARE @condition VARCHAR(MAX);  
 DECLARE @TotalRecords INT;  
  
-- Default Values  
  
  
-- Execution  
Create TABLE #temp_columns (actual_column varchar(500),replace_column varchar(500))  
  
  
  
    INSERT INTO #temp_columns(actual_column,replace_column) values   
    ('[LocationName]','UserLocationName')  
     
     
  
SELECT @strCondition =  replace(@strCondition,actual_column,replace_column) from #temp_columns  
SELECT @strSorting =  replace(@strSorting,actual_column,replace_column) from #temp_columns  
IF(ISNULL(@pAccessLevel,0)=4)  
   
 BEGIN  
  
  
  SET @qry = 'SELECT MaintenanceWorkNo,  
      FORMAT(MaintenanceWorkDateTime,''dd-MMM-yyyy hh:mm'') MaintenanceWorkDateTime,  
      AssessmentResponsedate,  
       AssetNo,  
       AssetDescription,  
       TypeOfWorkOrder,  
       --TargetDateTime,  
       WorkOrderPriority,  
       WorkOrderStatus,  
       MaintenanceDetails,  
       EngineerUserId,  
       EngineerUserName,  
       MaintenanceWorkType,  
       MaintenanceWorkTypeValue,  
       Model,  
       Manufacturer,  
       UserLocationName as LocationName,  
       AssigneeName as Assignee,  
       CountingDays AS CountOfDays  
     FROM [V_EngMaintenanceWorkOrderTxn_UnSchedule_Export]  
     outer apply (select UserRegistrationId as vendorUserRegistrationId from UMUserRegistration   AS Vendor   WITH(NOLOCK) where  [V_EngMaintenanceWorkOrderTxn_UnSchedule_Export].AssignedVendorid  = Vendor.ContractorId) a  
     WHERE 1 = 1  AND ' + 'a.vendorUserRegistrationId =' + cast(@pUserId as nvarchar(10))    
     + '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END    
     + ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_EngMaintenanceWorkOrderTxn_UnSchedule_Export].ModifiedDateUTC DESC')  
    
  PRINT @qry;  
    
  EXECUTE sp_executesql @qry, N' @TotalRecords INT', @TotalRecords = @TotalRecords  
  
 END  
 ELSE  
 BEGIN  
  
  SET @qry = 'SELECT MaintenanceWorkNo,  
       MaintenanceWorkDateTime,  
       AssetNo,    
       AssetDescription,       
       TypeOfWorkOrder,  
       --TargetDateTime,  
       WorkOrderPriority,  
       WorkOrderStatus,  
       MaintenanceDetails,  
       EngineerUserId,  
       EngineerUserName,  
       MaintenanceWorkType,  
       MaintenanceWorkTypeValue,  
       Model,  
       Manufacturer,  
       UserLocationName as LocationName,  
       AssigneeName as Assignee,  
       CountingDays AS CountOfDays  
     FROM [V_EngMaintenanceWorkOrderTxn_UnSchedule_Export]  
     WHERE 1 = 1 '  
     + '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END    
     + ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_EngMaintenanceWorkOrderTxn_UnSchedule_Export].ModifiedDateUTC DESC')  
    
  PRINT @qry;  
    
  EXECUTE sp_executesql @qry, N' @TotalRecords INT', @TotalRecords = @TotalRecords  
  
END  
    
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
