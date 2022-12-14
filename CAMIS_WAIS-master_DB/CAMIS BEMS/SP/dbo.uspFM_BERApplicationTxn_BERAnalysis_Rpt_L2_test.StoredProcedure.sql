USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BERApplicationTxn_BERAnalysis_Rpt_L2_test]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_BERApplicationTxn_BERAnalysis_Rpt_L2] 
Description			: Get the BER Analysis Report(Level2)
Authors				: Ganesan S
Date				: 14-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_BERApplicationTxn_BERAnalysis_Rpt_L2 @app_id = 102,
@MenuName = ''
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 create PROCEDURE [dbo].[uspFM_BERApplicationTxn_BERAnalysis_Rpt_L2_test]                                   
(                                              
     @app_id            VARCHAR(100),
	 @MenuName      VARCHAR(500)       
 )           
AS                                          
BEGIN                                
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY


Declare --@techid varchar(500),
@Supplier_name varchar(400)

	SET @Supplier_Name = ''
	select TOP 1 @Supplier_Name =  C.ContractorName  
	from EngAsset A
           join EngAssetSupplierWarranty B on A.AssetId = B.AssetId
           join MstContractorandVendor C on B.ContractorId = C.ContractorId
           where (B.Category = 13 AND A.FacilityId in(select FacilityId from BerApplicationTxn where ApplicationId=@app_id))


Create table #berlvl2(
BIL varchar(300),
FacilityId INT,
Facility_Name  varchar(300),
Ber_No  varchar(300),
Application_Date  varchar(300),
Purchase_Year  varchar(300),
Asset_Number  varchar(300),
Asset_Description  varchar(300),
User_Location_Code  varchar(300),
User_Location_Name  varchar(300),
Purchase_Cost_RM  varchar(300),
Make   varchar(300),
Repair_Estimates  varchar(300),
After_Repaired_Value  varchar(300),
Present_Value  varchar(300),
CurrentValue   varchar(300),
Estimated_duration_of_Used_After_Repaired  varchar(300),
Registration_No  varchar(300),
Damage_Frequency_From_Out  varchar(300),
Chassis_No  varchar(300),
Since_Purchased_Total_Cost_Improvement  varchar(300),
Engine_number  varchar(300),
Supplier_name  varchar(400),
Record  varchar(300),
Applicantname  varchar(300),
Asset_Age  varchar(300),
Still_in_LYF  varchar(300), 
Ber2_Technical_Condition  varchar(300), 
Ber2_Repaired_Well  varchar(300),
Ber2_Safe_Reliable  varchar(300),
Ber2_Estimate_Life_Time  varchar(300),
Ber2_Syor  varchar(300),
Remarks  varchar(300),
ExpectedLifespan  Varchar(200),
RequestNo varchar(300),
SR_Date  varchar(300),
Service  varchar(300),
Facility_Code  varchar(300),
EstRepcostToExpensive  varchar(300),
Model  varchar(300),
Since_Repair_Purchased  varchar(300),
--Major_Breakdown  varchar(300),
Not_Reliable  varchar(300),
--Ability_To_Be_Removed  varchar(300),
Repair_Estimate  varchar(300),
--Healthy_Safety_Hazards  varchar(300),
Statutory_Requirements  varchar(300),
Other_Observations  varchar(300),
Applicant_Designation  varchar(300),
Note  varchar(500),
Obsolescence_Value varchar(50)
)


