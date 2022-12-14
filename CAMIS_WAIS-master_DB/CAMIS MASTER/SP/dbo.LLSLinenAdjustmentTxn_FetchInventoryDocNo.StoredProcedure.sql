USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenAdjustmentTxn_FetchInventoryDocNo]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                
--EXEC LLSLinenAdjustmentTxn_FetchInventoryDocNo 10,'A'                
                      
CREATE PROCEDURE [dbo].[LLSLinenAdjustmentTxn_FetchInventoryDocNo]                  
@DocumentNo AS NVARCHAR(100) ,        
@pPageIndex    INT,          
@pPageSize    INT         
      
 --@FacilityId AS INT              
AS                      
                      
BEGIN                      
SET NOCOUNT ON                        
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                        
BEGIN TRY                        
      
DECLARE @TotalRecords INT         
SELECT  @TotalRecords = COUNT(*)          
FROM LLSLinenInventoryTxn  A          
WHERE ((ISNULL(@DocumentNo,'') = '' ) OR (ISNULL(@DocumentNo,'') <> '' AND ( A.DocumentNo LIKE + '%' + @DocumentNo + '%'  OR A.DocumentNo LIKE + '%' + @DocumentNo + '%' )))               
--AND ((ISNULL(@FacilityId,'')='' )  OR (ISNULL(@FacilityId,'') <> '' AND A.FacilityId = @FacilityId))          
AND ISNULL(A.IsDeleted,'')=''                      
                      
                    
SELECT LinenInventoryId,DocumentNo,Date    
, @TotalRecords AS TotalRecords FROM LLSLinenInventoryTxn A               
WHERE ((ISNULL(@DocumentNo,'') = '' ) OR (ISNULL(@DocumentNo,'') <> '' AND ( A.DocumentNo LIKE + '%' + @DocumentNo + '%'  OR A.DocumentNo LIKE + '%' + @DocumentNo + '%' )))               
AND ISNULL(A.IsDeleted,'')=''
ORDER BY A.ModifiedDateUTC DESC          
OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY           
      
      
--FacilityId =@FacilityId              
              
                
END TRY                        
BEGIN CATCH                        
                        
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                        
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                        
                        
THROW                        
                        
END CATCH                        
SET NOCOUNT OFF                        
                      
                    
END
GO
