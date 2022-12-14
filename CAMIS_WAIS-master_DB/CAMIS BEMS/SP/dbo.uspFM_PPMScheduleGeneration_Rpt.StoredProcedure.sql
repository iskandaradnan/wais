USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_PPMScheduleGeneration_Rpt]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--drop proc [PPMASIS_Rpt]


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- =============================================
-- Author:		Hari Haran N
-- Create date: 09-05-2016
-- Description:	Planned Preventive Maintenance
--EXEC dbo.uspFM_PPMScheduleGeneration_Rpt 15361888   [For BEMS SChedule]
-- =============================================
CREATE PROCEDURE [dbo].[uspFM_PPMScheduleGeneration_Rpt]
(
@WorkOrderid INT
)           
AS                                              
BEGIN                                
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY
SET DATEFIRST 1
declare @AssetId int
select @AssetId=AssetId from EngMaintenanceWorkOrderTxn where WorkOrderId=@WorkOrderid
SELECT 
           -----------------Basic Details ----
format(GETDATE(),'dd-MMM-yyyy') as PrintedDate 
,hospital.FacilityName
,hospital.FacilityCode
,ppm.MaintenanceWorkNo as WorkOrderNo
,lovmst.FieldValue as MaintenanceWorkCategory
,lovmst1.fieldvalue as Type
,lastmaintenance
------------------Asset Details--------------
,case when ppm.TypeOfWorkOrder=30 then '' else assetregister.Assetno end as Assetno
,case when ppm.TypeOfWorkOrder=30 then '' else vasset.AssetTypeDescription end as AssetTypeDescription
, case when ppm.TypeOfWorkOrder=30 then '' else assettypemst.AssetTypeCode end as AssetTypeCode
, case when assetregister.AssetClassification in (2324,2325) then 'Not Applicable' else case when ppm.TypeOfWorkOrder=30 then '' else  vasset.Manufacturer end end as Manufacturer
,case when assetregister.AssetClassification in (2324,2325) then 'Not Applicable' else case when ppm.TypeOfWorkOrder=30 then '' else   vasset.Model end end as Model
, case when assetregister.AssetClassification in (2324,2325) then 'Not Applicable' else case when ppm.TypeOfWorkOrder=30 then '' else  assetregister.SerialNo end end as SerialNo
,ISNULL((select top 1 format(MaintenanceWorkDateTime,'dd-MMM-yyyy HH:mm')
from EngMaintenanceWorkOrderTxn work join EngAsset asset on work.AssetId = asset.AssetId
where work.AssetId =@AssetId and ppm.WorkOrderId <> work.WorkOrderId and work.MaintenanceWorkDateTime<=ppm.MaintenanceWorkDateTime and work.MaintenanceWorkCategory=187
order by MaintenanceWorkDateTime desc),format(MaintenanceWorkDateTime,'dd-MMM-yyyy HH:mm')) as MaintenanceWorkDate
,case when ppm.TypeOfWorkOrder=30 then '' else (select FieldValue from FMLovMst
where  lovid=vmt.VariationStatus) end as variatonstatus
--,format(mwo.RescheduleDate,'dd-MMM-yyyy') as RescheduleDate
,(select top 1 format(mwo.RescheduleDate,'dd-MMM-yyyy')) as RescheduleDate
--,res.RescheduleDate as RescheduleDate
,Mainsupplier.Mainsupplier as mainsuppliername
,thirdparty.Thirdparty as thirdpartyserviceprovider
,(select concat(fieldvalue,' - ',Remarks) from FMLovMst
 where  LovId=completioninfo.QCCode)as QCPPM

,coalesce(case when ppm.TypeOfWorkOrder=30 then coalesce(GMRI.UserAreaCode,GMRIarea1.UserAreaCode) else GM.UserAreaCode end,GMfmsarea1.UserAreaCode) as UserDepartmentCode
,coalesce(case when ppm.TypeOfWorkOrder=30 then coalesce(GMRI.userareaname,GMRIarea1.userareaname) else GM.userareaname end,GMfmsarea1.userareaname) as UserDepartmentName
, case when ppm.TypeOfWorkOrder=30 then RIfmslocation.UserLocationCode else fmslocation .UserLocationCode end  as UserLocationCode
, case when ppm.TypeOfWorkOrder=30 then RIfmslocation.UserLocationName else fmslocation .UserLocationName end  as UserLocationName
,  coalesce(case when ppm.TypeOfWorkOrder=30 then coalesce(RIfmsarea.UserareaCode,RIfmsarea1.UserareaCode) else fmsarea.UserAreaCode end,fmsarea1.UserAreaCode) as UserareaCode
,coalesce(case when ppm.TypeOfWorkOrder=30 then coalesce(RIfmsarea.userareaName,RIfmsarea1.UserareaName) else fmsarea.UserAreaName end ,fmsarea1.UserAreaName) as UserareaName

