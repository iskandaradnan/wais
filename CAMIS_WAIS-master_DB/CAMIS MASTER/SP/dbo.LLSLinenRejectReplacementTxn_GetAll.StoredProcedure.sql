USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenRejectReplacementTxn_GetAll]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                          
--/*========================================================================================================                              
--Application Name : UETrack-1.5                                            
--Version    : 1.0                              
--Procedure Name  : LLSLinenRejectReplacementTxn_GetAll                          
--Description   : Get the LLSLinenRejectReplacementTxn_GetAll                          
--Authors    : SIDDHANT                              
--Date    : 16-JAN-2020                            
-------------------------------------------------------------------------------------------------------------                              
                              
--Unit Test:                              
--EXEC LLSLinenRejectReplacementTxn_GetAll  @PageSize=10,@PageIndex=0,@StrCondition='FacilityId=144',@StrSorting='ModifiedDateUTC desc'                          
                               
-------------------------------------------------------------------------------------------------------------                              
--Version History                               
-------:------------:---------------------------------------------------------------------------------------                              
--Init : Date       : Details                              
--========================================================================================================*/                            
CREATE PROCEDURE [dbo].[LLSLinenRejectReplacementTxn_GetAll]                                  
                                  
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
                 FROM VW_LLSLinenRejectReplacementTxn                        
                 WHERE 1 = 1'   ---change                         
                 + '  ' +                       
CASE WHEN ISNULL(@strCondition,'' ) = '' THEN ''                       
ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END                          
                      
--PRINT @countQry                      
EXECUTE SP_EXECUTESQL @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT                               
    
SET @qry =                                 
'                        
 SELECT              
 CustomerId
,FacilityId
,LinenRejectReplacementId
,[Month]
,[DateTime]
,DocumentNo
,CLINo
,UserAreaCode
,UserLocationCode
,ModifiedDate
,ModifiedDateUTC
,IsDeleted
,TotalQuantityRejected
,TotalQuantityReplaced
,@TotalRecords AS TotalRecords                      
                      
                      
FROM VW_LLSLinenRejectReplacementTxn A                 
WHERE 1 = 1 '   --change                         
 + '  ' + CASE WHEN ISNULL('A.'+REPLACE(REPLACE(REPLACE(@strCondition,'(',''),')',''),'AND','AND A.'),'') = '' THEN ''           
ELSE ' AND '+ REPLACE(ISNULL('A.'+REPLACE(REPLACE(REPLACE(@strCondition,'(',''),')',''),'AND','AND A.'),''),'WHERE',' AND ')  END                     
+ ' ' + ' ORDER BY ' +  ISNULL('A.'+@strSorting,'A.ModifiedDateUTC DESC')                              
   + ' OFFSET '  + CAST((@PageSize *  (@PageIndex-1)) AS VARCHAR(500)) + ' ROWS FETCH NEXT '  + CAST(@PageSize AS VARCHAR(100)) + ' ROWS ONLY ' ;                           
--PRINT @qry;                 
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
