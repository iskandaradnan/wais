USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMaintenanceWorkOrderTxn_Export]    Script Date: 20-09-2021 16:56:53 ******/
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
EXEC uspFM_EngMaintenanceWorkOrderTxn_Export  @StrCondition='([Assignee] LIKE ''%MobileFE1%'')',@StrSorting=null,@pUserId=37,@pAccessLevel=308                        
EXEC uspFM_EngMaintenanceWorkOrderTxn_Export  @StrCondition='FacilityId = 144',@StrSorting=null,@pUserId=19,@pAccessLevel=0                        
                        
-----------------------------------------------------------------------------------------------------------                        
Version History                         
-----:------------:---------------------------------------------------------------------------------------                        
Init : Date       : Details                        
========================================================================================================*/                        
                        
CREATE PROCEDURE [dbo].[uspFM_EngMaintenanceWorkOrderTxn_Export]                        
                        
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
    ('[Assignee]','AssigneeName')                        
                           
                           
                        
SELECT @strCondition =  replace(@strCondition,actual_column,replace_column) from #temp_columns                        
SELECT @strSorting =  replace(@strSorting,actual_column,replace_column) from #temp_columns                        
                        
                        
IF(ISNULL(@pAccessLevel,0)=308)                        
                         
 BEGIN                        
                        
  SET @qry = 'SELECT MaintenanceWorkNo,                        
      FORMAT(MaintenanceWorkDateTime,''dd-MM-yyyy'') WorkOrderDate,                
  FORMAT(MaintenanceWorkDateTime,''hh:mm tt'') WorkOrderTime,                        
       AssetNo,                        
       AssetDescription,                        
       UserArea,                        
        -- TypeOfWorkOrder,                   
   WorkOrderCategoryType as WorkOrderCategory,                   
       TypeOfWorkOrderGrid,                        
       FORMAT(TargetDateTime,''dd-MM-yyyy hh:mm'') TargetDateTime,                        
       WorkOrderPriority,           
       WorkOrderStatus,                        
       MaintenanceDetails,                        
    
       EngineerUserName,                        
                            
MaintenanceWorkTypeValue,                        
       Model,                        
       Manufacturer,            
    Taskcode,          
    UserArea,                      
    FORMAT(ResponseDateTime,''dd-MM-yyyy'') TargetDateTime,                      
          LocationName,                        
       AssigneeName as Assignee,                        
       CountingDays as CountOfDays ,                    
    FORMAT(ResponseDateTime,''dd-MM-yyyy hh:mm'') ResponseDateTime                       
      ,ResponseDuration                    
      ,FORMAT(HandOverDate,''dd-MM-yyyy hh:mm'') HandOverDate,                    
   AssetClassificationDescription                    
     FROM [V_EngMaintenanceWorkOrderTxn_Export]                        
     WHERE 1 = 1   AND ' + 'UserRegistrationId = ' + cast(@pUserId as nvarchar(10))                           
     + '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END                          
     + ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_EngMaintenanceWorkOrderTxn_Export].ModifiedDateUTC DESC')                        
                          
  PRINT @qry;                        
                          
  EXECUTE sp_executesql @qry, N' @TotalRecords INT', @TotalRecords = @TotalRecords                        
                        
 END                        
 ELSE                        
 BEGIN                        
                        
  SET @qry = 'SELECT MaintenanceWorkNo,                        
   FORMAT(MaintenanceWorkDateTime,''dd-MM-yyyy'') WorkOrderDate,                
  FORMAT(MaintenanceWorkDateTime,''hh:mm tt'') WorkOrderTime,                        
       AssetNo,                        
       AssetDescription,                        
        -- TypeOfWorkOrder,                   
   WorkOrderCategoryType as WorkOrderCategory,                       
       FORMAT(TargetDateTime,''dd-MM-yyyy'') TargetDateTime,                        
       WorkOrderPriority,                        
       WorkOrderStatus,                        
       MaintenanceDetails,                        
                              
       EngineerUserName,                        
                             
       MaintenanceWorkTypeValue,                        
       Model,                        
       Manufacturer,              
    Taskcode,          
    UserArea,                      
       FORMAT(TargetDateTime,''dd-MM-yyyy'') TargetDateTime,                      
       LocationName,                        
       AssigneeName as Assignee,                        
       CountingDays as CountOfDays,                    
      FORMAT(ResponseDateTime,''dd-MM-yyyy hh:mm'') ResponseDateTime                       
      ,ResponseDuration                    
      ,FORMAT(HandOverDate,''dd-MM-yyyy hh:mm'') HandOverDate  ,AssetClassificationDescription                    
     FROM [V_EngMaintenanceWorkOrderTxn_Export]                        
     WHERE 1 = 1  '                        
     + '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END                          
     + ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_EngMaintenanceWorkOrderTxn_Export].ModifiedDateUTC DESC')                        
                          
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
     );                        
  THROW;                        
                   
END CATCH    
GO
