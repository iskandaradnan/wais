USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Demo_uspFM_Planner_frequency]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                  
                  
/*========================================================================================================                  
Application Name : UETrack-BEMS                                
Version    : 1.0                  
Procedure Name  : uspFM_Planner_frequency                  
Description   : Get the Generate Frequency of weeks                 
Authors    : deepak V                  
Date    : 11-May-2018                  
-----------------------------------------------------------------------------------------------------------                  
                  
              
EXEC Demo_uspFM_Planner_frequency                  
                  
-----------------------------------------------------------------------------------------------------------                  
Version History                   
-----:------------:---------------------------------------------------------------------------------------                  
Init : Date       : Details                  
========================================================================================================*/                  
CREATE PROCEDURE  [dbo].[Demo_uspFM_Planner_frequency]                      
                
                  
AS                                                                 
                  
BEGIN TRY                  
                  
-- Paramter Validation                   
                  
 SET NOCOUNT ON;                   
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;                  
                  
-- Declaration                  
  DECLARE @planning_table TABLE (            
    PlannerId INT NOT NULL,            
  planneddate datetime NOT NULL,            
 PlannerDetId INT NOT Null            
    );            
  DECLARE @planning_tables TABLE (            
    PlannerId INT NOT NULL,            
  planneddate datetime NOT NULL,            
 PlannerDetId INT NOT Null            
    );            
 DECLARE @master_planning_table TABLE (            
    AssetId INT NOT NULL,            
 PlannerId INT NOT NULL,            
  PlannerDate datetime NOT NULL,            
 PlannerDetId INT NOT Null            
    );            
 DECLARE @planningforassets_table TABLE (            
 idx smallint Primary Key IDENTITY(1,1),            
    PlannerId INT NOT NULL,            
 PlannerDetId INT NOT Null,            
    planneddate datetime NOT NULL,            
 ScheduleType INT NOT NULL,            
 --AssetNo varchar(100) NOT NULL,            
 AssetId INT NOT NULL,            
 AssetTypeCodeId INT NOT NULL,            
 --PPMFrequency INT NOT NULL,            
 Nextday INT NOT NULL            
   -- Model int NOT NULL            
);            
               
   DECLARE @i int            
    DECLARE @numrows int            
     DECLARE @Plannerdt int            
   DECLARE @Plannerid int            
  DECLARE @frequency int            
  DECLARE @m1 int            
  DECLARE @m2 int            
   DECLARE @Planned_Date datetime            
   DECLARE @Planned_next_Date datetime            
            
  INSERT INTO @master_planning_table  select DISTINCT AssetId as AssetId ,max(PlannerId) as PlannerId,max(FirstDate) as PlannerDate ,max([Year] ) as [Year]  from EngPlannerTxn where EngPlannerTxn.FirstDate>dateadd(DD, -38, getdate()) and  AssetId is not  
  
   
null group by AssetId  order by PlannerId             
  INSERT INTO @planning_tables  select DISTINCT PlannerId,max(PlannerDate) as planneddate,max(PlannerDetId) from EngPlannerTxnDet where EngPlannerTxnDet.PlannerDate>dateadd(DD, -5, getdate()) group by PlannerId order by PlannerId              
  INSERT INTO @planning_table select s.PlannerId,s.planneddate,s.PlannerDetId from @planning_tables s inner join @master_planning_table as m on m.PlannerId=s.PlannerId             
  --INSERT INTO @planning_table  select DISTINCT PlannerId,max(PlannerDate) as planneddate,max(PlannerDetId) from EngPlannerTxnDet where EngPlannerTxnDet.PlannerDate>dateadd(DD, -5, getdate()) group by PlannerId order by PlannerId               
  INSERT INTO @planningforassets_table select  eptd.PlannerId,planner.PlannerDetId,planner.planneddate, eptd.ScheduleType,            
            
  eptd.AssetId,eptd.AssetTypeCodeId,            
            
  IIF(ppmcheck.PPMFrequency=44,364,IIF(ppmcheck.PPMFrequency=45,182,IIF(ppmcheck.PPMFrequency=46,91,IIF(ppmcheck.PPMFrequency=47,56,IIF(ppmcheck.PPMFrequency=48,28,IIF(ppmcheck.PPMFrequency=49,14,IIF(ppmcheck.PPMFrequency=50,7,0)))))))as Nextday          
  
             
   from  @planning_table  as planner               
   inner JOIN EngPlannerTxn as eptd on planner.PlannerId=eptd.PlannerId             
             
  INNER JOIN EngAssetPPMCheckList     AS ppmcheck   WITH (NOLOCK) ON eptd.StandardTaskDetId  = ppmcheck.PPMCheckListId             
            
             
               
   where eptd.GenerationType=365 order by eptd.PlannerId            
            
   select * from @planningforassets_table            
 ------------------------------------------------------Logic for inset-----------------------------------------            
 -- enumerate the table            
