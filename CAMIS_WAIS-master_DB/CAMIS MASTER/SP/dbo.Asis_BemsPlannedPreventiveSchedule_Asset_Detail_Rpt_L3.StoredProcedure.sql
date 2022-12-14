USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Asis_BemsPlannedPreventiveSchedule_Asset_Detail_Rpt_L3]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                
Application Name : ASIS                
Version       :                 
File Name      : Asis_BemsPlannedPreventiveSchedule_Asset_Detail_Rpt_L3                
Procedure Name  : Asis_BemsPlannedPreventiveSchedule_Asset_Detail_Rpt_L3  
Author(s) Name(s) : Prasanna V  
Date       :   
Purpose       : SP For Planned Preventive Schedule Report     Level 3  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
 
exec Asis_BemsPlannedPreventiveSchedule_Asset_Detail_Rpt_L3 '','234528','85','2362','taskcode','2016-01-01','2017-12-30'
Modification History      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/ 



CREATE      PROCEDURE [dbo].[Asis_BemsPlannedPreventiveSchedule_Asset_Detail_Rpt_L3]                                  
(                                             
  @Asset_Id              int,
  @Hospital_Id           VARCHAR(20),    
 @Planner_Classification VARCHAR(20),
 @Group_By                 VARCHAR(20), 
  @From_Date				VARCHAR(20),
  @To_Date					VARCHAR(20)   
 )           
AS                                              
BEGIN                                
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY

DECLARE @Hospital VARCHAR(20),@VariationHistory VARCHAR(40),
@MaintenanceHistory VARCHAR(40),@AssetTransferHistory VARCHAR(40),
@AreaDepartmentServiced VARCHAR(40),@Hosp_name  varchar(100)

SELECT @Hospital = EAR.FacilityId FROM EngAsset EAR  WHERE  --EAR.IsDeleted=0 AND 
EAR.AssetId = @Asset_Id 

select @Hosp_name = FacilityName  from MstLocationFacility  where FacilityId =@Hospital  

