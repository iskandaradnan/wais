USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Asis_BemsPlannedPreventiveScheduleRpt_L1]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                
Application Name : ASIS                
Version       :                 
File Name      : Asis_BemsPlannedPreventiveScheduleRpt_L1                
Procedure Name  : Asis_BemsPlannedPreventiveScheduleRpt_L1  
Author(s) Name(s) :  prasanna v  
Date       :   
Purpose       : SP For Planned Preventive Schedule Report     Level 1  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
EXEC Asis_bemsPlannedPreventiveScheduleRpt_L1 '','hospital','87','2513','2513','WorkGroup','2018-01-01','2018-12-30'

Modification History      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS    
								vasu  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/     
  
CREATE PROCEDURE [dbo].[Asis_BemsPlannedPreventiveScheduleRpt_L1]                                      
(                                                  
  @MenuName					VARCHAR(100),   
  @Level					VARCHAR(30),
  @Option					VARCHAR(30),
  @Planner_Classification   VARCHAR(30),
  @Type_Of_Planner          VARCHAR(30),
  @Group_By                 VARCHAR(20), 
  @From_Date				VARCHAR(20),
  @To_Date					VARCHAR(20)     
 )               
AS                                                  
BEGIN                                    
SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY

if(@Planner_Classification = 34)
begin
set @Type_Of_Planner = 34
end

--if (@Month = 'All')
--begin
--		SET @month='''01'',''02'',''03'',''04'',''05'',''06'',''07'',''08'',''09'',''10'',''11'',''12'''
--end

Declare  @Hospital_Master  table (  FacilityId int)     

                

 IF (@Level='national')         
 BEGIN       
	insert into  @Hospital_Master        
	Select  FacilityId FROM MstLocationFacility WITH(NOLOCK) --Where IsDeleted=0 
 END   
 ELSE IF (@Level='consortia')         
 BEGIN  
	 insert into  @Hospital_Master         
	 Select  FacilityId FROM MstLocationFacility WITH(NOLOCK) --Where companyid=@Option and IsDeleted=0 
 END 
 ELSE IF (@Level='State')         
 BEGIN  
	insert into  @Hospital_Master         
    Select  FacilityId FROM MstLocationFacility WITH(NOLOCK) --Where stateid=@Option and IsDeleted=0 
 END 
 ELSE IF (@Level='hospital')  
 begin  
	 insert into  @Hospital_Master    
	 select @Option
 END



CREATE TABLE #FINAL           
 (          
  row_id int identity(1,1),               
  FacilityId VARCHAR(50),
  Total      VARCHAR(10)
 )    

IF(@Group_By = 'TaskCode')  
BEGIN  		    
  
 -------------------------------------------------------- PPM PLANNER SCHEDULE -----------------------------------------------
   
   
 IF (@Planner_Classification = 30  )  --- RI

BEGIN  

  INSERT INTO #FINAL ( FacilityId, Total   )     
  SELECT DISTINCT PLANNER_DET.FacilityId,Count(distinct MAINT_WO.WorkOrderId)
  FROM 	EngPlannerTxn			 AS PLANNER_DET	 with(nolock)			
  join @Hospital_Master h on PLANNER_DET.FacilityId = h.FacilityId
  JOIN	EngMaintenanceWorkOrderTxn   AS MAINT_WO	with(nolock)	on MAINT_WO.PlannerId = PLANNER_DET.PlannerId  
  --join   EngUserAreaMst area	 on    area.EngUserAreaId = PLANNER_DET.RIUserAreaid 
  join   MstLocationUserArea fmsarea on fmsarea.UserAreaId  = PLANNER_DET.UserAreaid   
  --LEFT JOIN EngUserLocationMst		  LOCATION	    with(nolock)	ON LOCATION.UserLocationId = PLANNER_DET.EngUserLocationId
  --LEFT JOIN FmsUserLocationMst		  FMSLOCATION	with(nolock) ON FMSLOCATION.UserLocationId = LOCATION.UserLocationId
 -- LEFT JOIN EngMwoCompletionInfoTxn   WO_COMPLE	    with(nolock)  ON WO_COMPLE.WorkOrderId= MAINT_WO.WorkOrderId       
  WHERE PLANNER_DET.ServiceId = 2 
  AND MAINT_WO.MaintenanceWorkCategory = 187
  AND MAINT_WO.WorkOrderStatus in (192,193,194,195,196,197) 
  AND PLANNER_DET.TypeOfPlanner=@Planner_Classification
  AND CAST(MAINT_WO.TargetDateTime AS DATE) Between @From_Date AND  @To_Date 
  --AND PLANNER_DET.IsDeleted=0   
  --AND MAINT_WO.IsDeleted=0 
  GROUP BY PLANNER_DET.FacilityId

