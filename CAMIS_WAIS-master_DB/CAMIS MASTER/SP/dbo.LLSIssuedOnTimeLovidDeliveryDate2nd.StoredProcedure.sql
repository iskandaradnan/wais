USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSIssuedOnTimeLovidDeliveryDate2nd]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- SELECT CONVERT(DATETIME,CAST(GETDATE() AS DATE))   
   
---EXEC    
  
  
CREATE PROCEDURE [dbo].[LLSIssuedOnTimeLovidDeliveryDate2nd]    
(    
 --@DeliveryDate1st DATETIME NULL    
 @DeliveryDate2nd DATETIME NULL    
,@RequestDateTime DATETIME  NULL  
,@Priority INT    
,@ScheduleStatus INT    
--,@IssuedStatus INT    
,@LocationId VARCHAR(50)    
    
)    
AS    
    
BEGIN    
    
-----FOR TEST PURPOSE    
    
--DECLARE @DeliveryDate1st DATETIME       
------DECLARE @DeliveryDate2nd DATETIME NULL      
--DECLARE @RequestDateTime DATETIME      
--DECLARE @Priority INT      
--DECLARE @ScheduleStatus INT      
----DECLARE @IssuedStatus INT      
--DECLARE @LocationId  INT     
      
  
--SET @DeliveryDate1st='2020-04-23 14:30:00.000'  
--SET @RequestDateTime=NULL  
--SET @Priority=10101  
--SET @ScheduleStatus=10157  
--SET @LocationId='L4-OHR-010'  
    
    
IF(@Priority=10101 AND @ScheduleStatus= 10157)    
BEGIN     
    
SELECT  CASE WHEN CAST(@DeliveryDate2nd AS TIME) BETWEEN [1stScheduleStartTime] AND [1stScheduleEndTime]     
          THEN 10155     
        ELSE 10156 END AS IssuedOnTimeLovid    
FROM LLSUserAreaDetailsLocationMstDet A    
WHERE LinenSchedule = 10078    
AND LLSUserAreaLocationId=@LocationId    
  
    
END     
ELSE IF (@Priority=10101 AND @ScheduleStatus= 10158)     
BEGIN    
    
SELECT  CASE WHEN CAST(@DeliveryDate2nd AS TIME) BETWEEN [2ndScheduleStartTime] AND [2ndScheduleEndTime]     
        THEN 10155     
        ELSE 10156 END AS IssuedOnTimeLovid    
FROM LLSUserAreaDetailsLocationMstDet A    
WHERE LinenSchedule = 10078    
AND LLSUserAreaLocationId=@LocationId   
    
    
END    
    
ELSE IF (@Priority=10101 AND @ScheduleStatus= 10159)    
BEGIN     
    
SELECT  CASE WHEN CAST(@DeliveryDate2nd AS TIME) BETWEEN [3rdScheduleStartTime] AND [3rdScheduleEndTime]     
        THEN 10155     
        ELSE 10156 END AS IssuedOnTimeLovid    
FROM LLSUserAreaDetailsLocationMstDet A    
WHERE LinenSchedule = 10078    
AND LLSUserAreaLocationId=@LocationId    
    
END     
    
ELSE IF (@Priority=10102)    
BEGIN     
    
SELECT  CASE WHEN DATEDIFF(MINUTE,@RequestDateTime,@DeliveryDate2nd) <=30     
        THEN 10155     
        ELSE 10156 END AS IssuedOnTimeLovid    
FROM LLSUserAreaDetailsLocationMstDet A    
WHERE LinenSchedule = 10078    
AND LLSUserAreaLocationId=@LocationId   
    
END     
    
END 
GO
