USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenIssueTxn_Export]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                          
--/*========================================================================================================                              
--Application Name : UETrack-1.5                                            
--Version    : 1.0                              
--Procedure Name  : LLSCleanLinenIssueTxn_Export                          
--Description   : LLSCleanLinenIssueTxn_Export                          
--Authors    : SIDDHANT                              
--Date    : 15-Apr-2020                            
-------------------------------------------------------------------------------------------------------------                              
                              
--Unit Test:                              
--EXEC LLSCleanLinenIssueTxn_Export  @StrCondition='FacilityId=144',@StrSorting='ModifiedDateUTC desc'                          
                               
-------------------------------------------------------------------------------------------------------------                              
--Version History                               
-------:------------:---------------------------------------------------------------------------------------                              
--Init : Date       : Details                              
--========================================================================================================*/                            
CREATE PROCEDURE [dbo].[LLSCleanLinenIssueTxn_Export]                                  
                                                
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
                                
                                                
                                
-- EXECUTION                                  
SET @countQry = 'SELECT @Total = COUNT(1)                                 
                 FROM VW_LLSCleanLinenIssueTxn                                  
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
  FORMAT(DeliveryDate1st ,''dd MMMM,yyyy hh:mm tt'')  DeliveryDate1st            
,CLINo              
,CLRNo              
,[Priority]              
,UserAreaCode              
,UserLocationCode              
,ReceivedBy              
,DeliveredBy              
,TotalItemRequested              
,TotalItemIssued              
,TotalItemShortfall          
        
,TotalBagRequested        
,TotalBagIssued        
,TotalBagShortfall       
,TotalWeight            
                   
FROM VW_LLSCleanLinenIssueTxn A                  
  WHERE 1 = 1 '                                       
 + '  ' + CASE WHEN ISNULL('A.'+REPLACE(REPLACE(REPLACE(@strCondition,'(',''),')',''),'AND','AND A.'),'') = '' THEN ''                               
   ELSE ' AND '+ REPLACE(ISNULL('A.'+REPLACE(REPLACE(REPLACE(@strCondition,'(',''),')',''),'AND','AND A.'),''),'WHERE',' AND ')  END                                         
  + ' ' + '  ORDER BY ' +  ISNULL('A.'+@strSorting,'A.ModifiedDateUTC DESC')                                         
            
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
