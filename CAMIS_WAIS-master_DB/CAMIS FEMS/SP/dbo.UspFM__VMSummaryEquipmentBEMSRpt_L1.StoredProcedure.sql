USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM__VMSummaryEquipmentBEMSRpt_L1]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                  
Application Name	: UEMBEMSTRACK
Version				: 
File Name			: UspFM__VMSummaryEquipmentBEMSRpt_L1
Procedure Name		: UspFM__VMSummaryEquipmentBEMSRpt_L1
Author(s) Name(s)	: Hari Haran N
Date				: 06/06/2018
Purpose				: Report SP For approved list of buildings FEMS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
EXEC [UspFM__VMSummaryEquipmentBEMSRpt_L1]  
EXEC [UspFM__VMSummaryEquipmentBEMSRpt_L1]  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
Modification History        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
          
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/       
CREATE PROCEDURE [dbo].[UspFM__VMSummaryEquipmentBEMSRpt_L1]
(
		@MenuName       VARCHAR(500),
		@Level			VARCHAR(20),
		@Option			VARCHAR(20),
		@From_Year      VARCHAR(20),     
		@To_Year        VARCHAR(20)
		
 )               
AS                                                  
BEGIN                                    
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY                                      

CREATE  table #Hospital_Master (FacilityId varchar(25))      
 IF (@Level='national')             
 BEGIN            
    
	 insert into  #Hospital_Master(FacilityId)             
     Select  FacilityId FROM MstLocationFacility   group by FacilityId                
 END      
 IF (@Level='Customer')             
 BEGIN            
	insert into  #Hospital_Master(FacilityId)              
	Select  FacilityId FROM MstLocationFacility Where CustomerId=@Option  group by FacilityId           
 END      
 IF (@Level='Facility')             
 BEGIN         
   insert into  #Hospital_Master(FacilityId)  values (@Option)   
 END     


 
 CREATE TABLE #Temp
(
 Row_Id INT IDENTITY(1,1),
 FacilityId VARCHAR(MAX),
 Building_count INT,
 MonhlyProposedFeeDW  numeric (20,2),
 MonthlyProposedFeePW numeric (20,2)
)

--select
--Asset.AssetRegisterId,Period,Asset.HospitalId,userdepartmentcode,userdepartmentname,Asset.AssetRegisterId,AssetNo,AssetDescription,Asset.AssetTypeCodeId,
--AssetTypeCode,AssetTypeDescription,Asset.BldBuiltUpArea,dbo.fn_displaynameoflov(VM.VariationStatus) as VariationStatus,purchaseprojectcost,vm.StartServiceDate,
--VM.ServiceStopDate,VM.WarrantyEndDate,VM.paymentstartdate as DW_start_date, VM.pwpaymentstartdate as PW_Start_Date,
--ProposedRate as ProposedRateDW,ProposedRatePW,MonthlyProposedFee as MonthlyProposedFeeDW,MonthlyProposedFeePW,IsVerify,DoneRemarks,
--dbo.fn_displaynameoflov(VariationApprovedStatus) as VariationApprovedStatus

--from EngAssetRegisterMst Asset 
--left join VmVariationDetailsTxn VM  ON Asset.AssetRegisterId=VM.AssetRegisterId   
--left join EngAssetTypeCodeMstDet ATC ON Asset.AssetTypeCodeId=ATC.AssetTypeCodeId   
--left join EngUserAreaMst  EU on asset.EngUserAreaId=EU.EngUserAreaId
--left join GmStandardUserDepartmentMst  GD on GD.UserDepartmentId=EU.UserDepartmentId
--where Asset.AssetClassification=2324 and Asset.HospitalId=85
--AND   Asset.IsDeleted=0  

INSERT INTO #Temp(FacilityId,Building_count,MonhlyProposedFeeDW,MonthlyProposedFeePW)
SELECT 
	VDT.FacilityId,
	--convert(varchar(6),VDT.VariationRaisedDate,112),
	COUNT(1) ,
	sum(VDT.MonthlyProposedFeeDW)  as MonhlyProposedFeeDW,
	sum(VDT.MonthlyProposedFeePW) as MonthlyProposedFeePW
FROM EngAsset EARM WITH(NOLOCK) 
JOIN VmVariationTxn VDT WITH(NOLOCK) ON EARM.AssetId = VDT.AssetId 
WHERE exists (select 1 from #Hospital_Master h where h.FacilityId=VDT.FacilityId)
AND EARM.UserAreaId is not null
and YEAR(VDT.VariationRaisedDate)	BETWEEN @From_Year  and @To_Year
and VDT.VariationWFStatus in (5583,5614,5615,5616) --SVR - approved .
--AND   exists (SELECT VariationWFStatus FROM  VmVariationDetailsTxnDet DET WHERE VariationWFStatus = 5583 
                             --AND DET.VariationDetailsId = VDT.VariationDetailsId)    --SVR - Verified .
GROUP BY  VDT.FacilityId



declare @tcount int
select @tcount=count(*) from #Temp

Select 
		@MenuName as 'MenuName',
		--dbo.Fn_GetCompStateName(HospitalId,'Company') as 'Company_Name',
		--dbo.Fn_GetCompStateName(HospitalId,'State') as 'State_Name',
		v.CustomerName as 'Customer_Name',
		v.FacilityName AS 'Facillity_Name',
		v.FacilityId ,
		--DBO.Fn_DisplayHospitalName(HospitalId ) AS 'Hospital_Name',
		Building_count,
		MonhlyProposedFeeDW,
		MonthlyProposedFeePW,		
		@tcount as 'Total_Records'   
		--dbo.Fn_GetLogo(HospitalId,'company') as 'Company_Logo',
		--dbo.Fn_GetLogo(HospitalId,'MOH') as 'MOH_Logo'
FROM #Temp T Join V_MstLocationFacility V on v.FacilityId=t.FacilityId
END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF
END


select * from V_MstLocationFacility
GO
