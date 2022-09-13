
--[GetBulkPrintCheckList]30

--select * from EngScheduleGenerationWeekLog




DROP PROCEDURE [dbo].[GetBulkPrintCheckList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE  [dbo].[GetBulkPrintCheckList]                           

 -- @FacilityId	INT
 --,@CustomerId	INT
 --,@Year	INT
 --,@typeofplanner	INT

 @WeekLogId int

AS                                              

BEGIN TRY
--select * from EngScheduleGenerationFileJob
--update EngScheduleGenerationFileJob set IsDeleted=1 where WeekLogId=@WeekLogId
DELETE FROM EngScheduleGenerationFileJob where WeekLogId=@WeekLogId



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	Declare 
  @FacilityId		INT=(select top 1  FacilityId from EngScheduleGenerationWeekLog where weeklogid=@WeekLogId)
 ,@CustomerId		INT=(select top 1  CustomerId from EngScheduleGenerationWeekLog where weeklogid=@WeekLogId)
 ,@Year				INT =(select top 1  Year from EngScheduleGenerationWeekLog where weeklogid=@WeekLogId)
 ,@typeofplanner	INT=(select top 1  TypeOfPlanner from EngScheduleGenerationWeekLog where weeklogid=@WeekLogId)
 ,@Startdate		datetime=(select top 1  WeekStartDate from EngScheduleGenerationWeekLog where weeklogid=@WeekLogId)
 ,@EndDateTime		datetime=(select top 1  WeekEndDate from EngScheduleGenerationWeekLog where weeklogid=@WeekLogId)
 ,@WeekNo			INT=(select top 1  WeekNo	 from EngScheduleGenerationWeekLog where weeklogid=@WeekLogId)
 ,@WorkGroupId			INT=(select top 1  WorkGroupId	 from EngScheduleGenerationWeekLog where weeklogid=@WeekLogId)
 ,@ServiceId			INT=(select top 1  ServiceId	 from EngScheduleGenerationWeekLog where weeklogid=@WeekLogId)
 ,@DBNAME Varchar(max)=(SELECT DB_NAME() AS [Current Database])
 ,@DBservice  Int=0



 if(@DBNAME like '%FEMS%')
 Begin 
 set @DBservice=1;
 End
 else if (@DBNAME like '%BEMS%' )
 Begin 
 set @DBservice=2;
 End
 else if (@DBNAME like '%ICT%')
 Begin 
 set @DBservice=6;
 End

 print @DBservice;



--select @FacilityId	
--select @CustomerId	
--select @Year			
--select @typeofplanner
--select @Startdate	
--select @EndDateTime	
 
 if(@ServiceId=1)
 begin 

 

 	select distinct  
	
	@WeekLogId WeekLogId,
	wo.WorkOrderId,
	@FacilityId FacilityId,
	wo.MaintenanceWorkNo,
	@WeekNo WeekNo,
	wo.MaintenanceWorkCategory,
	lov.fieldvalue Typeofworkorder,
	checlist.PPMChecklistNo,
	checlist.TaskCode,
	checlist.[FileName] Print_File,
    checlist.DocumentId,
    checlist.[DocumentGuId]

from

EngMaintenanceWorkOrderTxn wo 
join [UetrackMasterdbPreProd]..fmlovmst lov on lov.[Lovid] = wo.typeofworkorder 

outer apply 
(select top 1	hepppmservice.PPMChecklistNo,
	hepppmservice.TaskCode,
	hepppmservice.PPMCheckListId,
	planner.StandardTaskDetId,
	hepppmservice.AssetTypeCodeId,
	document.[FileName] ,
    document.DocumentId,
    document.[DocumentGuId] from  [UetrackMasterdbPreProd]..EngAssetPPMCheckList hepppm inner join EngAssetPPMCheckList hepppmservice on hepppmservice.ppmchecklistno=hepppm.ppmchecklistnoinner join [UetrackMasterdbPreProd]..FMDocument document on hepppm.[guid] = document.DocumentGuId
inner join  engplannertxn planner 
on planner.AssetTypeCodeId=hepppmservice.AssetTypeCodeId  and planner.StandardTaskDetId=hepppmservice.PPMCheckListId 
join engasset engasset on planner.AssetTypeCodeId=engasset.AssetTypeCodeId AND engasset.AssetId=planner.AssetId
join EngMaintenanceWorkOrderTxn work on work.PlannerId=planner.PlannerId
where 
engasset.AssetId=wo.AssetId and work.workorderid=wo.WorkOrderId
and hepppm.ServiceId in (@DBservice) and hepppmservice.ServiceId in (@DBservice)
--and hepppmservice.PPMCheckListId=6758
order by document.DocumentId desc 

)checlist

where 
wo.MaintenanceWorkCategory=187
and wo.facilityid=@FacilityId
and wo.customerid=@CustomerId
and wo.typeofworkorder  in (@typeofplanner)
and Convert(date,wo.TargetDateTime) >= (@Startdate) 
and Convert(date,wo.TargetDateTime) <= (@EndDateTime) 
and YEAR(wo.targetdatetime)=@Year
and checlist.DocumentId is not null
and wo.WorkgroupId=@WorkGroupId


end

 else 
 Begin 



 

 	select distinct  
	
	@WeekLogId WeekLogId,
	wo.WorkOrderId,
	@FacilityId FacilityId,
	wo.MaintenanceWorkNo,
	@WeekNo WeekNo,
	wo.MaintenanceWorkCategory,
	lov.fieldvalue Typeofworkorder,
	checlist.PPMChecklistNo,
	checlist.TaskCode,
	checlist.[FileName] Print_File,
    checlist.DocumentId,
    checlist.[DocumentGuId]

from

EngMaintenanceWorkOrderTxn wo 
join [UetrackMasterdbPreProd]..fmlovmst lov on lov.[Lovid] = wo.typeofworkorder 

outer apply 
(select top 1	hepppmservice.PPMChecklistNo,
	hepppmservice.TaskCode,
	hepppmservice.PPMCheckListId,
	planner.StandardTaskDetId,
	hepppmservice.AssetTypeCodeId,
	document.[FileName] ,
    document.DocumentId,
    document.[DocumentGuId] from  [UetrackMasterdbPreProd]..EngAssetPPMCheckList hepppm inner join EngAssetPPMCheckList hepppmservice on hepppmservice.ppmchecklistno=hepppm.ppmchecklistnoinner join [UetrackMasterdbPreProd]..FMDocument document on hepppm.[guid] = document.DocumentGuId
inner join  engplannertxn planner 
on planner.AssetTypeCodeId=hepppmservice.AssetTypeCodeId  and planner.StandardTaskDetId=hepppmservice.PPMCheckListId 
join engasset engasset on planner.AssetTypeCodeId=engasset.AssetTypeCodeId AND engasset.AssetId=planner.AssetId
join EngMaintenanceWorkOrderTxn work on work.PlannerId=planner.PlannerId
where 
engasset.AssetId=wo.AssetId and work.workorderid=wo.WorkOrderId
and hepppm.ServiceId in (@DBservice) and hepppmservice.ServiceId in (@DBservice)
--and hepppmservice.PPMCheckListId=6758
order by document.DocumentId desc 

)checlist

where 
wo.MaintenanceWorkCategory=187
and wo.facilityid=@FacilityId
and wo.customerid=@CustomerId
and wo.typeofworkorder  in (@typeofplanner)
and Convert(date,wo.TargetDateTime) >= (@Startdate) 
and Convert(date,wo.TargetDateTime) <= (@EndDateTime) 
and YEAR(wo.targetdatetime)=@Year
and checlist.DocumentId is not null

 End




END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO


