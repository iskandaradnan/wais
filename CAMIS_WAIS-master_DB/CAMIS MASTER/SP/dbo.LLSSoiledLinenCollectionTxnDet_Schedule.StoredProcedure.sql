USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSSoiledLinenCollectionTxnDet_Schedule]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
--EXEC LLSSoiledLinenCollectionTxnDet_Schedule 144,269,1,5,10129                        
                              
CREATE PROCEDURE [dbo].[LLSSoiledLinenCollectionTxnDet_Schedule]                       
 @FacilityId as int,                          
 @LLSUserLocationid  as INT,          
 @pPageIndex    INT,                     
 @pPageSize    INT,
 @pScheduleid  int
AS                              
                              
BEGIN                              
SET NOCOUNT ON                                
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                                
BEGIN TRY                                
DECLARE @TotalRecords INT                     
SELECT  @TotalRecords = COUNT(*)     

FROM dbo.LLSUserAreaDetailsLocationMstDet A              
WHERE  ((ISNULL(@LLSUserLocationid,'') = '' ) OR (ISNULL(@LLSUserLocationid,'') <> '' AND ( A.LLSUserAreaLocationId =@LLSUserLocationid   OR A.LLSUserAreaLocationId =@LLSUserLocationid  )))                                           
AND ((ISNULL(@FacilityId,'')='' )  OR (ISNULL(@FacilityId,'') <> '' AND A.FacilityId = @FacilityId))             
AND ISNULL(A.IsDeleted,'')=''          
           
           
 if(@pScheduleid=10126)
  BEGIN
SELECT                   
LLSUserAreaLocationId                  
,UserLocationCode       
,[1stScheduleStartTime]       
,[1stScheduleEndTime]      
, @TotalRecords AS TotalRecords                  
FROM dbo.LLSUserAreaDetailsLocationMstDet        A          
--WHERE  A.LinenSchedule=10079      
WHERE  ((ISNULL(@LLSUserLocationid,'') = '' ) OR (ISNULL(@LLSUserLocationid,'') <> '' AND ( A.LLSUserAreaLocationId =@LLSUserLocationid   OR A.LLSUserAreaLocationId =@LLSUserLocationid  )))
AND ((ISNULL(@FacilityId,'')='' )  OR (ISNULL(@FacilityId,'') <> '' AND A.FacilityId = @FacilityId))             
AND ISNULL(A.IsDeleted,'')=''          
ORDER BY A.ModifiedDateUTC DESC                      
OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY                       
  END                     
    ELSE if (@pScheduleid=10128)
	BEGIN

       SELECT                   
LLSUserAreaLocationId                  
,UserLocationCode       
,[2ndScheduleStartTime]       
,[2ndScheduleEndTime]      
, @TotalRecords AS TotalRecords                  
FROM dbo.LLSUserAreaDetailsLocationMstDet        A          
--WHERE  A.LinenSchedule=10079      
WHERE  ((ISNULL(@LLSUserLocationid,'') = '' ) OR (ISNULL(@LLSUserLocationid,'') <> '' AND ( A.LLSUserAreaLocationId =@LLSUserLocationid   OR A.LLSUserAreaLocationId =@LLSUserLocationid  )))
AND ((ISNULL(@FacilityId,'')='' )  OR (ISNULL(@FacilityId,'') <> '' AND A.FacilityId = @FacilityId))             
AND ISNULL(A.IsDeleted,'')=''          
ORDER BY A.ModifiedDateUTC DESC                      
OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY  

    END     
	ELSE if (@pScheduleid=10129)
	BEGIN

       SELECT                   
LLSUserAreaLocationId                  
,UserLocationCode       
,[3rdScheduleStartTime]       
,[3rdScheduleEndTime]      
, @TotalRecords AS TotalRecords                  
FROM dbo.LLSUserAreaDetailsLocationMstDet        A          
--WHERE  A.LinenSchedule=10079      
WHERE  ((ISNULL(@LLSUserLocationid,'') = '' ) OR (ISNULL(@LLSUserLocationid,'') <> '' AND ( A.LLSUserAreaLocationId =@LLSUserLocationid   OR A.LLSUserAreaLocationId =@LLSUserLocationid  )))
AND ((ISNULL(@FacilityId,'')='' )  OR (ISNULL(@FacilityId,'') <> '' AND A.FacilityId = @FacilityId))             
AND ISNULL(A.IsDeleted,'')=''          
ORDER BY A.ModifiedDateUTC DESC                      
OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY  

    END   
END TRY                                
BEGIN CATCH                                
                                
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                                
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                                
                                
THROW                                
                                
END CATCH                                
SET NOCOUNT OFF                                
                              
                            
END       


GO