select EAR.AssetNo,
        [Authorization].FieldValue AS AuthorizationStatus,
         --case when EAR.Active=1 then 'Yes' else 'No' end as IsAssetTransferedIn,
        EAR.AssetNoOld,
        EATC.AssetTypeCode as TypeCode,
		EATC.AssetTypeDescription TypeDescription,
		AssetClassification.AssetClassificationCode AS AssetClassification,
		--EAR.GovernmentAssetNo,
		EAR.AssetDescription,
		AssetService.ServiceKey AS Service,
		AssetWorkGroup.WorkGroupCode AS WorkGroup,
		ISNULL(FORMAT(EAR.CommissioningDate,'dd-MMM-yyyy'),'') AS 'CommissioningDate',
		EAR.ExpectedLifespan, 
		AssetStatus.FieldValue as AssetStatus,
		--EAR.AssetAge,
		--EAR.YearInService,
		ASLMRealTimeStatus.FieldValue AS RealTimeStatus,
		LovTransferType.FieldValue AS AssetTransferMode,
		ISNULL(FORMAT(Pot.PorteringDate,'dd-MMM-yyyy'),'') AS 'TransferDate',
		LovTransferType.FieldValue AS TransferType,
		--ASLMTransferStateId.StateName AS State,
		LF.FacilityName AS Hospital,
		--EAR.IfOthersSpecify,
		--EAR.[PreviousAssetNo],
		--EAR.PreviousGovernmentAssetNo,
		ISNULL(FORMAT(Pot.PorteringDate,'dd-MMM-yyyy'),'') AS TransferDateOld,
		VST.SnfDocumentNo AS SNFNo,
		FUL.UserLocationCode,
		FUL.UserLocationName,
		FUA.UserAreaCode,
		FUA.UserAreaName,
		ULB.BlockName,
		ASM.Manufacturer,
		--[EASM1].Make,
		--[EASB].Brand,
		ASML.Model,  
		EAR.RegistrationNo,
		EAR.ChassisNo,
		EAR.EngineCapacity,
		ASLMFuelType.FieldValue AS FuelType,
		--EMCIT.CurrentMeterReading,
		EAR.Specification,
		EAR.SerialNo,
		ISNULL(FORMAT(EAR.ManufacturingDate,'dd-MMM-yyyy'),'') AS 'ManufacturingDate',
		SpecificationUnit.FieldValue AS PowerSpecificationSpecificationUnit,
		EAR.PowerSpecification AS PowerSpecificationSpecificationUnitWatt,
		CASE WHEN EAR.PpmPlannerId=1 THEN 'Yes' ELSE 'No' END AS PPM  ,
		CASE WHEN EAR.RiPlannerId=1 THEN 'Yes' ELSE 'No' END AS RoutineInspectionRIFlag ,
		CASE WHEN EAR.OtherPlannerId=1 THEN 'Yes' ELSE 'No' END AS Calibration,
		ISNULL(FORMAT(EAR.ServiceStartDate,'dd-MMM-yyyy'),'') AS 'ServiceStartDate',
		--ASLMMaintenanceCategory.FieldValue AS MaintenanceCategory,
		EMWOT.MaintenanceWorkNo AS LastServiceWorkNo,
		ISNULL(FORMAT(EMWOT.MaintenanceWorkDateTime,'dd-MMM-yyyy'),'') AS LastServiceWorkDate,
		EAR.PurchaseCostRM,
		ASLMPurchaseCategory.FieldValue AS PurchaseCategory,
		ISNULL(FORMAT(EAR.PurchaseDate,'dd-MMM-yyyy'),'') AS PurchaseDate,
		EAR.WarrantyDuration,
		ISNULL(FORMAT(EAR.WarrantyStartDate,'dd-MMM-yyyy'),'') AS WarrantyStartDate,
		ISNULL(FORMAT(EAR.WarrantyEndDate,'dd-MMM-yyyy'),'') AS WarrantyEndDate,
		--ASLMContractType.FieldValue AS ProjectType,
		--FPDT.ProjectNo,
		--FPDT.ProjectCostEstimatedCostRM,
		--FPDT.LPONo,
		--ASLMMDAClassCategory.FieldValue AS MDAClassCategory,
		--EAR.MDARegistrationNo,
		--EAR.LARRegistrationNo,
		VST.ContractLPONO,
		ISNULL(FORMAT(EAR.DisposalApprovalDate,'dd-MMM-yyyy'),'') AS DisposalApprovalDate,
		ISNULL(FORMAT(EAR.DisposedDate,'dd-MMM-yyyy'),'') AS DisposedDate,
		EAR.DisposedBy,
		EAR.DisposeMethod, 
		AssetStatus.FieldValue as [Status], 
		ISNULL(FORMAT(EAR.ModifiedDate,'dd-MMM-yyyy'),'') AS ModifiedDate,
		MAX(CAST(VST.AuthorizedStatus as INT)) Authorizedflag,
		VST.IsMonthClosed VMStatus,
		EAR.AssetId,
		EAR.AssetClassification as AssetClassificationId,
		EAR.FacilityId,
		EAR.CustomerId,
		EAR.ServiceId,
		--EAR.ObsoluteStatus  AS 'Obsolete_Status ',
		--FUL.MySPATACode,
		--FUL.MySPATADescription,
		ULB.BlockName,
		@AreaDepartmentServiced as 'AreaDepartmentServiced',
		@VariationHistory as 'VariationHistory',
		@MaintenanceHistory as 'MaintenanceHistory',
		@AssetTransferHistory as 'AssetTransferHistory',
		@Hosp_name as 'Hospital_Name'

	FROM	EngAsset												AS EAR				    WITH(NOLOCK)
			--LEFT JOIN		EngAsset								AS ParentAsset			WITH(NOLOCK)			ON EAR.AssetId							= ParentAsset.AssetParentId
			INNER JOIN		MstService								AS AssetService			WITH(NOLOCK)			ON EAR.ServiceId							= AssetService.ServiceId
			INNER JOIN		EngAssetWorkGroup						AS AssetWorkGroup		WITH(NOLOCK)			ON EAR.WorkGroupId						= AssetWorkGroup.WorkGroupId
			LEFT JOIN		EngAssetClassification					AS AssetClassification	WITH(NOLOCK)			ON EAR.AssetClassification				= AssetClassification.AssetClassificationId
			INNER JOIN		EngAssetTypeCode						AS EATC		            WITH(NOLOCK)		    ON EAR.AssetTypeCodeId					= EATC.AssetTypeCodeId
			--LEFT JOIN		FMLovMst								AS LovRiskRating	    WITH(NOLOCK)			ON AssetTypeCode.RiskRatingLovId			= LovRiskRating.LovId
			LEFT JOIN		FMLovMst								AS AssetStatus			WITH(NOLOCK)			ON EAR.AssetStatusLovId					= AssetStatus.LovId
			LEFT JOIN		MstLocationUserArea						AS UserArea				WITH(NOLOCK)			ON EAR.UserAreaId							= UserArea.UserAreaId
			LEFT JOIN		MstLocationUserLocation					AS UserLocation			WITH(NOLOCK)			ON EAR.UserLocationId						= UserLocation.UserLocationId
			LEFT JOIN		EngAssetStandardizationManufacturer		AS Manufacturer			WITH(NOLOCK)			ON EAR.Manufacturer						= Manufacturer.ManufacturerId
			LEFT JOIN		EngAssetStandardizationModel			AS Model				WITH(NOLOCK)			ON EAR.Model								= Model.ModelId
			LEFT JOIN		FMLovMst								AS AppliedPartType		WITH(NOLOCK)			ON EAR.AppliedPartTypeLovId				= AppliedPartType.LovId
			LEFT JOIN		FMLovMst								AS EquipmentClass		WITH(NOLOCK)			ON EAR.EquipmentClassLovId				= EquipmentClass.LovId
			LEFT JOIN		EngTestingandCommissioningTxnDet		AS TandCDet				WITH(NOLOCK)			ON EAR.TestingandCommissioningDetId		= TandCDet.TestingandCommissioningDetId
			LEFT JOIN		EngTestingandCommissioningTxn			AS TandC				WITH(NOLOCK)			ON TandCDet.TestingandCommissioningId		= TandC.TestingandCommissioningId
			LEFT JOIN		FMLovMst								AS DisposeMethod		WITH(NOLOCK)			ON EAR.DisposeMethod						= DisposeMethod.LovId
			LEFT JOIN		FMLovMst								AS [Authorization]		WITH(NOLOCK)			ON EAR.[Authorization]					= [Authorization].LovId
			LEFT JOIN		FMLovMst								AS SpecificationUnit	WITH(NOLOCK)			ON EAR.SpecificationUnit					= SpecificationUnit.LovId	
			LEFT JOIN		FMLovMst								AS FuelType				WITH(NOLOCK)			ON EAR.FuelType							= FuelType.LovId
			LEFT JOIN		FMLovMst								AS PowerSpecification	WITH(NOLOCK)			ON EAR.PowerSpecification					= PowerSpecification.LovId
			LEFT JOIN		FMLovMst								AS PurchaseCategory		WITH(NOLOCK)			ON EAR.PurchaseCategory					= PurchaseCategory.LovId
			LEFT JOIN		FMLovMst								AS LovAssetType			WITH(NOLOCK)			ON EAR.TypeOfAsset						= LovAssetType.LovId
			LEFT JOIN		FMLovMst								AS ASLMRealTimeStatus	WITH(NOLOCK)			ON EAR.RealTimeStatusLovId						= LovAssetType.LovId
			LEFT JOIN		PorteringTransaction					AS Pot			        WITH(NOLOCK)		    ON Pot.AssetId						= EAR.AssetId
			LEFT JOIN       FMLovMst                                AS TraansferType        WITH(NOLOCK)			ON Pot.SubCategory					= TraansferType.LovId
			LEFT JOIN       FMLovMst	                            AS LovTransferType	    WITH(NOLOCK)	        ON Pot.SubCategory=LovTransferType.LovId
			LEFT JOIN MstLocationFacility                           as Facility             WITH(NOLOCK)			ON EAR.FacilityId=Facility.FacilityId
			LEFT JOIN MstLocationUserArea							as FUA					WITH(NOLOCK)			on FUA.UserAreaId= EAR.UserAreaId
			LEFT JOIN MstLocationUserLocation as FUL WITH(NOLOCK) on FUA.UserAreaId= EAR.UserAreaId
			LEFT JOIN MstLocationBlock as ULB WITH(NOLOCK) on ULB.BlockId= FUA.BlockId
			LEFT JOIN VmVariationTxn as VST WITH(NOLOCK) on VST.AssetId = EAR.AssetId
			LEFT JOIN EngAssetStandardizationManufacturer as ASM WITH(NOLOCK) on ASM.ManufacturerId = EAR.Manufacturer
			LEFT JOIN EngAssetStandardizationModel as ASML WITH(NOLOCK) on ASML.ModelId = EAR.Model
			LEFT JOIN DBO.FmLovMst ASLMFuelType on ASLMFuelType.LovId=EAR.FuelType 
			LEFT JOIN dbo.EngMaintenanceWorkOrderTxn EMWOT ON  EMWOT.AssetId=EAR.AssetId
			LEFT JOIN dbo.EngMwoCompletionInfoTxn EMCIT ON EMCIT.WorkOrderId=EMWOT.WorkOrderId
			--LEFT JOIN DBO.FmLovMst ASLMMaintenanceCategory on ASLMMaintenanceCategory.LovId=EAR.MaintenanceCategory
			LEFT JOIN DBO.FmLovMst as ASLMPurchaseCategory on ASLMPurchaseCategory.LovId=EAR.PurchaseCategory 
				----LEFT JOIN DBO.FmLovMst ASLMContractType on ASLMContractType.LovId=EAR.ContractType 
				--LEFT JOIN DBO.FmLovMst ASLMMDAClassCategory on ASLMMDAClassCategory.LovId=EAR.MDAClassCategory 
				join MstLocationFacility as LF on LF.FacilityId = EAR.FacilityId
			OUTER APPLY (	SELECT	TOP 1 Portering.AssignPorterId,
									Portering.MovementCategory	AS TransferModeLovId,
									LovTransferMode.FieldValue	AS TransferMode,
									UserLocation.UserLocationName,
									Portering.SubCategory		AS TransferTypeLovId,
									LovTransferType.FieldValue	AS TransferType,
									Portering.PorteringDate	AS TransferDate,
									PorterFacility.FacilityId,
									PorterFacility.FacilityName,
									'NA' AS  OtherSpecify,
									EAR.AssetNo AS PreviousAssetNo
							FROM	PorteringTransaction AS Portering	WITH(NOLOCK)
									LEFT JOIN FMLovMst	AS	LovTransferMode	WITH(NOLOCK)	ON Portering.MovementCategory=LovTransferMode.LovId
									LEFT JOIN FMLovMst	AS	LovTransferType	WITH(NOLOCK)	ON Portering.SubCategory=LovTransferType.LovId
									LEFT JOIN MstLocationFacility	AS	PorterFacility	WITH(NOLOCK)	ON Portering.FromFacilityId=PorterFacility.FacilityId
									LEFT JOIN MstLocationUserLocation	AS	UserLocation	WITH(NOLOCK)	ON Portering.ToUserLocationId=UserLocation.UserLocationId
									WHERE	Portering.AssetId=EAR.AssetId
									ORDER BY EAR.ModifiedDate DESC
						) Porter
			WHERE	EAR.AssetId = @Asset_Id 
			Group by EAR.AssetId,EAR.FacilityId,Pot.PorteringDate,EAR.PpmPlannerId,--FPDT.ProjectCostEstimatedCostRM,FPDT.LPONo,
	EAR.EngineCapacity,EAR.OtherPlannerId,EAR.ChassisNo,EAR.CustomerId,EAR.ServiceId,EAR.AssetClassification,EAR.AssetNo,EATC.AssetTypeCode,
	--EAR.AssetIn, 
	[Authorization].FieldValue,FUL.UserLocationCode,ASM.Manufacturer ,ASML.Model,EAR.AssetDescription,EMWOT.MaintenanceWorkNo,EMWOT.MaintenanceWorkDateTime,
	--ASLM.FieldValue,EMCIT.CurrentMeterReading,
	EAR.ModifiedDate,VST.IsMonthClosed ,EATC.AssetTypeDescription,EAR.AssetNoOld, EAR.RegistrationNo,AssetClassification.AssetClassificationCode,--EAR.GovernmentAssetNo,
	EAR.EngineCapacity,EAR.AssetDescription,AssetService.ServiceKey,EAR.Specification,FUL.UserLocationName,AssetWorkGroup.WorkGroupCode,EAR.CommissioningDate,--EAR.TechnicalSupportId
	EAR.Model,--EAR.Brand,EAR.MadeIn,
	EAR.Manufacturer,ULB.BlockName,--EAR.AssetAge,ASLMPurchaseCategory.FieldValue ,EAR.PurchaseCostRM,EAR.PurchaseDate,
	EAR.WarrantyDuration,EAR.WarrantyStartDate,ASLMRealTimeStatus.FieldValue,--ASLM.MaintenanceCategory.FieldValue ,
	EAR.ServiceStartDate,--ASLMTransferTypeWithin.FieldValue,EAR.obsolutestatus,
	EAR.ExpectedLifespan,--ETSLTMD.EffectiveDate,
	EAR.RealTimeStatusLovId,--EAR.YearInService,
	LovTransferType.FieldValue,EAR.ManufacturingDate,
	EAR.WarrantyEndDate,--ASLMContractType.FieldValue,--FUL.MySPATACode,FUL.MySPATADescription,[EASM1].Make,[EASB].Brand,ASLMTransferStateId.StateName,
	FUA.UserAreaName,--EAR.IfOthersSpecify,
	FUA.UserAreaCode,--EAR.[PreviousAssetNo],
	LF.FacilityName,--EAR.PreviousGovernmentAssetNo,
	VST.SnfDocumentNo,ASLMFuelType.FieldValue,EAR.Volt
    ,EAR.SerialNo,--ASLMMDAClassCategory.FieldValue,EAR.Nominatedcategory,
	EAR.DisposedBy,EAR.DisposeMethod,--EAR.MDARegistrationNo,EAR.LARRegistrationNo,
	VST.ContractLPONO,
    EAR.DisposalApprovalDate,EAR.DisposedDate,VST.MainSupplierName,EAR.RiPlannerId,--FPDT.ProjectNo,
	SpecificationUnit.FieldValue,EAR.PowerSpecification,AssetStatus.FieldValue,EAR.PurchaseCostRM,ASLMPurchaseCategory.FieldValue,EAR.PurchaseDate
	ORDER BY EAR.ModifiedDate ASC

END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF                                        
END
GO
