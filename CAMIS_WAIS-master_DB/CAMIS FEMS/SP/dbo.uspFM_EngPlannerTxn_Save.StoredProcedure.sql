USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngPlannerTxn_Save]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================    
Application Name : UETrack-BEMS                  
Version    : 1.0    
Procedure Name  : uspFM_EngPlannerTxn_Save    
Description   : If Planner already exists then update else insert.    
Authors    : Balaji M S    
Date    : 05-April-2018    
-----------------------------------------------------------------------------------------------------------    
    
Unit Test:    
select * from engasset where AssetId=2    
    
EXEC uspFM_EngPlannerTxn_Save @pUserId=2, @pPlannerId=null,@CustomerId=1,@FacilityId=1,@ServiceId=2,@WorkGroupId=1,@TypeOfPlanner=27,@Year=2018,@UserAreaId=3,    
@AssigneeCompanyStaffId=24,@FacilityStaffId=26,@AssetClassificationId=1,@AssetTypeCodeId=4,@AssetId=151,@StandardTaskDetId=26,    
@WarrantyType=80,@ContactNo='01654910',@EngineerStaffId=null,@ScheduleType=27,@Month='1',@Date='2',@Week=null,@Day=null,    
@Status=1,@WorkOrderType=83,@GenerationType=365,@FirstDate=null,@FrequencyType=45    
    
select * from 108    
-----------------------------------------------------------------------------------------------------------    
Version History     
-----:------------:---------------------------------------------------------------------------------------    
Init :  Date       : Details    
  
Added Asset Name,UserAreaName,UserAreaCode By PRANAY KUMAR  
========================================================================================================*/    
    
CREATE PROCEDURE  [dbo].[uspFM_EngPlannerTxn_Save]    
    
   @pUserId      INT    = NULL,    
   @pPlannerId      INT    = NULL,    
   @CustomerId      INT,    
   @FacilityId      INT,    
   @ServiceId      INT,    
   @WorkGroupId     INT,    
   @TypeOfPlanner     INT,    
   @Year       INT,    
   @UserAreaId      INT    =   NULL,     
   @AssigneeCompanyStaffId   INT    = NULL,    
   @FacilityStaffId    INT    = NULL,    
   @AssetClassificationId   INT    = NULL,     
   @AssetTypeCodeId    INT    = NULL,    
   @AssetId      INT    = NULL,    
   @StandardTaskDetId    INT    = NULL,    
   @WarrantyType     INT    = NULL,    
   @ContactNo      NVARCHAR(100) = NULL,    
   @EngineerStaffId    INT    = NULL,    
   @ScheduleType     INT    = NULL,    
   @Month       NVARCHAR(200) = NULL,    
   @Date       NVARCHAR(200) = NULL,    
   @Week       NVARCHAR(200) = NULL,    
   @Day       NVARCHAR(200) = NULL,    
   @Status       INT    = NULL,    
   @WorkOrderType     INT    = NULL,       
   @GenerationType     INT    = NULL,    
   @FirstDate      DATETIME  =   NULL,    
   @FrequencyType     INT    = NULL ,
   @AgreedDate      DATETIME  =   NULL
  -- @AssetName NVARCHAR(20) = NULL,  
  -- @UserAreaName NVARCHAR(50) = NULL,  
  --@UserAreaCode NVARCHAR(20) = NULL  
AS                                                  
    
BEGIN TRY    
    
 --DECLARE @mTRANSCOUNT INT = @@TRANCOUNT    
    
 --BEGIN TRANSACTION    
    
-- Paramter Validation     
    
 SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;    
    
-- Declaration    
    
if exists (select 1 from EngPlannerTxn where  assetid=@assetid and [Year]=@Year) and  (ISNULL(@pPlannerId,0)= 0 OR @pPlannerId='')    
begin    
  SELECT 0 as PlannerId,    
    NULL AS [Timestamp],    
    'Already planned for this Asset for the year' as ErrorMessage    
    --+ FORMAT(CAST(PlannerDate AS DATE),'dd-MMM-yyyy') AS ErrorMessage    
      
  return    
