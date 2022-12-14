USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenInventoryTxn_FetchUserAreaCode]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC [LLSLinenInventoryTxn_FetchUserAreaCode] 'L',144,1,5                
                
CREATE PROCEDURE [dbo].[LLSLinenInventoryTxn_FetchUserAreaCode]                   
(                    
 @UserAreaCode VARCHAR(50),                
 @pFacilityId INT,      
 @pPageIndex    INT,         
 @pPageSize    INT         
      
)                    
                     
AS                     
                    
-- Exec [GetUserRole]                     
                    
--/*=====================================================================================================================                    
--APPLICATION  : UETrack                    
--NAME    : LLSLinenInventoryTxn_FetchUserAreaCode                    
--DESCRIPTION  : GET USER ROLE FOR THE GIVEN ID                    
--AUTHORS   : SIDDHANT                    
--DATE    : 13-FEB-2020              
-------------------------------------------------------------------------------------------------------------------------                    
--VERSION HISTORY                     
--------------------:---------------:---------------------------------------------------------------------------------------                    
--Init    : Date          : Details                    
--------------------:---------------:---------------------------------------------------------------------------------------                    
--SIDDHANT           : 13-FEB-2020 :                     
-------:------------:----------------------------------------------------------------------------------------------------*/                    
BEGIN                    
SET NOCOUNT ON                    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                    
BEGIN TRY                    
      
      
DECLARE @TotalRecords INT         
SELECT  @TotalRecords = COUNT(*)          
FROM dbo.LLSUserAreaDetailsMst A                
INNER JOIN dbo.MstLocationUserArea B                 
ON A.UserAreaCode = B.UserAreaCode                
WHERE A.Status = '1'                
AND ((ISNULL(@UserAreaCode,'') = '' ) OR (ISNULL(@UserAreaCode,'') <> '' AND ( A.UserAreaCode LIKE + '%' + @UserAreaCode + '%'  OR A.UserAreaCode LIKE + '%' + @UserAreaCode + '%' )))               
AND ((ISNULL(@pFacilityId,'')='' )  OR (ISNULL(@pFacilityId,'') <> '' AND A.FacilityId = @pFacilityId))          
AND ISNULL(A.IsDeleted,'') =''                    
                
                
SELECT A.LLSUserAreaId, A.UserAreaCode, B.UserAreaName , @TotalRecords AS TotalRecords               
FROM dbo.LLSUserAreaDetailsMst A                
INNER JOIN dbo.MstLocationUserArea B                 
ON A.UserAreaCode = B.UserAreaCode                
WHERE A.Status = '1'                
AND ((ISNULL(@UserAreaCode,'') = '' ) OR (ISNULL(@UserAreaCode,'') <> '' AND ( A.UserAreaCode LIKE + '%' + @UserAreaCode + '%'  OR A.UserAreaCode LIKE + '%' + @UserAreaCode + '%' )))               
AND ((ISNULL(@pFacilityId,'')='' )  OR (ISNULL(@pFacilityId,'') <> '' AND A.FacilityId = @pFacilityId))          
AND ISNULL(A.IsDeleted,'') =''  
ORDER BY A.ModifiedDateUTC DESC          
OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY           
                  
                  
END TRY                    
BEGIN CATCH                    
                    
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                    
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                    
                    
THROW                    
                    
END CATCH                    
SET NOCOUNT OFF                    
END
GO