SET @i = 0            
SET @frequency=0            
SET @numrows = (SELECT COUNT(*) FROM @planningforassets_table)            
IF @numrows > 0            
    WHILE (@i <= (SELECT MAX(idx) FROM @planningforassets_table))            
    BEGIN            
            
            
        -- get the next employee primary key            
        SET @Plannerdt = (SELECT PlannerDetId FROM @planningforassets_table WHERE idx = @i)            
  SET @frequency=(SELECT Nextday FROM @planningforassets_table WHERE idx = @i)            
  SET @Planned_Date=(SELECT planneddate FROM @planningforassets_table WHERE idx = @i)            
  SET @Plannerid=(SELECT Plannerid FROM @planningforassets_table WHERE idx = @i)            
  SET @Planned_next_Date=dateadd(yy, +1, @Planned_Date)            
              
  --SELECT * INTO #Temp FROM( select * from EngPlannerTxnDet where PlannerDetId=@Plannerdt ) as a            
  ----------------------create sub dates------------------------------------------------------>>>>>>>>>>>>>>>            
   WHILE (@Planned_Date <= dateadd(yy, +1, getdate()))            
    BEGIN            
 SELECT * INTO #Temp FROM( select * from EngPlannerTxnDet where PlannerDetId=@Plannerdt ) as a            
             
 SET @Planned_Date=dateadd(DD, +@frequency, @Planned_Date)            
            
 SET @m1=YEAR(@Planned_Date)            
 SET @m2=YEAR(@Planned_next_Date)            
 --------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!need to check same year or different year and create new master PlannerID            
 IF(@m1<@m2)            
 BEGIN            
 select * from #Temp            
 --SET @Planned_next_Date=dateadd(yy, +1, @Planned_Date)            
       update #Temp set PlannerDate=@Planned_Date,Year=YEAR(@Planned_Date),Plannerid=@Plannerid      
    --select * FROM #Temp            
 INSERT INTO [dbo].[EngPlannerTxnDet]([PlannerId],[CustomerId],[FacilityId],[ScheduleType] ,[Year],[Month],[Date],[Week],[Day],[PlannerDate],[CreatedBy],[CreatedDate],[CreatedDateUTC],[ModifiedBy],[ModifiedDate],[ModifiedDateUTC],[GuId])SELECT  
    
    [PlannerId]            ,[CustomerId],[FacilityId],[ScheduleType],[Year],[Month],[Date],[Week],[Day]            ,[PlannerDate],[CreatedBy],[CreatedDate],[CreatedDateUTC],[ModifiedBy],[ModifiedDate]            ,[ModifiedDateUTC]            ,[GuId]  FROM
 #Temp            
            
--drop table #Temp          
 END            
 ELSE            
 BEGIN            
 SET @Planned_next_Date=dateadd(yy, +1, @Planned_Date)            
             
 SELECT * INTO #TempEngPlannerTxn FROM(select * from EngPlannerTxn where PlannerId=@Plannerid ) as Eng            
 select * from #TempEngPlannerTxn            
    update #TempEngPlannerTxn set FirstDate=@Planned_Date,Year=YEAR(@Planned_Date)            
 INSERT INTO [dbo].[EngPlannerTxn]([CustomerId],[FacilityId],[ServiceId],[WorkGroupId],[TypeOfPlanner],[Year],[UserAreaId],[AssigneeCompanyUserId]            
           ,[FacilityUserId],[AssetClassificationId],[AssetTypeCodeId],[AssetId],[StandardTaskDetId],[WarrantyType],[ContactNo],[EngineerUserId]            
           ,[ScheduleType],[Month],[Date],[Week],[Day],[CreatedBy],[CreatedDate],[CreatedDateUTC],[ModifiedBy],[ModifiedDate],[ModifiedDateUTC]            
           ,[GuId] ,[Status],[WorkOrderType],[GenerationType],[FirstDate],[NextDate],[LastDate],[IntervalInWeeks]) OUTPUT INSERTED.PlannerId select[CustomerId],[FacilityId],            
     [ServiceId],[WorkGroupId],[TypeOfPlanner],[Year],[UserAreaId],[AssigneeCompanyUserId]            
           ,[FacilityUserId],[AssetClassificationId],[AssetTypeCodeId],[AssetId],[StandardTaskDetId],[WarrantyType],[ContactNo],[EngineerUserId]            
           ,[ScheduleType],[Month],[Date],[Week],[Day],[CreatedBy],[CreatedDate],[CreatedDateUTC],[ModifiedBy],[ModifiedDate],[ModifiedDateUTC]            
           ,[GuId] ,[Status],[WorkOrderType],[GenerationType],[FirstDate],[NextDate],[LastDate],[IntervalInWeeks] FROM #TempEngPlannerTxn            
     ----       gets the inserted ID            
   SET @Plannerid=SCOPE_IDENTITY()     
   update #Temp set PlannerDate=@Planned_Date,Year=YEAR(@Planned_Date),PlannerId=@Plannerid            
END            
 --------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!            
             
 --select * FROM #Temp            
 INSERT INTO [dbo].[EngPlannerTxnDet]([PlannerId],[CustomerId],[FacilityId],[ScheduleType] ,[Year],[Month],[Date],[Week],[Day],[PlannerDate],[CreatedBy],[CreatedDate]    
   
           ,[CreatedDateUTC],[ModifiedBy],[ModifiedDate],[ModifiedDateUTC],[GuId])SELECT [PlannerId],[CustomerId],[FacilityId],[ScheduleType],[Year],[Month],[Date],[Week],[Day],[PlannerDate],[CreatedBy],[CreatedDate],[CreatedDateUTC],[ModifiedBy],[Modifie
dDate]            ,[ModifiedDateUTC]            ,[GuId]  FROM #Temp            
            
drop table #Temp            
             
 END            
  ----------------------end create sub dates--------------------------------------------------->>>>>>>>>>>>>>>            
    SET @i=@i + 1            
            
 END            
             
                  
            
--------------------------------------------------END LOGIC-------------------------------------------------------------------            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
  --   select  eptd.PlannerId,eptd.PlannerDate, planner.ScheduleType,            
  --IIF(planner.ScheduleType=78,2,IIF(planner.ScheduleType=78,2,3))as days,            
  --assets.AssetNo,assets.AssetTypeCodeId,            
  --ppmcheck.PPMFrequency,            
  --IIF(ppmcheck.PPMFrequency=44,364,IIF(ppmcheck.PPMFrequency=45,182,IIF(ppmcheck.PPMFrequency=46,91,IIF(ppmcheck.PPMFrequency=47,56,IIF(ppmcheck.PPMFrequency=48,28,IIF(ppmcheck.PPMFrequency=49,14,IIF(ppmcheck.PPMFrequency=50,7,0)))))))as Nextday        
  
    
  -- from EngPlannerTxn as planner               
  --INNER JOIN EngAsset   AS assets  WITH (NOLOCK) ON Planner.AssetId  = assets.AssetId               
  --INNER JOIN EngAssetPPMCheckList     AS ppmcheck   WITH (NOLOCK) ON assets.AssetTypeCodeId  = ppmcheck.AssetTypeCodeId               
  -- INNER JOIN EngPlannerTxnDet as eptd on eptd.PlannerId=planner.PlannerId              
  -- where planner.GenerationType=365              
                  
-- Execution                  
                  
--1 PPM                  
                
     -- select * from @planningforassets_table            
 --select * from @planning_table             
            
            
END TRY                  
                  
BEGIN CATCH                  
                  
 INSERT INTO ErrorLog(                  
    Spname,                  
    ErrorMessage,                  
    createddate)                  
 VALUES(  OBJECT_NAME(@@PROCID),                  
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),                  
    getdate()                  
     )                  
                  
END CATCH 
GO
