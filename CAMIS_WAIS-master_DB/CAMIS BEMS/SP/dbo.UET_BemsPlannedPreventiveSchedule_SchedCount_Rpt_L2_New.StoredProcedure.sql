USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UET_BemsPlannedPreventiveSchedule_SchedCount_Rpt_L2_New]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                
Application Name : UET                
Version       :                 
File Name      : UET_BemsPlannedPreventiveSchedule_WOCountRpt_L2               
Procedure Name  : UET_BemsPlannedPreventiveSchedule_WOCountRpt_L2  
Author(s) Name(s) : Naveen Raj T 
Date       :   
Purpose       : SP For Planned Preventive Schedule Report     Level 1  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
EXEC UET_BemsPlannedPreventiveSchedule_SchedCount_Rpt_L2_New 'W2','85','2362','2512','workgroup','2016-01-01','2017-12-30'

Modification History      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/ 
CREATE procedure [dbo].[UET_BemsPlannedPreventiveSchedule_SchedCount_Rpt_L2_New]
(

@taskcode				varchar(25),  
@Facility_Id			VARCHAR(20),    
@Planner_Classification VARCHAR(20),
@Type_Of_Planner	    VARCHAR(20),
@Group_By               VARCHAR(20), 
@From_Date				VARCHAR(20),
@To_Date				VARCHAR(20)
)AS

Begin                   
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN TRY


if(@Planner_Classification = 34)
begin
set @Type_Of_Planner = 27
end
  
create table #final           
 (          
 
  FacilityId    int,
  Asset_Id varchar(50),            
  Asset_no varchar(500),
  AssetDescription varchar(3000),    
  WorkOrderId	varchar(50),
  MaintenanceWorkNo varchar(100),
  WorkOrderStatus	varchar(50),
  Estimated_Hours	varchar(50),
  Actual_Hours		varchar(50)
 )         

IF (@Group_By = 'TaskCode')   
BEGIN
  
