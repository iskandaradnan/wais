USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenRejectReplacementTxn_FetchCLINo]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                  
--EXEC LLSLinenRejectReplacementTxn_FetchCLINo                  
                        
CREATE PROCEDURE [dbo].[LLSLinenRejectReplacementTxn_FetchCLINo]                  
 @CLINo AS NVARCHAR(100)                
,@FacilityId AS INT                
,@pPageIndex    INT                       
,@pPageSize    INT                       
            
AS                        
                        
BEGIN                        
SET NOCOUNT ON                          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                          
BEGIN TRY                          
            
DECLARE @TotalRecords INT                       
SELECT  @TotalRecords = COUNT(*)                        
FROM dbo.LLSCleanLinenIssueTxn  A               
INNER JOIN LLSCleanLinenRequestTxn B    
ON A.CleanLinenRequestId=B.CleanLinenRequestId    
INNER JOIN LLSUserAreaDetailsLocationMstDet C    
ON B.LLSUserAreaLocationId=C.LLSUserAreaLocationId    
    
WHERE ((ISNULL(@CLINo,'') = '' ) OR (ISNULL(@CLINo,'') <> '' AND ( A.CLINo LIKE + '%' + @CLINo + '%'  OR A.CLINo LIKE + '%' + @CLINo + '%' )))                             
AND ((ISNULL(@FacilityId,'')='' )  OR (ISNULL(@FacilityId,'') <> '' AND A.FacilityId = @FacilityId))                          
AND ISNULL(A.IsDeleted,'')=''      
            
                
--SELECT * FROM LLSCleanLinenRequestTxn    
    
    
SELECT CleanLinenIssueId,CLINo ,A.Remarks,C.UserAreaCode,C.UserLocationCode,c.LLSUserAreaId,c.LLSUserAreaLocationId,D.UserAreaName,E.UserLocationName,@TotalRecords AS TotalRecords                 
FROM dbo.LLSCleanLinenIssueTxn  A            
INNER JOIN LLSCleanLinenRequestTxn B    
ON A.CleanLinenRequestId=B.CleanLinenRequestId    
INNER JOIN LLSUserAreaDetailsLocationMstDet C    
ON B.LLSUserAreaLocationId=C.LLSUserAreaLocationId    
INNER JOIN MstLocationUserArea D    
ON C.UserAreaCode=D.UserAreaCode    
INNER JOIN MstLocationUserLocation E    
ON C.UserLocationCode=E.UserLocationCode    
WHERE ((ISNULL(@CLINo,'') = '' ) OR (ISNULL(@CLINo,'') <> '' AND ( A.CLINo LIKE + '%' + @CLINo + '%'  OR A.CLINo LIKE + '%' + @CLINo + '%' )))                             
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
