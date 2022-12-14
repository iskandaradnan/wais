USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspEquipmentAuditAssessmentChecklist_Rpt]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--drop proc EquipmentAuditAssessmentChecklist_Rpt
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--select * from MstLocationUserArea
--select * from MstLocationUserLocation

--exec EquipmentAuditAssessmentChecklist_Rpt 8061348
CREATE PROCEDURE [dbo].[uspEquipmentAuditAssessmentChecklist_Rpt]   

(

@WorkOrderid int

)           

AS                                              

BEGIN      
 
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY
                         
SELECT distinct d.UserLocationId,d.AssetId,ISNULL(d.AssetNo,'-')as AssetNo
	,cast((DATEDIFF(m, d.PurchaseDate, GETDATE())/12) as varchar) + '.' + 
       CASE WHEN DATEDIFF(m, d.PurchaseDate, GETDATE())%12 = 0 THEN '0' 
	        ELSE cast((DATEDIFF(m, d.PurchaseDate, GETDATE())%12) as varchar) END   as AssetAge
--ISNULL(d.AssetAge,'-')as AssetAge ,
,ISNULL(typedet.AssetTypeDescription,'-')as AssetDescription
,ISNULL(vasset.Manufacturer,'-')as Manufacturer,ISNULL(vasset1.Model,'-')as Model ,ISNULL(d.SerialNo,'-') as SerialNo ,
ISNULL(ASLMS.FieldValue,'-') as AssetStatus
--,FORMAT(Planner.LastDate,'dd-MMM-yyyy HH:mm') as LastPPM
--,FORMAT(Eaf.Auditdate,'dd-MMM-yyyy') as AuditDate
-- '' as PPMStickerDate
 ,'' as Remarks 
 ,hosp.FacilityName as Hospitalname, c.UserAreaName
 --,fmsuser.UserAreaCode
 --, ASLMWS.FieldValue  as LastPPMStatus 
 ,c.UserAreaCode,fmsloc.UserLocationCode,fmsloc.UserLocationName
 ,ASLMW.FieldValue as variationstatus
 ,ASReal.FieldValue as RealTimeStatus
 ,datepart(ww,ppm.TargetDateTime) as TargetWeek
 ,ISNULL((select top 1 MaintenanceWorkNo
from EngMaintenanceWorkOrderTxn work join EngAsset asset on work.AssetId = asset.AssetId
where work.AssetId =ppm.AssetId and ppm.WorkOrderId <> work.WorkOrderId and work.MaintenanceWorkDateTime<=ppm.MaintenanceWorkDateTime and work.MaintenanceWorkCategory=2358 and work.ServiceId=1
order by MaintenanceWorkDateTime desc),MaintenanceWorkNo) as LastPPM
,ISNULL((select top 1 ppmlov.FieldValue --as LastPPMStatus
from EngMaintenanceWorkOrderTxn work join EngAsset asset on work.AssetId = asset.AssetId
join FMLovMst ppmlov ON ppmlov.lovid=work.WorkOrderStatus
where work.AssetId =ppm.AssetId and ppm.WorkOrderId <> work.WorkOrderId and work.MaintenanceWorkDateTime<=ppm.MaintenanceWorkDateTime and work.MaintenanceWorkCategory=2358 and work.ServiceId=1
order by MaintenanceWorkDateTime desc),ASLMWS.FieldValue) as LastPPMStatus
,ISNULL((select top 1 format(MaintenanceWorkDateTime,'dd-MMM-yyyy HH:mm')
from EngMaintenanceWorkOrderTxn work join EngAsset asset on work.AssetId = asset.AssetId
where work.AssetId =ppm.AssetId and ppm.WorkOrderId <> work.WorkOrderId and work.MaintenanceWorkDateTime<=ppm.MaintenanceWorkDateTime and work.MaintenanceWorkCategory=2358 and work.ServiceId=1
order by MaintenanceWorkDateTime desc),format(MaintenanceWorkDateTime,'dd-MMM-yyyy HH:mm')) as PPMStickerDate
--,(select ServiceKey from AsisService
--where isdeleted=0 and ServiceID=basg.Service) as Service
--,comp.CompanyName,comp.companylogo,comp.MohLogo
from  
dbo.EngMaintenanceWorkOrderTxn ppm join
 EngAsset d  on d.AssetId=ppm.AssetId
 left join MstLocationUserArea c  on c.UserAreaId = d.UserAreaId  
 --Left join [dbo].[FmsUserAreaMst] fmsuser  on fmsuser.FmsUserAreaId=c.FmsUserAreaId
 --left outer join GmStandardUserDepartmentMst dept ON dept.UserDepartmentId=fmsuser.UserDepartmentId
--left join [dbo].[EngAssetAuditFindingsTxn] Eaf  on eaf.UserAreaId=fmsuser.FmsUserAreaId
--left join EngUserLocationMst loc on loc.EngUserLocationId=d.EngUserLocationId
left join MstLocationUserLocation fmsloc ON fmsloc.UserLocationId=d.UserLocationId
left join EngAssetStandardizationManufacturer vasset on vasset.Manufacturerid=d.Manufacturer
left join EngAssetStandardizationModel vasset1 on vasset1.ModelId=d.Model
Left join [dbo].EngPlannerTxn Planner  on Planner.AssetId=d.AssetId
Left join [dbo].[MstLocationFacility] Hosp  on Hosp.FacilityId=ppm.FacilityId
--Left join [dbo].[GmCompanyMst] comp  on comp.CompanyId=hosp.CompanyId
left join VmVariationTxn vm ON vm.AssetId=d.AssetId
left join EngAssetTypeCode typedet ON typedet.AssetTypeCodeId=d.AssetTypeCodeId
left outer join FMLovMst ASLMS on ASLMS.LovId=d.AssetStatusLovId
LEFT OUTER JOIN FMLovMst ASLMWS ON ASLMWS.lovid=ppm.workorderstatus
left outer join FMLovMst ASLMW on  ASLMW.LovId=vm.VariationStatus
left outer join FMLovMst ASReal ON ASReal.lovid=d.RealTimeStatusLovId
where 
 ppm.WorkOrderId=@Workorderid and ppm.ServiceId=2

END TRY
BEGIN CATCH

insert into  ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF

 END
GO
