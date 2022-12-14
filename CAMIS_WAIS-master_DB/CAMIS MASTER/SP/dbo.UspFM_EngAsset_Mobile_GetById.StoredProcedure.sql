USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngAsset_Mobile_GetById]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngAsset_GetById
Description			: To Get the data from table EngAsset using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngAsset_Mobile_GetById]  @pFacilityId=1
SELECT * FROM EngAsset
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE  PROCEDURE  [dbo].[UspFM_EngAsset_Mobile_GetById]                           

  @pFacilityId				INT 
AS                                              

BEGIN TRY


	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF(ISNULL(@pFacilityId,0) = 0) RETURN

	DECLARE @TotSchdDownTime NUMERIC(24,2)
	DECLARE @TotUnSchdDownTime NUMERIC(24,2)
	DECLARE @DefectList INT




    SELECT	Asset.AssetId												AS AssetId,
			Asset.CustomerId											AS CustomerId,
			Customer.CustomerCode										AS CustomerCode,
			Customer.CustomerName										AS CustomerName,
			Asset.FacilityId											AS FacilityId,
			LocationFacility.FacilityCode								AS FacilityCode,
			LocationFacility.FacilityName								AS FacilityName,
			LocationLevel.LevelId										AS LevelId,
			LocationLevel.LevelCode										AS LevelCode,
			LocationLevel.LevelName										AS LevelName,
			LocationBlock.BlockId										AS BlockId,
			LocationBlock.BlockCode										AS BlockCode,
			LocationBlock.BlockName										AS BlockName,
			Asset.ServiceId												AS ServiceId,
			AssetService.ServiceKey										AS ServiceName,
			Asset.AssetNo												AS AssetNo,
			Asset.AssetPreRegistrationNo								AS AssetPreRegistrationNo,
			Asset.TestingandCommissioningDetId							AS TestingandCommissioningDetId,
			Asset.AssetTypeCodeId										AS AssetTypeCodeId,
			AssetTypeCode.AssetTypeCode									AS AssetTypeCode,
			AssetTypeCode.AssetTypeDescription							AS AssetTypeDescription,
			Asset.AssetClassification									AS AssetClassification,
			AssetClassification.AssetClassificationCode					AS AssetClassificationCode,
			AssetClassification.AssetClassificationDescription			AS AssetClassificationDescription,
			Asset.AssetDescription										AS AssetDescription,
			Asset.WorkGroupId											AS WorkGroupId,
			AssetWorkGroup.WorkGroupCode								AS WorkGroupCode,
			AssetWorkGroup.WorkGroupDescription							AS WorkGroupDescription,							
			Asset.CommissioningDate										AS CommissioningDate,
			Asset.AssetParentId											AS AssetParentId,
			Asset.ServiceStartDate										AS ServiceStartDate,
			Asset.ServiceStartDateUTC									AS ServiceStartDateUTC,
			Asset.EffectiveDate											AS EffectiveDate,
			Asset.EffectiveDateUTC										AS EffectiveDateUTC,
			Asset.ExpectedLifespan										AS ExpectedLifespan,

			Asset.AssetStatusLovId										AS AssetStatusLovId,
			AssetStatus.FieldValue										AS AssetStatusValue,

			Asset.UserAreaId											AS UserAreaId,						--4
			UserArea.UserAreaCode										AS UserAreaCode,
			UserArea.UserAreaName										AS UserAreaName,

			Asset.UserLocationId										AS UserLocationId,
			UserLocation.UserLocationCode								AS UserLocationCode,
			UserLocation.UserLocationName								AS UserLocationName,
			Asset.Manufacturer											AS Manufacturer,
			Manufacturer.Manufacturer									AS ManufacturerName,
			Asset.Model													AS Model,
			Model.Model													AS ModelName,
			Asset.AppliedPartTypeLovId									AS AppliedPartTypeLovId,
			AppliedPartType.FieldValue									AS AppliedPartType,
			Asset.EquipmentClassLovId									AS EquipmentClassLovId,
			EquipmentClass.FieldValue									AS EquipmentClass,
			Asset.Specification											AS Specification,
			Asset.SerialNo												AS SerialNo,

			--LovRiskRating.FieldValue									AS RiskRating,
			Asset.RiskRating											AS RiskRating,				-- 3

			Asset.MainSupplier											AS MainSupplier,
			Asset.ManufacturingDate										AS ManufacturingDate,
			Asset.ManufacturingDateUTC									AS ManufacturingDateUTC,
			Asset.PowerSpecification									AS PowerSpecification,
			PowerSpecification.FieldValue								AS PowerSpecificationName,
			Asset.PowerSpecificationWatt								AS PowerSpecificationWatt,	
			Asset.PowerSpecificationAmpere								AS PowerSpecificationAmpere,
			Asset.Volt													AS Volt,
			Asset.PpmPlannerId											AS PpmPlannerId,
			CASE	WHEN Asset.PpmPlannerId = 99		THEN 'YES'
					WHEN Asset.PpmPlannerId =100	THEN 'NO'
					ELSE		'NO'
			END															AS PpmPlanner,		
			Asset.RiPlannerId											AS RiPlannerId,
			CASE	WHEN Asset.RiPlannerId = 99		THEN 'YES'
					WHEN Asset.RiPlannerId =100	THEN 'NO'
					ELSE		'NO'
			END															AS RiPlanner,	
			Asset.OtherPlannerId										AS OtherPlannerId,
			CASE	WHEN Asset.OtherPlannerId = 99		THEN 'YES'
					WHEN Asset.OtherPlannerId =100	THEN 'NO'
					ELSE		'NO'
			END															AS OtherPlanner,	

			Asset.PurchaseCostRM										AS PurchaseCostRM,
			Asset.PurchaseDate											AS PurchaseDate,
			Asset.PurchaseDateUTC										AS PurchaseDateUTC,
			Asset.WarrantyDuration										AS WarrantyDuration,
			Asset.WarrantyStartDate										AS WarrantyStartDate,
			Asset.WarrantyStartDateUTC									AS WarrantyStartDateUTC,
			Asset.WarrantyEndDate										AS WarrantyEndDate,
			Asset.WarrantyEndDateUTC									AS WarrantyEndDateUTC,

			--Asset.CumulativePartCost									AS CumulativePartCost,
			--Asset.CumulativeLabourCost									AS CumulativeLabourCost,
			--Asset.CumulativeContractCost								AS CumulativeContractCost,

			Asset.DisposalApprovalDate									AS DisposalApprovalDate,
			Asset.DisposalApprovalDateUTC								AS DisposalApprovalDateUTC,
			Asset.DisposedDate											AS DisposedDate,
			Asset.DisposedDateUTC										AS DisposedDateUTC,
			Asset.DisposedBy											AS DisposedBy,
			Asset.DisposeMethod											AS DisposeMethod,
			Asset.PurchaseCategory										AS PurchaseCategory,
			PurchaseCategory.FieldValue									AS PurchaseCategoryName,
			Asset.[Timestamp]											AS [Timestamp],
			Asset.NamePlateManufacturer									AS NamePlateManufacturer,
			Asset.QRCode												AS QRCode,
			Asset.IsLoaner												AS IsLoaner,
			CASE	WHEN Asset.IsLoaner = 1		THEN 'YES'
					WHEN Asset.IsLoaner	= 0		THEN 'NO'
					ELSE		'NO'
			END															AS IsLoanerValue,
			Asset.TypeOfAsset											AS TypeOfAsset,
			LovAssetType.FieldValue										AS TypeOfAssetValue,
			Asset.[Authorization]										AS [Authorization],
			[Authorization].FieldValue									AS AuthorizationName,
			Asset.AssetWorkingStatus,
			AssetWorkingStatus.FieldValue as AssetWorkingStatusValue,
			Asset.CompanyStaffId,
			CompanyStaffId.StaffName
			

	FROM	EngAsset												AS Asset				WITH(NOLOCK)
			--LEFT JOIN		EngAsset								AS ParentAsset			WITH(NOLOCK)			ON Asset.AssetId							= ParentAsset.AssetParentId
			INNER JOIN		MstService								AS AssetService			WITH(NOLOCK)			ON Asset.ServiceId							= AssetService.ServiceId
			INNER JOIN		MstLocationFacility						AS LocationFacility		WITH(NOLOCK)			ON Asset.FacilityId							= LocationFacility.FacilityId
			INNER JOIN		MstCustomer								AS Customer				WITH(NOLOCK)			ON Asset.CustomerId							= Customer.CustomerId
			INNER JOIN		EngAssetWorkGroup						AS AssetWorkGroup		WITH(NOLOCK)			ON Asset.WorkGroupId						= AssetWorkGroup.WorkGroupId
			LEFT JOIN		EngAssetClassification					AS AssetClassification	WITH(NOLOCK)			ON Asset.AssetClassification				= AssetClassification.AssetClassificationId
			INNER JOIN		EngAssetTypeCode						AS AssetTypeCode		WITH(NOLOCK)			ON Asset.AssetTypeCodeId					= AssetTypeCode.AssetTypeCodeId
			--LEFT JOIN		FMLovMst								AS LovRiskRating	    WITH(NOLOCK)			ON AssetTypeCode.RiskRatingLovId			= LovRiskRating.LovId
			LEFT JOIN		FMLovMst								AS AssetStatus			WITH(NOLOCK)			ON Asset.AssetStatusLovId					= AssetStatus.LovId
			LEFT JOIN		MstLocationUserArea						AS UserArea				WITH(NOLOCK)			ON Asset.UserAreaId							= UserArea.UserAreaId
			LEFT JOIN		MstLocationLevel						AS LocationLevel		WITH(NOLOCK)			ON UserArea.LevelId							= LocationLevel.LevelId
			LEFT JOIN		MstLocationBlock						AS LocationBlock		WITH(NOLOCK)			ON UserArea.BlockId							= LocationBlock.BlockId
			LEFT JOIN		MstLocationUserLocation					AS UserLocation			WITH(NOLOCK)			ON Asset.UserLocationId						= UserLocation.UserLocationId
			LEFT JOIN		EngAssetStandardizationManufacturer		AS Manufacturer			WITH(NOLOCK)			ON Asset.Manufacturer						= Manufacturer.ManufacturerId
			LEFT JOIN		EngAssetStandardizationModel			AS Model				WITH(NOLOCK)			ON Asset.Model								= Model.ModelId
			LEFT JOIN		FMLovMst								AS AppliedPartType		WITH(NOLOCK)			ON Asset.AppliedPartTypeLovId				= AppliedPartType.LovId
			LEFT JOIN		FMLovMst								AS EquipmentClass		WITH(NOLOCK)			ON Asset.EquipmentClassLovId				= EquipmentClass.LovId
			LEFT JOIN		EngTestingandCommissioningTxnDet		AS TandCDet				WITH(NOLOCK)			ON Asset.TestingandCommissioningDetId		= TandCDet.TestingandCommissioningDetId
			LEFT JOIN		EngTestingandCommissioningTxn			AS TandC				WITH(NOLOCK)			ON TandCDet.TestingandCommissioningId		= TandC.TestingandCommissioningId
			LEFT JOIN		FMLovMst								AS DisposeMethod		WITH(NOLOCK)			ON Asset.DisposeMethod						= DisposeMethod.LovId
			LEFT JOIN		FMLovMst								AS [Authorization]		WITH(NOLOCK)			ON Asset.[Authorization]					= [Authorization].LovId
			LEFT JOIN		FMLovMst								AS SpecificationUnit	WITH(NOLOCK)			ON Asset.SpecificationUnit					= SpecificationUnit.LovId
			
			LEFT JOIN		FMLovMst								AS FuelType				WITH(NOLOCK)			ON Asset.FuelType							= FuelType.LovId
			LEFT JOIN		FMLovMst								AS PowerSpecification	WITH(NOLOCK)			ON Asset.PowerSpecification					= PowerSpecification.LovId
			LEFT JOIN		FMLovMst								AS PurchaseCategory		WITH(NOLOCK)			ON Asset.PurchaseCategory					= PurchaseCategory.LovId
			LEFT JOIN		FMLovMst								AS LovAssetType			WITH(NOLOCK)			ON Asset.TypeOfAsset						= LovAssetType.LovId
			LEFT JOIN		FMLovMst								AS AssetWorkingStatus	WITH(NOLOCK)			ON Asset.AssetWorkingStatus					= AssetWorkingStatus.LovId
			LEFT JOIN		UMUserRegistration						AS CompanyStaffId		WITH(NOLOCK)			ON Asset.CompanyStaffId						= CompanyStaffId.UserRegistrationId
			WHERE	Asset.FacilityId = @pFacilityId 
			ORDER BY Asset.ModifiedDate ASC
			


END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
