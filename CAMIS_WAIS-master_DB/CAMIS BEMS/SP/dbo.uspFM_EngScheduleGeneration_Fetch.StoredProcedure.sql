USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngScheduleGeneration_Fetch]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
/*========================================================================================================  
Application Name : UETrack-BEMS                
Version    : 1.0  
Procedure Name  : uspFM_EngScheduleGeneration_Fetch  
Description   : Get the Deduction_DashBoard  
Authors    : Dhilip V  
Date    : 11-May-2018  
-----------------------------------------------------------------------------------------------------------  
  
Unit Test:  
EXEC uspFM_EngScheduleGeneration_Fetch  @pCustomerId=1,@pFacilityId=1,@pWorkGroupId=1,@pTypeOfPlanner=34,@pYear=2018,@pWeekNo=10,@pWeekStartDate='2018-03-04 00:00:00.000',@pWeekEndDate='2018-03-10 00:00:00.000',  
@pUserId=null,@pPageIndex=1,@pPageSize=50,@pUserAreaId=null,@pUserLocationId=null  
  
-----------------------------------------------------------------------------------------------------------  
Version History   
-----:------------:---------------------------------------------------------------------------------------  
Init : Date       : Details  
========================================================================================================*/  
CREATE PROCEDURE  [dbo].[uspFM_EngScheduleGeneration_Fetch]      
  @pCustomerId  INT,  
  @pFacilityId  INT,  
  @pWorkGroupId  INT =NULL,  
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
  
-- Paramter Validation   
  
 SET NOCOUNT ON;   
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
-- Declaration  
  
 DECLARE @TotalRecords INT  
 DECLARE @pTotalPage  NUMERIC(24,2)  
  
-- Default Values  
  
   
  
-- Execution  
  
--1 PPM  
IF (@pTypeOfPlanner = 35)   
  
 BEGIN  
  
 /* SELECT @TotalRecords = COUNT(1)  
  FROM EngPlannerTxn     AS Planner   WITH (NOLOCK)  
  INNER JOIN EngPlannerTxnDet   AS PlannerDet  WITH (NOLOCK) ON Planner.PlannerId = PlannerDet.PlannerId  
  INNER JOIN MstLocationUserArea  AS UserArea   WITH (NOLOCK) ON Planner.UserAreaId = UserArea.UserAreaId  
  INNER JOIN FMLovMst     AS LovTypePlanner WITH (NOLOCK) ON Planner.TypeOfPlanner = LovTypePlanner.LovId  
  WHERE (PlannerDet.PlannerDate >= @pWeekStartDate AND PlannerDet.PlannerDate <= @pWeekEndDate)  
    AND Planner.FacilityId  = @pFacilityId  
    AND Planner.TypeOfPlanner = @pTypeOfPlanner  
    AND Planner.WorkGroupId  = @pWorkGroupId  
    AND ((ISNULL(@pUserAreaId,'')='' )  OR (ISNULL(@pUserAreaId,'') <> '' AND UserArea.UserAreaId = @pUserAreaId))  
    --AND ((ISNULL(@pUserLocationId,'')='' )  OR (ISNULL(@pUserLocationId,'') <> '' AND UserArea.UserLocationId = @pUserLocationId))  
  
  SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))  
  SET @pTotalPage = CEILING(@pTotalPage)  
  */  
  SELECT DISTINCT *  INTO #RI FROM(  
  SELECT DISTINCT Planner.PlannerId,  
    UserArea.UserAreaId,  
    UserArea.UserAreaCode,  
    UserArea.UserAreaName,  
    null as AssetNo,  
    null as AssetId,  
    '' AS WorkOrderNo,  
    'W2' AS WorkGroupCode,  
    GETDATE() AS WorkOrderDate,  
    PlannerDet.PlannerDate AS TargetDate,  
    LovTypePlanner.FieldValue AS TypeOfPlanner,  
    NULL        AS AssetType,  
    CAST(0 AS BIT)      AS IsParentChildAvailable  
  FROM EngPlannerTxn     AS Planner   WITH (NOLOCK)  
  INNER JOIN EngPlannerTxnDet   AS PlannerDet  WITH (NOLOCK) ON Planner.PlannerId = PlannerDet.PlannerId  
  INNER JOIN MstLocationUserArea  AS UserArea   WITH (NOLOCK) ON Planner.UserAreaId = UserArea.UserAreaId  
  INNER JOIN FMLovMst     AS LovTypePlanner WITH (NOLOCK) ON Planner.TypeOfPlanner = LovTypePlanner.LovId  
  WHERE (PlannerDet.PlannerDate >= @pWeekStartDate AND PlannerDet.PlannerDate <= @pWeekEndDate)  
    AND Planner.FacilityId  = @pFacilityId  
    AND Planner.TypeOfPlanner = @pTypeOfPlanner  
    AND ((ISNULL(@pUserAreaId,'')='' )  OR (ISNULL(@pUserAreaId,'') <> '' AND UserArea.UserAreaId = @pUserAreaId))  
    --AND ((ISNULL(@pUserLocationId,'')='' )  OR (ISNULL(@pUserLocationId,'') <> '' AND UserArea.UserLocationId = @pUserLocationId))  
  --ORDER BY UserArea.UserAreaCode ASC  
  --OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY   
  ) A  
  
  SELECT @TotalRecords = COUNT(1)  
  FROM #RI  
  SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))  
  SET @pTotalPage = CEILING(@pTotalPage)  
  
  SELECT PlannerId,  
    UserAreaId,  
    UserAreaCode,  
    UserAreaName,  
    AssetNo,  
    AssetId,  
    WorkOrderNo,  
    WorkGroupCode,  
    WorkOrderDate,  
    TargetDate,  
    TypeOfPlanner,  
    AssetType,  
    IsParentChildAvailable,  
    @TotalRecords    AS TotalRecords,  
    @pTotalPage     AS TotalPageCalc  
  FROM #RI  
  ORDER BY UserAreaCode ASC  
  OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY   
  
 END  
--1 RI  
ELSE IF (@pTypeOfPlanner <> 35)  
 BEGIN  

 
 /*  
  SELECT @TotalRecords = COUNT(1)  
  FROM EngPlannerTxn     AS Planner   WITH (NOLOCK)  
  INNER JOIN EngPlannerTxnDet   AS PlannerDet  WITH (NOLOCK) ON Planner.PlannerId = PlannerDet.PlannerId  
  INNER JOIN EngAsset     AS Asset   WITH (NOLOCK) ON Planner.AssetId = Asset.AssetId  
  INNER JOIN FMLovMst     AS LovTypePlanner WITH (NOLOCK) ON Planner.TypeOfPlanner = LovTypePlanner.LovId  
  WHERE (PlannerDet.PlannerDate >= @pWeekStartDate AND PlannerDet.PlannerDate <= @pWeekEndDate)  
    AND Planner.FacilityId  = @pFacilityId  
    AND Planner.TypeOfPlanner = @pTypeOfPlanner  
    AND Planner.WorkGroupId  = @pWorkGroupId  
    AND ((ISNULL(@pUserAreaId,'')='' )  OR (ISNULL(@pUserAreaId,'') <> '' AND Asset.UserAreaId = @pUserAreaId))  
    AND ((ISNULL(@pUserLocationId,'')='' )  OR (ISNULL(@pUserLocationId,'') <> '' AND Asset.UserLocationId = @pUserLocationId))  
  
  SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))  
  SET @pTotalPage = CEILING(@pTotalPage)  
  */  
  
  create table #AssetTypeFinding(AssetId int,AssetType nvarchar(100))  
  
  insert into #AssetTypeFinding(AssetId,AssetType)  
  select Distinct AssetParentId,'Parent' as AssetType from EngAsset where AssetParentId >0  
  
  insert into #AssetTypeFinding(AssetId,AssetType)  
  select Distinct AssetId,'Child' as AssetType from EngAsset where AssetParentId >0 and AssetParentId is not null  
  
  SELECT DISTINCT *  INTO #PPM FROM(  
  SELECT Planner.PlannerId,  
    NULL        AS UserAreaId,  
    NULL        AS UserAreaCode,  
    NULL        AS UserAreaName,  
    Asset.AssetId,  
    Asset.AssetNo,  
    ''         AS WorkOrderNo,  
    'W2'        AS WorkGroupCode,  
    GETDATE()       AS WorkOrderDate,  
    PlannerDet.PlannerDate    AS TargetDate,  
    LovTypePlanner.FieldValue   AS TypeOfPlanner,  
    ISNULL(AssetTypeValue.AssetType,'') AS AssetType,  
    CAST(0 AS BIT)      AS IsParentChildAvailable,  
    @TotalRecords    AS TotalRecords,  
    @pTotalPage     AS TotalPageCalc  
  --INTO #PPM  
  FROM EngPlannerTxn     AS Planner   WITH (NOLOCK)  
  INNER JOIN EngPlannerTxnDet   AS PlannerDet  WITH (NOLOCK) ON Planner.PlannerId  = PlannerDet.PlannerId  
  INNER JOIN EngAsset     AS Asset   WITH (NOLOCK) ON Planner.AssetId  = Asset.AssetId  
  INNER JOIN FMLovMst     AS LovTypePlanner WITH (NOLOCK) ON Planner.TypeOfPlanner = LovTypePlanner.LovId  
  LEFT  JOIN #AssetTypeFinding  AS AssetTypeValue WITH (NOLOCK) ON Planner.AssetId  = AssetTypeValue.AssetId  
  WHERE (PlannerDet.PlannerDate >= @pWeekStartDate AND PlannerDet.PlannerDate <= @pWeekEndDate)  
    AND Planner.FacilityId  = @pFacilityId  
    AND Planner.TypeOfPlanner = @pTypeOfPlanner  
    AND ((ISNULL(@pUserAreaId,'')='' )  OR (ISNULL(@pUserAreaId,'') <> '' AND Asset.UserAreaId = @pUserAreaId))  
    AND ((ISNULL(@pUserLocationId,'')='' )  OR (ISNULL(@pUserLocationId,'') <> '' AND Asset.UserLocationId = @pUserLocationId))  
  --ORDER BY Asset.AssetNo ASC  
  --OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY   
  ) A  
  
  
  SELECT @TotalRecords = COUNT(1)  
  FROM #PPM  
  SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))  
  SET @pTotalPage = CEILING(@pTotalPage)  
  
  DECLARE @ParentCount INT  
  DECLARE @ChildCount INT  
  
  SET @ParentCount = (SELECT COUNT(*) FROM #PPM WHERE AssetType='Parent')  
  SET @ChildCount = (SELECT COUNT(*) FROM #PPM WHERE AssetType='Child')  
  
  UPDATE #PPM SET IsParentChildAvailable = 1 WHERE (@ParentCount >=1 OR @ChildCount >=1)  
  
  SELECT PlannerId,  
    UserAreaId,  
    UserAreaCode,  
    UserAreaName,  
    AssetNo,  
    AssetId,  
    WorkOrderNo,  
    WorkGroupCode,  
    WorkOrderDate,  
    TargetDate,  
    TypeOfPlanner,  
    AssetType,  
    IsParentChildAvailable,  
    @TotalRecords    AS TotalRecords,  
    @pTotalPage     AS TotalPageCalc  
  FROM #PPM  
  ORDER BY AssetNo ASC  
  OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY   
  
  
  
  
 END  
  
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
