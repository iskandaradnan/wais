USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenInventoryTxn_Export]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                            
                              
--/*========================================================================================================                                  
--Application Name : UETrack-1.5                                                
--Version    : 1.0                                  
--Procedure Name  : LLSLinenInventoryTxn_Export                                 
--Description   : Export Data                                  
--Authors    : SIDDHANT                                  
--Date    : 15-Apr-2020                          
-------------------------------------------------------------------------------------------------------------                                  
                                  
--Unit Test:                                  
--EXEC LLSLinenInventoryTxn_Export  @StrCondition='FacilityId=10',@StrSorting='ModifiedDateUTC desc'                              
                                  
-------------------------------------------------------------------------------------------------------------                                  
--Version History                                   
-------:------------:---------------------------------------------------------------------------------------                                  
--Init : Date       : Details                                  
--========================================================================================================*/                                
CREATE PROCEDURE [dbo].[LLSLinenInventoryTxn_Export]                                      
                                      
 @StrCondition NVARCHAR(MAX)  = NULL,                                      
 @StrSorting NVARCHAR(MAX)  = NULL                                      
                                      
AS                                       
BEGIN                                    
                                      
BEGIN TRY                                      
                                      
-- Paramter Validation                                       
                                    
                                    
                                    
SET NOCOUNT ON;                                       
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;                                      
---FOR TESTING                                    
                                    
--DECLARE @StrCondition NVARCHAR(MAX)= 'FacilityId=10'                                      
--DECLARE @StrSorting NVARCHAR(MAX)= NULL                                        
                                    
  -- DECLARATION                                     
DECLARE @countQry NVARCHAR(MAX);                                      
DECLARE @qry  NVARCHAR(MAX);                                      
DECLARE @condition VARCHAR(MAX);                                      
DECLARE @TotalRecords INT;                                      
                                    
                                    
-- EXECUTION                                      
SET @countQry = 'SELECT @Total = COUNT(1)                                     
                 FROM VW_LLSLinenInventoryTxn                                     
                  WHERE 1 = 1'                                       
                 + '  ' +                                     
CASE WHEN ISNULL(@strCondition,'' ) = '' THEN ''                                     
ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END                                        
                                    
--PRINT @countQry     
EXECUTE SP_EXECUTESQL @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT                                      
--SELECT @TotalRecords AS [COUNT]                                     
                                    
SET @qry =                   
'SELECT                      
 [Year]    
,[Month]    
,StoreType    
,DocumentNo    
,[Date]      
,TotalPcs                       
                                                             
FROM VW_LLSLinenInventoryTxn A    
WHERE 1 = 1 '                             
 + '  ' + CASE WHEN ISNULL('A.'+REPLACE(REPLACE(REPLACE(@strCondition,'(',''),')',''),'AND','AND A.'),'') = '' THEN ''                     
   ELSE ' AND '+ REPLACE(ISNULL('A.'+REPLACE(REPLACE(REPLACE(@strCondition,'(',''),')',''),'AND','AND A.'),''),'WHERE',' AND ')  END                               
  + ' ' +'                      
 ORDER BY ' +  ISNULL('A.'+@strSorting,'A.ModifiedDateUTC DESC')                                          
  
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
