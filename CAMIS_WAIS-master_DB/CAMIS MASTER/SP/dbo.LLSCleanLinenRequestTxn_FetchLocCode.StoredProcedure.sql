USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSCleanLinenRequestTxn_FetchLocCode]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELPTEXT LLSCleanLinenRequestTxn_FetchLocCode              
--SP_HELPTEXT LLSCleanLinenRequestTxn_FetchRequestedBy               
              
              
              
                
---EXEC LLSCleanLinenRequestTxn_FetchLocCode '339','L',144,1,5               
                  
CREATE PROCEDURE [dbo].[LLSCleanLinenRequestTxn_FetchLocCode]                   
 @UserAreaId int    
,@LocationCode AS VARCHAR(50)              
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
FROM dbo.LLSUserAreaDetailsLocationMstDet A                
INNER JOIN dbo.MstLocationUserLocation B                
ON A.UserLocationCode = B.UserLocationCode              
--INNER JOIN LLSUserAreaDetailsMst C  
--ON A.LLSUserAreaId=C.LLSUserAreaId  
WHERE ((ISNULL(@LocationCode,'') = '' ) OR (ISNULL(@LocationCode,'') <> '' AND ( A.UserLocationCode LIKE + '%' + @LocationCode + '%'  OR A.UserLocationCode LIKE + '%' + @LocationCode + '%' )))                       
AND ((ISNULL(@UserAreaId,'')='' )  OR (ISNULL(@UserAreaId,'') <> '' AND A.LLSUserAreaId= @UserAreaId))                                    
AND ((ISNULL(@FacilityId,'')='' )  OR (ISNULL(@FacilityId,'') <> '' AND A.FacilityId = @FacilityId))                  
AND ISNULL(A.IsDeleted,'')=''        
                  
                  
SELECT A.LLSUserAreaLocationId,A.UserLocationCode                
,B.UserLocationName, @TotalRecords AS TotalRecords                
FROM dbo.LLSUserAreaDetailsLocationMstDet A                
INNER JOIN dbo.MstLocationUserLocation B                
ON A.UserLocationCode = B.UserLocationCode    
--INNER JOIN LLSUserAreaDetailsMst C  
--ON A.LLSUserAreaId=C.LLSUserAreaId  
WHERE ((ISNULL(@LocationCode,'') = '' ) OR (ISNULL(@LocationCode,'') <> '' AND ( A.UserLocationCode LIKE + '%' + @LocationCode + '%'  OR A.UserLocationCode LIKE + '%' + @LocationCode + '%' )))                       
AND ((ISNULL(@UserAreaId,'')='' )  OR (ISNULL(@UserAreaId,'') <> '' AND A.LLSUserAreaId= @UserAreaId))                                    
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