insert into #berlvl2
(BIL ,
FacilityId,
Facility_Name,
Ber_No  ,
Application_Date  ,
Purchase_Year  ,
Asset_Number  ,
Asset_Description  ,
User_Location_Code  ,
User_Location_Name  ,
Purchase_Cost_RM  ,
Make   ,
Repair_Estimates  ,
After_Repaired_Value  ,
Present_Value  ,
CurrentValue,
Estimated_duration_of_Used_After_Repaired  ,
Registration_No  ,
--Damage_Frequency_From_Out  ,
Chassis_No  ,
Since_Purchased_Total_Cost_Improvement  ,
Engine_number  , 
Supplier_name,
Record  ,
Applicantname  ,
Asset_Age  ,
Still_in_LYF  , 
Ber2_Technical_Condition  , 
Ber2_Repaired_Well  ,
Ber2_Safe_Reliable  ,
Ber2_Estimate_Life_Time  ,
Ber2_Syor  ,
Remarks  ,
ExpectedLifespan,
--RequestNo,
--SR_Date  ,
Service  ,
Facility_Code  ,
EstRepcostToExpensive  ,
Model  ,
Since_Repair_Purchased  ,
--Major_Breakdown  ,
Not_Reliable  ,
--Ability_To_Be_Removed  ,
Repair_Estimate  ,
--Healthy_Safety_Hazards  ,
Statutory_Requirements  ,
Other_Observations  ,
Applicant_Designation  ,
Note ,
Obsolescence_Value 
)
SELECT 
	a.BIL,
	a.FacilityId,
	DBO.udf_DisplayHospitalName(A.FacilityId) AS 'Facility_Name',
	A.Berno as 'Ber_No',
	FORMAT(A.createddate,'dd-MMM-yyyy') AS 'Application_Date', 
	FORMAT(b.PurchaseDate,'dd-MMM-yyyy') as 'Purchase_Year',
	B.AssetNo as 'Asset_Number',
	td.AssetTypeDescription 'Asset_Description',
	UL.UserLocationCode as 'User_Location_Code', 
	UL.UserLocationName as User_Location_Name,
	B.PurchaseCostRM as 'Purchase_Cost_RM',
    stmanu.Manufacturer as 'Maker',
	A.EstRepcostToExpensive as 'Repair_Estimates',
	a.ValueAfterRepair as 'After_Repaired_Value',
	C.CurrentValue as 'Present_Value',
	c.remarks,
	'' as 'Estimated_duration_of_Used_After_Repaired',
	ISNULL(b.Registrationno,'Not Applicable') as 'Registration_No',
	--A.FreqDamSincPurchased as 'Damage_Frequency_From_Out',
	ISNULL(B.ChassisNo,'Not Applicable') as 'Chassis_No',
	(select top 1 TotalCost from EngMaintenanceWorkOrderTxn a
join EngMwoCompletionInfoTxn b on a.WorkOrderId = b.WorkOrderId
join FmLovMst c on a.MaintenanceWorkType = c.LovId
join FmLovMst d on a.WorkOrderStatus = d.LovId
left join EngAsset asset on asset.AssetId=a.AssetId
left join BerApplicationTxn app on app.AssetId=asset.AssetId
where app.ApplicationId = @app_id 
and c.LovKey='MWOWorkOrderCategoryValue' 
and d.LovKey = 'WorkOrderStatusValue' 
and d.FieldCode != '5'
group by a.AssetId,TotalCost) as 'Since_Purchased_Total_Cost_Improvement',
	B.SerialNo as 'Engine_number',
	@Supplier_name as Supplier_name,
	'' as 'Record',
/* Ber 2*/
    dbo.Fn_DisplayUserNamebyStaffId_BI(a.ApplicantUserID) as Applicantname,
	cast((DATEDIFF(m, b.PurchaseDate, GETDATE())/12) as varchar) + '.' + 
       CASE WHEN DATEDIFF(m, b.PurchaseDate, GETDATE())%12 = 0 THEN '0' 
	        ELSE cast((DATEDIFF(m, b.PurchaseDate, GETDATE())%12) as varchar) END   as 'Asset_Age',
	ISNULL(a.TBer2StillLifeSpan,0) as 'Still_in_LYF',
	BER2Tech.FieldValue as 'Ber2_Technical_Condition',
	A.Ber2RepairedWell as 'Ber2_Repaired_Well',
       BER2Safe.FieldValue as 'Ber2_Safe_Reliable',
	  BEREsti.FieldValue as 'Ber2_Estimate_Life_Time',
	--ISNULL(A.Ber2Syor,'1') as 'Ber2_Syor',
	
  	Case 
			When A.BER2Syor=1 then 'The asset can be repaired and is safe to use.'
			When A.BER2Syor=2 then 'The asset is beyond economical repair. However, it can be used and maintained until condemned.'
			When A.BER2Syor=3 then 'The asset is beyond economical repair. It must be decommissioned immediately due to safety reason and/or major breakdown.'
			When A.BER2Syor=4 then 'These assets are in good condition and safe to use. These assets can be transferred.'
		Else 'The asset can be repaired and is safe to use.' End as 'Ber2_Syor',
   '' as 'Remarks',
   0 as 'ExpectedLifespan',
