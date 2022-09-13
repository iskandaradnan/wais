USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenAdjustmentTxn_GetAll]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                  
--/*========================================================================================================                      
--Application Name : UETrack-1.5                                    
--Version    : 1.0                      
--Procedure Name  : LLSLinenAdjustmentTxn_GetAll                  
--Description   : Get the LicenseType                  
--Authors    : SIDDHANT                      
--Date    : 8-JAN-2020                    
-------------------------------------------------------------------------------------------------------------                      
                      
--Unit Test:                      
--EXEC LLSLinenAdjustmentTxn_GetAll  @PageSize=10,@PageIndex=0,@StrCondition='FacilityId=144',@StrSorting='ModifiedDateUTC desc'                  
                       
-------------------------------------------------------------------------------------------------------------                      
--Version History                       
-------:------------:---------------------------------------------------------------------------------------                      
--Init : Date       : Details                      
--========================================================================================================*/                    
CREATE PROCEDURE [dbo].[LLSLinenAdjustmentTxn_GetAll]                          
                          
 @PageSize INT     = 5,                          
 @PageIndex INT     = 0,                          
 @StrCondition NVARCHAR(MAX)  = NULL,                          
 @StrSorting NVARCHAR(MAX)  = NULL                          
                          
AS                           
BEGIN                        
                          
BEGIN TRY                          
                          
-- Paramter Validation                           
                        
                        
                        
SET NOCOUNT ON;                           
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;                          
---FOR TESTING                        
                        
--DECLARE @PageSize INT= 5                          
--DECLARE @PageIndex INT=0                          
--DECLARE @StrCondition NVARCHAR(MAX)= NULL                          
--DECLARE @StrSorting NVARCHAR(MAX)= NULL                            
                        
  -- DECLARATION                         
DECLARE @countQry NVARCHAR(MAX);                          
DECLARE @qry  NVARCHAR(MAX);                          
DECLARE @condition VARCHAR(MAX);                          
DECLARE @TotalRecords INT;                          
                        
                     
-- DEFAULT VALUES                          
SET @PageIndex = @PageIndex+1                         
                        
-- EXECUTION                          
SET @countQry = 'SELECT @Total = COUNT(1)                         
                 FROM VW_LLSLinenAdjustmentTxn                          
                WHERE 1 = 1'   ---change                             
                 + '  ' +                       
CASE WHEN ISNULL(@strCondition,'' ) = '' THEN ''                       
ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END                        
                        
--PRINT @countQry                        
EXECUTE SP_EXECUTESQL @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT                          
--SELECT @TotalRecords AS [COUNT]                         
                        
SET @qry =                         
'                
SELECT            
CustomerId
,FacilityId
,LinenAdjustmentId
,[Year]
,[Month]
,DocumentNo
,DocumentDate
,AuthorisedBy
,[Status]
,ModifiedDate
,ModifiedDateUTC
,IsDeleted         
,@TotalRecords AS TotalRecords                  
       
FROM VW_LLSLinenAdjustmentTxn A

WHERE 1 = 1 '   --change                         
 + '  ' + CASE WHEN ISNULL('A.'+REPLACE(REPLACE(REPLACE(@strCondition,'(',''),')',''),'AND','AND A.'),'') = '' THEN ''                 
   ELSE ' AND '+ REPLACE(ISNULL('A.'+REPLACE(REPLACE(REPLACE(@strCondition,'(',''),')',''),'AND','AND A.'),''),'WHERE',' AND ')  END                           
  + ' ' + ' ORDER BY ' +  ISNULL('A.'+@strSorting,'A.ModifiedDateUTC DESC')                              
   + ' OFFSET '  + CAST((@PageSize *  (@PageIndex-1)) AS VARCHAR(500)) + ' ROWS FETCH NEXT '  + CAST(@PageSize AS VARCHAR(100)) + ' ROWS ONLY ' ;      
--PRINT @qry;                    
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
END
GO
