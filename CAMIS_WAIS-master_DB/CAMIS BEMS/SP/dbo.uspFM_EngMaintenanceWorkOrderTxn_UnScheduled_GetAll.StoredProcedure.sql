USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMaintenanceWorkOrderTxn_UnScheduled_GetAll]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================                          
Application Name : UETrack-BEMS                                        
Version    : 1.0                          
Procedure Name  : uspFM_EngMaintenanceWorkOrderTxn_UnScheduled_GetAll                          
Description   : Get the Asset Standardization details                          
Authors    : Dhilip V                          
Date    : 16-May-2018                          
-----------------------------------------------------------------------------------------------------------                          
                          
Unit Test:                          
EXEC uspFM_EngMaintenanceWorkOrderTxn_UnScheduled_GetAll  @PageSize=100,@PageIndex=5,@StrCondition='FacilityId = 144',@StrSorting=null,@pUserId=19,@pAccessLevel   =0                          
                          
-----------------------------------------------------------------------------------------------------------                          
Version History                           
-----:------------:---------------------------------------------------------------------------------------                          
Init : Date       : Details                          
========================================================================================================*/                          
                          
CREATE PROCEDURE [dbo].[uspFM_EngMaintenanceWorkOrderTxn_UnScheduled_GetAll]                          
                          
 @PageSize  INT,                          
 @PageIndex  INT,                          
 @StrCondition NVARCHAR(MAX) = NULL,                          
 @StrSorting  NVARCHAR(MAX) = NULL,                           
 @pUserId  INT     = NULL,                          
 @pAccessLevel INT     = NULL                          
                          
AS                           
                          
BEGIN TRY                          
                          
-- Paramter Validation                      
                  
/*made changes in where clause on 2/9/2020 */                  
                  
 --CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END                   
                          
 SET NOCOUNT ON;                           
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;                          
                          
-- Declaration                          
 DECLARE @countQry NVARCHAR(MAX);                          
 DECLARE @qry  NVARCHAR(MAX);                          
 DECLARE @condition VARCHAR(MAX);                          
 DECLARE @TotalRecords INT;                          
                          
-- Default Values                          
                          
 SET @PageIndex = @PageIndex+1  /* This is for JQ grid implementation */                          
                          
-- Execution                          
IF(ISNULL(@pAccessLevel,0)=4)                          
                           
 BEGIN                          
                          
  SET @countQry = 'SELECT @Total = COUNT(1)                          
      FROM [V_EngMaintenanceWorkOrderTxn_UnScheduled]                           
      outer apply (select UserRegistrationId as vendorUserRegistrationId from UMUserRegistration   AS Vendor   WITH(NOLOCK) where  [V_EngMaintenanceWorkOrderTxn_UnScheduled].AssignedVendorid  = Vendor.ContractorId) a                          
      WHERE 1 = 1  AND WorkOrderStatusId=386  AND' + ' a.vendorUserRegistrationId = ' + cast(@pUserId as nvarchar(10))                            
      + '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END                            
                            
  print @countQry;                          
                            
  EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT                          
  --select @TotalRecords as Counts                          
             
  SET @qry = 'SELECT WorkOrderId,                          
       MaintenanceWorkNo,                          
        CAST(MaintenanceWorkDateTime AS DATE) AS MaintenanceWorkDateTime,                             
       AssetNo,                          
       AssetDescription,    
       Department,                    
       WorkOrderCategoryGrid,                          
       WorkOrderCategoryLovId,                          
       WorkGroupCode,                     
       TargetDateTime,                          
       WorkOrderPriorityGrid,                          
       WorkOrderPriorityLovId,                          
       WorkOrderStatusGrid,                          
       MaintenanceDetails,                          
       CountingDays ,                          
     LocationName,                          
       AssigneeName as Assignee,                           
          AssessmentResponsedate,                       
       ResponseDateTime,                      
    ResponseDuration,                      
    HandOverDate,                      
  AssetClassificationDescription   ,                      
       @TotalRecords AS TotalRecords                          
     FROM [V_EngMaintenanceWorkOrderTxn_UnScheduled]  B                         
     outer apply (select UserRegistrationId as vendorUserRegistrationId from UMUserRegistration   AS Vendor   WITH(NOLOCK) where  B.AssignedVendorid  = Vendor.ContractorId) a                          
     WHERE 1 = 1 AND WorkOrderStatusId=386  AND' + ' a.vendorUserRegistrationId = ' + cast(@pUserId as nvarchar(10))                            
     + '  ' +CASE WHEN ISNULL('B.'+REPLACE(REPLACE(@strCondition,'(',''),')',''),'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL('B.'+REPLACE(REPLACE(@strCondition,'(',''),')',''),''),'WHERE',' AND ')  END                   
  + ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'B.CountingDays DESC')                          
     + ' OFFSET '  + CAST((@PageSize *  (@PageIndex-1)) AS VARCHAR(500)) + ' ROWS FETCH NEXT '  + CAST(@PageSize AS VARCHAR(100)) + ' ROWS ONLY ' ;                          
  print @qry;                          
  EXECUTE sp_executesql @qry, N' @TotalRecords INT', @TotalRecords = @TotalRecords                          
                          
 END                          
 ELSE                          
 BEGIN                          
                          
                          
  SET @countQry = 'SELECT @Total = COUNT(1)                          
      FROM [V_EngMaintenanceWorkOrderTxn_UnScheduled] B                         
      WHERE 1 = 1 '                           
     + '  ' +CASE WHEN ISNULL('B.'+REPLACE(REPLACE(@strCondition,'(',''),')',''),'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL('B.'+REPLACE(REPLACE(@strCondition,'(',''),')',''),''),'WHERE',' AND ')  END                 
                            
  print @countQry;                          
                            
  EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT                          
  --select @TotalRecords as Counts                          
                            
  SET @qry = 'SELECT WorkOrderId,                          
       MaintenanceWorkNo,               
              
        CAST(MaintenanceWorkDateTime AS DATE) AS MaintenanceWorkDateTime,                             
       AssetNo,                          
       AssetDescription,       
       Department,               
       WorkOrderCategoryGrid,                          
       WorkOrderCategoryLovId,                          
       WorkGroupCode,                          
       TargetDateTime,                          
       WorkOrderPriorityGrid,                          
       WorkOrderPriorityLovId,                          
       WorkOrderStatusGrid,                          
       MaintenanceDetails,         
       CountingDays,                          
       LocationName,                          
       AssigneeName as Assignee,                          
       AssessmentResponsedate,                          
       ResponseDateTime,                      
    ResponseDuration,                      
    HandOverDate,                      
    AssetClassificationDescription  ,                    
      @TotalRecords AS TotalRecords                          
     FROM [V_EngMaintenanceWorkOrderTxn_UnScheduled]  B                        
     WHERE 1 = 1 '                          
     + '  ' +CASE WHEN ISNULL('B.'+REPLACE(REPLACE(@strCondition,'(',''),')',''),'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL('B.'+REPLACE(REPLACE(@strCondition,'(',''),')',''),''),'WHERE',' AND ')  END                   
     + ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'CountingDays DESC')                          
     + ' OFFSET '  + CAST((@PageSize *  (@PageIndex-1)) AS VARCHAR(500)) + ' ROWS FETCH NEXT '  + CAST(@PageSize AS VARCHAR(100)) + ' ROWS ONLY ' ;                          
  print @qry;                          
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
