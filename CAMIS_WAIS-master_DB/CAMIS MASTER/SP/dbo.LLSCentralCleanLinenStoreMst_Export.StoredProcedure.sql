USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCentralCleanLinenStoreMst_Export]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*========================================================================================================                      
--Application Name : UETrack-1.5                                    
--Version    : 1.0                      
--Procedure Name  : LLSCentralCleanLinenStoreMst_Export                      
--Description   : LLSCentralCleanLinenStoreMst_Export                      
--Authors    : SIDDHANT                      
--Date    : 15-Apr-2020                    
-------------------------------------------------------------------------------------------------------------                      
                      
--Unit Test:                      
--EXEC LLSCentralCleanLinenStoreMst_Export  @StrCondition='FacilityId=144',@StrSorting=null                      
                      
-------------------------------------------------------------------------------------------------------------                      
--Version History                       
-------:------------:---------------------------------------------------------------------------------------                      
--Init : Date       : Details                      
--========================================================================================================*/                      
                      
CREATE PROCEDURE [dbo].[LLSCentralCleanLinenStoreMst_Export]                      
                      
   
 @StrCondition NVARCHAR(MAX)  = NULL,                      
 @StrSorting NVARCHAR(MAX)  = NULL                      
                      
AS                       
BEGIN                    
                    
                    
BEGIN TRY                      
                      
-- Paramter Validation                       
                    
                    
                    
SET NOCOUNT ON;                       
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;                      
---FOR TESTING                    
                    
--DECLARE @StrCondition NVARCHAR(MAX)= 'FacilityId=144'                      
--DECLARE @StrSorting NVARCHAR(MAX)= NULL                        
                    
  -- DECLARATION                     
DECLARE @countQry NVARCHAR(MAX);                      
DECLARE @qry  NVARCHAR(MAX);                      
DECLARE @condition VARCHAR(MAX);                      
DECLARE @TotalRecords INT;                      
                    
                    
                    
                    
-- EXECUTION                      
SET @countQry = 'SELECT @Total = COUNT(1)                     
                 FROM VW_LLSCentralCleanLinenStoreMst                      
                WHERE 1 = 1 '                             
                 + '  ' +                           
CASE WHEN ISNULL(@strCondition,'' ) = '' THEN ''                           
ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END                              
                    
--PRINT @countQry                    
EXECUTE SP_EXECUTESQL @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT                      
--SELECT @TotalRecords AS [COUNT]                     
                    
SET @qry =                     
'                    
SELECT                          
 StoreType     
,@TotalRecords AS TotalRecords                                
                    
FROM VW_LLSCentralCleanLinenStoreMst A                     
WHERE 1 = 1 '                             
   + '  ' + CASE WHEN ISNULL('A.'+REPLACE(REPLACE(REPLACE(@strCondition,'(',''),')',''),'AND','AND A.'),'') = '' THEN ''         
   ELSE ' AND '+ REPLACE(ISNULL('A.'+REPLACE(REPLACE(REPLACE(@strCondition,'(',''),')',''),'AND','AND A.'),''),'WHERE',' AND ')  END                              
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
    'ERROR_LINE: '+CONVERT(VARCHAR(10), ERROR_LINE())+' - '+ERROR_MESSAGE(),                      
    GETDATE()                      
     )                      
                      
END CATCH                      
END             
            
--select * from LLSCentralCleanLinenStoreMst 
GO
