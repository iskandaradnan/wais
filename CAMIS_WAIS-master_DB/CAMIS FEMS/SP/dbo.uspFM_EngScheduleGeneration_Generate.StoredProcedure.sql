USE [uetrackfemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngScheduleGeneration_Generate]    Script Date: 1/5/2022 2:17:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


              
              
/*========================================================================================================              
Application Name : UETrack-BEMS                            
Version    : 1.0              
Procedure Name  : uspFM_EngScheduleGeneration_Generate              
Description   : Get the Deduction_DashBoard              
Authors    : Dhilip V              
Date    : 11-May-2018              
-----------------------------------------------------------------------------------------------------------              
              
Unit Test:              
EXEC uspFM_EngScheduleGeneration_Generate  @pCustomerId=1,@pFacilityId=1,@pWorkGroupId=163,@pTypeOfPlanner=34,@pYear=2022,@pWeekNo=2,@pWeekStartDate='2022-01-10 00:00:00.000',@pWeekEndDate='2022-01-16 00:00:00.000',              
@pUserId=1,@pPageIndex=1,@pPageSize=100,@pUserAreaId = NULL, @pUserLocationId= NULL              
              
-----------------------------------------------------------------------------------------------------------              
Version History               
-----:------------:---------------------------------------------------------------------------------------              
Init : Date       : Details              
========================================================================================================*/              
DROP PROCEDURE  [dbo].[uspFM_EngScheduleGeneration_Generate]  
GO

CREATE PROCEDURE  [dbo].[uspFM_EngScheduleGeneration_Generate]                  
  @pFacilityId  INT,              
  @pCustomerId  INT,              
  @pWorkGroupId  INT,              
  @pTypeOfPlanner  INT,              
  @pYear    INT,              
  @pWeekNo   INT,              
  @pWeekStartDate  DATETIME,              
  @pWeekEndDate  DATETIME,              
  @pUserId   INT,              
  @pPageIndex   INT,              
  @pPageSize   INT,              
  @pUserAreaId  INT = NULL,              
  @pUserLocationId INT = NULL              
AS                                                             
              
BEGIN TRY              
              
 DECLARE @mTRANSCOUNT INT = @@TRANCOUNT              
 --BEGIN TRANSACTION              
-- Paramter Validation               
              
 SET NOCOUNT ON;               
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;              
              
-- Declaration              
 DECLARE @TotalRecords INT              
 DECLARE @pTotalPage  NUMERIC(24,2)              
 DECLARE @mLoopStart INT =1,@mLoopLimit INT              
 DECLARE @pOutParam NVARCHAR(50) ,@mMonth INT = MONTH(@pWeekStartDate) ,@mYear INT = YEAR(@pWeekStartDate)              
 DECLARE @mDateFmt NVARCHAR(100)              
 DECLARE @mDateFmtValue NVARCHAR(100)              
 DECLARE @PrimaryKeyId int              
 DECLARE @Table TABLE (ID INT,AssignedUserId int)              
 DECLARE @TableNotification TABLE (ID INT,userid int)              
   DECLARE @pFacility nvarchar(50)                    
  SELECT @pFacility = FacilityCode FROM MstLocationFacility WHERE FacilityId=@pFacilityId         
              
 CREATE TABLE #ScheduleWorkOrder ( SWOid INT IDENTITY(1,1) NOT NULL              
          ,CustomerId INT              
          ,FacilityId INT              
          ,ServiceId INT              
          ,AssetId INT              
          ,MaintenanceWorkNo NVARCHAR(100)              
          ,MaintenanceDetails NVARCHAR(500)              
          ,MaintenanceWorkCategory INT              
          ,TypeOfWorkOrder INT              
          ,MaintenanceWorkDateTime DATETIME              
          ,TargetDateTime DATETIME              
          ,PlannerId INT              
          ,WorkGroupId INT
		  ,WorkGroupType INT
          ,WorkOrderStatus INT              
          ,UserAreaId INT              
          ,UserLocationId INT              
          ,StandardTaskDetId INT              
          ,CreatedBy INT               
          ,CreatedDate  DATETIME              
          ,CreatedDateUTC DATETIME              
          ,ModifiedBy INT              
          ,ModifiedDate DATETIME        
          ,ModifiedDateUTC DATETIME              
          ,AssigneeCompanyUserId INT              
          ,AssetType nvarchar(100)              
         )             
