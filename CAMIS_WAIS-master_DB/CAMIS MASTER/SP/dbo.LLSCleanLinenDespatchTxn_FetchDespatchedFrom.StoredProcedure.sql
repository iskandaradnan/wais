USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenDespatchTxn_FetchDespatchedFrom]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
CREATE PROCEDURE [dbo].[LLSCleanLinenDespatchTxn_FetchDespatchedFrom]    
@LaundryPlantName VARCHAR(100)  
,@pPageIndex    INT           
,@pPageSize    INT           
  
AS    
    
BEGIN    
SET NOCOUNT ON      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
BEGIN TRY      
DECLARE @TotalRecords INT           
SELECT  @TotalRecords = COUNT(*)            
FROM LLSLaundryPlantMst A  
WHERE ((ISNULL(@LaundryPlantName,'') = '' ) OR (ISNULL(@LaundryPlantName,'') <> '' AND ( A.LaundryPlantName LIKE + '%' + @LaundryPlantName + '%'  OR A.LaundryPlantName LIKE + '%' + @LaundryPlantName + '%' )))                 
AND ISNULL(A.IsDeleted,'')=''    
  
  
SELECT LaundryPlantName FROM LLSLaundryPlantMst   A  
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
