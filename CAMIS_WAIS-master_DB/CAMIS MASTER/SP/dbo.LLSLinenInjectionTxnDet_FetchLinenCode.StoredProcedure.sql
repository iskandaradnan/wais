USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenInjectionTxnDet_FetchLinenCode]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                
---EXEC LLSLinenInjectionTxnDet_FetchLinenCode 'mnbv',144,1,5               
                  
				
CREATE PROCEDURE [dbo].[LLSLinenInjectionTxnDet_FetchLinenCode]                
@LinenCode    AS NVARCHAR(50),              
@FacilityId AS INT,                 
@pPageIndex    INT,          
@pPageSize    INT         
        
AS                  
                  
BEGIN                  
SET NOCOUNT ON                    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                    
BEGIN TRY                    
        
DECLARE @TotalRecords INT         
SELECT  @TotalRecords = COUNT(*)          
FROM dbo.LLSLinenItemDetailsMst  A          
WHERE ((ISNULL(@LinenCode,'') = '' ) OR (ISNULL(@LinenCode,'') <> '' AND ( A.LinenCode LIKE + '%' + @LinenCode + '%'  OR A.LinenCode LIKE + '%' + @LinenCode + '%' )))               
AND ((ISNULL(@FacilityId,'')='' )  OR (ISNULL(@FacilityId,'') <> '' AND A.FacilityId = @FacilityId))          
AND ISNULL(IsDeleted,'')=''    
        
                  
SELECT LinenItemId,LinenCode, LinenDescription,LinenPrice, @TotalRecords AS TotalRecords                
FROM dbo.LLSLinenItemDetailsMst A        
WHERE ((ISNULL(@LinenCode,'') = '' ) OR (ISNULL(@LinenCode,'') <> '' AND ( A.LinenCode LIKE + '%' + @LinenCode + '%'  OR A.LinenCode LIKE + '%' + @LinenCode + '%' )))               
AND ((ISNULL(@FacilityId,'')='' )  OR (ISNULL(@FacilityId,'') <> '' AND A.FacilityId = @FacilityId))          
AND ISNULL(IsDeleted,'')=''    
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