-- Default Values              
              
-- Execution              
IF (@pTypeOfPlanner = 35)               
              
 BEGIN              
              
   INSERT INTO #ScheduleWorkOrder ( CustomerId              
             ,FacilityId              
             ,ServiceId              
             ,AssetId              
             ,MaintenanceWorkNo              
             ,MaintenanceDetails              
             ,MaintenanceWorkCategory              
             ,TypeOfWorkOrder              
             ,MaintenanceWorkDateTime              
             ,TargetDateTime              
             ,PlannerId              
             ,WorkGroupId 
			 ,WorkGroupType
             ,WorkOrderStatus              
             ,UserAreaId              
             ,UserLocationId              
             ,StandardTaskDetId              
             ,CreatedBy              
             ,CreatedDate              
             ,CreatedDateUTC              
             ,ModifiedBy              
             ,ModifiedDate              
             ,ModifiedDateUTC,              
             AssigneeCompanyUserId,              
             AssetType              
            )              
              
              
  SELECT DISTINCT Planner.CustomerId,              
    Planner.FacilityId,              
    Planner.ServiceId,              
    Planner.AssetId,              
    '' AS MaintenanceWorkNo,              
    '' AS MaintenanceDetails,              
    187 AS MaintenanceWorkCategory,              
    Planner.TypeOfPlanner,              
    GETDATE() AS MaintenanceWorkDateTime,              
    PlannerDet.PlannerDate AS TargetDateTime,              
    Planner.PlannerId,              
    Planner.WorkGroupId,
	Planner.AssetClassificationid, 
    192 AS WorkOrderStatus,              
    Planner.UserAreaId,              
    NULL UserLocationId,              
    Planner.StandardTaskDetId,              
    @pUserId,              
    GETDATE() AS CreatedDate,              
    GETUTCDATE() AS CreatedDateUTC,              
    @pUserId,              
    GETDATE() AS ModifiedDate,              
    GETUTCDATE() AS ModifiedDateUTC,              
    Planner.AssigneeCompanyUserId,              
    NULL              
  FROM EngPlannerTxn     AS Planner   WITH (NOLOCK)              
  INNER JOIN EngPlannerTxnDet   AS PlannerDet  WITH (NOLOCK) ON Planner.PlannerId = PlannerDet.PlannerId              
  INNER JOIN MstLocationUserArea  AS UserArea   WITH (NOLOCK) ON Planner.UserAreaId = UserArea.UserAreaId              
  INNER JOIN FMLovMst     AS LovTypePlanner WITH (NOLOCK) ON Planner.TypeOfPlanner = LovTypePlanner.LovId              
  WHERE (PlannerDet.PlannerDate >= @pWeekStartDate AND PlannerDet.PlannerDate <= @pWeekEndDate)              
    AND Planner.FacilityId  = @pFacilityId              
    AND Planner.TypeOfPlanner = @pTypeOfPlanner              
    AND Planner.WorkGroupId  = 1 
	AND Planner.AssetClassificationId  = @pWorkGroupId              
    AND ((ISNULL(@pUserAreaId,'')='' )  OR (ISNULL(@pUserAreaId,'') <> '' AND UserArea.UserAreaId = @pUserAreaId))              
    --AND ((ISNULL(@pUserLocationId,'')='' )  OR (ISNULL(@pUserLocationId,'') <> '' AND UserArea.UserLocationId = @pUserLocationId))              
 END              
              
