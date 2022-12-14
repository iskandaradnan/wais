USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenInventoryTxnDet_FetchLinenCode]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  -- exec LLSCleanLinenDespatchTxnDet_FetchLinenCode 'b',10                   
CREATE PROCEDURE [dbo].[LLSCleanLinenInventoryTxnDet_FetchLinenCode]                      
(                  
 @LinenCode VARCHAR(50),     
 @LocationCode VARCHAR(50),    
 --@AreaCode VARCHAR(50),    
 @pFacilityId int        ,            
 @pPageIndex    INT,                     
 @pPageSize    INT                     
            
)                    
AS                    
                    
BEGIN                    
SET NOCOUNT ON                      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                      
BEGIN TRY                      
            
DECLARE @TotalRecords INT                     
SELECT  @TotalRecords = COUNT(*)                      
FROM LLSUserAreaDetailsLinenItemMstDet A    
INNER JOIN LLSUserAreaDetailsLocationMstDet B    
ON A.UserLocationId=B.LLSUserAreaLocationId    
INNER JOIN LLSLinenItemDetailsMst C    
ON A.LinenItemId=C.LinenItemId    
WHERE ((ISNULL(@LinenCode,'') = '' ) OR (ISNULL(@LinenCode,'') <> '' AND ( C.LinenCode LIKE + '%' + @LinenCode + '%'  OR C.LinenCode LIKE + '%' + @LinenCode + '%' )))                           
AND ((ISNULL(@LocationCode,'') = '' ) OR (ISNULL(@LocationCode,'') <> '' AND ( B.UserLocationCode LIKE + '%' + @LocationCode + '%'  OR B.UserLocationCode LIKE + '%' + @LocationCode + '%' )))                           
--AND ((ISNULL(@AreaCode,'') = '' ) OR (ISNULL(@AreaCode,'') <> '' AND ( B.UserAreaCode LIKE + '%' + @AreaCode + '%'  OR B.UserAreaCode LIKE + '%' + @AreaCode + '%' )))                           
AND ((ISNULL(@pFacilityId,'')='' )  OR (ISNULL(@pFacilityId,'') <> '' AND C.FacilityId = @pFacilityId))                      
AND ISNULL(A.IsDeleted,'')=''            
                    
                    
SELECT LinenCode, LinenDescription,A.LinenItemId,B.UserAreaCode,B.UserLocationCode,A.AgreedShelfLevel, @TotalRecords AS TotalRecords                     
FROM LLSUserAreaDetailsLinenItemMstDet A    
INNER JOIN LLSUserAreaDetailsLocationMstDet B    
ON A.UserLocationId=B.LLSUserAreaLocationId    
INNER JOIN LLSLinenItemDetailsMst C    
ON A.LinenItemId=C.LinenItemId    
WHERE ((ISNULL(@LinenCode,'') = '' ) OR (ISNULL(@LinenCode,'') <> '' AND ( C.LinenCode LIKE + '%' + @LinenCode + '%'  OR C.LinenCode LIKE + '%' + @LinenCode + '%' )))                           
AND ((ISNULL(@LocationCode,'') = '' ) OR (ISNULL(@LocationCode,'') <> '' AND ( B.UserLocationCode LIKE + '%' + @LocationCode + '%'  OR B.UserLocationCode LIKE + '%' + @LocationCode + '%' )))                           
--AND ((ISNULL(@AreaCode,'') = '' ) OR (ISNULL(@AreaCode,'') <> '' AND ( B.UserAreaCode LIKE + '%' + @AreaCode + '%'  OR B.UserAreaCode LIKE + '%' + @AreaCode + '%' )))                           
AND ((ISNULL(@pFacilityId,'')='' )  OR (ISNULL(@pFacilityId,'') <> '' AND C.FacilityId = @pFacilityId))                      
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