END
   
ELSE

 BEGIN 

  INSERT INTO #FINAL ( FacilityId, Total   )     
  SELECT DISTINCT PLANNER_DET.FacilityId,Count(DISTINCT MAINT_WO.WorkOrderId)
  FROM	 EngPlannerTxn			 AS PLANNER_DET		 with(nolock)	
  join	 @Hospital_Master h on PLANNER_DET.FacilityId = h.FacilityId		
  JOIN	 EngMaintenanceWorkOrderTxn   AS MAINT_WO		 with(nolock)	ON MAINT_WO.PlannerId=PLANNER_DET.PlannerId
  --LEFT JOIN EngStandardTaskDetailsMstDet AS STD_TASK		 with(nolock)	ON STD_TASK.StandardTaskDetId=PLANNER_DET.StandardTaskDetId
  --LEFT JOIN	EngHeppmCheckListMst		 AS	HEPPM_CHECKLIST  with(nolock)	ON HEPPM_CHECKLIST.StandardTaskDetId=PLANNER_DET.StandardTaskDetId
 --- LEFT JOIN	EngMaintenanceWorkOrderTxn   AS MAINT_WO		 with(nolock)	ON MAINT_WO.AssetRegisterId=PLANNER_DET.AssetRegisterId and MAINT_WO.hospitalid = PLANNER_DET.hospitalid 
  --LEFT JOIN  EngMwoCompletionInfoTxn     WO_COMPLE	         with(nolock)	ON WO_COMPLE.WorkOrderId= MAINT_WO.WorkOrderId           
  WHERE PLANNER_DET.ServiceId=2 
  AND MAINT_WO.MaintenanceWorkCategory = 187
  AND MAINT_WO.WorkOrderStatus in (192,193,194,195,196,197)
  AND CAST(MAINT_WO.TargetDateTime AS DATE) Between @From_Date AND  @To_Date
  AND PLANNER_DET.TypeOfPlanner	=	@Planner_Classification
  --AND PLANNER_DET.TypeOfPlanner= @Type_Of_Planner 
  AND ( MAINT_WO.TypeOfWorkOrder = 84 or MAINT_WO.TypeOfWorkOrder = @Type_Of_Planner)
  --AND PLANNER_DET.IsDeleted	=	0    
  --AND MAINT_WO.IsDeleted	=	0 
  GROUP BY PLANNER_DET.FacilityId

 
           
 END 
 
 

END

IF(@Group_By = 'WorkGroup')  
BEGIN  		    


 -------------------------------------------------------- PPM PLANNER SCHEDULE -----------------------------------------------
   
   
 IF (@Planner_Classification = 30  )

BEGIN      

  INSERT INTO #FINAL ( FacilityId, Total   )     
  SELECT DISTINCT PLANNER_DET.FacilityId,Count(distinct MAINT_WO.WorkOrderId)
  FROM 	EngPlannerTxn			 AS PLANNER_DET	
  join @Hospital_Master h on PLANNER_DET.FacilityId = h.FacilityId			
  --JOIN FmWorkGroupDetails AS STD_TASK		  with(nolock)	ON STD_TASK.WorkGroupId =PLANNER_DET.WorkGroupId		
  JOIN	EngMaintenanceWorkOrderTxn   AS MAINT_WO  with(nolock)	on MAINT_WO.PlannerId = PLANNER_DET.PlannerId  
  --LEFT JOIN EngUserLocationMst		  LOCATION		  with(nolock)	ON LOCATION.UserLocationId = PLANNER_DET.EngUserLocationId
  --LEFT JOIN FmsUserLocationMst		  FMSLOCATION	  with(nolock)	ON FMSLOCATION.UserLocationId = LOCATION.UserLocationId
  --LEFT JOIN EngMwoCompletionInfoTxn   WO_COMPLE	      with(nolock)	ON WO_COMPLE.WorkOrderId= MAINT_WO.WorkOrderId       
  WHERE  PLANNER_DET.ServiceId=2 
  AND MAINT_WO.MaintenanceWorkCategory = 187
  ANd    MAINT_WO.WorkOrderStatus in (192,193,194,195,196,197)
  AND PLANNER_DET.TypeOfPlanner=@Planner_Classification
  AND CAST(MAINT_WO.TargetDateTime AS DATE) Between @From_Date AND  @To_Date
  --AND PLANNER_DET.IsDeleted=0   
 -- AND MAINT_WO.IsDeleted=0 
  GROUP BY PLANNER_DET.FacilityId

