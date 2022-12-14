USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSUserAreaDetailsLocationMstDet_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[LLSUserAreaDetailsLocationMstDet_Save]                                                   
(                        
@LLSUserAreaDetailsLocationMstDet AS [dbo].[LLSUserAreaDetailsLocationMstDet] READONLY                      
)                              
                        
AS                              
                        
BEGIN                        
SET NOCOUNT ON                        
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                        
BEGIN TRY                        
                      
DECLARE @Table TABLE (ID INT)                        
                        
INSERT INTO LLSUserAreaDetailsLocationMstDet (                      
 LLSUserAreaId,                      
 UserLocationId,                      
 UserAreaCode,                      
 UserLocationCode,                    
 LinenSchedule,                      
 [1stScheduleStartTime],                      
 [1stScheduleEndTime],                      
 [2ndScheduleStartTime],                      
 [2ndScheduleEndTime],                      
 [3rdScheduleStartTime],                      
 [3rdScheduleEndTime],    
 CustomerId,    
 FacilityId,    
     
 CreatedBy,                      
 CreatedDate,                      
 CreatedDateUTC,                      
 ModifiedBy,                      
 ModifiedDate,                      
 ModifiedDateUTC)                        
                       
 OUTPUT INSERTED.LLSUserAreaId INTO @Table                        
 SELECT                      
 LLSUserAreaId                      
,UserLocationId                      
,UserAreaCode                      
,UserLocationCode                    
,LinenSchedule                      
                      
,[1stScheduleStartTime]                      
,DATEADD(HOUR,2,[1stScheduleStartTime]) AS [1stScheduleEndTime]                      
,[2ndScheduleStartTime]                      
,CASE WHEN [2ndScheduleStartTime]='00:00:00.0000000' THEN '00:00:00.0000000' ELSE DATEADD(HOUR,2,[2ndScheduleStartTime]) END AS [2ndScheduleEndTime]                      
                      
,[3rdScheduleStartTime]                      
,CASE WHEN [3rdScheduleStartTime]='00:00:00.0000000' THEN '00:00:00.0000000' ELSE DATEADD(HOUR,2,[3rdScheduleStartTime]) END AS [3rdScheduleEndTime]                      
,CustomerId    
,FacilityId    
    
,CreatedBy                      
,GETDATE()                      
,GETUTCDATE()                      
,ModifiedBy ----USERID PASSED NULL                      
,GETDATE()                      
,GETUTCDATE()                      
                      
FROM @LLSUserAreaDetailsLocationMstDet                        
                        
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
