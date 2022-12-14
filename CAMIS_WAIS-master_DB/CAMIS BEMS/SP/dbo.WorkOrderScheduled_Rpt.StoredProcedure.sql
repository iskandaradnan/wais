USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[WorkOrderScheduled_Rpt]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Exec [WorkOrderScheduled_Rpt] 1

CREATE PROCEDURE [dbo].[WorkOrderScheduled_Rpt]
	-- Add the parameters for the stored procedure here
	(
	@WorkOrderId INT
	)
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY
SET Datefirst 1
declare @AssetRegisterId int
select @AssetRegisterId=AssetId from EngMaintenanceWorkOrderTxn where WorkOrderId=@WorkOrderid
SELECT distinct
           -----------------Basic Details ----
format(GETDATE(),'dd-MMM-yyyy') as PrintedDate 
,hospital.FacilityName
,hospital.FacilityCode
,ppm.MaintenanceWorkNo as WorkOrderNo
,lovmst.FieldValue as MaintenanceWorkCategory
,lovmst1.FieldValue as Type
,lastmaintenance
------------------Asset Details--------------
,case when ppm.TypeOfWorkOrder=30 then '' else assetregister.Assetno end as Assetno
,case when ppm.TypeOfWorkOrder=30 then '' else vasset.AssetTypeDescription end as TypeDescription
, case when ppm.TypeOfWorkOrder=30 then '' else assettypemst.AssetTypeCode end as AssetTypeCode
, case when ppm.TypeOfWorkOrder=30 then '' else  isnull(vasset.Manufacturer,'Not Applicable') end as Manufacturer
--,case when vasset.Model is null then 'Not Applicable' 
--else case when ppm.TypeOfWorkOrder=30 then 'Not Applicable' end as
--else (select top 1 brand from EngAssetStandardizationBrand
--where BrandId=assetregister.Brand)-- and isDeleted=0)
-- +' / '+ vasset.Model end end as Model
--,case when assetregister.AssetClassification in (2324,2325) then 'Not Applicable' 
--else 
, case when ppm.TypeOfWorkOrder=30 then 'Not Applicable' else  (Select Model From EngAssetStandardizationModel mo where mo.ModelId=assetregister.Model)
end as Model
,case when ppm.TypeOfWorkOrder=30 then 'Not Applicable' 
else  assetregister.SerialNo 
end   as SerialNo,
isnull((select top 1 format(MaintenanceWorkDateTime,'dd-MMM-yyyy HH:mm')
from EngMaintenanceWorkOrderTxn work join EngAsset asset 
on work.AssetId = asset.AssetId
where work.AssetId =@AssetRegisterId and ppm.WorkOrderId <> work.WorkOrderId 
and work.MaintenanceWorkDateTime<=ppm.MaintenanceWorkDateTime and work.MaintenanceWorkCategory=187
order by MaintenanceWorkDateTime desc),format(MaintenanceWorkDateTime,'dd-MMM-yyyy HH:mm')) as MaintenanceWorkDate
,case when ppm.TypeOfWorkOrder=30 then '' else 
(select FieldValue from FmLovMst
where --IsDeleted=0 and 
lovid=vmv.VariationStatus) end as variatonstatus
,(select top 1 format(mwo.RescheduleDate,'dd-MMM-yyyy')) as RescheduleDate
,Mainsupplier.Mainsupplier as mainsuppliername
,thirdparty.Thirdparty as thirdpartyserviceprovider
,(select concat(fieldvalue,' - ',Remarks) from FmLovMst
 where --isDeleted=0 and  
 LovId=completioninfo.QCCode) as QCPPM