if (@Planner_Classification = 35)
 BEGIN 
    INSERT INTO #final  
    	select    
				PLANNER_DET.FacilityId,
				asset.AssetId ,
				ASSET.AssetNo ,
				ATC.AssetTypeDescription,
				MAINT_WO.WorkOrderId,
				MAINT_WO.MaintenanceWorkNo,
				MAINT_WO.WorkOrderStatus,
				sum(HC.PpmHours) ,
				sum(MWOC.repairhours)			
		from EngPlannerTxn AS PLANNER_DET			
		JOIN EngMaintenanceWorkOrderTxn   AS MAINT_WO		ON MAINT_WO.PlannerId=PLANNER_DET.PlannerId  
		left JOIN EngAsset ASSET ON ASSET.AssetId = MAINT_WO.AssetId 
		LEFT JOIN EngAssetTypeCode   ATC on ATC.AssetTypeCodeId  = asset.AssetTypeCodeId
		LEFT join EngMwoCompletionInfoTxn MWOC	on MWOC.WorkOrderId = MAINT_WO.WorkOrderId   --and MWOC.isdeleted = 0 
		--LEFT join EngMwoCompletionInfoTxn MWOCD	on MWOCD.CompletionInfoId = MWOC.CompletionInfoId		--and MWOCD.isdeleted = 0  	
		--left join EngUserAreaMst area	 on   PLANNER_DET.RIUserAreaid = area.EngUserAreaId
		left join MstLocationUserArea fmsarea on PLANNER_DET.UserAreaId = fmsarea.UserAreaId     
		LEFT JOIN   EngAssetTypeCodeStandardTasksDet AS STD_TASK1	    ON STD_TASK1.StandardTaskDetId=PLANNER_DET.StandardTaskDetId		
		outer apply (select sum(HReg.PpmHours) as PpmHours from EngAssetPPMCheckList AS	HEPPM_CHECKLIST
					join EngPPMRegisterMst HReg	on STD_TASK1.StandardTaskDetId = HReg.StandardTaskDetId	 
					where HEPPM_CHECKLIST.PPMChecklistNo=HReg.PPMChecklistNo and HReg.AssetTypeCodeId = HEPPM_CHECKLIST.AssetTypeCodeId 
					 --and HReg.isdeleted = 0 
					--and HEPPM_CHECKLIST.isdeleted = 0  
					) HC
		where PLANNER_DET.FacilityId = @Facility_Id
		and PLANNER_DET.serviceid = 2
		and MaintenanceWorkCategory=187
		AND MAINT_WO.WorkOrderStatus in (192,193,194,195,196,197)
		AND PLANNER_DET.TypeOfPlanner =@Planner_Classification
		and fmsarea.UserAreaCode=@taskcode
		AND CAST(MAINT_WO.TargetDateTime AS DATE) Between @From_Date AND  @To_Date	
		--and  MAINT_WO.IsDeleted=0		
		--AND  PLANNER_DET.IsDeleted=0	
		--AND  ASSET.IsDeleted=0	
		group by PLANNER_DET.FacilityId,
			asset.AssetId ,
			ASSET.AssetNo ,
			ATC.AssetTypeDescription,
			MAINT_WO.WorkOrderId,
			MAINT_WO.MaintenanceWorkNo,
			MAINT_WO.WorkOrderStatus
	END
	ELSE
	BEGIN

		 INSERT INTO #final 
		 select PLANNER_DET.FacilityId,
				asset.AssetId ,
				ASSET.AssetNo ,
				ATC.AssetTypeDescription,
				MAINT_WO.WorkOrderId,
				MAINT_WO.MaintenanceWorkNo,
				MAINT_WO.WorkOrderStatus,
				sum(HC.PpmHours) ,
				sum(MWOC.repairhours)		
	from EngPlannerTxn			 AS PLANNER_DET			
	JOIN EngMaintenanceWorkOrderTxn   AS MAINT_WO		ON MAINT_WO.PlannerId=PLANNER_DET.PlannerId  
	JOIN EngAssetTypeCodeStandardTasksDet AS STD_TASK	    ON STD_TASK.StandardTaskDetId=PLANNER_DET.StandardTaskDetId
	LEFT join EngMwoCompletionInfoTxn MWOC	on MWOC.WorkOrderId = MAINT_WO.WorkOrderId   --and MWOC.isdeleted = 0 
	--LEFT join EngMwoCompletionInfoTxndet MWOCD	on MWOCD.CompletionInfoId = MWOC.CompletionInfoId		and MWOCD.isdeleted = 0	
	LEFT JOIN EngAsset ASSET ON ASSET.AssetId = PLANNER_DET.AssetId  
	--LEFT join   EngHeppmRegisterMst HReg	on STD_TASK.StandardTaskDetId = HReg.StandardTaskDetId and ASSET.AssetTypeCodeId = hreg.AssetTypeCodeId and hreg.isdeleted=0
	--left JOIN   AsisSysLovMst   lov on  lov.LovId = HReg.PPMFrequency

	LEFT JOIN EngAssetTypeCode   ATC on ATC.AssetTypeCodeId  = asset.AssetTypeCodeId
	outer apply (select sum(HReg.PpmHours) as PpmHours from EngAssetPPMCheckList AS	HEPPM_CHECKLIST
				join EngPPMRegisterMst HReg	on STD_TASK.StandardTaskDetId = HReg.StandardTaskDetId	 and   ASSET.AssetTypeCodeId = hreg.AssetTypeCodeId 
					where HEPPM_CHECKLIST.PPMChecklistNo=HReg.PPMChecklistNo and HReg.AssetTypeCodeId = HEPPM_CHECKLIST.AssetTypeCodeId 
					-- and HReg.isdeleted = 0 
					--and HEPPM_CHECKLIST.isdeleted = 0  
					) HC
	where  PLANNER_DET.FacilityId = @Facility_Id
	AND PLANNER_DET.ServiceId=2
	and MaintenanceWorkCategory=187
	AND MAINT_WO.WorkOrderStatus in (192,193,194,195,196,197)
	--AND PLANNER_DET.PlannerClassification= @Planner_Classification
	AND PLANNER_DET.TypeOfPlanner=  @Type_Of_Planner 
	AND (MAINT_WO.TypeOfWorkOrder = 28 or MAINT_WO.TypeOfWorkOrder =  @Type_Of_Planner )
	and STD_TASK.TaskCode = @taskcode
	AND CAST(MAINT_WO.TargetDateTime AS DATE) Between @From_Date AND  @To_Date
	--AND  MAINT_WO.IsDeleted=0  
	--AND  PLANNER_DET.IsDeleted=0
	--AND  MWOC.IsDeleted=0
	--AND  ASSET.IsDeleted=0	
	group by PLANNER_DET.FacilityId,
				asset.AssetId ,
				ASSET.AssetNo ,
				ATC.AssetTypeDescription,
				MAINT_WO.WorkOrderId,
				MAINT_WO.MaintenanceWorkNo,
				MAINT_WO.WorkOrderStatus
	END

END



SELECT   

f.FacilityId as 'Facility_Id',
f.Asset_Id,       
f.Asset_no , 
f.AssetDescription,
f.WorkOrderId	,
f.MaintenanceWorkNo ,
(select fieldvalue from FMLovMst where lovid=f.WorkOrderStatus) as WorkOrderStatus,
cast(f.Estimated_Hours	as numeric(30,2)) as Estimated_Hours,
cast(f.Actual_Hours		as numeric(30,2)) as Actual_Hours
from #final f

   
drop table #final   

END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH

SET NOCOUNT OFF

end
GO