end    
     
 DECLARE @Table TABLE (ID INT)    
    
 Declare @IntervalInWeeks  int, @Nextdate  datetime , @lastdate datetime    
    
    
 IF(ISNULL(@EngineerStaffId,0)=0)    
  SET @EngineerStaffId = @AssigneeCompanyStaffId    
    
 IF OBJECT_ID(N'tempdb..#PlannerTxn') IS NOT NULL    
 BEGIN    
   DROP TABLE #PlannerTxn    
 END    
    
 CREATE TABLE #PlannerTxn (  PlannerId  INT NULL,    
         CustomerId  INT NULL,    
         FacilityId  INT NULL,    
         WorkGroupId  INT NULL,    
         AssetId   INT NULL,    
         UserAreaId  INT NULL,    
         ScheduleType INT NULL,    
         Year   INT NULL,    
         Month  NVARCHAR(100) NULL,    
         Date   NVARCHAR(100) NULL,    
         Week   NVARCHAR(100) NULL,    
         Day    NVARCHAR(100) NULL,    
         PlannerDate  DATETIME NULL,    
         CreatedBy  INT NULL,    
         CreatedDate  DATETIME NULL,    
         CreatedDateUTC DATETIME NULL,    
         ModifiedBy  INT NULL,    
         ModifiedDate DATETIME NULL,    
         ModifiedDateUTC DATETIME NULL,    
         Firstdate  DATETIME NULL,    
         Nextdate  DATETIME NULL,    
         lastdate  DATETIME NULL  ,  
  
        )    
    
 CREATE TABLE #PlannerDate (  ID INT IDENTITY(1,1),     
         PlannerId  INT NULL,    
         CustomerId  INT NULL,    
         FacilityId  INT NULL,    
         WorkGroupId  INT NULL,    
         AssetId   INT NULL,    
         UserAreaId  INT NULL,    
         ScheduleType INT NULL,    
         ScheduleTypeValue NVARCHAR(100),    
         Year   INT NULL,    
         Month   NVARCHAR(100) NULL,    
         Date   NVARCHAR(100) NULL,    
         Week   NVARCHAR(100) NULL,    
         Day    NVARCHAR(100) NULL,    
         PlannerDate  DATETIME NULL,    
        )    
-- Default Values    
    
    
-- Execution    
    
 SELECT IDENTITY(INT,1,1) AS ID,    
   DATEFROMPARTS (A.Year, A.Month, A.Day) CalenderDate ,    
   A.Year,    
   A.Month,    
   A.Day,    
   B.FacilityId    
 INTO #TempWorkingCalender    
 FROM MstWorkingCalenderDet A     
   INNER JOIN MstWorkingCalender B ON A.CalenderId = B.CalenderId    
 WHERE B.CustomerId  = @CustomerId    
   AND B.FacilityId = @FacilityId    
   AND A.IsWorking = 0    
    
    
      
    
    
    
IF @GenerationType  = 365    
BEGIN    
    
       
   IF(ISNULL(@pPlannerId,0)= 0 OR @pPlannerId='')    
    
    BEGIN    
    
    select @IntervalInWeeks  = case when @FrequencyType = 44 then 52    
            when @FrequencyType = 45 then 26    
            when @FrequencyType = 46 then 13     
            when @FrequencyType = 47 then 8     
            when @FrequencyType = 48 then 4    
            when @FrequencyType = 49 then 2    
            when @FrequencyType = 50 then 1    
         ELSE    
          Null    
         END    
    
   select @Nextdate = DATEADD(DAY,(@IntervalInWeeks*7),@FirstDate)    
    
     select @lastdate = null    
