USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAsset_History_Rpt_L2]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author		:Aravinda Raja 
-- Create date	:04-06-2015
-- Description	:Asset Details
-- =============================================
--exec [dbo].[uspFM_EngAsset_History_Rpt_L2] '1'
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE   PROCEDURE [dbo].[uspFM_EngAsset_History_Rpt_L2]                                  
(    
--@MenuName			varchar(200),                                           
@Asset_Id			int   
 )           
AS                                              
BEGIN                                
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY       
                              
DECLARE 
		@Hospital				VARCHAR(100),
		@VariationHistory		VARCHAR(100),
		@MaintenanceHistory		VARCHAR(100),
		@AssetTransferHistory	VARCHAR(100),
		@AreaDepartmentServiced VARCHAR(100)       

SELECT @Hospital = EAR.FacilityId FROM EngAsset EAR  WHERE  EAR.Active=1  AND EAR.AssetId = @Asset_Id         


--IF EXISTS(select '*' from V_AssetMaintenanceHistory where AssetId=@Asset_Id )
--BEGIN
SELECT @MaintenanceHistory= 'Maintainence_History'
--END
--IF EXISTS(select '*' from EngAssetRegisterAssetTransferHistMst where AssetId=@Asset_Id and IsDeleted=0)
--BEGIN
SELECT @AssetTransferHistory= 'Asset_Transfer_History'
--END
IF EXISTS(select '*' from VmVariationTxn VM where VM.AssetId=@Asset_Id)
BEGIN
	SELECT @VariationHistory= 'Variation_History'
