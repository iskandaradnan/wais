USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSSoiledLinenCollectionTxnDet_FetchLocCodetest ]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
--EXEC LLSSoiledLinenCollectionTxnDet_FetchLocCode                         
                              
Create PROCEDURE [dbo].[LLSSoiledLinenCollectionTxnDet_FetchLocCodetest ]                       
 @FacilityId as int,                          
 @UserLocationCode as  nvarchar(50),          
 @pPageIndex    INT,                     
 @pPageSize    INT

                      
                        
AS                              
                              
BEGIN                              
SET NOCOUNT ON                                
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                                
BEGIN TRY                                
DECLARE @TotalRecords INT                     
SELECT  @TotalRecords = COUNT(*)                      
FROM dbo.LLSUserAreaDetailsLocationMstDet A          
WHERE  A.LinenSchedule=10079      
AND  ((ISNULL(@UserLocationCode,'') = '' ) OR (ISNULL(@UserLocationCode,'') <> '' AND ( A.UserLocationCode LIKE + '%' + @UserLocationCode + '%'  OR A.UserLocationCode LIKE + '%' + @UserLocationCode + '%' )))                                           
AND ((ISNULL(@FacilityId,'')='' )  OR (ISNULL(@FacilityId,'') <> '' AND A.FacilityId = @FacilityId))             
AND ISNULL(A.IsDeleted,'')=''          
           
           
          
SELECT                   
LLSUserAreaLocationId                  
,UserLocationCode       
,[1stScheduleStartTime]       
,[1stScheduleEndTime]      
, @TotalRecords AS TotalRecords                  
FROM dbo.LLSUserAreaDetailsLocationMstDet        A          
WHERE  A.LinenSchedule=10079      
AND  ((ISNULL(@UserLocationCode,'') = '' ) OR (ISNULL(@UserLocationCode,'') <> '' AND ( A.UserLocationCode LIKE + '%' + @UserLocationCode + '%'  OR A.UserLocationCode LIKE + '%' + @UserLocationCode + '%' )))                                           
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
