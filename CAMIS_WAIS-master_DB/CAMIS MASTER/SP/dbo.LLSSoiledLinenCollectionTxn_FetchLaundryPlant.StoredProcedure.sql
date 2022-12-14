USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSSoiledLinenCollectionTxn_FetchLaundryPlant]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
--EXEC LLSSoiledLinenCollectionTxn_FetchLaundryPlant    
          
CREATE PROCEDURE [dbo].[LLSSoiledLinenCollectionTxn_FetchLaundryPlant]          
 @LaundryPlantName VARCHAR(100),  
 @pPageIndex    INT,             
 @pPageSize    INT             
  
AS          
          
BEGIN          
SET NOCOUNT ON            
SET TRANSACTION ISOLATION LEVEL READ COMMITTED            
BEGIN TRY            
  
  
DECLARE @TotalRecords INT             
SELECT  @TotalRecords = COUNT(*)              
FROM dbo.LLSLaundryPlantMst A    
INNER JOIN dbo.FMLovMst B    
ON A.Ownership = B.LovId    
WHERE                 
((ISNULL(@LaundryPlantName,'') = '' ) OR (ISNULL(@LaundryPlantName,'') <> '' AND ( A.LaundryPlantName LIKE + '%' + @LaundryPlantName + '%'  OR A.LaundryPlantName LIKE + '%' + @LaundryPlantName + '%' )))                   
--AND ((ISNULL(@FacilityId,'')='' )  OR (ISNULL(@FacilityId,'') <> '' AND A.FacilityId = @FacilityId))                
AND ISNULL(A.IsDeleted,'')=''          
          
        
SELECT     
A.LaundryPlantName,    
 B.FieldValue AS Ownership    
FROM dbo.LLSLaundryPlantMst A    
INNER JOIN dbo.FMLovMst B    
ON A.Ownership = B.LovId    
WHERE ((ISNULL(@LaundryPlantName,'') = '' ) OR (ISNULL(@LaundryPlantName,'') <> '' AND ( A.LaundryPlantName LIKE + '%' + @LaundryPlantName + '%'  OR A.LaundryPlantName LIKE + '%' + @LaundryPlantName + '%' )))                   
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
