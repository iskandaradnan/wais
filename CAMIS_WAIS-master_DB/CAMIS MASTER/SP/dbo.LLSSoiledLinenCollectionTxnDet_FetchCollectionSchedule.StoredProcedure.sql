USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSSoiledLinenCollectionTxnDet_FetchCollectionSchedule]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--10126 -1
--10128--2
--10129-3



      
--EXEC LLSSoiledLinenCollectionTxnDet_FetchCollectionSchedule 714,10126       
            
CREATE PROCEDURE [dbo].[LLSSoiledLinenCollectionTxnDet_FetchCollectionSchedule]            
 @LocationID INT  
,@CollectionSchedule INT  
AS            
            
BEGIN            
SET NOCOUNT ON              
SET TRANSACTION ISOLATION LEVEL READ COMMITTED              
BEGIN TRY              
            
            
  SELECT       
       C.UserLocationCode,      
             
  @CollectionSchedule as CollectionSchedule,      
 CASE      
 WHEN  @CollectionSchedule=10126 THEN  C.[1stScheduleStartTime]      
 WHEN @CollectionSchedule=10128 THEN   C.[2ndScheduleStartTime]      
 WHEN @CollectionSchedule=10129 THEN   C.[3rdScheduleStartTime]      
 END AS CollectionStartTime, 
 
 CASE      
 WHEN @CollectionSchedule=10126 THEN  C.[1stScheduleEndTime]      
 WHEN @CollectionSchedule=10128 THEN  C.[2ndScheduleEndTime]      
 WHEN @CollectionSchedule=10129 THEN  C.[3rdScheduleEndTime]      
 END AS CollectionEndTime      


FROM  dbo.LLSUserAreaDetailsLocationMstDet C      
WHERE LinenSchedule = 10079      
AND ISNULL(C.IsDeleted,'')=''  
AND C.LLSUserAreaLocationId=@LocationID  
  
            
END TRY              
BEGIN CATCH              
              
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)              
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());              
              
THROW              
              
END CATCH              
SET NOCOUNT OFF              
            
          
END
GO
