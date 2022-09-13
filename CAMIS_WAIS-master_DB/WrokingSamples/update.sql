--use UetrackFemsdbPreProd


--select * from sys.tables where name like '%log%'

--select * from EngScheduleGenerationWeekLog

--delete   EngScheduleGenerationWeekLog where weekno>0and year>=2020



 

 	select distinct  
	
	
	wo.WorkOrderId,
	
	wo.MaintenanceWorkNo,
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
(select top 1
	hepppmservice.PPMChecklistNo,
	hepppmservice.TaskCode,
	hepppmservice.PPMCheckListId,
	planner.StandardTaskDetId,
	hepppmservice.AssetTypeCodeId,
	document.[FileName] ,
    document.DocumentId,
    document.[DocumentGuId]

 from 

[UetrackMasterdbPreProd]..EngAssetPPMCheckList hepppm 
inner join EngAssetPPMCheckList hepppmservice on hepppmservice.ppmchecklistno=hepppm.ppmchecklistno
inner join [UetrackMasterdbPreProd]..FMDocument document on hepppm.[guid] = document.DocumentGuId
inner join  engplannertxn planner 
on planner.AssetTypeCodeId=hepppmservice.AssetTypeCodeId  and planner.StandardTaskDetId=hepppmservice.PPMCheckListId 
join engasset engasset on planner.AssetTypeCodeId=engasset.AssetTypeCodeId AND engasset.AssetId=planner.AssetId
join EngMaintenanceWorkOrderTxn work on work.PlannerId=planner.PlannerId
where 
engasset.AssetId=wo.AssetId and work.workorderid=wo.WorkOrderId
and hepppm.ServiceId in (1) and hepppmservice.ServiceId in (1)

order by document.DocumentId desc 

)checlist

where 
wo.MaintenanceWorkCategory=187
and wo.facilityid=144
and wo.customerid=157
and wo.typeofworkorder  in (34)

and Convert(date,wo.TargetDateTime) >= ('2020-01-27') 
and Convert(date,wo.TargetDateTime) <= ('2020-02-02') 
and YEAR(wo.targetdatetime)=2020
and checlist.DocumentId is not null
--and wo.WorkgroupId=163

select * from EngScheduleGenerationFileJob


--select  * from [UetrackMasterdbPreProd]..engassettypecode where AssetTypeCode='99999'
--select * from EngAssetPPMCheckList where AssetTypeCodeId =972
--select * from [UetrackMasterdbPreProd]..EngAssetPPMCheckList where AssetTypeCodeId =972

--select AssetTypeCodeId ,* from engasset where assetno='WF101004777A'

--update EngAssetPPMCheckList set AssetTypeCodeId =972,ppmchecklistno='UEMEd/BEMS/0125' where ppmchecklistid=803
--update engasset set AssetTypeCodeId=972 where AssetNo='WF101004777A'

--select AssetTypeCodeId ,standardtaskdetid,* from engplannertxn where assetid=15371
--update engplannertxn set   AssetTypeCodeId=972 ,standardtaskdetid=803  where assetid=15371

--select assetid,plannerid from EngMaintenanceWorkOrderTxn where MaintenanceWorkNo='PMWWAC/F/2020/005406'
--select AssetTypeCodeId,* from EngAsset where assetid=15490
--select AssetTypeCodeId,StandardTaskDetId,* from engplannertxn where assetid=15490 and PlannerId=10819
--select * from EngAssetPPMCheckList where  ppmchecklistid=395



--select * from [UetrackMasterdbPreProd]..EngAssetPPMCheckList where ppmchecklistno='KKM/FEMS/M0003'


--select 

--hepppmservice.PPMChecklistNo,
--	hepppmservice.TaskCode,
--	hepppmservice.PPMCheckListId,
--	planner.StandardTaskDetId,
--	hepppmservice.AssetTypeCodeId,
--	document.[FileName] ,
--    document.DocumentId,
--    document.[DocumentGuId]


-- from 
--[UetrackMasterdbPreProd]..EngAssetPPMCheckList hepppm 
--left join EngAssetPPMCheckList hepppmservice on hepppmservice.ppmchecklistno=hepppm.ppmchecklistno
--left join [UetrackMasterdbPreProd]..FMDocument document on hepppm.[guid] = document.DocumentGuId
--left join  engplannertxn planner 
--on planner.AssetTypeCodeId=hepppmservice.AssetTypeCodeId  and planner.StandardTaskDetId=hepppmservice.PPMCheckListId 
--left join engasset engasset on planner.AssetTypeCodeId=engasset.AssetTypeCodeId AND engasset.AssetId=planner.AssetId
--left join EngMaintenanceWorkOrderTxn work on work.PlannerId=planner.PlannerId
--where 
--engasset.AssetId=(select assetid from EngMaintenanceWorkOrderTxn where MaintenanceWorkNo='PMWWAC/20/000280') 
--and work.workorderid=(select workorderid from EngMaintenanceWorkOrderTxn where MaintenanceWorkNo='PMWWAC/20/000280')
--and hepppm.ServiceId in (1) and hepppmservice.ServiceId in (1)
