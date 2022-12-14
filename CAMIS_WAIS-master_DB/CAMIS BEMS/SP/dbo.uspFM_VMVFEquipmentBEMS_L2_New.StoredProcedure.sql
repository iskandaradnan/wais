USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VMVFEquipmentBEMS_L2_New]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                    
-- =============================================  
-- Author  :Aravinda Raja   
-- Create date :08-06-2018  
-- Description :VVF approve Details  
-- =============================================  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~          
EXEC [Asis_ApprovedListofEquipmentBEMS_L1] 'national','','2017-01-01','2017-03-01',''  
EXEC [uspFM_VMVFEquipmentBEMS_L2_New] '82','2018','01'  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/         
     
  
     
CREATE PROCEDURE [dbo].[uspFM_VMVFEquipmentBEMS_L2_New]  
(  
       
  @Hospital_Id VARCHAR(20),  
  @year   VARCHAR(20),  
  @month   VARCHAR(20)  
 )                 
AS                                                    
BEGIN      
SET FMTONLY OFF                                
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
BEGIN TRY                                      
    
 declare   
 @Prepared_name   varchar(100),  
 @Verified_name   varchar(100),  
 @Acknowledged_name  varchar(100),  
 @Prepared_Designation varchar(100),  
 @Verified_Designation varchar(100),  
 @Acknowledged_Designation varchar(100),  
 @Prepared_date   DATETIME,  
 @Verified_date   DATETIME,  
 @Acknowledged_date  DATETIME  
    
 CREATE TABLE #Temp  
(  
 Row_Id INT IDENTITY(1,1),  
 HospitalId VARCHAR(MAX),  
 Periodid   int,  
 Period  Varchar(Max),  
 Building_count INT  
)  
  
  
create table #tempVM (VariationDetailsId int)  
  
  
insert into #tempVM (VariationDetailsId)  
select VDT.VariationId  
FROM EngAsset EARM  WITH(NOLOCK)   
JOIN  VmVariationTxn VDT  WITH(NOLOCK) ON EARM.AssetId = VDT.AssetId   
left join VmVariationTxnDet DET ON DET.VariationId = VDT.VariationId   
WHERE VDT.FacilityId = @Hospital_Id  
AND EARM.AssetClassification=4807   /* FEMS - Building */  
AND EARM.Active = 1   
AND year (VDT.VariationRaisedDate) = @year   
AND month (VDT.VariationRaisedDate) = @month  
and ISNULL(VDT.VariationWFStatus,DET.VariationWFStatus) = 5578   
  
declare  @tmpStaffMaster TABLE  
(  
  Rowid     int identity,  
  FmsStaffMstId   int,  
  userregistrationid  int null,  
  Position    int,  
  effectivedate   datetime   
 )  
  
insert into @tmpStaffMaster(FmsStaffMstId,userregistrationid,Position,effectivedate)  
  
select  t1.UserRegistrationId,t1.UserRegistrationId,t2.Designation,t1.DateJoined  
from UMUserRegistration t1  
join userdesignation t2 on t1.UserDesignationId =t2.UserDesignationId  
where t1.FacilityId=@Hospital_Id  and t1.Active=1  
--and t2.EffectiveDate <= GETDATE() and (t2.EndDate is null or t2.EndDate>=GETDATE())   
  
--insert into @tmpStaffMaster(FmsStaffMstId,userregistrationid,Position,effectivedate)  
  
--select  t3.StaffMasterId,t1.UserRegistrationId,t2.CurrentPosition,t3.EffectiveDate  
--from FmsStaffLocationMstDet t3   
--join  FmsStaffMst t1 on t3.StaffMasterId=t1.StaffMasterId  
--join FmsStaffPositionMstDet t2 on t1.StaffMasterId =t2.StaffMasterId  
--where t2.CurrentPosition in (3191,3192) and t3.HospitalId=@Hospital_Id   
-- and UserRegistrationId is not null  
--and t1.IsDeleted=0 and t2.IsDeleted=0  
--and (t1.DateResigned is null or t1.DateResigned>=GETDATE() )  
--and t2.EffectiveDate <= GETDATE() and (t2.EndDate is null or t2.EndDate>=GETDATE())   
  
  
select @Prepared_name   = case when a.variationWFStatus =232 then (select top 1 FmsStaffMstId from @tmpStaffMaster  order by effectivedate) else  b.doneby  end  ,  
    @Prepared_Designation = case when a.variationWFStatus =232 then (select top 1 FmsStaffMstId from @tmpStaffMaster  order by effectivedate) else b.doneby  end  ,  
    @Prepared_date   = case when a.variationWFStatus =232 then  b.donedate end    
from  (select variationWFStatus,max(VariationDetId) as VariationDetailsDetId from VmVariationTxnDet V    
  join #tempVM T on v.VariationId = t.VariationDetailsId  
  where variationWFStatus in (232 ) group by variationWFStatus) a    
join VmVariationTxnDet b on  a.VariationDetailsDetId = b.VariationDetId  
  
  
select   
    @Verified_name   = case when a.variationWFStatus =233 then (select top 1 FmsStaffMstId from @tmpStaffMaster order by effectivedate) else b.doneby  end  ,  
    @Verified_Designation = case when a.variationWFStatus =233 then (select top 1 FmsStaffMstId from @tmpStaffMaster order by effectivedate) else b.doneby  end  ,  
    @Verified_date   = case when a.variationWFStatus =233 then  b.donedate end    
from  (select variationWFStatus,max(VariationDetId) as VariationDetailsDetId from VmVariationTxnDet V    
join #tempVM T on v.VariationId = t.VariationDetailsId  
   where variationWFStatus in (233) group by variationWFStatus) a    
join VmVariationTxnDet b on  a.VariationDetailsDetId = b.VariationDetId  
  
  
  
select   
    @Acknowledged_name  = case when a.variationWFStatus =5578 then (select top 1 FmsStaffMstId from @tmpStaffMaster  order by effectivedate) else b.doneby  end  ,  
    @Acknowledged_Designation= case when a.variationWFStatus =5578 then (select top 1 FmsStaffMstId from @tmpStaffMaster  order by effectivedate) else b.doneby  end  ,  
    @Acknowledged_date  = case when a.variationWFStatus =5578 then  b.donedate  end    
from  (select variationWFStatus,max(VariationDetId) as VariationDetailsDetId from VmVariationTxnDet V    
join #tempVM T on v.VariationId = t.VariationDetailsId  
   where variationWFStatus in (5578)  
   group by variationWFStatus) a    
join VmVariationTxnDet b on  a.VariationDetailsDetId = b.VariationDetId  
  
  
  
select  @Prepared_name     =  (select top 1 FmsStaffMstId from @tmpStaffMaster where Position in (3191,3192) order by effectivedate)  ,  
  @Prepared_Designation  = (select top 1 FmsStaffMstId from @tmpStaffMaster where Position in (3191,3192) order by effectivedate) ,  
  @Verified_name     =   (select top 1 FmsStaffMstId from @tmpStaffMaster where Position in (5920,2840) order by effectivedate),  
  @Verified_Designation  = (select top 1 FmsStaffMstId from @tmpStaffMaster where Position in (5920,2840) order by effectivedate) ,  
  @Acknowledged_name    =    (select top 1 FmsStaffMstId from @tmpStaffMaster where Position in (2837) order by effectivedate) ,  
  @Acknowledged_Designation =(select top 1 FmsStaffMstId from @tmpStaffMaster where Position in (2837) order by effectivedate)  
  
  
select HospitalId,VariationRaisedDate,AssetRegisterId,VariationRaisedDate,AssetRegisterId,Department,Equipment_Description,Equipment_Code,  
Asset_Number,Manufacturer,Model,purchaseprojectcost,VariationStatus,StartServiceDate,StartServiceDate,ExpiryDate,ServiceStopDate,  
ProposedRateDW,ProposedRatePW,MonhlyProposedFeeDW,MonthlyProposedFeePW,DoneRemarks,Prepared_name,Verified_name,Acknowledged_name,  
Prepared_Designation,Verified_Designation,Acknowledged_Designation,Prepared_date,Verified_date,Acknowledged_date,Effective_date,variation  
from   
(  
SELECT distinct  
  
 EARM.FacilityId HospitalId,    
 ISNULL(FORMAT(VariationRaisedDate,'dd-MMM-yyyy'),'') as VariationRaisedDate,  
 EARM.AssetId AssetRegisterId,  
 FUA.BlockName as Department,  
 AT.AssetTypeDescription as Equipment_Description,  
 AT.AssetTypeCode as Equipment_Code,  
 EARM.AssetNo as Asset_Number,  
 (select top 1 Manufacturer from EngAssetStandardizationManufacturer S where S.ManufacturerId = EARM.Manufacturer) as Manufacturer,  
 (select top 1 Model from EngAssetStandardizationModel M where M.ModelId = EARM.Model) as Model,  
 VDT.purchaseprojectcost,  
 left(dbo.Fn_DisplayNameofLov(VDT.VariationStatus),3) as VariationStatus,  
 ISNULL(FORMAT(VDT.StartServiceDate,'dd-MMM-yyyy'),'') as StartServiceDate,  
 ISNULL(FORMAT(VDT.WarrantyEndDate,'dd-MMM-yyyy'),'') as ExpiryDate,  
 ISNULL(FORMAT(VDT.ServiceStopDate,'dd-MMM-yyyy'),'') as ServiceStopDate,  
 --EARM.GovernmentAssetNo as Asset_Number,   
 VDT.ProposedRateDW  as ProposedRateDW,  
 VDT.ProposedRatePW as ProposedRatePW,  
   case when VDT.WarrantyEndDate is not null and cast(VDT.WarrantyEndDate as date)>=cast(VariationRaisedDate as date) then isnull(VDT.MonthlyProposedFeeDW,0.00) else Null end  as MonhlyProposedFeeDW,  
 case when VDT.WarrantyEndDate is  null or   cast(VDT.WarrantyEndDate as date)<cast(VariationRaisedDate as date) then isnull(VDT.MonthlyProposedFeePW,0.00) else Null end   as MonthlyProposedFeePW,  
 DoneRemarks,   
 dbo.Fn_DisplayUserNamebyStaffId_BI ( @Prepared_name ) as Prepared_name,  
 dbo.Fn_DisplayUserNamebyStaffId_BI (@Verified_name )  as Verified_name ,  
 dbo.Fn_DisplayUserNamebyStaffId_BI (@Acknowledged_name ) as Acknowledged_name ,   
 dbo.Fn_DisplayUserDesignation( @Prepared_Designation) as Prepared_Designation ,  
 dbo.Fn_DisplayUserDesignation( @Verified_Designation) as Verified_Designation,  
 dbo.Fn_DisplayUserDesignation( @Acknowledged_Designation )as Acknowledged_Designation,  
 ISNULL(FORMAT(@Prepared_date,'dd-MMM-yyyy'),'') as Prepared_date,  
 ISNULL(FORMAT(@Verified_date,'dd-MMM-yyyy'),'') as Verified_date,  
 ISNULL(FORMAT(@Acknowledged_date,'dd-MMM-yyyy'),'') as Acknowledged_date,   
 ISNULL(FORMAT(VDT.PaymentStartDate,'dd-MMM-yyyy'),'') as Effective_date  
 ,VDT.VariationStatus as variation  
FROM EngAsset EARM  WITH(NOLOCK)   
left join   MstLocationUserLocation EULM on EULM.UserLocationId=EARM.UserLocationId   
JOIN  VmVariationTxn VDT  WITH(NOLOCK) ON EARM.AssetId = VDT.AssetId   
Join #tempVM t      WITH(NOLOCK) ON t.VariationDetailsId = VDT.VariationId  
left join EngAssetTypeCode AT WITH(NOLOCK) ON EARM.AssetTypeCodeId = AT.AssetTypeCodeId     
left join MstLocationUserArea  EUA ON EULM.UserAreaId = EUA.UserAreaId  
left join MstLocationBlock  FUA ON EUA.BlockId = FUA.BlockId  
)a  
order by  a.VariationStatus,a.Asset_Number ASC   
  
END TRY  
BEGIN CATCH  
  
insert into ErrorLog(Spname,ErrorMessage,createddate)  
  values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())  
  
END CATCH  
SET NOCOUNT OFF  
END
GO
