USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSSoiledLinenCollectionTxnDet_FetchUserAreaCode]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC LLSSoiledLinenCollectionTxnDet_FetchUserAreaCode            
                  
CREATE PROCEDURE [dbo].[LLSSoiledLinenCollectionTxnDet_FetchUserAreaCode]           
  @FacilityId as int,            
  @UserAreaCode as  nvarchar(50),                  
  @pPageIndex    INT,             
  @pPageSize    INT             
    
AS                  
                  
BEGIN                  
SET NOCOUNT ON                    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                    
BEGIN TRY                    
DECLARE @TotalRecords INT             
SELECT  @TotalRecords = COUNT(*)              
FROM LLSUserAreaDetailsMst A    
WHERE ((ISNULL(@UserAreaCode,'') = '' ) OR (ISNULL(@UserAreaCode,'') <> '' AND ( A.UserAreaCode LIKE + '%' + @UserAreaCode + '%'  OR A.UserAreaCode LIKE + '%' + @UserAreaCode + '%' )))                   
AND ((ISNULL(@FacilityId,'')='' )  OR (ISNULL(@FacilityId,'') <> '' AND A.FacilityId = @FacilityId))              
AND ISNULL(A.IsDeleted,'')=''    
                  
                  
                
SELECT LLSUserAreaId,UserAreaCode, @TotalRecords AS TotalRecords            
FROM dbo.LLSUserAreaDetailsMst A            
WHERE ((ISNULL(@UserAreaCode,'') = '' ) OR (ISNULL(@UserAreaCode,'') <> '' AND ( A.UserAreaCode LIKE + '%' + @UserAreaCode + '%'  OR A.UserAreaCode LIKE + '%' + @UserAreaCode + '%' )))                   
AND ((ISNULL(@FacilityId,'')='' )  OR (ISNULL(@FacilityId,'') <> '' AND A.FacilityId = @FacilityId))              
AND ISNULL(A.IsDeleted,'')=''    
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
