USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenRepairTxn_GetAll]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
          
                
--/*========================================================================================================                    
--Application Name : UETrack-1.5                                  
--Version    : 1.0                    
--Procedure Name  : LLSLinenRepairTxn_GetAll                
--Description   : Get the LLSLinenRepairTxn                
--Authors    : SIDDHANT                    
--Date    : 8-JAN-2020                  
-------------------------------------------------------------------------------------------------------------                    
                    
--Unit Test:                    
--EXEC LLSLinenRepairTxn_GetAll  @PageSize=10,@PageIndex=0,@StrCondition='FacilityId=144',@StrSorting='ModifiedDateUTC desc'                
                     
-------------------------------------------------------------------------------------------------------------                    
--Version History                     
-------:------------:---------------------------------------------------------------------------------------                    
--Init : Date       : Details                    
--========================================================================================================*/                  
CREATE PROCEDURE [dbo].[LLSLinenRepairTxn_GetAll]                        
                        
 @PageSize INT,                        
 @PageIndex INT,                        
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
--DECLARE @StrCondition NVARCHAR(MAX)= 'FacilityId=10'                        
--DECLARE @StrSorting NVARCHAR(MAX)= 'ModifiedDateUTC desc'                            
                      
  -- DECLARATION                       
DECLARE @countQry NVARCHAR(MAX);                        
DECLARE @qry  NVARCHAR(MAX);                        
DECLARE @condition VARCHAR(MAX);                        
DECLARE @TotalRecords INT;                        
                      
                   
-- DEFAULT VALUES                        
SET @PageIndex = @PageIndex+1                       
                      
-- EXECUTION                        
SET @countQry = 'SELECT @Total = COUNT(1)                       
                 FROM VW_LLSLinenRepairTxn                         
                WHERE 1 = 1'   ---change                  
                 + '  ' +                   
CASE WHEN ISNULL(@strCondition,'' ) = '' THEN ''                   
ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END                          
                      
--PRINT @countQry                      
EXECUTE SP_EXECUTESQL @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT                        
--SELECT @TotalRecords AS [COUNT]                       
-- @TotalRecords AS TotalRecords             
                      
            
SET @qry =                       
'SELECT          
 CustomerId
,FacilityId
,LinenRepairId
,DocumentNo
,DocumentDate
,RepairedBy
,CheckBy
,Remarks
,ModifiedDate
,ModifiedDateUTC
,IsDeleted
,@TotalRecords AS TotalRecords             
FROM VW_LLSLinenRepairTxn A      
WHERE 1 = 1 '   --change                  
   + '  ' + CASE WHEN ISNULL('A.'+REPLACE(REPLACE(@strCondition,'(',''),')',''),'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL('A.'+REPLACE(REPLACE(@strCondition,'(',''),')',''),''),'WHERE',' AND ')  END                      
   + ' ' + ' ORDER BY ' +  ISNULL('A.'+@strSorting,'A.ModifiedDateUTC DESC')                    
   + ' OFFSET '  + CAST((@PageSize *  (@PageIndex-1)) AS VARCHAR(500)) + ' ROWS FETCH NEXT '  + CAST(@PageSize AS VARCHAR(100)) + ' ROWS ONLY ' ;                    
                 
--print @qry;                
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
