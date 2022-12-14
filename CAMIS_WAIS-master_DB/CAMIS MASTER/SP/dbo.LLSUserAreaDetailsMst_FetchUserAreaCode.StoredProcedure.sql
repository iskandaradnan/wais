USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSUserAreaDetailsMst_FetchUserAreaCode]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC LLSUserAreaDetailsMst_FetchUserAreaCode 'T'    
    
CREATE PROCEDURE [dbo].[LLSUserAreaDetailsMst_FetchUserAreaCode]       
(        
 @UserAreaCode VARCHAR(50),    
 @pFacilityId int ,   
 @pPageIndex    INT,           
 @pPageSize    INT           
  
)        
         
AS         
        
-- Exec [GetUserRole]         
        
--/*=====================================================================================================================        
--APPLICATION  : UETrack        
--NAME    : GetAreaDetails        
--DESCRIPTION  : GET USER ROLE FOR THE GIVEN ID        
--AUTHORS   : BIJU NB        
--DATE    : 20-March-2018        
-------------------------------------------------------------------------------------------------------------------------        
--VERSION HISTORY         
--------------------:---------------:---------------------------------------------------------------------------------------        
--Init    : Date          : Details        
--------------------:---------------:---------------------------------------------------------------------------------------        
--BIJU NB           : 20-March-2018 :         
-------:------------:----------------------------------------------------------------------------------------------------*/        
BEGIN        
SET NOCOUNT ON        
SET TRANSACTION ISOLATION LEVEL READ COMMITTED        
BEGIN TRY        
  
DECLARE @TotalRecords INT           
SELECT  @TotalRecords = COUNT(*)            
FROM dbo.MstLocationUserArea    A  
WHERE Active = 1                   
AND ((ISNULL(@UserAreaCode,'') = '' ) OR (ISNULL(@UserAreaCode,'') <> '' AND ( A.UserAreaCode LIKE + '%' + @UserAreaCode + '%'  OR A.UserAreaCode LIKE + '%' + @UserAreaCode + '%' )))                 
AND ((ISNULL(@pFacilityId,'')='' )  OR (ISNULL(@pFacilityId,'') <> '' AND A.FacilityId = @pFacilityId))            
  
  
         
SELECT        
               UserAreaId,    
              UserAreaCode,      
              UserAreaName,      
             ActiveFromDate,    
              ActiveToDate,
		@TotalRecords AS TotalRecords

FROM dbo.MstLocationUserArea    A  
WHERE Active = 1                   
AND ((ISNULL(@UserAreaCode,'') = '' ) OR (ISNULL(@UserAreaCode,'') <> '' AND ( A.UserAreaCode LIKE + '%' + @UserAreaCode + '%'  OR A.UserAreaCode LIKE + '%' + @UserAreaCode + '%' )))                 
AND ((ISNULL(@pFacilityId,'')='' )  OR (ISNULL(@pFacilityId,'') <> '' AND A.FacilityId = @pFacilityId))            
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
