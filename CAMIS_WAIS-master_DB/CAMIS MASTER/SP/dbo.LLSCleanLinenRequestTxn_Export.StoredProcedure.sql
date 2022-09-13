USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenRequestTxn_Export]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                          
--/*========================================================================================================                              
--Application Name : UETrack-1.5                                            
--Version    : 1.0                              
--Procedure Name  : LLSCleanLinenRequestTxn_Export                          
--Description   : LLSCleanLinenRequestTxn_Export                          
--Authors    : SIDDHANT                              
--Date    : 15-JAN-2020                            
-------------------------------------------------------------------------------------------------------------                              
                              
--Unit Test:                              
--EXEC LLSCleanLinenRequestTxn_Export  @StrCondition='FacilityId=144',@StrSorting='ModifiedDateUTC desc'                          
                               
-------------------------------------------------------------------------------------------------------------                              
--Version History                               
-------:------------:---------------------------------------------------------------------------------------                              
--Init : Date       : Details                              
--========================================================================================================*/                            
CREATE PROCEDURE [dbo].[LLSCleanLinenRequestTxn_Export]                                  
                                  
                    
 @StrCondition NVARCHAR(MAX)  = NULL,                                  
 @StrSorting NVARCHAR(MAX)  = NULL                                  
                                  
AS                                   
BEGIN                                
                                  
BEGIN TRY                                  
                                  
-- Paramter Validation                                   
                                
                                
                                
SET NOCOUNT ON;                                   
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;                                  
---FOR TESTING                                
                                
--DECLARE @StrCondition NVARCHAR(MAX)= NULL                                  
--DECLARE @StrSorting NVARCHAR(MAX)= NULL                                    
                                
  -- DECLARATION                                 
DECLARE @countQry NVARCHAR(MAX);                                  
DECLARE @qry  NVARCHAR(MAX);                                  
DECLARE @condition VARCHAR(MAX);                                  
DECLARE @TotalRecords INT;                                  
                                
                             
                                
-- EXECUTION                                  
SET @countQry = 'SELECT @Total = COUNT(1)                                 
                 FROM VW_LLSCleanLinenRequestTxn                                  
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
 DocumentNo        
,RequestDateTime        
,UserAreaCode        
,UserLocationCode        
,RequestedBy        
,[Priority]        
,IssueStatus        
,TotalItemRequested  
FROM VW_LLSCleanLinenRequestTxn A            
WHERE 1 = 1 '   --change                            
   + ' ' + CASE WHEN ISNULL('A.'+REPLACE(REPLACE(@strCondition,'(',''),')',''),'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL('A.'+REPLACE(REPLACE(@strCondition,'(',''),')',''),''),'WHERE',' AND ')  END                        
   + ' ' + ' ORDER BY ' +  ISNULL('A.'+@strSorting,'A.ModifiedDateUTC DESC')                              
      
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
