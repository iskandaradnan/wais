USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSUserAreaDetailsLinenItemMstDet_GetAll (OLD)]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*========================================================================================================  
--Application Name : UETrack-1.5                
--Version    : 1.0  
--Procedure Name  : LLSUserAreaDetailsLinenItemMstDetGetAllSP  
--Description   : Get the Area details  
--Authors    : SIDDHANT  
--Date    : 19-DEC-2019
-------------------------------------------------------------------------------------------------------------  
  
--Unit Test:  
--EXEC LLSUserAreaDetailsLinenItemMstDetGetAllSP  @PageSize=10,@PageIndex=0,@StrCondition='LevelName=''adasd''',@StrSorting=null  
  
-------------------------------------------------------------------------------------------------------------  
--Version History   
-------:------------:---------------------------------------------------------------------------------------  
--Init : Date       : Details  
--========================================================================================================*/  
  
CREATE PROCEDURE [dbo].[LLSUserAreaDetailsLinenItemMstDet_GetAll (OLD)]  
  
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
                 FROM [DBO].[LLSUserAreaDetailsLinenItemMstDet]  
                 WHERE 1 = 1 '   
                 + '  ' + 
CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' 
ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END    

--PRINT @countQry
EXECUTE SP_EXECUTESQL @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT  
--SELECT @TotalRecords AS [COUNT] 

SET @qry = 
'SELECT
 C.UserAreaId
,C.UserLocationId
,A.LinenItemId
,B.Par1
,B.Par2
,B.DefaultIssue
,B.AgreedShelfLevel
FROM
 dbo.LLSLinenItemDetailsMst A
INNER JOIN dbo.LLSUserAreaDetailsLinenItemMstDet B
ON A.LinenItemId = B.LinenItemId
INNER JOIN dbo.MstLocationUserLocation C
ON B.UserLocationId= C.UserLocationId 
WHERE 1=1'   
   + '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END    
   + ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[LLSUserAreaDetailsLinenItemMstDet].ModifiedDateUTC DESC')  
   + ' OFFSET '  + CAST((@PageSize *  (@PageIndex-1)) AS VARCHAR(500)) + ' ROWS FETCH NEXT '  + CAST(@PageSize AS VARCHAR(100)) + ' ROWS ONLY ' ;  
PRINT @qry;  
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
GO