/* Ber 1*/
	--s.RequestNo,convert(varchar(12),
	--s.DateTime,106) as 'SR_Date',
	Ser.ServiceKey as 'Service',
	dbo.udf_DisplayHospitalName(a.FacilityId)as 'Facility_Code',
	A.EstRepcostToExpensive,
	stmodel.model as 'Model',
	'' as 'Since_Repair_Purchased',
	--a.MajorBreakdown as 'Major_Breakdown',
	reliable.FieldValue as 'Not_Reliable',
	--val.FieldValue as 'Ability_To_Be_Removed',
	A.RepairEstimate as 'Repair_Estimate',
	--a.HealthySafetyHazards as 'Healthy_Safety_Hazards',
	statreq.FieldValue as 'Statutory_Requirements',
	a.OtherObservations as 'Other_Observations',
	dbo.Fn_DisplayUserDesignation(a.ApplicantUserId) as 'Applicant_Designation',
	'' as 'Note',
	A.Obsolescence as Obsolescence_Value
FROM 
	BerApplicationTxn A
	left join FmLovMst   BER2Tech on BER2Tech.LovId=A.Ber2TechnicalCondition
	left join FmLovMst    BER2Safe on BER2Safe.LovId=A.Ber2SafeReliable
	Left join FmLovMst    BEREsti on BEREsti.LovId=A.Ber2EstimateLifeTime
	Left join FmLovMst    statreq on statreq.LovId=A.Ber2EstimateLifeTime
	Left join FmLovMst    reliable on reliable.LovId=A.NotReliable

	--left join FmLovMst val  on val.LovId=a.EstRepcostToExpensive
join 
	EngAsset B on A.AssetId=B.AssetId
	left join EngAssetTypeCode td on td.AssetTypeCodeId=B.AssetTypeCodeId
	--left join EngNewTypeCodeDetailsTxn ntd on ntd.AssetTypeCodeDetId=td.AssetTypeCodeId
--left  join 
--	CRMRequest s on a.CRMRequestId=s.CRMRequestId
	left join MstLocationUserLocation UL on UL.UserLocationId=B.UserLocationId
	left join EngAssetStandardizationModel stmodel on stmodel.ModelId=b.Model
		left join EngAssetStandardizationManufacturer stmanu on stmanu.ManufacturerId=b.Manufacturer
	left join MstService Ser on Ser.ServiceId=B.ServiceId
inner  Join 
BerCurrentValueHistoryTxnDet C on c.ApplicationId=A.ApplicationId --AND A.ServiceRequestId=C.ServiceRequestId
where A.applicationid=@app_id 


--select @techid=a.TechnicalSupportNo from EngTechSupportLetterTxn a
--inner join  EngTechSupportLetterTxnDet b on a.TechnicalSupportId=b.TechnicalSupportId
-- inner join EngTechSupportLetterStatusTxnDet c on b.TechnicalSupportDetId=c.TechnicalSupportDetId
-- inner join EngAssetRegisterMst d on d.Manufacturer=b.Manufacturer and b.MadeIn=d.MadeIn and b.Model=d.Model
-- where a.IsDeleted=0 and b.IsDeleted=0 and c.IsDeleted=0 and c.Status=2350
--and d.AssetRegisterId=(select AssetRegisterId from BerApplicationTxn where IsDeleted=0 and ApplicationId=@app_id)  

select  DISTINCT *
--dbo.Fn_GetCompStateName(Hospitalid,'company') as 'Company_Name',
--dbo.fn_GetCompStateName(Hospitalid,'state') as 'State_Name', 
--@techid as 'Technical_support',Case when len(@techid)>0 then 'Yes' else 'No' END as 'Obscelence' 
--,dbo.Fn_GetLogo(Hospitalid,'company') as 'Company_Logo',
-- dbo.Fn_GetLogo(Hospitalid,'MOH') as 'MOH_Logo'
from #berlvl2



    

END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())
		
END CATCH
SET NOCOUNT OFF
                                    
END
GO
