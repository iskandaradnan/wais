USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSUserAreaDetailsLocationMstDet_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
        
-- Exec [LLSUserAreaDetailsLocationMstDet_Update]         
        
--/*=====================================================================================================================        
--APPLICATION  : UETrack 1.5        
--NAME    : SaveUserAreaDetailsLLS       
--DESCRIPTION  : Update RECORD IN [LLSUserAreaDetailsLocationMstDet_Update] TABLE         
--AUTHORS   : SIDDHANT        
--DATE    : 24-DEC-2019      
-------------------------------------------------------------------------------------------------------------------------        
--VERSION HISTORY         
--------------------:---------------:---------------------------------------------------------------------------------------        
--Init    : Date          : Details        
--------------------:---------------:---------------------------------------------------------------------------------------        
--SIDDHANT          : 24-DEC-2019 :         
-------:------------:----------------------------------------------------------------------------------------------------*/        
      
        
      
    
        
CREATE PROCEDURE  [dbo].[LLSUserAreaDetailsLocationMstDet_Update]                                   
        
(        
 @1stScheduleStartTime AS TIME  
,@2ndScheduleStartTime AS TIME  =null
,@3rdScheduleStartTime AS TIME  =null
,@ModifiedBy AS INT  
,@ModifiedDate AS  varchar(100)   
,@ModifiedDateUTC AS varchar(100)  
,@LLSUserAreaLocationId AS INT  
)              
        
AS              
        
BEGIN        
SET NOCOUNT ON        
SET TRANSACTION ISOLATION LEVEL READ COMMITTED        
BEGIN TRY        
      
DECLARE @Table TABLE (ID INT)        
      
UPDATE A      
SET [1stScheduleStartTime] = @1stScheduleStartTime      
,[1stScheduleEndTime] = DATEADD(HOUR,2,@1stScheduleStartTime)      
,[2ndScheduleStartTime] = @2ndScheduleStartTime      
,[2ndScheduleEndTime] = DATEADD(HOUR,2,@2ndScheduleStartTime)      
,[3rdScheduleStartTime] = @3rdScheduleStartTime     
,[3rdScheduleEndTime] = DATEADD(HOUR,2,@3rdScheduleStartTime)      
,ModifiedBy = @ModifiedBy      
,ModifiedDate = GETDATE()      
,ModifiedDateUTC =GETUTCDATE()    
FROM LLSUserAreaDetailsLocationMstDet A      
WHERE LLSUserAreaLocationId = @LLSUserAreaLocationId       
      
      
SELECT LLSUserAreaId      
      ,[Timestamp]      
   ,'' ErrorMsg      
      --,GuId       
FROM LLSUserAreaDetailsLocationMstDet WHERE LLSUserAreaId IN (SELECT ID FROM @Table)        
        
END TRY        
BEGIN CATCH        
        
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)        
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());        
        
THROW        
        
END CATCH        
SET NOCOUNT OFF        
END
GO
