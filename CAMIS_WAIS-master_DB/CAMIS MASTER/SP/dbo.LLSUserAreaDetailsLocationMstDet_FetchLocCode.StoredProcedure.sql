USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSUserAreaDetailsLocationMstDet_FetchLocCode]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  
  
  

      
            
            
CREATE PROCEDURE [dbo].[LLSUserAreaDetailsLocationMstDet_FetchLocCode]                
(                
@UserAreaId INT,    
 @UserLocationCode  VARCHAR(50),              
 @pFacilityId int,          
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
 FROM (                             
SELECT A.UserAreaId, A.UserLocationId,A.UserLocationCode,A.UserLocationName,@TotalRecords AS TotalRecords                       
FROM dbo.MstLocationUserLocation A                        
INNER JOIN MstLocationUserArea B                        
ON A.UserAreaId=B.UserAreaId      
--INNER JOIN LLSUserAreaDetailsLocationMstDet C    
--ON A.UserLocationCode=C.UserLocationCode    
WHERE A.Active = '1'                          
AND ((ISNULL(@UserAreaId,'')='' )  OR (ISNULL(@UserAreaId,'') <> '' AND b.UserAreaId= @UserAreaId))                                    
AND ((ISNULL( @pFacilityId,'')='' )  OR (ISNULL( @pFacilityId,'') <> '' AND A.FacilityId =  @pFacilityId))               
--AND ((ISNULL(@FacilityId,'')='' )  OR (ISNULL(@FacilityId,'') <> '' AND A.FacilityId = @FacilityId))                          
) AA                          
WHERE               
((ISNULL(@UserLocationCode,'') = '' ) OR (ISNULL(@UserLocationCode,'') <> '' AND ( AA.UserLocationCode LIKE + '%' + @UserLocationCode + '%'  OR AA.UserLocationCode LIKE + '%' + @UserLocationCode + '%' )))                             
              
              
              
SELECT UserAreaId,UserLocationId,UserLocationCode,UserLocationName,ModifiedDateUTC,@TotalRecords AS TotalRecords     FROM (                             
SELECT A.UserAreaId, A.UserLocationId,A.UserLocationCode ,A.UserLocationName,A.ModifiedDateUTC                         
FROM dbo.MstLocationUserLocation A                        
INNER JOIN MstLocationUserArea B                        
ON A.UserAreaId=B.UserAreaId                        
--INNER JOIN LLSUserAreaDetailsLocationMstDet C    
--ON A.UserLocationCode=C.UserLocationCode    
WHERE A.Active = '1'                          
AND ((ISNULL(@UserAreaId,'')='' )  OR (ISNULL(@UserAreaId,'') <> '' AND b.UserAreaId= @UserAreaId))                                    
AND ((ISNULL( @pFacilityId,'')='' )  OR (ISNULL( @pFacilityId,'') <> '' AND A.FacilityId =  @pFacilityId))               
--AND ((ISNULL(@FacilityId,'')='' )  OR (ISNULL(@FacilityId,'') <> '' AND A.FacilityId = @FacilityId))                          
) AA                          
WHERE               
((ISNULL(@UserLocationCode,'') = '' ) OR (ISNULL(@UserLocationCode,'') <> '' AND ( AA.UserLocationCode LIKE + '%' + @UserLocationCode + '%'  OR AA.UserLocationCode LIKE + '%' + @UserLocationCode + '%' )))                             
ORDER BY AA.ModifiedDateUTC DESC                        
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
