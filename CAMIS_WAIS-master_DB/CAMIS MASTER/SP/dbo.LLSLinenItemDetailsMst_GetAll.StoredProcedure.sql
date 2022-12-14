USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenItemDetailsMst_GetAll]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================          
--APPLICATION  : UETrack 1.5          
--NAME    : SaveUserAreaDetailsLLS         
--DESCRIPTION  : UPDATE RECORD IN [LLSLinenItemDetailsMst] TABLE           
--AUTHORS   : SIDDHANT          
--MODIFIED DATE    : 24-FEB-2021        
-------------------------------------------------------------------------------------------------------------------------          
--VERSION HISTORY           
--------------------:---------------:---------------------------------------------------------------------------------------          
--Init    : Date          : Details          
--------------------:---------------:---------------------------------------------------------------------------------------          
--SIDDHANT          : 8-JAN-2020 :           
-------:------------:----------------------------------------------------------------------------------------------------*/          
        
          



CREATE PROCEDURE [dbo].[LLSLinenItemDetailsMst_GetAll]                    
                    
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
                 FROM VW_LLSLinenItemDetailsMst                    
                  WHERE 1 = 1 '                        
                 + '  ' +                         
CASE WHEN ISNULL(@strCondition,'' ) = '' THEN ''                         
ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END                          
                  
--PRINT @countQry                  
EXECUTE SP_EXECUTESQL @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT                    
--SELECT @TotalRecords AS [COUNT]                   
                  
SET @qry =                   
'SELECT            
  CustomerId    
,FacilityId    
,LinenItemId    
,LinenCode    
,LinenDescription    
,UOM    
,Material    
,[Status]    
,EffectiveDate    
,Size    
,Colour    
,[Standard]    
,IdentificationMark  
,LinenPrice  
,ModifiedDate    
,ModifiedDateUTC    
,IsDeleted            
,@TotalRecords AS TotalRecords            
FROM  VW_LLSLinenItemDetailsMst A           
            
WHERE 1 = 1 '                          
   + '  ' + CASE WHEN ISNULL('A.'+REPLACE(REPLACE(@strCondition,'(',''),')',''),'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL('A.'+REPLACE(REPLACE(@strCondition,'(',''),')',''),''),'WHERE',' AND ')  END                            
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
