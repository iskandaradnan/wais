USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequest_GetAll]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
      
      
      
/*========================================================================================================      
Application Name : UETrack-BEMS                    
Version    : 1.0      
Procedure Name  : uspFM_CRMRequest_GetAll      
Description   : Get the all CRMRequests.      
Authors    : Dhilip V      
Date    : 20-April-2018      
-----------------------------------------------------------------------------------------------------------      
      
Unit Test:      
EXEC uspFM_CRMRequest_GetAll  @PageSize=10,@PageIndex=0,@StrCondition='RequestStatusValue=''Open''',@StrSorting=null      
      
      
-----------------------------------------------------------------------------------------------------------      
Version History       
-----:------------:---------------------------------------------------------------------------------------      
Init : Date       : Details      
========================================================================================================*/      
      
CREATE PROCEDURE [dbo].[uspFM_CRMRequest_GetAll]      
      
 @PageSize  INT,      
 @PageIndex  INT,      
 @StrCondition NVARCHAR(MAX) = NULL,      
 @StrSorting  NVARCHAR(MAX) = NULL      
      
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
      
 SET @PageIndex = @PageIndex+1  /* This is for JQ grid implementation */      
      
-- Execution      
      
      
SET @countQry = 'SELECT @Total = COUNT(1)      
    FROM [V_CRMRequest]      
    WHERE 1 = 1 '       
    + '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END        
      
print @countQry;      
      
EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT      
--select @TotalRecords as Counts      
      
SET @qry = 'SELECT (CRMRequestId+900000000) as CRMRequestId,      
     RequestNo,      
     RequestDateTime,      
     TypeOfRequestVal ,      
     RequestStatusValue AS RequestStatusValue,      
     IsWorkOrder,      
     ModifiedDateUTC,      
     ReqStaffId,      
     ReqStaff,      
     Model,      
     Manufacturer,      
     @TotalRecords AS TotalRecords,'''' as AssetNo,'''' as AssetId      
   FROM [V_CRMRequest]      
   WHERE 1 = 1 '       
   + '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END        
   + ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_CRMRequest].ModifiedDateUTC DESC')      
   + ' OFFSET '  + CAST((@PageSize *  (@PageIndex-1)) AS VARCHAR(500)) + ' ROWS FETCH NEXT '  + CAST(@PageSize AS VARCHAR(100)) + ' ROWS ONLY ' ;      
print @qry;      
EXECUTE sp_executesql @qry, N' @TotalRecords INT', @TotalRecords = @TotalRecords      
       
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
