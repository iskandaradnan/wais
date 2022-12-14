USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BreakdownEmergency]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--drop procedure [uspFM_BreakdownEmergency_New]
-- =============================================
-- Author:		Aravinda Raja 
-- Create date: 14-05-2018
-- Description:	BD-ASIS MAin Query
--EXEC dbo.uspFM_BreakdownEmergency 39
-- =============================================
-- Change log
-- changed query 
--=================================================
CREATE PROCEDURE [dbo].[uspFM_BreakdownEmergency]

@WorkOrderId BIGINT
AS
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY


select distinct 
		a.AssetId
		,a.FacilityId
		,a.MaintenanceWorkNo
		,a.MaintenanceWorkNo as serviceRequestNo
		,dbo.Fn_DisplayNameofLov(a.MaintenanceWorkCategory) as Category
		,format(getdate(),'dd-MMM-yyyy HH:mm') as printeddatetime
		,dbo.Fn_DisplayNameofLov(a.TypeOfWorkOrder) as type
		,b.AssetNo as AssetNo
		,b.AssetDescription as Assetdescription
		,d.UserLocationName as assetLocationName 
		,d.UserLocationCode as assetLocationcode
		,(select UserAreaCode from MstLocationUserArea a where a.Active=1 and a.UserAreaId=d.UserAreaId ) UserAreaCode
		,(select UserAreaName from MstLocationUserArea a where a.Active=1 and a.UserAreaId=d.UserAreaId ) UserAreaName
		,ASLMM.Manufacturer
		,ASM.Model
		--,(select top 1 Brand from EngAssetStandardizationBrand where  Active=1 and BrandId=b.brand) as brand		,
		,b.SerialNo
		,a.ServiceId
		,ISNULL(FORMAT(a.MaintenanceWorkDateTime,'dd-MMM-yyyy HH:mm'),'') as [Last_Maintenance_date]
		,asl.FieldValue as [Variation_status]
		,v.AssetRealtimeStatus as RealtimestatusID
		,dbo.Fn_DisplayNameofLov(b.RealTimeStatusLovId) AS RealTimeStatus
		--, datediff(year,y.TandCDate,getdate()) [service life] 
		,a.MaintenanceWorkNo as [Last_Maintenance_work_No]  
		--,dbo.Fn_DisplayNameofLov(b.ObsoluteStatus) as ObsoluteStatus
		,dbo.Fn_DisplayNameofLov(i.ResourceType) as [Maintanence_done] 
		,(select top 1 CustomerName from dbo.MstCustomer where CustomerId=a.CustomerId) as CompanyName
		,(select top 1 fieldvalue from FmLovMst where lovid = ((SELECT top 1 ProcessStatus FROM EngAssetProcessStatus h
																	wHERE h.AssetId=b.AssetId  and h.Active = 0
																	order by  ProcessStatusId desc))) AS assetprocessstatus
		,ISNULL(FORMAT(i.StartDateTime,'dd-MMM-yyyy HH:mm'),'')as StartDateTime
		,ISNULL(FORMAT(i.EndDateTime,'dd-MMM-yyyy HH:mm'),'')as EndDateTime
		, i.CompletionInfoId
		, i.DowntimeHoursMin
		--, i.OPR AS PerformanceTest
		--, i.ElectricalSafetyTest AS ElectricalSafetyTest
		,1 AlternativeServiceProvided
		,i.LoanerProvision ProvideLoaner
		----------Contract Vendor information--
		,Con.ContractorName 
		,Con.contractorcode AS [Service_Agent]
		,format(con.ContractStartDate,'dd-MMM-yyyy') as ContractStartDate
		,format(con.ContractEndDate,'dd-MMM-yyyy') as ContractEndDate
		,Con.ContactPerson
		,isnull(Con.TelephoneNo,con.HandphoneNo) as TelephoneNo
		,format(v.ResponseDateTime,'dd-MMM-yyyy') as [ResponseDate]
		,format(v.ResponseDateTime,'HH:mm') as [ResponseTime]
		--,v. ResponseFinding
		,(select top 1 StaffName from dbo.MstStaff where StaffMasterId=v.UserId) as [Response_By]
		--,v.AssettakenOutfromLocation
		 ,'' as [Reference_no]
		 ,userregistration.staffname as DVO2
		,(select top 1 StaffName  from MstStaff where Active=1  and StaffMasterId=i.CompletedBy) as [completed_by]
		,(select top 1 FacilityName from dbo.MstLocationFacility where FacilityId= a.FacilityId and Active=1) as Hospitalname
		,(select top 1 Logo from dbo.MstCustomer where CustomerId=a.CustomerId and Active=1) as Companynaeme
		,(select top 1 Logo from dbo.MstCustomer where CustomerId=a.CustomerId and Active=1) as Companylogo
		,(select top 1 Logo from dbo.MstCustomer where CustomerId=a.CustomerId and Active=1) as MohLogo
		,bc.ContractorId
		,fms.StaffName as Requestor
		--,r.ServiceRequestId
		,i.RepairDetails as RequestDetails
		,i.AcceptedBy FmsStaffMstId
		,format(i.HandoverDateTime,'dd-MMM-yyyy HH:mm') as RequestDateTime
		,fspm.Designation as designation
		,vsr.UserLocationCode as [Location_code]
		,vsr.UserLocationName as [Requestor_Location_Name]
		--,r.ContactNo as [Ext No]
		,w.StaffName as [verified_By]
		,i.HandoverDateTime as verifieddatetime
		,b.UserAreaId EngUserAreaId
		,asl.Remarks as variationstatus
		--,d.UserDepartmentName
		,i.ResourceType
		--,j.Reason
		,PLPfms.StaffName
		,i.EndDateTime As CompletedDateTime
		,format(PLP.PPMAgreedDate,'dd-MMM-yyyy HH:mm') as loanstartdate
		,format(PLP.EndDateTime,'dd-MMM-yyyy HH:mm') as loanenddate
		--,format(APLP.StartDateTime,'dd-MMM-yyyy HH:mm') as SPstartdate
		--,format(APLP.EndDateTime,'dd-MMM-yyyy HH:mm') as SPEnddate
		--,APLP.ReferenceNo as SPReferenceNo
		,EATC.AssetTypeCode
		,GMW.WorkGroupCode,
		GMW.WorkGroupDescription
		,Nullif(dbo.Fn_DisplayNameofLov(i.QCCode),'No Values Defined')as QCCode
		--,i.ActionTaken		
		,dbo.Fn_DisplayNameofLov(a.WorkOrderPriority) as Priority
		,asr.ServiceKey
		,(select top 1 StaffName  from MstStaff	where Active=1  and StaffMasterId=i.AcceptedBy)as [Accepted_by]
		,(select top 1 StaffName  from MstStaff	where Active=1  and StaffMasterId=(select top 1 ban.CompletedBy from EngMwoCompletionInfoTxn ban 
																						where ban.WorkOrderId=a.WorkOrderId 
																						  order by ban.CompletionInfoId desc)) as LastMaintanancepersonal

		,(select top 1 Fieldvalue from FmLovMst where Active=1 and  LovId=a.WorkOrderStatus) as currentstatus
		,EATC.AssetTypeDescription TypeDescription
		,(select top 1 FacilityCode from dbo.MstLocationFacility where FacilityId= a.FacilityId and Active=1) as HospitalCode
from dbo.EngMaintenanceWorkOrderTxn as a 
left join dbo.EngAsset as b on a.AssetId=b.AssetId 
left outer Join DBO.EngAssetStandardizationModel ASM on ASM.ModelId=b.Model
Left outer  Join DBO.EngAssetStandardizationManufacturer ASLMM on ASLMM.ManufacturerId=b.Manufacturer 
left outer  Join DBO.EngAssetTypeCode EATC on EATC.AssetTypeCodeId=b.AssetTypeCodeId
left join MstService asr on asr.ServiceID=a.ServiceId
left join EngAssetWorkGroup GMW on GMW.WorkGroupId=b.WorkGroupId
left join dbo.MstLocationUserLocation as d ON d.UserLocationId = a.UserLocationId
--left join EngAssetRegisterLocationMst engloc on engloc.AssetRegisterId=b.AssetRegisterId
--left join EngUserLocationMst loc on loc.EngUserLocationId=engloc.EngUserLocationId
--left join FmsUserLocationMst fmsloc on fmsloc.UserLocationId=loc.UserLocationId 
left join dbo.EngMwoCompletionInfoTxn as i on i.WorkOrderId = a.WorkOrderId
left outer join UMUserRegistration userregistration on userregistration.UserRegistrationId=i.AcceptedBy
--left join dbo.EngMwoProcessStatusTxnDet as j ON j.CompletionInfoId = i.CompletionInfoId
left join EngMwoCompletionInfoTxn as PLP on PLP.WorkOrderId=a.WorkOrderId
--left join EngMwoProcessStatusAspTxnDet as APLP on APLP.ProcessStatusId=j.ProcessStatusId
left join MstStaff as PLPfms on PLPfms.StaffMasterId=PLP.AcceptedBy
left join   EngMwoAssesmentTxn as v on v.WorkOrderId=a.WorkOrderId
outer apply ( SELECT   top 1   ContractorId FROM EngAssetSupplierWarranty ctr 
				WHERE ctr.AssetId = a.AssetId and ctr.Active = 0 order by SupplierWarrantyId desc)m
outer apply ( SELECT  top 1   cv.ContractorId, cv.SSMRegistrationCode as contractorcode,cv.ContractorName,cvinfo.Name ContactPerson,crm.ContractStartDate,crm.ContractEndDate,cvinfo.Designation,cvinfo.ContactNo TelephoneNo,cvinfo.ContactNo HandphoneNo
				FROM EngContractOutRegisterDet ctr 
				join EngContractOutRegister  crm on ctr.ContractId =crm.ContractId 
				join MstContractorandVendor  cv on crm.contractorid =cv.contractorid  
				join MstContractorandVendorContactInfo cvinfo on cvinfo.contractorid =cv.contractorid  
				WHERE   ctr.AssetId = a.AssetId   and   cast( a.MaintenanceWorkDateTime  as date) between crm.ContractStartDate and isnull(crm.ContractEndDate,getdate()) ) Con
left join dbo.EngContractOutRegister AS n ON n.ContractorId = m.ContractorId 
outer apply (SELECT top 1    crm.ContractId,crm.ContractNo,ContractorId,ContractStartDate,ContractEndDate 
			FROM            EngContractOutRegister crm
			WHERE      crm.ContractorId=n.ContractorId order by  ContractId desc) bc		
left join EngMwoCompletionInfoTxn as r on  a.WorkOrderId=r.WorkOrderId 
left join DBO.MstLocationUserLocation vsr on vsr.UserLocationId=a.UserLocationId  
--left join dbo.EngTestingandCommissioningTxn as y on y.ServiceRequestId=r.ServiceRequestId
--left join dbo.SrServiceRequestFemsBemsTxn AS s ON s.ServiceRequestId = r.ServiceRequestId 
left join dbo.MstStaff w  on w.StaffMasterId=i.AcceptedBy 
left join UMUserRegistration as fms on fms.UserRegistrationId=r.AcceptedBy
left join UserDesignation as fspm on fspm.UserDesignationId=fms.UserDesignationId 
outer apply ( select top 1 vmv.VariationStatus from dbo.VmVariationTxn  as vmv 
			 where  vmv.AssetId=b.AssetId
			 order by VariationRaisedDate desc)vst
left join FmLovMst as asl on asl.lovid=vst.VariationStatus
where a.WorkOrderId=@WorkOrderId and a.MaintenanceWorkCategory in(188,189) 

END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF

END

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO
