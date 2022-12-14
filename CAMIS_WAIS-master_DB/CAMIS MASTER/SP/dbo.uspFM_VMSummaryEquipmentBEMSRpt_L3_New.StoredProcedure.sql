USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VMSummaryEquipmentBEMSRpt_L3_New]    Script Date: 20-09-2021 16:43:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                  
Application Name	: ASIS
Version				: 
File Name			: uspFM_VMSummaryEquipmentBEMSRpt_L3
Procedure Name		: uspFM_VMSummaryEquipmentBEMSRpt_L3
Author(s) Name(s)	: Hari Haran N
Date				: 14 Jun 2018
Purpose				: Report SP For approved list of buildings FEMS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        

EXEC [uspFM_VMSummaryEquipmentBEMSRpt_L3] '200','4610','2017'
EXEC [uspFM_VMSummaryEquipmentBEMSRpt_L3] 'national','1','monthly','02','2017','','',''
 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
Modification History        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
          

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/    
    
create PROCEDURE [dbo].[uspFM_VMSummaryEquipmentBEMSRpt_L3_New]
(
				
		@Facility_Id		VARCHAR(20),
		@Period			VARCHAR(20),
		@year			VARCHAR(20)
 )               
AS                                                  
BEGIN                                    
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY                                   

  
 declare 
 @Prepared_name			varchar(100),
 @Verified_name			varchar(100),
 @Acknowledged_name		varchar(100),
 @Prepared_Designation	varchar(100),
 @Verified_Designation	varchar(100),
 @Acknowledged_Designation varchar(100),
 @Prepared_date			Datetime,
 @Verified_date			Datetime,
 @Acknowledged_date		Datetime


  

 CREATE TABLE #Temp
(
 Row_Id INT IDENTITY(1,1),
 HospitalId VARCHAR(MAX),
 Periodid   int,
 Period		Varchar(Max),
 Building_count INT
)


create table #tempVM (VariationId int)


insert into #tempVM (VariationId)
select VariationId
FROM	EngAsset EARM	 WITH(NOLOCK) 
JOIN 	VmVariationTxn VDT	 WITH(NOLOCK) ON EARM.AssetId = VDT.AssetId 
WHERE VDT.FacilityId	=	@Facility_Id
AND EARM.UserAreaId is not null  
AND year (VDT.VariationRaisedDate) = @year 
AND VDT.period = @Period
and VDT.VariationWFStatus in (125) --SVR - approved .
--AND exists (SELECT VariationWFStatus FROM  VmVariationDetailsTxnDet DET WHERE VariationWFStatus = 5583 
--                             AND DET.VariationDetailsId = VDT.VariationDetailsId)  /* SVR - Verified */





select 
	   @Prepared_name			= case when a.variationWFStatus =233 then  b.doneby  end  ,
	   @Prepared_Designation	= case when a.variationWFStatus =233 then  b.doneby  end  ,
	   @Prepared_date			= case when a.variationWFStatus =233 then  b.donedate end  
	  
 --, max(b.doneby) as doneby, max(a.donedate) as donedate 
from  (select variationWFStatus,max(VariationDetId) as VariationDetId from VmVariationTxnDet V  join #tempVM T on v.VariationId = t.VariationId
			where variationWFStatus in (233 )
			group by variationWFStatus) a  
join VmVariationTxnDet b on  a.VariationDetId = b.VariationDetId



select 
	   @Verified_name		= case when a.variationWFStatus =230 then  b.doneby  end  ,
	   @Verified_Designation= case when a.variationWFStatus =230 then  b.doneby  end  ,
	   @Verified_date		= case when a.variationWFStatus =230 then  b.donedate  end  
 --, max(b.doneby) as doneby, max(a.donedate) as donedate 
from  (select variationWFStatus,max(VariationDetId) as VariationDetId from VmVariationTxnDet V  join #tempVM T on v.VariationId = t.VariationId
			where variationWFStatus in (5583)
			group by variationWFStatus) a  
join VmVariationTxnDet b on  a.VariationDetId = b.VariationDetId

	
--select @Prepared_name			= case when a.variationWFStatus =5578 then  b.doneby  end  ,
--	   @Prepared_Designation	= case when a.variationWFStatus =5578 then  b.doneby  end  ,
--	   @Prepared_date			= case when a.variationWFStatus =5578 then  b.donedate end  
-- --, max(b.doneby) as doneby, max(a.donedate) as donedate 
--from  (select variationWFStatus,max(VariationDetailsDetId) as VariationDetailsDetId from VmVariationDetailsTxndet V  join #tempVM T on v.VariationDetailsId = t.VariationDetailsId
--			where variationWFStatus in (5578 )
--			group by variationWFStatus) a  
--join VmVariationDetailsTxndet b on  a.VariationDetailsDetId = b.VariationDetailsDetId


--select 
--	   @Verified_name			= case when a.variationWFStatus =5581 then  b.doneby  end  ,
--	   @Verified_Designation	= case when a.variationWFStatus =5581 then  b.doneby  end  ,
--	   @Verified_date			= case when a.variationWFStatus =5581 then  b.donedate end  
	  
-- --, max(b.doneby) as doneby, max(a.donedate) as donedate 
--from  (select variationWFStatus,max(VariationDetailsDetId) as VariationDetailsDetId from VmVariationDetailsTxndet V  join #tempVM T on v.VariationDetailsId = t.VariationDetailsId
--			where variationWFStatus in (5581 )
--			group by variationWFStatus) a  
--join VmVariationDetailsTxndet b on  a.VariationDetailsDetId = b.VariationDetailsDetId



--select 
--	   @Acknowledged_name		= case when a.variationWFStatus =5583 then  b.doneby  end  ,
--	   @Acknowledged_Designation= case when a.variationWFStatus =5583 then  b.doneby  end  ,
--	   @Acknowledged_date		= case when a.variationWFStatus =5583 then  b.donedate  end  
-- --, max(b.doneby) as doneby, max(a.donedate) as donedate 
--from  (select variationWFStatus,max(VariationDetailsDetId) as VariationDetailsDetId from VmVariationDetailsTxndet V  join #tempVM T on v.VariationDetailsId = t.VariationDetailsId
--			where variationWFStatus in (5583)
--			group by variationWFStatus) a  
--join VmVariationDetailsTxndet b on  a.VariationDetailsDetId = b.VariationDetailsDetId

--select @Prepared_name			= case when a.variationWFStatus =5578 then  b.doneby  end  ,
--	   @Verified_name			= case when a.variationWFStatus =5581 then  b.doneby  end  ,
--	   @Acknowledged_name		= case when a.variationWFStatus =5583 then  b.doneby  end  ,
--	   @Prepared_Designation	= case when a.variationWFStatus =5578 then  b.doneby  end  ,
--	   @Verified_Designation	= case when a.variationWFStatus =5581 then  b.doneby  end  ,
--	   @Acknowledged_Designation= case when a.variationWFStatus =5583 then  b.doneby  end  ,
--	   @Prepared_date			= case when a.variationWFStatus =5578 then  b.donedate end  ,
--	   @Verified_date			= case when a.variationWFStatus =5581 then  b.donedate end  ,
--	   @Acknowledged_date		= case when a.variationWFStatus =5583 then  b.donedate  end  
-- --, max(b.doneby) as doneby, max(a.donedate) as donedate 
--from  (select variationWFStatus,max(VariationDetailsDetId) as VariationDetailsDetId from VmVariationDetailsTxndet V  join #tempVM T on v.VariationDetailsId = t.VariationDetailsId
--			where variationWFStatus in (5578 ,5581 , 5583)
--			group by variationWFStatus) a  
--join VmVariationDetailsTxndet b on  a.VariationDetailsDetId = b.VariationDetailsDetId

select  @Prepared_name		   =  case when @Prepared_name = UserRegistrationId then UserRegistrationId else @Prepared_name end ,
		@Prepared_Designation  =  case when @Prepared_Designation = UserRegistrationId then UserRegistrationId else @Prepared_Designation end ,
		@Verified_name		   =  case when @Verified_name = UserRegistrationId then UserRegistrationId else @Verified_name end ,
		@Verified_Designation  =  case when @Verified_Designation = UserRegistrationId then UserRegistrationId  else @Verified_Designation end ,
		@Acknowledged_name	   =   case when @Acknowledged_name = UserRegistrationId then UserRegistrationId else @Acknowledged_name end 	,
		@Acknowledged_Designation = case when @Acknowledged_Designation = UserRegistrationId then UserRegistrationId else @Acknowledged_Designation end 
from UMUserRegistration   where  ( UserRegistrationId = isnull (@Prepared_name,UserRegistrationId)  or UserRegistrationId = isnull (@Verified_name,UserRegistrationId)  or UserRegistrationId = isnull (@Acknowledged_name,UserRegistrationId) )

IF EXISTS (select 1 from UserDesignation  where   UserDesignationId = @Prepared_Designation)
BEGIN
	SELECT @Prepared_Designation =( select Designation from UserDesignation a with (nolock)  where   UserDesignationId = @Prepared_Designation)
END
else
begin
select @Prepared_Designation=''
end

if exists (select 1 from UserDesignation  where   UserDesignationId = @Verified_Designation)
begin
select @Verified_Designation = ( select Designation from UserDesignation a with (nolock)  where   UserDesignationId = @Verified_Designation)
end
else 
begin
select @Verified_Designation=''
end

