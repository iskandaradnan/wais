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
    CAST(0 AS BIT)      AS IsParentChildAvailable
  
  
  FROM EngPlannerTxn     AS Planner   WITH (NOLOCK)  
  INNER JOIN EngPlannerTxnDet   AS PlannerDet  WITH (NOLOCK) ON Planner.PlannerId  = PlannerDet.PlannerId  
  INNER JOIN EngAsset     AS Asset   WITH (NOLOCK) ON Planner.AssetId  = Asset.AssetId  
  INNER JOIN FMLovMst     AS LovTypePlanner WITH (NOLOCK) ON Planner.TypeOfPlanner = LovTypePlanner.LovId  
  --and PlannerDet.PlannerDate  is not null
  --order by PlannerDet.PlannerDate 

  WHERE (PlannerDet.PlannerDate >= '2020-01-06' AND PlannerDet.PlannerDate <= '2020-01-12')  
    AND Planner.FacilityId  = 144
    AND Planner.TypeOfPlanner = 34
    

EXEC 
uspFM_EngScheduleGeneration_Fetch  @pCustomerId=157,
@pFacilityId=144,@pWorkGroupId=1,
@pTypeOfPlanner=34,
@pYear=2020,
@pWeekNo=20,
@pWeekStartDate='2020-01-06 00:00:00.000',@pWeekEndDate='2020-1-12 00:00:00.000',  
@pUserId=null,@pPageIndex=1,@pPageSize=50,@pUserAreaId=null,@pUserLocationId=null  