USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSUserAreaDetailsLinenItemMstDet_FetchLocCodeNew]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SELECT * FROM LLSUserAreaDetailsMst WHERE UserAreaCode='L11PS2'
--SELECT * FROM LLSUserAreaDetailsLocationMstDet  WHERE UserAreaCode = 'L11PS2'                        
                            
CREATE PROCEDURE [dbo].[LLSUserAreaDetailsLinenItemMstDet_FetchLocCodeNew]                                
(                                
 @UserAreaId int,                            
 @UserLocationCode VARCHAR(50),                            
 @FacilityId int,                  
 @pPageIndex    INT,                           
 @pPageSize    INT                           
                  
)                                
                                 
AS                                 
                                
-- ---EXEC LLSUserAreaDetailsLinenItemMstDet_FetchLocCode 45,'L',144,1,5                           
                               
                                
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
SELECT  A.UserLocationId,A.UserLocationCode,A.UserLocationName,C.LinenSchedule,@TotalRecords AS TotalRecords                           
FROM dbo.MstLocationUserLocation A                            
INNER JOIN MstLocationUserArea B                            
ON A.UserAreaId=B.UserAreaId          
INNER JOIN LLSUserAreaDetailsLocationMstDet C        
ON A.UserLocationCode=C.UserLocationCode        
INNER JOIN LLSUserAreaDetailsMst D    
ON B.UserAreaCode=D.UserAreaCode    
WHERE A.Active = '1'                              
AND ((ISNULL(@UserAreaId,'')='' )  OR (ISNULL(@UserAreaId,'') <> '' AND B.UserAreaId= @UserAreaId))                                        
AND ((ISNULL(@FacilityId,'')='' )  OR (ISNULL(@FacilityId,'') <> '' AND A.FacilityId = @FacilityId))                   
--AND ((ISNULL(@FacilityId,'')='' )  OR (ISNULL(@FacilityId,'') <> '' AND A.FacilityId = @FacilityId))                              
AND ISNULL(C.IsDeleted,'')=''  
) AA                              
WHERE                   
((ISNULL(@UserLocationCode,'') = '' ) OR (ISNULL(@UserLocationCode,'') <> '' AND ( AA.UserLocationCode LIKE + '%' + @UserLocationCode + '%'  OR AA.UserLocationCode LIKE + '%' + @UserLocationCode + '%' )))                                 
 AND  LinenSchedule= 10078              
                  
                  
SELECT UserLocationId,UserLocationCode,UserLocationName,ModifiedDateUTC, LLSUserLocationCode,LLSUserAreaLocationId     
,LLSUserAreaLocationId ,LLSUserAreaId     
,@TotalRecords AS TotalRecords     FROM (                                 
SELECT  A.UserLocationId,A.UserLocationCode,C.UserLocationCode AS LLSUserLocationCode
,A.UserLocationName,A.ModifiedDateUTC       
,C.LLSUserAreaLocationId,D.LLSUserAreaId ,C.LinenSchedule     
FROM dbo.MstLocationUserLocation A                            
INNER JOIN MstLocationUserArea B                            
ON A.UserAreaId=B.UserAreaId                            
INNER JOIN LLSUserAreaDetailsLocationMstDet C        
ON A.UserLocationCode=C.UserLocationCode      
INNER JOIN LLSUserAreaDetailsMst D    
ON B.UserAreaCode=D.UserAreaCode    
WHERE A.Active = '1'                              
AND ((ISNULL(@UserAreaId,'')='' )  OR (ISNULL(@UserAreaId,'') <> '' AND B.UserAreaId= @UserAreaId))                                        
AND ((ISNULL(@FacilityId,'')='' )  OR (ISNULL(@FacilityId,'') <> '' AND A.FacilityId = @FacilityId))                   
--AND ((ISNULL(@FacilityId,'')='' )  OR (ISNULL(@FacilityId,'') <> '' AND A.FacilityId = @FacilityId))                              
AND ISNULL(C.IsDeleted,'')=''  
) AA                              
WHERE                   
--((ISNULL(@UserLocationCode,'') = '' ) OR (ISNULL(@UserLocationCode,'') <> '' AND ( AA.UserLocationCode LIKE + '%' + @UserLocationCode + '%'  OR AA.UserLocationCode LIKE + '%' + @UserLocationCode + '%' )))                                 
((ISNULL(@UserLocationCode,'') = '' ) OR (ISNULL(@UserLocationCode,'') <> '' AND ( AA.LLSUserLocationCode LIKE + '%' + @UserLocationCode + '%'  OR AA.LLSUserLocationCode LIKE + '%' + @UserLocationCode + '%' )))                                 
AND  LinenSchedule= 10078              
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