--if exists (SELECT 1 from DBO.GmStaffCompanyMstDet with(nolock) where StaffMasterId=@Verified_Designation )
--BEGIN
--SELECT @Verified_Designation = dbo.Fn_DisplayNameofLov(CurrentPosition) from DBO.GmStaffCompanyMstDet with(nolock) where StaffMasterId=@Verified_Designation 
--END
--else
--begin
--select @Verified_Designation=''
--end
--select @Verified_Designation = dbo.Fn_DisplayNameofLov(Position) from GMStaffMstDet  where   StaffMasterId = @Verified_Designation


SELECT 

	--dbo.Fn_GetCompStateName(EARM.HospitalId,'Company') as 'Company_Name',
	--dbo.Fn_GetCompStateName(EARM.HospitalId,'State') as 'State_Name',
	--DBO.Fn_DisplayHospitalName(EARM.HospitalId) AS 'Hospital_Name',
	EARM.FacilityId,		
	ISNULL(FORMAT(VariationRaisedDate,'dd-MMM-yyyy'),'') as VariationRaisedDate,
	EARM.AssetId,
	EUA.UserAreaName as Department,
	--EARM.AssetDescription as Equipment_Description,
	ATC.AssetTypeDescription as Equipment_Description,
	ATC.AssetTypeCode as Equipment_Code,
	EARM.AssetNo,
	EARM.AssetDescription,
	(select top 1 Manufacturer from EngAssetStandardizationManufacturer S where S.ManufacturerId = EARM.Manufacturer) as Manufacturer,
	(select top 1 Model from EngAssetStandardizationModel M where M.ModelId = EARM.Model) as Model,
	VDT.purchaseprojectcost,
	left(dbo.Fn_DisplayNameofLov(VDT.VariationStatus),3) as VariationStatus,
	ISNULL(FORMAT(VDT.StartServiceDate,'dd-MMM-yyyy'),'') as StartServiceDate,
	ISNULL(FORMAT(VDT.WarrantyEndDate,'dd-MMM-yyyy'),'') as ExpiryDate,
	ISNULL(FORMAT(VDT.ServiceStopDate,'dd-MMM-yyyy'),'') as ServiceStopDate,
	0 as BldBuiltUpArea,
	VDT.ProposedRateDW  as ProposedRateDW,
	VDT.ProposedRatePW as ProposedRatePW,
	VDT.MonthlyProposedFeeDW  as MonhlyProposedFeeDW,
	VDT.MonthlyProposedFeePW as MonthlyProposedFeePW,
	DoneRemarks,	
	dbo.Fn_DisplayUserNamebyStaffId_BI ( @Prepared_name	)	as Prepared_name,
	dbo.Fn_DisplayUserNamebyStaffId_BI (@Verified_name	)	 as Acknowledged_name	,
	dbo.Fn_DisplayUserNamebyStaffId_BI (@Acknowledged_name	) as Verified_name	,	
	@Prepared_Designation	as Prepared_Designation	,
	--dbo.Fn_DisplayUserDesignation( @Verified_Designation)	as Acknowledged_Designation,
	@Verified_Designation as Verified_Designation,
dbo.Fn_DisplayUserDesignation( @Acknowledged_Designation )as Acknowledged_Designation,
	--@Acknowledged_Designation as Acknowledged_Designation,
	ISNULL(FORMAT(@Prepared_date,'dd-MMM-yyyy'),'') as Prepared_date,
	ISNULL(FORMAT(@Verified_date,'dd-MMM-yyyy'),'') as Acknowledged_date,
	ISNULL(FORMAT(@Acknowledged_date,'dd-MMM-yyyy'),'') as Verified_date,	
	ISNULL(FORMAT(VDT.PaymentStartDate,'dd-MMM-yyyy'),'') as Effective_date	
	--dbo.Fn_GetLogo(EARM.HospitalId,'company') as 'Company_Logo',
	--dbo.Fn_GetLogo(EARM.HospitalId,'MOH') as 'MOH_Logo'
FROM	EngAsset EARM	 WITH(NOLOCK)
JOIN 	VmVariationTxn VDT	 WITH(NOLOCK) ON EARM.AssetId = VDT.AssetId 
Join	#tempVM t					 WITH(NOLOCK) ON t.VariationId = VDT.VariationId
left join EngAssetTypeCode ATC WITH(NOLOCK) ON EARM.AssetTypeCodeId = ATC.AssetTypeCodeId   
--left join EngAssetRegisterLocationMst  EU		 WITH(NOLOCK) ON EARM.AssetRegisterId	  = EU.AssetRegisterId
--left join EngUserLocationMst EUL ON EUL.EngUserLocationId = EU.EngUserLocationId
left join  MstLocationUserArea EUA ON EARM.UserAreaId = EUA.UserAreaId

 order by VDT.VariationStatus ASC
END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF
END
GO
