USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSUserAreaDetailsLocationMstDet_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
CREATE PROCEDURE [dbo].[LLSUserAreaDetailsLocationMstDet_GetById]                
(                
 @Id INT                
)                
                 
AS                 
                
-- Exec LLSUserAreaDetailsLocationMstDet_GetById 375                
                
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
                 
SELECT       
 A.LLSUserAreaLocationId   
,A.LLSUserAreaId  
,B.UserLocationCode 
,B.UserLocationId
,B.UserLocationName              
,A.LinenSchedule              
              
,A.[1stScheduleStartTime]              
,A.[1stScheduleEndTime]              
,A.[2ndScheduleStartTime]              
,A.[2ndScheduleEndTime]              
              
,A.[3rdScheduleStartTime]              
,A.[3rdScheduleEndTime]              
FROM dbo.LLSUserAreaDetailsLocationMstDet A              
INNER JOIN dbo.MstLocationUserLocation B              
ON A.UserLocationId =B.UserLocationId               
WHERE LLSUserAreaId=@Id           
AND ISNULL(A.IsDeleted,'') = ''        
        
              
END TRY                
BEGIN CATCH                
                
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                
                
THROW                
                
END CATCH                
SET NOCOUNT OFF                
END     
  
  
GO