--,a.assetProcessStatus as assetprocessstatus
--,lovmst2.FieldValue as RealTimeStatus
,case when ppm.TypeOfWorkOrder=30 then '' else lovmst2.FieldValue end as RealTimeStatus,
case when ppm.TypeOfWorkOrder=30 then '' else cast((DATEDIFF(m, assetregister.CommissioningDate, GETDATE())/12) as varchar) + '.' + 
       CASE WHEN DATEDIFF(m, assetregister.CommissioningDate, GETDATE())%12 = 0 THEN '1' 
	        ELSE cast((DATEDIFF(m, assetregister.CommissioningDate, GETDATE())%12) as varchar) END End  as ServiceLife 
,ISNULL((select top 1 MaintenanceWorkNo
from EngMaintenanceWorkOrderTxn work join EngAsset asset on work.AssetId = asset.AssetId
where work.AssetId =@AssetId and ppm.WorkOrderId <> work.WorkOrderId and work.MaintenanceWorkDateTime<=ppm.MaintenanceWorkDateTime and work.MaintenanceWorkCategory=187
 order by MaintenanceWorkDateTime desc),MaintenanceWorkNo) as LastMaintenanceWorkNo,
--t.technical,
case when assetregister.AssetClassification in (2324,2325) then 'Not Applicable' else 
case when ppm.TypeOfWorkOrder=30 then '' else isnull('','No') end end as 'obsolutestatus'
--isnull(t.obsolutestatus,'No') as 'obsolutestatus'
--t.obsolutestatus
--,assetregister.obsolutestatus,
--(select top 1 a.TechnicalSupportNo,Case when len(a.TechnicalSupportNo)>0 then 'Yes' else 'No' END as 'obsolutestatus' from EngTechSupportLetterTxn a
--inner join  EngTechSupportLetterTxnDet b on a.TechnicalSupportId=b.TechnicalSupportId
-- inner join EngTechSupportLetterStatusTxnDet c on b.TechnicalSupportDetId=c.TechnicalSupportDetId
-- inner join EngAsset d on d.Manufacturer=b.Manufacturer and b.MadeIn=d.MadeIn and b.Model=d.Model
-- where a.IsDeleted=0 and b.IsDeleted=0 and c.IsDeleted=0 and c.Status=2350
--and d.AssetId=(select AssetId from EngMaintenanceWorkOrderTxn where IsDeleted=0 and WorkOrderId=@WorkOrderid))
--,Case when len(obsolutestatus)>0 then 'Yes' else 'No' END as 'obsolutestatus'
,lovmst4.FieldValue as Maintenancedone
,('W2') as workgroup
,('Biomedical Engineering') as workgroupdescription
,case when ppm.TypeOfWorkOrder=30 then '' else assetregister.AssetDescription end as AssetDescription
,case when ppm.TypeOfWorkOrder=30 then '' else assetregister.AssetId end as AssetId
--------------------Contract information--------------------------
--,contractor.ContactPerson
--,contractor.Serviceagent
--,contractor.ContractStartDate
--,contractor.ContractEndDate
--,contractor.TelephoneNo
,case when assetregister.AssetClassification in (2324,2325) then 'Not Applicable' else Con.ContractorName end as ContractorName
		,case when assetregister.AssetClassification in (2324,2325) then 'Not Applicable' else Con.contractorcode End AS Serviceagent
		,case when assetregister.AssetClassification in (2324,2325) then 'Not Applicable' else format(con.ContractStartDate,'dd-MMM-yyyy') End as ContractStartDate
		,case when assetregister.AssetClassification in (2324,2325) then 'Not Applicable' else format(con.ContractEndDate,'dd-MMM-yyyy') End as ContractEndDate
		,case when assetregister.AssetClassification in (2324,2325) then 'Not Applicable' else Con.ContactPerson end as ContactPerson
		,case when assetregister.AssetClassification in (2324,2325) then 'Not Applicable' else Con.TelephoneNo end as TelephoneNo
----------------Task Details------------------------
,EngStandardTask.TaskCode
,EngStandardTask.TaskDescription
--,d.IntervalInWeeks as frequency
,ISNULL(FORMAT(ppm.TargetDateTime,'dd-MMM-yyyy'),'')as LastDueDate
,ISNULL(FORMAT(completioninfo.PPMAgreedDate,'dd-MMM-yyyy'),'')as PPMAgreedDate
,(select FieldValue from  FMLovMst where   lovid=EngStandardTask.Status) as Taskstatus
--,ISNULL(FORMAT(d.NextDate,'dd-MMM-yyyy'),'')as NextDate
-----------------Part Details Images-------
--,mwp.Reason as processstatus
-------------Completion tab performance test and electirical test Images-----
--,completioninfo.OPR
--,completioninfo.ElectricalSafetyTest
,ISNULL(FORMAT(completioninfo.StartDateTime,'dd-MMM-yyyy HH:mm'),'') as startDatetime
,ISNULL(FORMAT(completioninfo.EndDateTime,'dd-MMM-yyyy HH:mm'),'')as EndDatetime
,completioninfo.DowntimeHoursMin
-------------------Logo's&CompanyName---------------------
,company .CustomerName
--,company .CompanyLogo
--,company.MohLogo
,ppm.ServiceId
,datepart(ww,ppm.TargetDateTime) as TargetWeek
,Year(ppm.TargetDateTime) as TargetYear
,asr.ServiceKey
--,dbo.Fn_DisplayNameofLov(completioninfo.QCCode)as QCCode,
,Nullif(dbo.Fn_DisplayNameofLov(completioninfo.QCCode),'No Values Defined')as QCCode,
--completioninfo.ActionTaken
ppm.Remarks
----------
from EngMaintenanceWorkOrderTxn ppm 
Left outer join	EngAsset assetregister      ON ppm.AssetId = assetregister.AssetId  
Left outer join  V_EngAsset vasset          ON vasset.AssetId=assetregister.AssetId
--Left outer join	EngUserLocationMst location            ON location.EngUserLocationId=assetregister.EngUserLocationId
Left outer join	MstLocationUserLocation fmslocation         ON fmslocation.UserLocationId=assetregister.UserLocationId
--Left outer join	EngUserAreaMst userarea                ON userarea.EngUserAreaId=assetregister.EngUserAreaId
Left outer join	MstLocationUserArea fmsarea                 ON fmsarea.UserAreaId=assetregister.UserAreaId
Left outer join	MstLocationUserArea fmsarea1                ON fmsarea1.UserAreaId=assetregister.UserAreaId
left outer join MstLocationUserArea GMfmsarea1 ON GMfmsarea1.UserAreaId=fmsarea1.UserAreaId
left outer join MstLocationUserArea GM         ON GM.UserAreaId=fmsarea.UserAreaId
--Left outer join	EngUserLocationMst RIlocation          ON RIlocation.EngUserLocationId=ppm.EngUserLocationId
Left outer join	MstLocationUserLocation RIfmslocation       ON RIfmslocation.UserLocationId=ppm.UserLocationId
--Left outer join	EngUserAreaMst RIuserarea              ON RIuserarea.EngUserAreaId=ppm.EngUserAreaId
Left outer join	MstLocationUserArea RIfmsarea               ON RIfmsarea.UserAreaId=ppm.UserAreaId
left outer join MstLocationUserArea RIfmsarea1              ON RIfmsarea1.UserAreaId=RIfmslocation.UserAreaId
left outer join MstLocationUserArea GMRI       ON GMRI.UserAreaId=RIfmsarea.UserAreaId
left outer join MstLocationUserArea GMRIarea1  ON GMRIarea1.UserAreaId=RIfmsarea1.UserAreaId
left outer join MstService asr                        ON asr.ServiceID=ppm.ServiceId 
--left outer join VmSnfTxn vm                            ON vm.AssetId=assetregister.AssetId
left outer join VmVariationTxn vmt              ON vmt.AssetId=assetregister.AssetId
left outer join EngMwoReschedulingTxn mwo              ON mwo.WorkOrderId=ppm.WorkOrderId
--outer apply (select top 1 a.TechnicalSupportNo as 'technical' ,Case when len(a.TechnicalSupportNo)>0 then 'Yes' else 'No' END as 'obsolutestatus' from EngTechSupportLetterTxn a
--inner join  EngTechSupportLetterTxnDet b            ON a.TechnicalSupportId=b.TechnicalSupportId
--inner join EngTechSupportLetterStatusTxnDet c      ON b.TechnicalSupportDetId=c.TechnicalSupportDetId
--inner join EngAsset d ON d.Manufacturer=b.Manufacturer and b.MadeIn=d.MadeIn and b.Model=d.Model
-- where a.IsDeleted=0 and b.IsDeleted=0 and c.IsDeleted=0 and c.Status=2350 and a.ApprovedStatus = 2212
--and d.AssetId=(select AssetId from EngMaintenanceWorkOrderTxn where IsDeleted=0 and WorkOrderId=@WorkOrderid)) t 
--left join
--(SELECT  a.AssetId
--,STUFF((SELECT ', ' + CAST(a.[Process Status] AS VARCHAR(max)) [text()]
--from V_VmAssetProcess as a
--where  a.AssetId=@AssetId
--FOR XML PATH(''), TYPE)
--.value('.','NVARCHAR(MAX)'),1,2,' ') As assetProcessStatus
--FROM  V_VmAssetProcess as a
--where  a.AssetId=@AssetId 
--group by a.AssetId
--) as  a 
--ON a.AssetId=assetregister.AssetId
Left outer join	EngMwoCompletionInfoTxn completioninfo   ON completioninfo.WorkOrderId=ppm.WorkOrderId 
--left outer join EngMwoProcessStatusTxnDet as mwp         ON mwp.CompletionInfoId=completioninfo.CompletionInfoId and mwp.IsDeleted=0
Left outer join	engmwopartreplacementtxn partreplacement ON partreplacement.WorkOrderId=ppm.WorkOrderId  
Left outer join	EngSpareParts  sparepart       ON sparepart.SparePartsId=partreplacement.SparePartStockRegisterId
--Left outer join	MstContractorandVendor c  ON c.ContractorId=ppm.Contrac
Left outer join	EngPlannerTxn  d                      ON d.AssetId=assetregister.AssetId and d.PlannerId=ppm.PlannerId 
Left outer join	EngAssetTypeCode assettypemst      ON assettypemst.AssetTypeCodeId=assetregister.AssetTypeCodeId  
Left outer join	EngTestingandCommissioningTxn e          ON e.AssetId=assetregister.AssetId
left outer join	UMUserRegistration userregistration    ON userregistration.UserRegistrationId=completioninfo.AcceptedBy
inner join EngPlannerTxn plannertxn on plannertxn.PlannerId=ppm.PlannerId
Left outer join	EngAssetTypeCodeStandardTasksDet EngStandardTask ON EngStandardTask.StandardTaskDetId=plannertxn.StandardTaskDetId
Left outer join	MstLocationFacility hospital                   ON hospital.FacilityId=ppm.FacilityId
Left outer join	MstCustomer company                     ON company.CustomerId=ppm.CustomerId 
left outer join	FMLovMst lovmst                     ON lovmst.LovId=ppm.MaintenanceWorkCategory
left outer join	FMLovMst lovmst1                    ON lovmst1.LovId=ppm.TypeOfWorkOrder
left outer join	FMLovMst lovmst2                    ON lovmst2.LovId=assetregister.RealTimeStatusLovId
left outer join	FMLovMst lovmst4                    ON lovmst4.LovId=completioninfo.ResourceType
left join
(SELECT  b.Workorderid
,STUFF((SELECT ', ' + CAST(q.[staffname] AS VARCHAR(max)) [text()]
From 
--EngMwoRepairStatusTxnDet as a
EngMwoCompletionInfoTxn b inner join dbo.MstStaff AS q 
ON q.StaffMasterId = b.CompletedBy
where  b.WorkOrderId=@WorkOrderid
FOR XML PATH(''), TYPE)
.value('.','NVARCHAR(MAX)'),1,2,' ') As lastmaintenance
From 
--EngMwoRepairStatusTxnDet as a
EngMwoCompletionInfoTxn b 
inner join dbo.MstStaff AS q      ON q.StaffMasterId = b.CompletedBy
where  b.WorkOrderId=@WorkOrderid 
group by b.WorkOrderId) as lastmaintenance
on lastmaintenance.WorkOrderId=ppm.WorkOrderId
-------added nely-----------
left join 
 (

 SELECT  a.AssetId
       ,STUFF((SELECT ', ' + CAST(concat(B.SSMRegistrationCode,'(',b.ContractorName,')')AS VARCHAR(300)) [text()]
         from EngAssetSupplierWarranty as a
left join MstContractorandVendor as b ON a.ContractorId=b.ContractorId
where a.Category=2293 and a.AssetId=@AssetId 
         FOR XML PATH(''), TYPE)
        .value('.','NVARCHAR(MAX)'),1,2,' ') Mainsupplier
FROM  EngAssetSupplierWarranty as a
left join MstContractorandVendor as b ON a.ContractorId=b.ContractorId
where a.Category=2293 and a.AssetId=@AssetId 
group by a.AssetId


)AS MAINSUPPLIER   ON MAINSUPPLIER.AssetId=assetregister.AssetId