--44 Annually    --- 52    
--45 Half Yearly  -- 26    
--46 Quarterly  -- 13    
--47  Bi-Monthly   -- 8    
--48 Monthly   -- 4    
--49 Bi-Weekly  -- 2    
--50 Weekly   -- 1       
    
       
      INSERT INTO EngPlannerTxn(    
              CustomerId,    
              FacilityId,    
              ServiceId,    
              WorkGroupId,    
              TypeOfPlanner,    
              Year,    
              UserAreaId,    
              AssigneeCompanyUserId,    
              FacilityUserId,    
              AssetClassificationId,    
              AssetTypeCodeId,    
              AssetId,    
              StandardTaskDetId,    
              WarrantyType,    
              ContactNo,    
              EngineerUserId,    
              ScheduleType,    
              Month,    
              Date,    
              Week,    
              Day,    
              CreatedBy,    
              CreatedDate,    
              CreatedDateUTC,    
              ModifiedBy,    
              ModifiedDate,    
              ModifiedDateUTC,    
              Status,    
              WorkOrderType,    
              GenerationType,    
              FirstDate,    
              Nextdate,    
              Lastdate,    
              IntervalInWeeks
     --AssetName,  
     --UserAreaName,  
     --UserAreaCode  
                                                  
          )OUTPUT INSERTED.PlannerId INTO @Table    
      VALUES        (    
    
              @CustomerId,    
              @FacilityId,    
              @ServiceId,    
              @WorkGroupId,    
              @TypeOfPlanner,    
              @Year,    
              @UserAreaId,    
              @AssigneeCompanyStaffId,    
              @FacilityStaffId,    
              @AssetClassificationId,    
              @AssetTypeCodeId,    
              @AssetId,    
              @StandardTaskDetId,    
              @WarrantyType,    
              @ContactNo,    
              @EngineerStaffId,    
              @ScheduleType,    
              @Month,    
              @Date,    
              @Week,    
              @Day,    
              @pUserId,                 
              GETDATE(),     
              GETUTCDATE(),    
              @pUserId,                 
              GETDATE(),     
              GETUTCDATE(),    
              @Status,    
              @WorkOrderType,    
              @GenerationType,    
              @FirstDate,    
              @Nextdate,    
              @Lastdate,    
              @IntervalInWeeks 
     --@AssetName,  
     --@UserAreaName,  
     --@UserAreaCode  
              )    
       
    
    
    
    INSERT INTO #PlannerTxn ( PlannerId,    
           CustomerId,    
           FacilityId,    
           WorkGroupId,    
           Year,    
           UserAreaId,    
           AssetId,    
           ScheduleType,    
           Month,    
           Date,    
           Week,    
           Day,    
           CreatedBy,    
           CreatedDate,    
           CreatedDateUTC,    
           ModifiedBy,    
           ModifiedDate,    
           ModifiedDateUTC,    
           Firstdate,    
           Nextdate,    
           lastdate    
          )    
        
      SELECT DISTINCT PlannerId,    
        CustomerId,    
        FacilityId,    
        WorkGroupId,    
        Year,    
        UserAreaId,    
        AssetId,    
        ScheduleType,    
        Month,    
        Date,    
        Week,    
        Day,    
        CreatedBy,    
        CreatedDate,    
        CreatedDateUTC,    
        ModifiedBy,    
        ModifiedDate,    
        ModifiedDateUTC,    
        Firstdate,    
        Nextdate,    
        lastdate    
      FROM EngPlannerTxn    
      WHERE PlannerId IN (SELECT ID FROM @Table)    
    
      INSERT INTO EngPlannerTxnDet ( PlannerId,    
          CustomerId,    
          FacilityId,    
          ScheduleType,    
          Year,    
          Month,    
          Date,    
          PlannerDate,    
          CreatedBy,    
          CreatedDate,    
          CreatedDateUTC,    
          ModifiedBy,    
          ModifiedDate,    
          ModifiedDateUTC    
         )    
      
     SELECT DISTINCT PlannerId,    
       CustomerId,    
       FacilityId,    
       ScheduleType,    
       Year,    
       Month,    
       Date,    
       case when lastdate is null then firstdate else Nextdate end PlannerDate,    
       CreatedBy,    
       CreatedDate,    
       CreatedDateUTC,    
       ModifiedBy,    
       ModifiedDate,    
       ModifiedDateUTC    
     FROM #PlannerTxn       
         
                SELECT    PlannerId,    
           [Timestamp],    
           '' AS ErrorMessage    
        FROM     EngPlannerTxn    
        WHERE    PlannerId IN (SELECT ID FROM @Table)     
     
   END    
   ELSE    
    BEGIN    
    
     
     UPDATE EngPlannerTxn SET     
    
          CustomerId         = @CustomerId,        
          FacilityId         = @FacilityId,        
          ServiceId         = @ServiceId,        
          WorkGroupId         = @WorkGroupId,        
          TypeOfPlanner        = @TypeOfPlanner,       
          Year          = @Year,         
          UserAreaId         = @UserAreaId,        
          AssigneeCompanyUserId      = @AssigneeCompanyStaffId,     
          FacilityUserId        = @FacilityStaffId,       
          AssetClassificationId      = @AssetClassificationId,     
          AssetTypeCodeId        = @AssetTypeCodeId,       
          AssetId          = @AssetId,         
          StandardTaskDetId       = @StandardTaskDetId,      
          WarrantyType        = @WarrantyType,       
          ContactNo         = @ContactNo,        
          EngineerUserId        = @EngineerStaffId,       
          ScheduleType        = @ScheduleType,       
          Month          = @Month,         
          Date   = @Date,         
          Week          = @Week,         
          Day           = @Day,          
          ModifiedBy         = @pUserId,    
          ModifiedDate        = GETDATE(),    
          ModifiedDateUTC        = GETUTCDATE(),    
          Status          = @Status,    
          WorkOrderType        = @WorkOrderType,    
          GenerationType        = @GenerationType      
    --AssetName       =@AssetName,  
    --UserAreaName    =@UserAreaName,  
    --UserAreaCode    =@UserAreaCode  
          OUTPUT INSERTED.PlannerId INTO @Table    
       WHERE PlannerId=@pPlannerId    
    
          SELECT    PlannerId,    
           [Timestamp],    
           '' AS ErrorMessage    
        FROM     EngPlannerTxn    
        WHERE    PlannerId IN (SELECT ID FROM @Table)    
    
    
    INSERT INTO #PlannerTxn ( PlannerId,    
           CustomerId,    
           FacilityId,    
           WorkGroupId,    
           Year,    
           UserAreaId,    
           AssetId,    
           ScheduleType,    
           Month,    
           Date,    
           Week,    
           Day,    
           CreatedBy,    
           CreatedDate,    
           CreatedDateUTC,    
           ModifiedBy,    
           ModifiedDate,    
           ModifiedDateUTC,    
           Firstdate,    
              Nextdate,    
           lastdate    
          )    
        
      SELECT DISTINCT PlannerId,    
        CustomerId,    
        FacilityId,    
        WorkGroupId,    
        Year,    
        UserAreaId,    
        AssetId,    
        ScheduleType,    
        Month,    
        Date,    
        Week,    
        Day,    
        CreatedBy,    
        CreatedDate,    
        CreatedDateUTC,    
        ModifiedBy,    
        ModifiedDate,    
        ModifiedDateUTC,    
        Firstdate,    
        Nextdate,    
        lastdate    
      FROM EngPlannerTxn    
      WHERE PlannerId = @pPlannerId    
    
       
   END       
    
     
    
  DELETE FROM EngPlannerTxnDet WHERE PlannerId IN (SELECT DISTINCT PlannerId FROM #PlannerTxn)    
     
  INSERT INTO EngPlannerTxnDet ( PlannerId,    
          CustomerId,    
          FacilityId,    
          ScheduleType,    
          Year,    
          Month,    
          Date,    
          PlannerDate,    
          CreatedBy,    
          CreatedDate,    
          CreatedDateUTC,    
          ModifiedBy,    
          ModifiedDate,    
          ModifiedDateUTC    
         )    
      
     SELECT DISTINCT PlannerId,    
       CustomerId,    
       FacilityId,    
       ScheduleType,    
       Year,    
       Month,    
       Date,    
       case when lastdate is null then firstdate else Nextdate end PlannerDate,    
       CreatedBy,    
       CreatedDate,    
       CreatedDateUTC,    
       ModifiedBy,    
       ModifiedDate,    
       ModifiedDateUTC    
     FROM #PlannerTxn        
         
    
        
      
    
    
END    
ELSE    
BEGIN    
    
INSERT INTO #PlannerTxn (    PlannerId,    
          CustomerId,    
          FacilityId,    
          WorkGroupId,    
          Year,    
          UserAreaId,    
          AssetId,    
          ScheduleType,    
          Month,    
          Date,    
          Week,    
          Day    
         ) VALUES    
        
       (0,    
       @CustomerId,    
       @FacilityId,    
       @WorkGroupId,    
       @Year,    
       @UserAreaId,    
       @AssetId,    
       @ScheduleType,    
       @Month,    
       @Date,    
       @Week,    
       @Day)    
    
    
 IF (@ScheduleType=78) --Monthly-Date    
  BEGIN    
    
    
  INSERT INTO #PlannerDate ( PlannerId,    
          CustomerId,    
          FacilityId,    
          ScheduleType,    
          Year,    
          Month,    
          Date,    
          PlannerDate,    
          ScheduleTypeValue    
         )    
    
     SELECT PlannerId,    
       CustomerId,    
       FacilityId,    
       ScheduleType,    
       Year,    
       splitMonth.Item AS Month,    
       splitDate.Item AS Date,    
       CAST(NULL AS date) AS PlannerDate,    
       'Monthly-Date'     
     FROM #PlannerTxn    
     OUTER APPLY SplitString(MONTH,',') splitMonth    
     OUTER APPLY SplitString(DATE,',') splitDate    
     where isnull(PlannerId,0)>0    
    UPDATE #PlannerDate SET PlannerDate =DATEFROMPARTS(Year,Month,Date)    
  END    
    
    
 ELSE IF (@ScheduleType=79)    
    
  BEGIN    
    
  INSERT INTO #PlannerDate ( PlannerId,    
          CustomerId,    
          FacilityId,    
          ScheduleType,    
          Year,    
          Month,    
          Week,    
          Day,    
          PlannerDate,    
          ScheduleTypeValue    
         )    
     
     SELECT     
       PlannerId,    
       CustomerId,    
       FacilityId,    
       ScheduleType,    
       Year,    
       splitMonth.Item AS Month,    
       splitWeek.Item AS Week,    
       splitDay.Item AS Day,    
       CAST(NULL AS date) AS PlannerDate,    
       'Monthly-Day'    
     FROM #PlannerTxn    
     OUTER APPLY SplitString(MONTH,',') splitMonth    
     OUTER APPLY SplitString(Week,',') splitWeek    
     OUTER APPLY SplitString(Day,',') splitDay    
     where isnull(PlannerId,0)>0    
    UPDATE #PlannerDate  SET PlannerDate = DATEADD(DAY,CAST([Day] as int)+1, DATEADD(WEEK, CAST([Week] as int)-1, DATEFROMPARTS(YEAR,Month,1)) )    
  END    
    
    
 SELECT DISTINCT B.FacilityId,B.PlannerId,B.PlannerDate,B.ScheduleTypeValue INTO #ResSet FROM #TempWorkingCalender A INNER JOIN #PlannerDate B ON A.FacilityId = B.FacilityId AND CAST(A.CalenderDate AS DATE) =  CAST(B.PlannerDate AS DATE)    
    
    
    
 IF EXISTS (SELECT 1 FROM #ResSet)    
 BEGIN    
  SELECT DISTINCT    
    IDENTITY(INT ,1,1) AS ID,    
    A.FacilityId,    
    PlannerId,    
    ScheduleTypeValue,    
      
    CAST(STUFF((SELECT ',' + CAST(FORMAT(CAST (PlannerDate AS DATE) ,'dd-MMM-yyyy') AS nvarchar(100))    
    FROM #ResSet AA where  AA.FacilityId=A.FacilityId FOR XML PATH('')),1,1,'') AS nvarchar(MAX)    
        
    ) AS PlannerDate    
  INTO #ErrorMsg    
  FROM #ResSet A    
    
      
  SELECT PlannerId,    
    NULL AS [Timestamp],    
    'The following dates falls on leave calender - ' + PlannerDate AS ErrorMessage    
    --+ FORMAT(CAST(PlannerDate AS DATE),'dd-MMM-yyyy') AS ErrorMessage    
  FROM #ErrorMsg    
    
 END    
    
    
 ELSE    
    
 BEGIN    
    
    
   IF(ISNULL(@pPlannerId,0)= 0 OR @pPlannerId='')    
    
    BEGIN    
      INSERT INTO EngPlannerTxn(    
              CustomerId,    
              FacilityId,    
              ServiceId,    
              WorkGroupId,    
              TypeOfPlanner,    
              Year,    
              UserAreaId,    
              AssigneeCompanyUserId,    
              FacilityUserId,    
              AssetClassificationId,    
              AssetTypeCodeId,    
              AssetId,    
              StandardTaskDetId,    
              WarrantyType,    
              ContactNo,    
              EngineerUserId,    
              ScheduleType,    
              Month,    
              Date,    
              Week,    
              Day,    
              CreatedBy,    
              CreatedDate,    
              CreatedDateUTC,    
              ModifiedBy,    
              ModifiedDate,    
              ModifiedDateUTC,    
              Status,    
              WorkOrderType,    
              GenerationType,    
              FirstDate     
     --AssetName,  
     --UserAreaName,  
     --UserAreaCode  
          )OUTPUT INSERTED.PlannerId INTO @Table    
      VALUES        (    
    
              @CustomerId,    
              @FacilityId,    
              @ServiceId,    
              @WorkGroupId,    
              @TypeOfPlanner,    
              @Year,    
              @UserAreaId,    
              @AssigneeCompanyStaffId,    
              @FacilityStaffId,    
              @AssetClassificationId,    
              @AssetTypeCodeId,    
              @AssetId,    
              @StandardTaskDetId,    
              @WarrantyType,    
              @ContactNo,    
              @EngineerStaffId,    
              @ScheduleType,    
              @Month,    
              @Date,    
              @Week,    
              @Day,    
              @pUserId,                 
              GETDATE(),     
              GETUTCDATE(),    
              @pUserId,                 
              GETDATE(),     
              GETUTCDATE(),    
              @Status,    
              @WorkOrderType,    
              @GenerationType,    
              @FirstDate   
     --@AssetName,  
     --@UserAreaName,  
     --@UserAreaCode  
              )    
       
    
           SELECT    PlannerId,    
           [Timestamp],    
           '' AS ErrorMessage    
        FROM     EngPlannerTxn    
        WHERE    PlannerId IN (SELECT ID FROM @Table)    
    
    INSERT INTO #PlannerTxn ( PlannerId,    
           CustomerId,    
           FacilityId,    
           WorkGroupId,    
           Year,    
           UserAreaId,    
           AssetId,    
           ScheduleType,    
           Month,    
           Date,    
           Week,    
           Day,    
           CreatedBy,    
           CreatedDate,    
           CreatedDateUTC,    
           ModifiedBy,    
           ModifiedDate,    
           ModifiedDateUTC    
          )    
        
      SELECT DISTINCT PlannerId,    
        CustomerId,    
        FacilityId,    
        WorkGroupId,    
        Year,    
        UserAreaId,    
        AssetId,    
        ScheduleType,    
        Month,    
        Date,    
        Week,    
        Day,    
        CreatedBy,    
        CreatedDate,    
        CreatedDateUTC,    
        ModifiedBy,    
        ModifiedDate,    
        ModifiedDateUTC    
      FROM EngPlannerTxn    
      WHERE PlannerId IN (SELECT ID FROM @Table)    
     
   END    
   ELSE    
    BEGIN    
    
    print 'aa'    
    
     UPDATE EngPlannerTxn SET     
    
          CustomerId         = @CustomerId,        
          FacilityId         = @FacilityId,        
          ServiceId         = @ServiceId,        
          WorkGroupId         = @WorkGroupId,        
          TypeOfPlanner        = @TypeOfPlanner,       
          Year          = @Year,         
          UserAreaId         = @UserAreaId,        
          AssigneeCompanyUserId      = @AssigneeCompanyStaffId,     
          FacilityUserId        = @FacilityStaffId,       
          AssetClassificationId      = @AssetClassificationId,     
          AssetTypeCodeId        = @AssetTypeCodeId,       
          AssetId          = @AssetId,         
          StandardTaskDetId       = @StandardTaskDetId,      
          WarrantyType        = @WarrantyType,       
          ContactNo         = @ContactNo,        
          EngineerUserId        = @EngineerStaffId,       
          ScheduleType        = @ScheduleType,       
          Month          = @Month,         
          Date          = @Date,         
          Week          = @Week,         
          Day           = @Day,          
          ModifiedBy         = @pUserId,    
          ModifiedDate        = GETDATE(),    
          ModifiedDateUTC        = GETUTCDATE(),    
          Status          = @Status,    
          WorkOrderType        = @WorkOrderType,    
          GenerationType        = @GenerationType,    
          FirstDate         = @FirstDate  
    --AssetName    =@AssetName,  
    --UserAreaName    =@UserAreaName,  
    --UserAreaCode   =@UserAreaCode  
          OUTPUT INSERTED.PlannerId INTO @Table    
       WHERE PlannerId=@pPlannerId    
    
          SELECT    PlannerId,    
           [Timestamp],    
           '' AS ErrorMessage    
        FROM     EngPlannerTxn    
        WHERE    PlannerId IN (SELECT ID FROM @Table)    
    
    
    INSERT INTO #PlannerTxn ( PlannerId,    
           CustomerId,    
           FacilityId,    
           WorkGroupId,    
           Year,    
           UserAreaId,    
           AssetId,    
           ScheduleType,    
           Month,    
           Date,    
           Week,    
           Day,    
           CreatedBy,    
           CreatedDate,    
           CreatedDateUTC,    
           ModifiedBy,    
           ModifiedDate,    
           ModifiedDateUTC    
          )    
        
      SELECT DISTINCT PlannerId,    
        CustomerId,    
        FacilityId,    
        WorkGroupId,    
        Year,    
        UserAreaId,    
        AssetId,    
        ScheduleType,    
        Month,    
        Date,    
        Week,    
        Day,    
        CreatedBy,    
        CreatedDate,    
        CreatedDateUTC,    
        ModifiedBy,    
        ModifiedDate,    
        ModifiedDateUTC    
      FROM EngPlannerTxn    
      WHERE PlannerId = @pPlannerId    
    
       
   END       
    
  --IF @mTRANSCOUNT = 0    
  --       BEGIN    
  --           COMMIT TRANSACTION    
  --       END       
    
    
 IF (@ScheduleType=78) --Monthly-Date    
  BEGIN    
      
  DELETE FROM EngPlannerTxnDet WHERE PlannerId IN (SELECT DISTINCT PlannerId FROM #PlannerTxn)    
     
  INSERT INTO EngPlannerTxnDet ( PlannerId,    
          CustomerId,    
          FacilityId,    
          ScheduleType,    
          Year,    
          Month,    
          Date,    
          PlannerDate,    
          CreatedBy,    
          CreatedDate,    
          CreatedDateUTC,    
          ModifiedBy,    
          ModifiedDate,    
          ModifiedDateUTC    
         )    
      
     SELECT DISTINCT PlannerId,    
       CustomerId,    
       FacilityId,    
       ScheduleType,    
       Year,    
       splitMonth.Item AS Month,    
       splitDate.Item AS Date,    
       NULL AS PlannerDate,    
       CreatedBy,    
       CreatedDate,    
       CreatedDateUTC,    
       ModifiedBy,    
       ModifiedDate,    
       ModifiedDateUTC    
     FROM #PlannerTxn    
     OUTER APPLY SplitString(MONTH,',') splitMonth    
     OUTER APPLY SplitString(DATE,',') splitDate    
     where isnull(PlannerId,0)>0    
    
         
    
    SELECT * INTO #EngPlannerTxnDet FROM EngPlannerTxnDet  WHERE PlannerId IN (SELECT DISTINCT PlannerId FROM #PlannerTxn)    
    
    UPDATE A SET A.PlannerDate =DATEFROMPARTS(B.Year,B.Month,B.Date)    
    FROM EngPlannerTxnDet A INNER JOIN #EngPlannerTxnDet B ON A.PlannerDetId=B.PlannerDetId     
    WHERE A.PlannerId IN (SELECT DISTINCT PlannerId FROM #PlannerTxn)    
    AND A.ScheduleType=78    
    
        
  END    
    
    
 ELSE IF (@ScheduleType=79)    
    
  BEGIN    
      
  DELETE FROM EngPlannerTxnDet WHERE PlannerId IN (SELECT DISTINCT PlannerId FROM #PlannerTxn)    
    
      
  INSERT INTO EngPlannerTxnDet ( PlannerId,    
          CustomerId,    
          FacilityId,    
          ScheduleType,    
          Year,    
          Month,    
          Week,    
          Day,    
          PlannerDate,    
          CreatedBy,    
          CreatedDate,    
          CreatedDateUTC,    
          ModifiedBy,    
          ModifiedDate,    
          ModifiedDateUTC    
         )    
      
     SELECT DISTINCT PlannerId,    
       CustomerId,    
       FacilityId,    
       ScheduleType,    
       Year,    
       splitMonth.Item AS Month,    
       splitWeek.Item AS Week,    
       splitDay.Item AS Day,    
       NULL AS PlannerDate,    
       CreatedBy,    
       CreatedDate,    
       CreatedDateUTC,    
       ModifiedBy,    
       ModifiedDate,    
       ModifiedDateUTC    
     FROM #PlannerTxn    
     OUTER APPLY SplitString(MONTH,',') splitMonth    
     OUTER APPLY SplitString(Week,',') splitWeek    
     OUTER APPLY SplitString(Day,',') splitDay    
     where isnull(PlannerId,0)>0    
     --WHERE PlannerId=2    
    
    SELECT * INTO #EngPlannerTxnDet79 FROM EngPlannerTxnDet  WHERE PlannerId IN (SELECT DISTINCT PlannerId FROM #PlannerTxn)    
    
    UPDATE A SET A.PlannerDate = DATEADD(wk, DATEDIFF(wk, 6,  CAST(A.[month] as varchar(30))+'/'+'1/' + cast(a.year as varchar(30))) + (a.[Week]-1), 6) +( CAST(A.[Day] as int) -1)     
    --DATEADD(DAY,CAST(A.[Day] as int)+1, DATEADD(WEEK, CAST(A.[Week] as int)-1, DATEFROMPARTS(A.YEAR,A.Month,1)) )    
    --CAST((CAST(B.Month AS CHAR(2)))+ '/'+'01/' +cast(B.Year AS CHAR(4)) AS DATETIME) + ((B.Week * 7) - B.Day)    
    FROM EngPlannerTxnDet A INNER JOIN #EngPlannerTxnDet79 B ON A.PlannerDetId=B.PlannerDetId     
    WHERE A.PlannerId IN (SELECT DISTINCT PlannerId FROM #PlannerTxn)    
    AND A.ScheduleType=79    
        
  END    
    
 END     
END    
    
END TRY    
    
BEGIN CATCH    
    
 --IF @mTRANSCOUNT = 0    
 --       BEGIN    
 --           ROLLBACK TRAN    
 --       END    
    
 INSERT INTO ErrorLog(    
    Spname,    
    ErrorMessage,    
    createddate)    
 VALUES(  OBJECT_NAME(@@PROCID),    
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),    
    getdate()    
     );    
     THROW;    
    
END CATCH
GO