END
   
ELSE
BEGIN   
  
  INSERT INTO #FINAL ( FacilityId, Total   )    
  SELECT DISTINCT PLANNER_DET.FacilityId,Count(DISTINCT MAINT_WO.WorkOrderId)
  FROM EngPlannerTxn			 AS PLANNER_DET	
  join EngMaintenanceWorkOrderTxn   AS MAINT_WO		 with(nolock)	ON MAINT_WO.PlannerId = PLANNER_DET.PlannerId
  join @Hospital_Master h on PLANNER_DET.FacilityId = h.FacilityId				
  --JOIN GmWorkGroupDetailsMst AS STD_TASK				 with(nolock)	ON STD_TASK.WorkGroupId =PLANNER_DET.WorkGroupId
 -- left JOIN	EngHeppmCheckListMst		 AS	HEPPM_CHECKLIST  with(nolock)	ON HEPPM_CHECKLIST.StandardTaskDetId=PLANNER_DET.StandardTaskDetId
 -- LEFT JOIN	EngMaintenanceWorkOrderTxn   AS MAINT_WO		 with(nolock)	ON MAINT_WO.AssetRegisterId=PLANNER_DET.AssetRegisterId and MAINT_WO.hospitalid = PLANNER_DET.hospitalid 
  LEFT JOIN  EngMwoCompletionInfoTxn     WO_COMPLE	         with(nolock)	ON WO_COMPLE.WorkOrderId= MAINT_WO.WorkOrderId           
  WHERE PLANNER_DET.ServiceId=2 
  AND  MAINT_WO.MaintenanceWorkCategory = 187
  AND  MAINT_WO.WorkOrderStatus in (192,193,194,195,196,197)
  AND  CAST(MAINT_WO.TargetDateTime AS DATE) Between @From_Date AND  @To_Date
  AND  PLANNER_DET.TypeOfPlanner=@Planner_Classification
  --AND  PLANNER_DET.TypeOfPlanner= @Type_Of_Planner 
  AND  (MAINT_WO.TypeOfWorkOrder =84 or  MAINT_WO.TypeOfWorkOrder = @Type_Of_Planner )    
  --AND  PLANNER_DET.IsDeleted=0    
  --AND  MAINT_WO.IsDeleted=0 
  GROUP BY PLANNER_DET.FacilityId
           
 END
 
----------------------------------------------------------------------------------------------------------------

--DROP TABLE #FINAL


END

IF(@Group_By = 'Department')  
BEGIN  		    

     
 -------------------------------------------------------- PPM PLANNER SCHEDULE -----------------------------------------------
   
   
IF (@Planner_Classification = 2513  )
BEGIN      
 
	  INSERT INTO #FINAL ( FacilityId, Total   ) 
	  SELECT DISTINCT PLANNER_DET.FacilityId,Count(distinct MAINT_WO.WorkOrderId)
	  FROM EngPlannerTxn		 AS PLANNER_DET				
	  join @Hospital_Master h on PLANNER_DET.FacilityId = h.FacilityId	
	  JOIN	EngMaintenanceWorkOrderTxn   AS MAINT_WO with(nolock)			on MAINT_WO.PlannerId = PLANNER_DET.PlannerId  
	  --JOIN EngUserAreaMst		  Area with(nolock)		ON Area.EngUserAreaID = PLANNER_DET.UserAreaid
	  join MstLocationUserArea area on area.UserAreaId = PLANNER_DET.UserAreaId 
	  JOIN MstLocationBlock		  Dept	ON Dept.BlockId = area.BlockId   
	--  LEFT JOIN EngUserLocationMst		  LOCATION		 with(nolock)	ON LOCATION.UserLocationId = PLANNER_DET.EngUserLocationId
	 -- LEFT JOIN FmsUserLocationMst		  FMSLOCATION	 with(nolock)	ON FMSLOCATION.UserLocationId = LOCATION.UserLocationId
	--  LEFT JOIN EngMwoCompletionInfoTxn   WO_COMPLE	     with(nolock)	ON WO_COMPLE.WorkOrderId= MAINT_WO.WorkOrderId 
	--  LEFT JOIN	EngAssetRegisterMst asset  with(nolock)	ON MAINT_WO.AssetRegisterId = Asset.AssetRegisterId
	 --  LEFT JOIN EngUserLocationMst LM     with(nolock)	ON LM.EngUserLocationId = asset.EngUserLocationId 
	--   LEFT JOIN EngUserAreaMst		  Area with(nolock)		ON Area.EngUserAreaID = LM.EngUserAreaID
	        
	  WHERE  PLANNER_DET.ServiceId=2 
	  AND MAINT_WO.MaintenanceWorkCategory = 187
	  AND MAINT_WO.WorkOrderStatus in (192,193,194,195,196,197)
	  AND CAST(MAINT_WO.TargetDateTime AS DATE) Between @From_Date AND  @To_Date
	  AND PLANNER_DET.TypeOfPlanner=@Planner_Classification
	  --AND PLANNER_DET.IsDeleted=0    
	  --AND MAINT_WO.IsDeleted=0 
	 GROUP BY PLANNER_DET.FacilityId

END
   
ELSE
BEGIN 

	  INSERT INTO #FINAL ( FacilityId, Total   ) 
	  SELECT DISTINCT PLANNER_DET.FacilityId,Count(DISTINCT MAINT_WO.WorkOrderId)
	  FROM EngPlannerTxn		 AS PLANNER_DET			
	  join @Hospital_Master h on PLANNER_DET.FacilityId = h.FacilityId		
	  JOIN EngMaintenanceWorkOrderTxn   AS MAINT_WO		 with(nolock)	ON MAINT_WO.PlannerId=PLANNER_DET.PlannerId
	 -- LEFT JOIN	EngHeppmCheckListMst		 AS	HEPPM_CHECKLIST  with(nolock)	ON HEPPM_CHECKLIST.StandardTaskDetId=PLANNER_DET.StandardTaskDetId	  
	  LEFT JOIN  EngMwoCompletionInfoTxn     WO_COMPLE	         with(nolock)	ON WO_COMPLE.WorkOrderId= MAINT_WO.WorkOrderId     
	  JOIN EngAsset asset  with(nolock)	ON PLANNER_DET.AssetId = Asset.AssetId
	  JOIN MstLocationUserLocation LM      with(nolock)	ON LM.UserLocationId = asset.UserLocationId 
	  JOIN MstLocationUserArea		  Area with(nolock)		ON Area.UserAreaID = LM.UserAreaID
	  JOIN MstLocationBlock		  Dept	 with(nolock)	ON Dept.BlockId = Area.BlockId            
	  WHERE PLANNER_DET.ServiceId=2 
	  AND  MAINT_WO.MaintenanceWorkCategory = 187
	  AND  MAINT_WO.WorkOrderStatus in (192,193,194,195,196,197)	 
	  --AND  PLANNER_DET.PlannerClassification=	@Planner_Classification
	  AND  PLANNER_DET.TypeOfPlanner        =	@Type_Of_Planner 
	  AND  (MAINT_WO.TypeOfWorkOrder =3120 or  MAINT_WO.TypeOfWorkOrder = @Type_Of_Planner )  
	  AND  CAST(MAINT_WO.TargetDateTime AS DATE) Between @From_Date AND  @To_Date  
	  --AND  PLANNER_DET.IsDeleted=0    
	  --ND  MAINT_WO.IsDeleted=0 
	  GROUP BY PLANNER_DET.FacilityId
           
 END
 

END

declare @Planner_Classification_value varchar(2000)
select @Planner_Classification_value =  FieldValue from FMLovMst where lovid = @Planner_Classification 

SELECT  CustomerName as 'Company_Name',
	    --StateName as 'State_Name',
		FI.FacilityId		AS	 'Hospital_ID',
		FacilityName as 'Hospital_Name',
		@Planner_Classification_value  AS  'Type_Of_Planner_Name',
		FI.Total  AS 'Total_Count' 
FROM	#FINAL	AS FI join V_MstLocationFacility h on fi.FacilityId = h.FacilityId
WHERE 	NOT (Total = 0)
order by Company_Name,--State_Name,
Hospital_Name



DROP TABLE #FINAL

END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH

SET NOCOUNT OFF                                   
END
GO