left join 
(
SELECT  a.AssetId
       ,STUFF((SELECT ', ' + CAST(concat(B.SSMRegistrationCode,'(',b.ContractorName,')')AS VARCHAR(300)) [text()]
         from EngAssetSupplierWarranty as a
left join MstContractorandVendor as b
on a.ContractorId=b.ContractorId
where a.Category=2295and a.AssetId=@AssetId 
         FOR XML PATH(''), TYPE)
        .value('.','NVARCHAR(MAX)'),1,2,' ') Thirdparty
FROM  EngAssetSupplierWarranty as a
left join MstContractorandVendor as b
on a.ContractorId=b.ContractorId
where a.Category=2295 and a.AssetId=@AssetId 
group by a.AssetId
)as thirdparty
on thirdparty.AssetId=assetregister.AssetId
left join 
(select top 1 WorkOrderId,format(RescheduleDate,'dd-MMM-yyyy')as RescheduleDate
from EngPpmRescheduleTxnDet
where WorkOrderId=@WorkOrderid 
order by RescheduleDate desc) as res
on res.WorkOrderId=ppm.WorkOrderId 
--left join
--(select 
--a.AssetId
--,fcvm.ContactPerson
--,fcvm.ContractorName as Serviceagent
--,FCVM.TelephoneNo as TelephoneNo
--,format(fcor.ContractStartDate,'dd-MMM-yyyy') as  ContractStartDate
--,format(fcor.ContractEndDate,'dd-MMM-yyyy') as ContractEndDate
-- from EngAsset as a
-- inner join EngContractOutRegisterTxnDet COR on cor.AssetId=A.AssetId and isnull(cor.IsDeleted,0)=0 
--LEFT JOIN FmsContractOutRegisterMst FCOR on fcor.ContractId=cor.ContractId and isnull(FCOR.IsDeleted,0)=0
--LEFT JOIN MstContractorandVendor FCVM on FCVM.ContractorId=FCOR.ContractorId and isnull(fcvm.IsDeleted,0)=0
--where FCVM.IsDeleted=0 and fcvm.Status=127 and fcor.Status=127 and a.AssetId=@AssetId
--)as contractor
--on contractor.AssetId=assetregister.AssetId
outer apply ( SELECT   top 1   cv.ContractorId, cv.SSMRegistrationCode as contractorcode,cv.ContractorName,'' as ContactPerson,crm.ContractStartDate,crm.ContractEndDate,'' as Designation
,'' as TelephoneNo--,cv.HandphoneNo
				FROM EngContractOutRegisterDet ctr 
				join EngContractOutRegister  crm on ctr.ContractId =crm.ContractId 
				join MstContractorandVendor  cv on crm.contractorid =cv.contractorid  
				 WHERE     ctr.AssetId = @AssetId  and   cast( ppm.MaintenanceWorkDateTime  as date) between ContractStartDate and isnull(ContractEndDate,getdate()) ) Con
Where ppm.WorkOrderId=@WorkOrderid and ppm.MaintenanceWorkCategory=187 

---Don't Remove--
-- --and assetregister.IsDeleted=0 and location.IsDeleted=0 and fmslocation.IsDeleted=0 and userarea.IsDeleted=0 and fmsarea.IsDeleted=0 and completioninfo.IsDeleted=0
--and partreplacement.IsDeleted=0 and sparepart.IsDeleted=0 and c.IsDeleted=0 and f.IsDeleted=0 and assettypemst.IsDeleted=0 and e.IsDeleted=0 and completioninfodet.IsDeleted=0
--and userregistration.IsDeleted=0 and staffmst.IsDeleted=0 and EngStandardTask.IsDeleted=0 and hospital.IsDeleted=0 and company.IsDeleted=0 and lovmst.IsDeleted=0
--and lovmst1.IsDeleted=0 and lovmst2.IsDeleted=0 and lovmst3.IsDeleted=0 and lovmst4.IsDeleted=0
END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF

END
GO