--, case when ppm.type=30 then '' else (select top 1 UserDepartmentName from dbo.GmStandardUserDepartmentMst where IsDeleted=0 and  UserDepartmentId=fmsarea.UserDepartmentId)end  as UserDepartmentName
--,case when assetregister.AssetClassification in (2324,2325) then 'Not Applicable' else  case when ppm.type=30 then '' else (select top 1 UserAreaName from dbo.FmsUserAreaMst ms where IsDeleted=0 and  ms.FmsUserAreaId=userarea.FmsUserAreaId)end end as UserDepartmentName
,coalesce(case when ppm.TypeOfWorkOrder=30 then GMRI.BlockCode else GM.BlockCode end,GMfmsarea1.BlockCode) as UserDepartmentCode
,coalesce(case when ppm.TypeOfWorkOrder=30 then GMRI.BlockName else GM.BlockName end,GMfmsarea1.BlockName) as UserDepartmentName
, --case when assetregister.AssetClassification in (2324,2325) then 'Not Applicable' else 
case when ppm.TypeOfWorkOrder=30 then RIfmslocation.UserLocationCode else fmslocation.UserLocationCode end  as UserLocationCode
, case when ppm.TypeOfWorkOrder=30 then RIfmslocation.UserLocationName else fmslocation.UserLocationName end  as UserLocationName
--,  case when ppm.type=30 then RIfmsarea.UserareaCode else fmsarea.UserAreaCode end as UserareaCode
--,case when ppm.type=30 then RIfmsarea.userareaName else fmsarea.UserAreaName end  as UserareaName
,coalesce(case when ppm.TypeOfWorkOrder=30 then RIfmsarea.UserareaCode else fmsarea.UserAreaCode end,fmsarea1.UserAreaCode) as UserareaCode
,coalesce(case when ppm.TypeOfWorkOrder=30 then RIfmsarea.userareaName else fmsarea.UserAreaName end,fmsarea1.UserAreaName) as UserareaName
,a.assetProcessStatus as assetprocessstatus
,case when ppm.TypeOfWorkOrder=30 then 'Not Applicable' else lovmst2.FieldValue end as RealTimeStatus,
--,datediff(yy,assetregister.CommissioningDate,getdate()) as ServiceLife
case when ppm.TypeOfWorkOrder=30 then 'Not Applicable' else cast((DATEDIFF(m, assetregister.CommissioningDate, GETDATE())/12) as varchar) + '.' + 
       CASE WHEN DATEDIFF(m, assetregister.CommissioningDate, GETDATE())%12 = 0 THEN '1' 
	        ELSE cast((DATEDIFF(m, assetregister.CommissioningDate, GETDATE())%12) as varchar) END End  as ServiceLife,
isnull((select top 1 MaintenanceWorkNo
from EngMaintenanceWorkOrderTxn work join EngAsset asset on work.AssetId = asset.AssetId
where work.AssetId =@AssetRegisterId and ppm.WorkOrderId <> work.WorkOrderId and work.MaintenanceWorkDateTime<=ppm.MaintenanceWorkDateTime 
and work.MaintenanceWorkCategory=187
--and work.IsDeleted=0 
order by MaintenanceWorkDateTime desc),MaintenanceWorkNo) as LastMaintenanceWorkNo,
--t.technical,
--case when assetregister.AssetClassification in (2324,2325) then 'Not Applicable' else  case when ppm.TypeOfWorkOrder=30 then '' 
--else isnull(t.obsolutestatus,'No') end end as 'obsolutestatus'
--t.obsolutestatus
--,(select top 1 a.TechnicalSupportNo from EngTechSupportLetterTxn a
--inner join  EngTechSupportLetterTxnDet b on a.TechnicalSupportId=b.TechnicalSupportId
-- inner join EngTechSupportLetterStatusTxnDet c on b.TechnicalSupportDetId=c.TechnicalSupportDetId
-- inner join EngAssetRegisterMst d on d.Manufacturer=b.Manufacturer and b.MadeIn=d.MadeIn and b.Model=d.Model
-- where a.IsDeleted=0 and b.IsDeleted=0 and c.IsDeleted=0 and c.Status=2350
--and d.AssetRegisterId=(select AssetRegisterId from EngMaintenanceWorkOrderTxn where IsDeleted=0 and WorkOrderId=@WorkOrderid))
--,Case when len(obsolutestatus)>0 then 'Yes' else 'No' END as 'obsolutestatus'
--,lovmst4.FieldValue as Maintenancedone
--,(select WorkGroupCode from GmWorkGroupDetailsMst
-- where IsDeleted=0 and WorkGroupId=ppm.WorkGroupId) as workgroup
--,(select WorkGroupDescription from GmWorkGroupDetailsMst
--where IsDeleted=0 and WorkGroupId=ppm.WorkGroupId) as workgroupdescription
--,case when ppm.type=2513 then '' else assetregister.AssetDescription end as AssetDescription
--,case when ppm.type=2513 then '' else assetregister.AssetRegisterId end as AssetRegisterId
--------------------Contract information--------------------------
--,contractor.ContactPerson
--,contractor.Serviceagent
--,contractor.ContractStartDate
--,contractor.ContractEndDate
--,contractor.TelephoneNo
--,ma.MaintenanceWorkDateTime
--,ma.MaintenanceWorkNo
case when assetregister.AssetClassification in (2324,2325) then 'Not Applicable' else  Con.ContractorName end as ContractorName
		,case when assetregister.AssetClassification in (2324,2325) then 'Not Applicable' else Con.contractorcode end AS Serviceagent
		,case when assetregister.AssetClassification in (2324,2325) then 'Not Applicable' else format(con.ContractStartDate,'dd-MMM-yyyy') end as ContractStartDate
		,case when assetregister.AssetClassification in (2324,2325) then 'Not Applicable' else format(con.ContractEndDate,'dd-MMM-yyyy') end as ContractEndDate
		,case when assetregister.AssetClassification in (2324,2325) then 'Not Applicable' else Con.ContactPerson end as ContactPerson
		,case when assetregister.AssetClassification in (2324,2325) then 'Not Applicable' else isnull(Con.ContactNo,con.AContactNumber) end as TelephoneNo,
----------------Task Details------------------------
EngStandardTask.TaskCode
,EngStandardTask.TaskDescription
--,d.IntervalInWeeks as frequency
--,ISNULL(FORMAT(d.LastDate,'dd-MMM-yyyy'),'')as LastDueDate
,ISNULL(FORMAT(ppm.TargetDateTime,'dd-MMM-yyyy'),'')as LastDueDate
,ISNULL(FORMAT(completioninfo.PPMAgreedDate,'dd-MMM-yyyy'),'')as PPMAgreedDate
,(select FieldValue from  FMLovMst where --isdeleted=0 and  
lovid=EngStandardTask.Status) as Taskstatus
--,ISNULL(FORMAT(d.NextDate,'dd-MMM-yyyy'),'')as NextDate
--,ISNULL(FORMAT(ppm.TargetDateTime,'dd-MMM-yyyy'),'')as NextDate

-----------------Part Details Images-------
--,mwp.Reason as processstatus
-------------Completion tab performance test and electirical test Images-----
--,completioninfo.OPR
--,completioninfo.ElectricalSafetyTest
,ISNULL(FORMAT(completioninfo.StartDateTime,'dd-MMM-yyyy HH:mm'),'') as startDatetime
,ISNULL(FORMAT(completioninfo.EndDateTime,'dd-MMM-yyyy HH:mm'),'')as EndDatetime
,completioninfo.DowntimeHoursMin
-------------------Logo's&CompanyName---------------------
,company.CustomerName
,company.Logo
--,company.MohLogo
,ppm.ServiceId
--,ppm.TargetWeek
,datepart(ww,ppm.TargetDateTime) as TargetWeek
,Year(ppm.TargetDateTime) as TargetYear
,asr.ServiceKey
--,dbo.Fn_DisplayNameofLov(completioninfo.QCCode)as QCCode,
,Nullif(dbo.Fn_DisplayNameofLov(completioninfo.QCCode),'No Values Defined')as QCCode,
--completioninfo.ActionTaken,
ppm.Remarks
----------
from EngMaintenanceWorkOrderTxn ppm 
Left outer join	EngAsset assetregister ON ppm.AssetId = assetregister.AssetId  --and assetregister.IsDeleted=0
Left outer join  V_EngAsset vasset ON vasset.AssetId=assetregister.AssetId 
--Left outer join	EngUserLocationMst location on location.EngUserLocationId=assetregister.EngUserLocationId
Left outer join	MstLocationUserLocation fmslocation  on fmslocation.UserLocationId=assetregister.UserLocationId
--Left outer join	EngUserAreaMst userarea  on userarea.EngUserAreaId=assetregister.EngUserAreaId
Left outer join	MstLocationUserArea fmsarea on fmsarea.UserAreaId=fmslocation.UserAreaId
Left outer join	MstLocationUserArea fmsarea1 on fmsarea1.UserAreaId=fmslocation.UserAreaId
left join MstLocationBlock GMfmsarea1 ON GMfmsarea1.BlockId=fmsarea.BlockId
left join MstService asr on asr.ServiceID=ppm.ServiceId
--left join VmSnfTxn vm on vm.AssetRegisterId=assetregister.AssetId
left join VmVariationTxn vmv on vmv.AssetId=assetregister.AssetId
left join MstLocationBlock GM on GM.BlockId=fmsarea.BlockId
--Left outer join	EngUserLocationMst RIlocation  on RIlocation.EngUserLocationId=ppm.EngUserLocationId
Left outer join	MstLocationUserLocation RIfmslocation  on RIfmslocation.UserLocationId=ppm.UserLocationId
-- Left outer join	EngUserAreaMst RIuserarea  on RIuserarea.EngUserAreaId=ppm.EngUserAreaId
Left outer join	MstLocationUserArea RIfmsarea on RIfmsarea.UserAreaId=ppm.UserAreaId
left join MstLocationBlock GMRI ON GMRI.BlockId=RIfmsarea.BlockId
left join EngMwoReschedulingTxn mwo on mwo.WorkOrderId=ppm.WorkOrderId
--outer apply (select top 1 a.TechnicalSupportNo as 'technical' ,Case when len(a.TechnicalSupportNo)>0 then 'Yes' 
--else 'No' END as 'obsolutestatus' from EngTechSupportLetterTxn a
--inner join  EngTechSupportLetterTxnDet b on a.TechnicalSupportId=b.TechnicalSupportId
-- inner join EngTechSupportLetterStatusTxnDet c on b.TechnicalSupportDetId=c.TechnicalSupportDetId
-- inner join EngAssetRegisterMst d on d.Manufacturer=b.Manufacturer and b.MadeIn=d.MadeIn and b.Model=d.Model
-- where a.IsDeleted=0 and b.IsDeleted=0 and c.IsDeleted=0 and c.Status=2350 and a.ApprovedStatus = 2212
--and d.AssetRegisterId=(select AssetRegisterId from EngMaintenanceWorkOrderTxn where IsDeleted=0 and WorkOrderId=@WorkOrderid)) t
left join
(
SELECT  a.AssetId,STUFF((SELECT ', ' + CAST(a.[ProcessStatus] AS VARCHAR(max)) [text()]
from EngAssetProcessStatus as a
where  a.AssetId=@AssetRegisterId
FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,' ') As assetProcessStatus
FROM  EngAssetProcessStatus as a
where  a.AssetId=@AssetRegisterId 
group by a.AssetId
) as  a 
on a.AssetId=assetregister.AssetId Left outer join	EngMwoCompletionInfoTxn completioninfo  
ON completioninfo.WorkOrderId=ppm.WorkOrderId --and completioninfo.IsDeleted=0 
--left join EngMwoProcessStatusTxnDet as mwp
--on mwp.CompletionInfoId=completioninfo.CompletionInfoId and mwp.IsDeleted=0 
Left outer join	EngMwoPartReplacementTxn partreplacement 
ON partreplacement.WorkOrderId=ppm. WorkOrderId  Left outer join	EngSpareParts  sparepart  
ON sparepart.SparePartsId=partreplacement.SparePartStockRegisterId 
--Left outer join	MstContractorandVendor c on c.ContractorId=ppm.ContractorId 
Left outer join	EngPlannerTxn  d 
on d.AssetId=assetregister.AssetId and d.PlannerId=ppm.PlannerId --and d.IsDeleted=0 
Left outer join EngAssetTypeCode assettypemst 
ON assettypemst.AssetTypeCodeId=assetregister.AssetTypeCodeId  Left outer join	EngTestingandCommissioningTxn e
ON e.AssetId=assetregister.AssetId left outer join	UMUserRegistration userregistration 
on userregistration.UserRegistrationId=completioninfo.AcceptedBy 
Left outer join EngAssetTypeCodeStandardTasksDet EngStandardTask 
ON EngStandardTask.StandardTaskDetId= ppm.StandardTaskDetId
Left outer join	MstLocationFacility hospital 
ON hospital.FacilityId=ppm.FacilityId Left outer join	MstCustomer company 
ON company.CustomerId=ppm.CustomerId  left outer join	FMLovMst lovmst 
ON lovmst.LovId=ppm.MaintenanceWorkCategory left outer join	FMLovMst lovmst1 
ON lovmst1.LovId=ppm.TypeOfWorkOrder left outer join	FMLovMst lovmst2 
ON lovmst2.LovId=assetregister.RealTimeStatusLovId left outer join	FMLovMst lovmst4 
ON lovmst4.LovId=completioninfo.ResourceType left join
(SELECT  b.Workorderid
,STUFF((SELECT ', ' + CAST(q.[staffname] AS VARCHAR(max)) [text()]
From 
--EngMwoRepairStatusTxnDet as a
--EngMwoCompletionInfoTxndet a inner join 
EngMwoCompletionInfoTxn b --on a.CompletionInfoId=b.CompletionInfoId 
inner join dbo.UMUserRegistration AS q 
ON q.UserRegistrationId = --a.StaffMasterId
b.CompletedBy
where  b.WorkOrderId=@WorkOrderid
FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,' ') As lastmaintenance
From 
--EngMwoRepairStatusTxnDet as a
--EngMwoCompletionInfoTxndet a inner join 
EngMwoCompletionInfoTxn b --on a.CompletionInfoId=b.CompletionInfoId 
inner join dbo.UMUserRegistration AS q 
ON q.UserRegistrationId = --a.StaffMasterId
b.CompletedBy
where  b.WorkOrderId=@WorkOrderid 
group by b.WorkOrderId) as lastmaintenance
on lastmaintenance.WorkOrderId=ppm.WorkOrderId
-------added nely
left join 
 (
 SELECT  a.AssetId
       ,STUFF((SELECT ', ' + CAST(concat(B.SSMRegistrationCode,'(',b.ContractorName,')')AS VARCHAR(300)) [text()]
         from EngAssetSupplierWarranty as a left join MstContractorandVendor as b
on a.ContractorId=b.ContractorId
where a.Category=13 and a.AssetId=@AssetRegisterId --and a.IsDeleted=0 and b.IsDeleted=0
         FOR XML PATH(''), TYPE)
        .value('.','NVARCHAR(MAX)'),1,2,' ') Mainsupplier
FROM  EngAssetSupplierWarranty as a left join MstContractorandVendor as b
on a.ContractorId=b.ContractorId
where a.Category=13 and a.AssetId=@AssetRegisterId --and a.IsDeleted=0 and b.IsDeleted=0
group by a.AssetId )
AS MAINSUPPLIER
ON MAINSUPPLIER.AssetId=assetregister.AssetId

left join 
(
SELECT  a.AssetId
       ,STUFF((SELECT ', ' + CAST(concat(B.SSMRegistrationCode,'(',b.ContractorName,')')AS VARCHAR(300)) [text()]
         from EngAssetSupplierWarranty as a
left join MstContractorandVendor as b
on a.ContractorId=b.ContractorId
where a.Category=15 and a.AssetId=@AssetRegisterId --and a.IsDeleted=0 and b.IsDeleted=0
        FOR XML PATH(''), TYPE)
        .value('.','NVARCHAR(MAX)'),1,2,' ') Thirdparty
FROM  EngAssetSupplierWarranty as a
left join MstContractorandVendor as b
on a.ContractorId=b.ContractorId
where a.Category=15 and a.AssetId=@AssetRegisterId --and a.IsDeleted=0 and b.IsDeleted=0
group by a.AssetId
)as thirdparty
on thirdparty.AssetId=assetregister.AssetId
left join 
(select top 1 WorkOrderId,format(RescheduleDate,'dd-MMM-yyyy')as RescheduleDate
from EngPpmRescheduleTxnDet
where WorkOrderId=@WorkOrderid --and IsDeleted=0
order by RescheduleDate desc) as res
on res.WorkOrderId=ppm.WorkOrderId 
--left join
--(select 
--a.AssetRegisterId
--,fcvm.ContactPerson
--,fcvm.ContractorName as Serviceagent
--,FCVM.TelephoneNo as TelephoneNo
--,format(fcor.ContractStartDate,'dd-MMM-yyyy') as  ContractStartDate
--,format(fcor.ContractEndDate,'dd-MMM-yyyy') as ContractEndDate
-- from EngAssetRegisterMst as a
-- inner join EngContractOutRegisterTxnDet COR on cor.AssetRegisterId=A.AssetRegisterId and isnull(cor.IsDeleted,0)=0 
--LEFT JOIN FmsContractOutRegisterMst FCOR on fcor.ContractId=cor.ContractId and isnull(FCOR.IsDeleted,0)=0
--LEFT JOIN FmsContractorandVendorMst FCVM on FCVM.ContractorId=FCOR.ContractorId and isnull(fcvm.IsDeleted,0)=0
--where FCVM.IsDeleted=0 and fcvm.Status=127 and fcor.Status=127 and a.AssetRegisterId=@AssetRegisterId
--)as contractor
--on contractor.AssetRegisterId=assetregister.AssetRegisterId
outer apply ( SELECT   top 1   cv.ContractorId, cv.SSMRegistrationCode as contractorcode,cv.ContractorName,
info.Name ContactPerson,crm.ContractStartDate,crm.ContractEndDate,
info.Designation,info.ContactNo,crm.AContactNumber
				FROM EngContractOutRegisterDet ctr 
				join EngContractOutRegister  crm on ctr.ContractId =crm.ContractId 
				join MstContractorandVendor  cv on ctr.ContractId =cv.contractorid  
				join MstContractorandVendorContactInfo info on info.ContractorId=cv.ContractorId
				 WHERE     ctr.AssetId = a.AssetId and 
				 --ctr.IsDeleted = 0  and  crm.IsDeleted = 0 and cv.IsDeleted = 0 and   
				 cast(ppm.MaintenanceWorkDateTime  as date) between ContractStartDate and isnull(ContractEndDate,getdate()) ) Con
--				 outer apply(select top 1 MaintenanceWorkDateTime,MaintenanceWorkNo
--from EngMaintenanceWorkOrderTxn work join EngAssetRegisterMst asset on work.AssetRegisterId = asset.AssetRegisterId
--where work.AssetRegisterId =@AssetRegisterId
--order by MaintenanceWorkDateTime desc )ma
Where ppm.WorkOrderId=@WorkOrderid and ppm.MaintenanceWorkCategory=187-- and  ppm.IsDeleted=0
 END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF 
END
GO
