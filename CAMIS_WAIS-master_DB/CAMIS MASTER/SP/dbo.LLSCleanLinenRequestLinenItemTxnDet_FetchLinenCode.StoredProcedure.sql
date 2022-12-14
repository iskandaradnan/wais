USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenRequestLinenItemTxnDet_FetchLinenCode]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
      
                  
---EXEC LLSCleanLinenRequestLinenItemTxnDet_FetchLinenCode 'S',144,1,5                 
                    
CREATE PROCEDURE [dbo].[LLSCleanLinenRequestLinenItemTxnDet_FetchLinenCode]                 
 @LinenCode AS VARCHAR(100)                
,@FacilityId AS INT                
,@pPageIndex    INT                   
,@pPageSize    INT  
,@pUserLocCode AS VARCHAR(100)                
          
          
                
AS                    
                    
BEGIN                    
SET NOCOUNT ON                      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                      
BEGIN TRY                      
          
DECLARE @TotalRecords INT                   
SELECT  @TotalRecords = COUNT(*)                    
FROM dbo.LLSLinenItemDetailsMst A     
INNER JOIN LLSUserAreaDetailsLinenItemMstDet B    
ON A.LinenItemId=B.LinenItemId    
INNER JOIN LLSCentralCleanLinenStoreMstDet C    
ON A.LinenItemId=C.LinenItemId  
INNER JOIN LLSUserAreaDetailsLocationMstDet D  
ON B.UserLocationId=D.LLSUserAreaLocationId  
WHERE  ((ISNULL(@LinenCode,'') = '' ) OR (ISNULL(@LinenCode,'') <> '' AND ( A.LinenCode LIKE + '%' + @LinenCode + '%'  OR A.LinenCode LIKE + '%' + @LinenCode + '%' )))                         
AND ((ISNULL(@pUserLocCode,'') = '' ) OR (ISNULL(@pUserLocCode,'') <> '' AND ( D.UserLocationCode LIKE + '%' + @pUserLocCode + '%'  OR  D.UserLocationCode LIKE + '%' + @pUserLocCode + '%' )))                 
AND ((ISNULL(@FacilityId,'')='' )  OR (ISNULL(@FacilityId,'') <> '' AND A.FacilityId = @FacilityId))                    
AND ISNULL(A.IsDeleted,'')=''                    
AND ISNULL(B.IsDeleted,'')=''
                    
SELECT A.LinenItemId,A.LinenCode, A.LinenDescription,B.AgreedShelfLevel,C.StoreBalance,@TotalRecords AS TotalRecords                 
FROM dbo.LLSLinenItemDetailsMst A     
INNER JOIN LLSUserAreaDetailsLinenItemMstDet B    
ON A.LinenItemId=B.LinenItemId    
INNER JOIN LLSCentralCleanLinenStoreMstDet C    
ON A.LinenItemId=C.LinenItemId    
INNER JOIN LLSUserAreaDetailsLocationMstDet D  
ON B.UserLocationId=D.LLSUserAreaLocationId  
  
WHERE  ((ISNULL(@LinenCode,'') = '' ) OR (ISNULL(@LinenCode,'') <> '' AND ( A.LinenCode LIKE + '%' + @LinenCode + '%'  OR A.LinenCode LIKE + '%' + @LinenCode + '%' )))                         
AND ((ISNULL(@pUserLocCode,'') = '' ) OR (ISNULL(@pUserLocCode,'') <> '' AND ( D.UserLocationCode LIKE + '%' + @pUserLocCode + '%'  OR  D.UserLocationCode LIKE + '%' + @pUserLocCode + '%' )))                 
AND ((ISNULL(@FacilityId,'')='' )  OR (ISNULL(@FacilityId,'') <> '' AND A.FacilityId = @FacilityId))                    
AND ISNULL(A.IsDeleted,'')=''

/*FLAG ADDED 30-11-2020*/
AND ISNULL(B.IsDeleted,'')=''
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