ELSE IF (@pTypeOfPlanner <> 35)               
              
 BEGIN              
              
  create table #AssetTypeFinding(AssetId int,AssetType nvarchar(100))              
              
  insert into #AssetTypeFinding(AssetId,AssetType)              
  select Distinct AssetParentId,'Parent' as AssetType from EngAsset where AssetParentId >0              
              
  insert into #AssetTypeFinding(AssetId,AssetType)              
  select Distinct AssetId,'Child' as AssetType from EngAsset where AssetParentId >0 and AssetParentId is not null              
                
  --Below #PPM, #High temp tables created newly to filter high frequency assets only for Schedule generation. Date: 04/01/2022
  SELECT DISTINCT Planner.CustomerId,              
    Planner.FacilityId,              
    Planner.ServiceId,              
	Planner.AssetId,              
    '' AS MaintenanceWorkNo,              
    '' AS MaintenanceDetails,              
    187 AS MaintenanceWorkCategory,              
    Planner.TypeOfPlanner,              
    GETDATE() AS MaintenanceWorkDateTime,              
    PlannerDet.PlannerDate AS TargetDateTime,              
    Planner.PlannerId,              
    Planner.WorkGroupId,
	Planner.AssetClassificationid,
    192 AS WorkOrderStatus,              
    Planner.UserAreaId,              
    Asset.UserLocationId,              
    Planner.StandardTaskDetId,                            
    GETDATE() AS CreatedDate,              
    GETUTCDATE() AS CreatedDateUTC,                           
    GETDATE() AS ModifiedDate,              
    GETUTCDATE() AS ModifiedDateUTC,              
    AssigneeCompanyUserId,              
    ISNULL(AssetTypeValue.AssetType,'') AS AssetType ,
	Planner.IntervalInWeeks
	INTO #PPM             
  FROM EngPlannerTxn     AS Planner   WITH (NOLOCK)              
  INNER JOIN EngPlannerTxnDet   AS PlannerDet  WITH (NOLOCK) ON Planner.PlannerId = PlannerDet.PlannerId              
  INNER JOIN EngAsset     AS Asset   WITH (NOLOCK) ON Planner.AssetId = Asset.AssetId              
  INNER JOIN FMLovMst     AS LovTypePlanner WITH (NOLOCK) ON Planner.TypeOfPlanner = LovTypePlanner.LovId              
  LEFT  JOIN #AssetTypeFinding  AS AssetTypeValue WITH (NOLOCK) ON Planner.AssetId  = AssetTypeValue.AssetId              
  WHERE (PlannerDet.PlannerDate >= @pWeekStartDate AND PlannerDet.PlannerDate <= @pWeekEndDate)              
    AND Planner.FacilityId  = @pFacilityId              
    AND Planner.TypeOfPlanner = @pTypeOfPlanner              
    AND Planner.WorkGroupId  =1            
	AND Planner.AssetClassificationId=@pWorkGroupId 
    AND ((ISNULL(@pUserAreaId,'')='' )  OR (ISNULL(@pUserAreaId,'') <> '' AND Asset.UserAreaId = @pUserAreaId))              
    AND ((ISNULL(@pUserLocationId,'')='' )  OR (ISNULL(@pUserLocationId,'') <> '' AND Asset.UserLocationId = @pUserLocationId))              
	
	--below statement used to get highest frequency for the Asset
     select AssetId,max(IntervalInWeeks) as maxweek into #High from #PPM group by AssetId 
	            
   INSERT INTO #ScheduleWorkOrder ( CustomerId              
             ,FacilityId              
             ,ServiceId              
             ,AssetId              
             ,MaintenanceWorkNo              
             ,MaintenanceDetails              
             ,MaintenanceWorkCategory              
             ,TypeOfWorkOrder              
             ,MaintenanceWorkDateTime              
             ,TargetDateTime              
             ,PlannerId              
             ,WorkGroupId
			 ,WorkGroupType
             ,WorkOrderStatus              
             ,UserAreaId              
             ,UserLocationId              
             ,StandardTaskDetId              
             ,CreatedBy              
             ,CreatedDate             
             ,CreatedDateUTC              
             ,ModifiedBy              
             ,ModifiedDate              
             ,ModifiedDateUTC              
             ,AssigneeCompanyUserId              
             ,AssetType              
            )              
                           
              
  SELECT DISTINCT Planner.CustomerId,              
    Planner.FacilityId,              
    Planner.ServiceId,              
	Planner.AssetId,              
    '' AS MaintenanceWorkNo,              
    '' AS MaintenanceDetails,              
    187 AS MaintenanceWorkCategory,              
    Planner.TypeOfPlanner,              
    GETDATE() AS MaintenanceWorkDateTime,              
    Planner.TargetDateTime,              
    Planner.PlannerId,              
    Planner.WorkGroupId,
	Planner.AssetClassificationid,
    192 AS WorkOrderStatus,              
    Planner.UserAreaId,              
    Planner.UserLocationId,              
    Planner.StandardTaskDetId,              
    @pUserId,              
    GETDATE() AS CreatedDate,              
    GETUTCDATE() AS CreatedDateUTC,              
    @pUserId,              
    GETDATE() AS ModifiedDate,              
    GETUTCDATE() AS ModifiedDateUTC,              
    AssigneeCompanyUserId,              
    Planner.AssetType              
  FROM #PPM     AS Planner   WITH (NOLOCK)              
  INNER JOIN #High   AS H  WITH (NOLOCK) on Planner.AssetId=H.AssetId and Planner.IntervalInWeeks=H.maxweek  

 END              
              
              
 -----------------IsParentChildAvailable Checking              
              
 alter table #ScheduleWorkOrder add IsParentChildAvailable Bit              
                
  DECLARE @ParentCount INT              
  DECLARE @ChildCount INT              
              
  SET @ParentCount = (SELECT COUNT(*) FROM #ScheduleWorkOrder WHERE AssetType='Parent')              
  SET @ChildCount = (SELECT COUNT(*) FROM #ScheduleWorkOrder WHERE AssetType='Child')              
              
  UPDATE #ScheduleWorkOrder SET IsParentChildAvailable = 0 WHERE (@ParentCount =0 AND @ChildCount = 0)              
  UPDATE #ScheduleWorkOrder SET IsParentChildAvailable = 1 WHERE (@ParentCount >=1 OR @ChildCount >=1)              
              
              
DECLARE @pMaintenanceWorkNo NVARCHAR(50) ,@mDefaultkey NVARCHAR(50)     
DECLARE @pPlannerType NVARCHAR(50)               
              
 SELECT @mLoopLimit = COUNT(1) FROM #ScheduleWorkOrder              
 WHILE (@mLoopStart<=@mLoopLimit)              
 BEGIN              
                
              
  IF((SELECT TypeOfWorkOrder FROM #ScheduleWorkOrder WHERE SWOid = @mLoopStart)=34)              
   BEGIN               
    SET @pPlannerType = 'PMW'              
   END              
  ELSE IF((SELECT TypeOfWorkOrder FROM #ScheduleWorkOrder WHERE SWOid = @mLoopStart)=198)              
   BEGIN             
    SET @pPlannerType = 'CAL'              
   END              
  ELSE IF((SELECT TypeOfWorkOrder FROM #ScheduleWorkOrder WHERE SWOid = @mLoopStart)=35)              
   BEGIN               
    SET @pPlannerType = 'RI'              
   END              
  ELSE IF((SELECT TypeOfWorkOrder FROM #ScheduleWorkOrder WHERE SWOid = @mLoopStart)=36)              
   BEGIN               
    SET @pPlannerType = 'PDM'              
   END              
  ELSE IF((SELECT TypeOfWorkOrder FROM #ScheduleWorkOrder WHERE SWOid = @mLoopStart)=343)              
   BEGIN             
    SET @pPlannerType = 'RQC'              
   END              
              
 IF((SELECT TypeOfWorkOrder FROM #ScheduleWorkOrder WHERE SWOid = @mLoopStart)<>35)              
 BEGIN              
  IF EXISTS (SELECT 1 FROM EngContractOutRegisterDet WHERE AssetId in (select AssetId from #ScheduleWorkOrder where SWOid=@mLoopStart))              
   BEGIN              
    SET @mDefaultkey='CWO'              
   END              
   ELSE              
   BEGIN              
    SET @mDefaultkey='WWO'              
   END              
 END              
 ELSE              
  BEGIN              
   SET @mDefaultkey='WO'              
  END              
               
      -- set @mDefaultkey= @mDefaultkey+@pFacility+'/F'      
    set @mDefaultkey= @pPlannerType+@pFacility+'/F/'          
  EXEC [uspFM_GenerateDocumentNumber] @pFlag='EngMaintenanceWorkOrderTxnSchd',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey=@mDefaultkey,@pService=@pPlannerType,@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT              
  SELECT @pMaintenanceWorkNo= @pOutParam               
  UPDATE #ScheduleWorkOrder SET MaintenanceWorkNo = @pMaintenanceWorkNo WHERE SWOid = @mLoopStart              
                
 SET @mLoopStart = @mLoopStart+1              
 END              
              
 ----- Date updation  
 
 IF (@pTypeOfPlanner <> 35)               
              
 BEGIN      
              
     UPDATE B SET B.LastDate = B.NextDate FROM #PPM A INNER JOIN EngPlannerTxn B ON A.PlannerId = B.PlannerId       
 INNER JOIN EngPlannerTxnDet C ON B.PlannerId = C.PlannerId WHERE B.LastDate IS Not NULL and B.NextDate is not NULL AND B.GenerationType = 365      

  UPDATE B SET B.LastDate = B.FirstDate FROM #PPM A INNER JOIN EngPlannerTxn B ON A.PlannerId = B.PlannerId       
 INNER JOIN EngPlannerTxnDet C ON B.PlannerId = C.PlannerId WHERE B.LastDate IS NULL and b.FirstDate is not Null AND B.GenerationType = 365      
  
   
  UPDATE B SET B.NextDate = DATEADD(WEEK,(B.IntervalInWeeks),B.LastDate) FROM #PPM A INNER JOIN EngPlannerTxn B ON A.PlannerId = B.PlannerId       
 INNER JOIN EngPlannerTxnDet C ON B.PlannerId = C.PlannerId WHERE B.LastDate IS NOT NULL AND B.GenerationType = 365      
      
       
 UPDATE C SET C.PlannerDate = B.NextDate FROM #PPM A INNER JOIN EngPlannerTxn B ON A.PlannerId = B.PlannerId       
 INNER JOIN EngPlannerTxnDet C ON B.PlannerId = C.PlannerId WHERE B.LastDate IS NOT NULL and B.NextDate is not NULL AND B.GenerationType = 365      
               
 END
 ELSE
 
 BEGIN
  UPDATE B SET B.LastDate = B.NextDate FROM #ScheduleWorkOrder A INNER JOIN EngPlannerTxn B ON A.PlannerId = B.PlannerId       
 INNER JOIN EngPlannerTxnDet C ON B.PlannerId = C.PlannerId WHERE B.LastDate IS Not NULL and B.NextDate is not NULL AND B.GenerationType = 365      

  UPDATE B SET B.LastDate = B.FirstDate FROM #ScheduleWorkOrder A INNER JOIN EngPlannerTxn B ON A.PlannerId = B.PlannerId       
 INNER JOIN EngPlannerTxnDet C ON B.PlannerId = C.PlannerId WHERE B.LastDate IS NULL and b.FirstDate is not Null AND B.GenerationType = 365      
  
   
  UPDATE B SET B.NextDate = DATEADD(WEEK,(B.IntervalInWeeks),B.LastDate) FROM #ScheduleWorkOrder A INNER JOIN EngPlannerTxn B ON A.PlannerId = B.PlannerId       
 INNER JOIN EngPlannerTxnDet C ON B.PlannerId = C.PlannerId WHERE B.LastDate IS NOT NULL AND B.GenerationType = 365      
      
       
 UPDATE C SET C.PlannerDate = B.NextDate FROM #ScheduleWorkOrder A INNER JOIN EngPlannerTxn B ON A.PlannerId = B.PlannerId       
 INNER JOIN EngPlannerTxnDet C ON B.PlannerId = C.PlannerId WHERE B.LastDate IS NOT NULL and B.NextDate is not NULL AND B.GenerationType = 365      
 
 END             
 
              
 --    UPDATE B SET B.LastDate = B.NextDate FROM #PPM A INNER JOIN EngPlannerTxn B ON A.PlannerId = B.PlannerId       
 --INNER JOIN EngPlannerTxnDet C ON B.PlannerId = C.PlannerId WHERE B.LastDate IS Not NULL and B.NextDate is not NULL AND B.GenerationType = 365      

 -- UPDATE B SET B.LastDate = B.FirstDate FROM #PPM A INNER JOIN EngPlannerTxn B ON A.PlannerId = B.PlannerId       
 --INNER JOIN EngPlannerTxnDet C ON B.PlannerId = C.PlannerId WHERE B.LastDate IS NULL and b.FirstDate is not Null AND B.GenerationType = 365      
  
   
 -- UPDATE B SET B.NextDate = DATEADD(WEEK,(B.IntervalInWeeks),B.LastDate) FROM #PPM A INNER JOIN EngPlannerTxn B ON A.PlannerId = B.PlannerId       
 --INNER JOIN EngPlannerTxnDet C ON B.PlannerId = C.PlannerId WHERE B.LastDate IS NOT NULL AND B.GenerationType = 365      
      
       
 --UPDATE C SET C.PlannerDate = B.NextDate FROM #PPM A INNER JOIN EngPlannerTxn B ON A.PlannerId = B.PlannerId       
 --INNER JOIN EngPlannerTxnDet C ON B.PlannerId = C.PlannerId WHERE B.LastDate IS NOT NULL and B.NextDate is not NULL AND B.GenerationType = 365      
               
              
              
               
 --UPDATE C SET C.PlannerDate = B.NextDate FROM #ScheduleWorkOrder A INNER JOIN EngPlannerTxn B ON A.PlannerId = B.PlannerId               
 --INNER JOIN EngPlannerTxnDet C ON B.PlannerId = C.PlannerId WHERE B.LastDate IS NOT NULL AND A.TypeOfWorkOrder = 34 AND B.GenerationType = 365              
              
 --UPDATE B SET B.LastDate = B.NextDate FROM #ScheduleWorkOrder A INNER JOIN EngPlannerTxn B ON A.PlannerId = B.PlannerId               
 --INNER JOIN EngPlannerTxnDet C ON B.PlannerId = C.PlannerId WHERE B.LastDate IS NOT NULL AND A.TypeOfWorkOrder = 34 AND B.GenerationType = 365              
              
 --UPDATE B SET B.NextDate = DATEADD(DAY,(B.IntervalInWeeks*7),B.NextDate) FROM #ScheduleWorkOrder A INNER JOIN EngPlannerTxn B ON A.PlannerId = B.PlannerId               
 --INNER JOIN EngPlannerTxnDet C ON B.PlannerId = C.PlannerId WHERE B.LastDate IS NOT NULL AND A.TypeOfWorkOrder = 34 AND B.GenerationType = 365              
              
              
 --UPDATE C SET C.PlannerDate = B.NextDate FROM #ScheduleWorkOrder A INNER JOIN EngPlannerTxn B ON A.PlannerId = B.PlannerId               
 --INNER JOIN EngPlannerTxnDet C ON B.PlannerId = C.PlannerId WHERE  B.LastDate IS NULL AND A.TypeOfWorkOrder = 34 AND B.GenerationType = 365              
              
 --UPDATE B SET B.NextDate = DATEADD(DAY,(B.IntervalInWeeks*7),B.NextDate) FROM #ScheduleWorkOrder A INNER JOIN EngPlannerTxn B ON A.PlannerId = B.PlannerId               
 --INNER JOIN EngPlannerTxnDet C ON B.PlannerId = C.PlannerId WHERE  B.LastDate IS NULL AND A.TypeOfWorkOrder = 34 AND B.GenerationType = 365              
              
 --UPDATE B SET B.LastDate = B.FirstDate FROM #ScheduleWorkOrder A INNER JOIN EngPlannerTxn B ON A.PlannerId = B.PlannerId               
 --INNER JOIN EngPlannerTxnDet C ON B.PlannerId = C.PlannerId WHERE B.LastDate IS NULL AND A.TypeOfWorkOrder = 34 AND B.GenerationType = 365              
               

   Declare @Woid int=@pWorkGroupId 
              if(@pWorkGroupId=0)
			  begin 
					set @Woid=1
			  end 
			  else if(@pWorkGroupId>0)
			  begin 
					set @Woid=@pWorkGroupId
			  end 
          
-- Main table insert.              
              
  INSERT INTO EngMaintenanceWorkOrderTxn ( CustomerId              
             ,FacilityId              
             ,ServiceId              
             ,AssetId              
             ,MaintenanceWorkNo              
             ,MaintenanceDetails              
             ,MaintenanceWorkCategory              
             ,TypeOfWorkOrder              
             ,MaintenanceWorkDateTime              
             ,TargetDateTime              
             ,PlannerId              
             ,WorkGroupId
			 ,WorkGroupType
             ,WorkOrderStatus              
             ,UserAreaId              
             ,UserLocationId              
             ,StandardTaskDetId              
             ,CreatedBy              
             ,CreatedDate              
             ,CreatedDateUTC              
             ,ModifiedBy              
             ,ModifiedDate              
             ,ModifiedDateUTC              
             ,AssignedUserId              
             ,EngineerUserId         
			 ,MaintenanceWorkType     
            ) OUTPUT INSERTED.WorkOrderId,INSERTED.AssignedUserId INTO @Table              
              
              
           SELECT CustomerId              
             ,FacilityId              
             ,ServiceId              
             ,AssetId              
             ,MaintenanceWorkNo              
             ,MaintenanceDetails              
             ,MaintenanceWorkCategory              
             ,TypeOfWorkOrder              
             ,MaintenanceWorkDateTime              
             ,TargetDateTime              
             ,PlannerId              
             ,WorkGroupId
			 ,WorkGroupType
             ,WorkOrderStatus              
             ,UserAreaId              
             ,UserLocationId              
   ,StandardTaskDetId              
             ,CreatedBy              
             ,CreatedDate              
             ,CreatedDateUTC              
             ,ModifiedBy              
             ,ModifiedDate              
             ,ModifiedDateUTC              
             ,AssigneeCompanyUserId              
             ,AssigneeCompanyUserId              
			    ,TypeOfWorkOrder 
           FROM #ScheduleWorkOrder              
              
              
              
 SELECT @TotalRecords = COUNT(1)              
 FROM #ScheduleWorkOrder              
 SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))              
 SET @pTotalPage = CEILING(@pTotalPage)              
              
              
IF(@pTypeOfPlanner<>35)              
               
 BEGIN              
 if @pPageSize!=1               
 begin               
               
 SELECT PlannerId,              
   NULL AS UserAreaId,              
   NULL AS UserAreaCode,              
   NULL AS UserAreaName,              
   Asset.AssetId,              
   Asset.AssetNo,              
   MaintenanceWorkNo AS WorkOrderNo,              
   'W2' AS WorkGroupCode,              
   MaintenanceWorkDateTime AS WorkOrderDate,              
   TargetDateTime AS TargetDate,              
   LovTypePlanner.FieldValue AS TypeOfPlanner,              
   AssetType,              
   IsParentChildAvailable,              
   @TotalRecords    AS TotalRecords,              
   @pTotalPage     AS TotalPageCalc              
 FROM #ScheduleWorkOrder     AS SWO              
  INNER JOIN EngAsset     AS Asset   WITH (NOLOCK) ON SWO.AssetId   = Asset.AssetId              
  INNER JOIN FMLovMst     AS LovTypePlanner WITH (NOLOCK) ON SWO.TypeOfWorkOrder = LovTypePlanner.LovId           
 ORDER BY AssetNo ASC              
 OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY               
              
 END              
              
 END              
              
ELSE              
               
 BEGIN              
              
 SELECT PlannerId,              
   UserArea.UserAreaId,              
   UserArea.UserAreaCode,              
   UserArea.UserAreaName,              
   NULL AS AssetId,              
   NULL AS AssetNo,              
   MaintenanceWorkNo AS WorkOrderNo,              
   'W2' AS WorkGroupCode,              
   MaintenanceWorkDateTime AS WorkOrderDate,              
   TargetDateTime AS TargetDate,              
   LovTypePlanner.FieldValue AS TypeOfPlanner,              
   NULL AS AssetType,              
   0 AS IsParentChildAvailable,              
   @TotalRecords    AS TotalRecords,              
   @pTotalPage     AS TotalPageCalc              
 FROM #ScheduleWorkOrder     AS SWO              
  INNER JOIN MstLocationUserArea  AS UserArea   WITH (NOLOCK) ON SWO.UserAreaId   = UserArea.UserAreaId              
  INNER JOIN FMLovMst     AS LovTypePlanner WITH (NOLOCK) ON SWO.TypeOfWorkOrder = LovTypePlanner.LovId              
 ORDER BY AssetNo ASC              
 OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY               
              
 END              
              
              
  INSERT INTO EngScheduleGenerationWeekLog ( FacilityId,              
            CustomerId,              
            ServiceId,              
            TypeOfPlanner,              
            Year,              
            WeekNo,              
            WeekStartDate,              
            WeekEndDate,              
            GenerateDate,              
            WorkGroupId,              
            CreatedBy,              
       CreatedDate,              
            CreatedDateUTC,              
            ModifiedBy,              
            ModifiedDate,              
            ModifiedDateUTC   ,  
   ClassificationId           
           )               
         VALUES ( @pFacilityId,              
            @pCustomerId,              
            1,              
            @pTypeOfPlanner,              
            @pYear,              
            @pWeekNo,              
            @pWeekStartDate,              
            @pWeekEndDate,              
            GETDATE(),              
           1 ,              
            @pUserId,              
            GETDATE(),              
            GETUTCDATE(),              
            @pUserId,              
            GETDATE(),              
            GETUTCDATE() ,  
   @pWorkGroupId             
           )              
              
---------- Notification Alerts------------              
              
 SELECT ID,@pUserId AS UserId,AssignedUserId INTO #Temp FROM @Table              
              
 SELECT AssignedUserId,COUNT(AssignedUserId) as CNT INTO #TempUserGroupBy FROM #Temp group by AssignedUserId              
              
 SELECT @mDateFmt = b.FieldValue                
 FROM FMConfigCustomerValues a               
   INNER JOIN FMLovMst b on a.ConfigKeyLovId=b.LovId              
 WHERE A.KeyName='DATE'              
   AND CustomerId IN (SELECT DISTINCT TOP 1  CustomerId FROM EngMaintenanceWorkOrderTxn  WHERE WorkOrderId IN (SELECT ID FROM @Table))              
              
 IF (@mDateFmt='DD-MMM-YYYY')              
  BEGIN              
   SET @mDateFmtValue = REPLACE(CONVERT(VARCHAR, GETDATE(), 6),' ','-')              
  END              
 ELSE IF (@mDateFmt='DD/MMM/YYYY')              
  BEGIN              
   SET @mDateFmtValue = REPLACE(CONVERT(VARCHAR, GETDATE(), 6),' ','/')              
  END            
            
  --Added on 2020 -JAN-24            
    SET @mDateFmtValue= GETDATE();          
 INSERT INTO QueueWebtoMobile (  TableName,              
           Tableprimaryid,              
           UserId              
         )              
     SELECT 'EngMaintenanceWorkOrderTxn',              
       ID,              
       --UserId              
       AssignedUserId              
     FROM #Temp              
                
 INSERT INTO FENotification ( UserId,              
         NotificationAlerts,              
         Remarks,              
         CreatedBy,              
         CreatedDate,              
         CreatedDateUTC,              
         ModifiedBy,              
         ModifiedDate,              
         ModifiedDateUTC,              
         ScreenName,                       
         SingleRecord              
        ) OUTPUT INSERTED.NotificationId,INSERTED.UserId INTO @TableNotification              
     SELECT AssignedUserId,              
       cast(CNT as nvarchar(10)) + ' Scheduled Work Order has been assinged to you on Dt '+ @mDateFmtValue,              
       'Scheduled work order' AS Remarks,              
       @pUserId,              
       GETDATE(),              
       GETUTCDATE(),              
       @pUserId,              
       GETDATE(),              
       GETUTCDATE(),              
       'EngMaintenanceWorkOrderTxn',       
       0              
     FROM #TempUserGroupBy              
                   
 INSERT INTO QueueWebtoMobile (  TableName,              
           Tableprimaryid,              
           UserId              
         )              
     SELECT 'FENotification',              
       ID,              
       UserId              
     FROM @TableNotification              
              
              
              
              
 --IF @mTRANSCOUNT = 0              
 --       BEGIN              
 --           COMMIT TRANSACTION              
 --       END               
              
              
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