END 
--IF EXISTS(select '*' from EngAssetRegisterServingAreaMst where AssetId=@Asset_Id and IsDeleted=0)
--BEGIN
SELECT @AreaDepartmentServiced= 'Area_Department_Serviced'
--END        


	
	Select distinct 
		EAR.AssetNo,
		ASLMAuthorization.FieldValue AS AuthorizationStatus, 
		EAR.AssetNoOld,
		EATC.AssetTypeCode as TypeCode,
		EATC.AssetTypeDescription TypeDescription,
		ASLMAssetClassification.FieldValue AS AssetClassification,
		EAR.AssetPreRegistrationNo GovernmentAssetNo,
		EAR.AssetDescription,
		ASLMService.ServiceKey AS Service,
		GWGDM.WorkGroupCode AS WorkGroup,
		GWGDM.WorkgroupDescription as WorkGroupDescription,
		ISNULL(FORMAT(EAR.CommissioningDate,'dd-MMM-yyyy'),'') AS 'CommissioningDate',
		 
		EAR.ExpectedLifespan, 
		ASLM.FieldValue as AssetStatus,
		case 
			when DATEDIFF(year, EAR.CommissioningDate, GETDATE()) = 0 then 0 
			else round( cast((DATEDIFF(m, EAR.CommissioningDate, GETDATE())/12) as varchar) + '.' + 
       CASE 
			WHEN DATEDIFF(m, EAR.CommissioningDate, GETDATE())%12 = 0 THEN '0' 
	        ELSE cast((DATEDIFF(m, EAR.CommissioningDate, GETDATE())%12) as varchar) END , 0,5) end AS 'YearInService', 

		cast((DATEDIFF(m, EAR.PurchaseDate, GETDATE())/12) as varchar) + '.' +  
		CASE WHEN DATEDIFF(m, EAR.PurchaseDate, GETDATE())%12 = 0 THEN '0' ELSE cast((DATEDIFF(m, EAR.PurchaseDate, GETDATE())%12) as varchar) END 
		as AssetAge, 

		ASLMRealTimeStatus.FieldValue AS RealTimeStatus,
		ASLMTransferTypeWithin.FieldValue AS AssetTransferMode,
		ISNULL(FORMAT(tr.PorteringDate,'dd-MMM-yyyy'),'') AS 'TransferDate',
		ASLMTransferType.FieldValue AS TransferType,
		GMH.FacilityName AS Hospital,
		ISNULL(FORMAT(tr.ModifiedDate,'dd-MMM-yyyy'),'') AS TransferDateOld,
		VST.SnfDocumentNo AS SNFNo,
		FUL.UserLocationCode,
		FUL.UserLocationName,
		EUA.UserAreaCode,
		EUA.UserAreaName,
		ASLMM.Manufacturer Manufacturer,
		[EASM1].Manufacturer,
		[EASB].Model, 
		EAR.RegistrationNo,
		EAR.ChassisNo,
		EAR.EngineCapacity,
		ASLMFuelType.FieldValue AS FuelType,
		EAR.Specification,
		EAR.SerialNo,
		ISNULL(FORMAT(EAR.ManufacturingDate,'dd-MMM-yyyy'),'') AS 'ManufacturingDate',
		ASLMSpecificationUnit.FieldValue AS PowerSpecificationSpecificationUnit,
		EAR.PowerSpecification AS PowerSpecificationSpecificationUnitWatt,
		CASE WHEN EAR.PpmPlannerId=1 THEN 'Yes' ELSE 'No' END AS PPM  ,
		CASE WHEN EAR.RiPlannerId=1 THEN 'Yes' ELSE 'No' END AS RoutineInspectionRIFlag ,
		CASE WHEN EAR.OtherPlannerId=1 THEN 'Yes' ELSE 'No' END AS Calibration,
		ISNULL(FORMAT(EAR.ServiceStartDate,'dd-MMM-yyyy'),'') AS 'ServiceStartDate',
		EMWOT.MaintenanceWorkNo AS LastServiceWorkNo,
		ISNULL(FORMAT(EMWOT.MaintenanceWorkDateTime,'dd-MMM-yyyy'),'') AS LastServiceWorkDate,
		EAR.PurchaseCostRM,
		ASLMPurchaseCategory.FieldValue AS PurchaseCategory,
		ISNULL(FORMAT(EAR.PurchaseDate,'dd-MMM-yyyy'),'') AS PurchaseDate,
		EAR.WarrantyDuration,
		ISNULL(FORMAT(EAR.WarrantyStartDate,'dd-MMM-yyyy'),'') AS WarrantyStartDate,
		ISNULL(FORMAT(EAR.WarrantyEndDate,'dd-MMM-yyyy'),'') AS WarrantyEndDate,
		EAR.PurchaseCostRM ProjectCostEstimatedCostRM,

		(select top 1 a.ContractLpoNo from EngTestingandCommissioningTxn a
		where a.AssetId =EAR.AssetId) AS ContractLPONO,

		ISNULL(FORMAT(EAR.DisposalApprovalDate,'dd-MMM-yyyy'),'') AS DisposalApprovalDate,
		ISNULL(FORMAT(EAR.DisposedDate,'dd-MMM-yyyy'),'') AS DisposedDate,
		EAR.DisposedBy,
		EAR.DisposeMethod, 
		ASLM.FieldValue as [Status], 
		ISNULL(FORMAT(EAR.ModifiedDate,'dd-MMM-yyyy'),'') AS ModifiedDate,
		MAX(CAST(VM.AuthorizedStatus as INT)) Authorizedflag,
		VM.IsMonthClosed VMStatus,
		EAR.AssetId AssetRegisterId,
		EAR.AssetClassification as AssetClassificationId,
		EAR.FacilityId HospitalId,
		EAR.CustomerId CompanyId,
		EAR.ServiceId,
		@AreaDepartmentServiced as 'AreaDepartmentServiced',
		@VariationHistory as 'VariationHistory',
		@MaintenanceHistory as 'MaintenanceHistory',
		@AssetTransferHistory as 'AssetTransferHistory'
		--,@MenuName as 'Menu_Name'
	FROM DBO.EngAsset EAR  with(nolock)
	LEFT  JOIN  DBO.MstLocationUserLocation FUL  with(nolock) on FUL.UserLocationId=EAR.UserLocationId  
	LEFT  JOIN  DBO.MstLocationUserArea EUA  with(nolock) ON EUA.UserAreaId=FUL.UserAreaId
	INNER JOIN  DBO.EngAssetTypeCode EATC  with(nolock) on EATC.AssetTypeCodeId=EAR.AssetTypeCodeId
	INNER JOIN  DBO.EngAssetTypeCode EAT  with(nolock) on EATC.AssetTypeCodeId=EAT.AssetTypeCodeId
	left  join  PorteringTransaction tr on tr.AssetId=ear.AssetId
	LEFT JOIN  DBO.[EngAssetStandardizationManufacturer] AS [EASM1]   with(nolock)   ON [EASM1].ManufacturerId = [EAR].Manufacturer 
	LEFT JOIN  DBO.[EngAssetStandardizationModel] AS [EASB]    with(nolock)  ON [EASB].ModelId = [EAR].Model
	LEFT JOIN DBO.FmLovMst ASLM  with(nolock) on ASLM.LovId=EAR.AssetStatusLovId
	LEFT JOIN DBO.MstService ASLMService  with(nolock) on ASLMService.ServiceID=EAR.ServiceId
	INNER JOIN DBO.EngAssetWorkGroup  GWGDM  with(nolock) on GWGDM.WorkGroupId=EAR.WorkGroupId
	LEFT JOIN DBO.FmLovMst ASLMAuthorization  with(nolock)  on ASLMAuthorization.LovId=EAR.[Authorization] 
	INNER JOIN DBO.FmLovMst ASLMAssetClassification  with(nolock) on ASLMAssetClassification.LovId=EAR.AssetClassification  
	Left outer  Join DBO.EngAssetStandardizationManufacturer ASLMM  with(nolock) on ASLMM.ManufacturerId=EAR.Manufacturer   
	LEFT OUTER JOIN  DBO.VmVariationTxn VM  with(nolock) on EAR.AssetId=VM.AssetId and VM.AssetId is not null
	left  JOIN DBO.FmLovMst ASLMRealTimeStatus  with(nolock) on ASLMRealTimeStatus.LovId=EAR.RealTimeStatusLovId
	LEFT JOIN DBO.FmLovMst ASLMTransferTypeWithin  with(nolock) on ASLMTransferTypeWithin.LovId=tr.ModeOfTransport
	LEFT JOIN DBO.FmLovMst ASLMTransferType  with(nolock) on ASLMTransferType.LovId=tr.MovementCategory    
	LEFT JOIN dbo.MstLocationFacility GMH  with(nolock) ON GMH.FacilityId=tr.FromFacilityId
	LEFT JOIN DBO.VmVariationTxn VST  with(nolock) ON VST.AssetId = EAR.AssetId
	LEFT JOIN DBO.FmLovMst ASLMFuelType  with(nolock) on  ASLMFuelType.LovId=EAR.FuelType 
	outer apply (select top 1  WorkOrderId,MaintenanceWorkNo,MaintenanceWorkDateTime  from  dbo.EngMaintenanceWorkOrderTxn   with(nolock) where  AssetId=EAR.AssetId
				order by MaintenanceWorkDateTime desc) 
				as EMWOT
	LEFT JOIN dbo.EngMwoCompletionInfoTxn EMCIT  with(nolock) ON EMCIT.WorkOrderId=EMWOT.WorkOrderId
	LEFT JOIN DBO.FmLovMst ASLMSpecificationUnit  with(nolock) on ASLMSpecificationUnit.LovId=EAR.SpecificationUnit
	LEFT JOIN DBO.FmLovMst ASLMPurchaseCategory  with(nolock) on ASLMPurchaseCategory.LovId=EAR.PurchaseCategory 
	where   EAR.AssetId = @Asset_Id and EAR.Active=1 
	group by EAR.AssetId,EAR.FacilityId,tr.PorteringDate,EAR.PpmPlannerId,EAR.PurchaseCostRM,EAR.EngineCapacity,EAR.OtherPlannerId,EAR.ChassisNo,EAR.CustomerId,EAR.ServiceId,EAR.AssetClassification,EAR.AssetNo,EATC.AssetTypeCode
	, ASLMAuthorization.FieldValue,FUL.UserLocationCode,ASLMM.Manufacturer ,EAR.AssetDescription,EMWOT.MaintenanceWorkNo,EMWOT.MaintenanceWorkDateTime,ASLM.FieldValue,EAR.ModifiedDate,VM.IsMonthClosed ,EATC.AssetTypeDescription,EAR.AssetNoOld,  EAR.RegistrationNo,
	ASLMAssetClassification.FieldValue,EAR.EngineCapacity,EAR.AssetDescription,ASLMService.ServiceKey,EAR.Specification,FUL.UserLocationName,GWGDM.WorkGroupCode,GWGDM.WorkgroupDescription,EAR.CommissioningDate
	,EAR.Model,EAR.Manufacturer,EAR.Model,EAR.Manufacturer,ASLMPurchaseCategory.FieldValue ,EAR.PurchaseCostRM,EAR.PurchaseDate,EAR.WarrantyDuration,EAR.WarrantyStartDate,ASLMRealTimeStatus.FieldValue,EAR.ServiceStartDate,ASLMTransferTypeWithin.FieldValue,EAR.ExpectedLifespan,EAR.RealTimeStatusLovId
	,ASLMTransferType.FieldValue,EAR.ManufacturingDate,EAR.WarrantyEndDate,[EASM1].Manufacturer,[EASB].Model,EUA.UserAreaCode,GMH.FacilityName,VST.SnfDocumentNo
	,ASLMFuelType.FieldValue,EAR.Volt,EAR.SerialNo,EAR.DisposedBy,EAR.DisposeMethod,EAR.DisposalApprovalDate,EAR.DisposedDate,VST.MainSupplierName,EAR.RiPlannerId,ASLMSpecificationUnit.FieldValue,EAR.PowerSpecification,EAR.TestingandCommissioningDetId
	,EAR.AssetPreRegistrationNo,tr.ModifiedDate,EUA.UserAreaName


END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF                                             
END
GO
