USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngAsset_Export]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_EngAsset_Export]
AS


    SELECT	DISTINCT Asset.AssetId										AS AssetId,
			Asset.CustomerId											AS CustomerId,
			Asset.FacilityId											AS FacilityId,
			Asset.ServiceId												AS ServiceId,
			AssetService.ServiceKey										AS ServiceName,

			Asset.QRCode												AS QRCode,
			Asset.AssetNo												AS AssetNo,
			Asset.AssetPreRegistrationNo								AS AssetPreRegistrationNo,
			AssetTypeCode.AssetTypeCode									AS AssetTypeCode,
			AssetTypeCode.AssetTypeDescription							AS AssetTypeDescription,
			AssetClassification.AssetClassificationCode					AS AssetClassificationCode,
			AssetClassification.AssetClassificationDescription			AS AssetClassification,
			Asset.AssetDescription										AS AssetDescription,
	
							
			FORMAT(Asset.CommissioningDate,'dd-MMM-yyyy')				AS CommissioningDate,
			(SELECT AssetNo FROM EngAsset AS ParentAsset WHERE AssetId=Asset.AssetParentId) AS ParentAssetNo,				--1
			FORMAT(Asset.ServiceStartDate,'dd-MMM-yyyy')										AS ServiceStartDate,
			FORMAT(Asset.EffectiveDate,'dd-MMM-yyyy')											AS EffectiveDate,
			Asset.ExpectedLifespan										AS ExpectedLifespan,

			AssetStatus.FieldValue										AS AssetStatus,
			CAST(CAST((DATEDIFF(m, TandC.PurchaseDate, GETDATE())/12) AS VARCHAR) + '.' + 
				CASE	WHEN DATEDIFF(m, TandC.PurchaseDate, GETDATE())%12 = 0 THEN '1' 
						ELSE cast((abs(DATEDIFF(m, TandC.PurchaseDate, GETDATE())%12)) 
				AS VARCHAR) END as NUMERIC(24,2))				AS AssetAge, 
			CAST(CAST((DATEDIFF(m, TandC.TandCDate, GETDATE())/12) AS VARCHAR) + '.' + 
				CASE	WHEN DATEDIFF(m, TandC.TandCDate, GETDATE())%12 = 0 THEN '1' 
						ELSE CAST((abs(DATEDIFF(m, TandC.TandCDate, GETDATE())%12)) 
				AS VARCHAR) END as NUMERIC(24,2))				AS YearsInService,			
			LovRealTStatus.FieldValue									AS RealTimeStatus,
			Asset.OperatingHours										AS OperatingHours,


			Porter.TransferMode											AS AssetTransferMode,

			CASE WHEN Porter.TransferModeLovId=239 THEN	Porter.UserLocationName	
			ELSE NULL				END									AS TransferToUserLocationName,
			CASE WHEN Porter.TransferModeLovId=239 THEN Porter.TransferDate											
			ELSE NULL				END									AS TransferDateWithIn,


			
			CASE WHEN Porter.TransferModeLovId=240 THEN  Porter.TransferType											
			ELSE NULL														END	AS TransferType,
			CASE WHEN Porter.TransferModeLovId=240 THEN  Porter.TransferDate											
			ELSE NULL													END	AS TransferDate,

			CASE WHEN Porter.TransferModeLovId=240 THEN  Porter.FacilityName											
			ELSE NULL										END	AS FacilityName,
			CASE WHEN Porter.TransferModeLovId=240 THEN  Porter.OtherSpecify											
			ELSE NULL														END	AS IfOtherSpecify,
			CASE WHEN Porter.TransferModeLovId=240 THEN  Porter.PreviousAssetNo										
			ELSE NULL											END	AS PreviousAssetNo,

			''															AS SNFNo,

			''															AS State,



--Location Details
			UserLocation.UserLocationCode								AS UserLocationCode,
			UserLocation.UserLocationName								AS UserLocationName,
			UserArea.UserAreaCode										AS UserAreaCode,
			UserArea.UserAreaName										AS UserAreaName,

--Asset Specification
			Manufacturer.Manufacturer									AS Manufacturer,
			Asset.NamePlateManufacturer									AS NamePlateManufacturer,
			Model.Model													AS Model,
			AppliedPartType.FieldValue									AS AppliedPartType,
			EquipmentClass.FieldValue									AS EquipmentClass,
			Spec.SpecificationTypeName									AS Specification,
			Asset.SerialNo												AS SerialNumber,
			RiskRatingLovs.FieldValue								    AS RiskRating,				-- 3
			Asset.MainSupplier											AS MainSupplier,
			FORMAT(Asset.ManufacturingDate,'dd-MMM-yyyy')				AS ManufacturingDate,
			(SELECT TOP 1 Softwarekey FROM EngAssetSoftware 
			WHERE AssetId	=	Asset.AssetId 
			ORDER BY ModifiedDate DESC)									AS Softwarekey,
			(SELECT TOP 1 Softwarekey FROM EngAssetSoftware 
			WHERE AssetId	=	Asset.AssetId 
			ORDER BY ModifiedDate DESC)									AS SoftwareVersion,
			PowerSpecification.FieldValue								AS PowerSpecification,
			Asset.PowerSpecificationWatt								AS PowerSpecificationWatt,	
			Asset.PowerSpecificationAmpere								AS PowerSpecificationAmpere,
			Asset.Volt													AS Volt,

--Asset Maintenance
			CASE	WHEN Asset.PpmPlannerId = 99		THEN 'YES'
					WHEN Asset.PpmPlannerId =100	THEN 'NO'
					ELSE		'NO'
			END															AS PPM,		
			CASE	WHEN Asset.RiPlannerId = 99		THEN 'YES'
					WHEN Asset.RiPlannerId =100	THEN 'NO'
					ELSE		'NO'
			END															AS [RoutineInspection(RI)Flag],	
			CASE	WHEN Asset.OtherPlannerId = 99		THEN 'YES'
					WHEN Asset.OtherPlannerId =100	THEN 'NO'
					ELSE		'NO'
			END															AS Calibration,	
			SchdWo.MaintenanceWorkNo				AS LastScheduledWorkOrderNo,
			SchdWo.MaintenanceWorkDateTime			AS LastScheduledWorkOrderDate,
			UnSchdWo.MaintenanceWorkNo				AS [LastBrakdown/EmergencyWorkOrderNo],
			UnSchdWo.MaintenanceWorkDateTime		AS [LastBrakdown/EmergencyWorkOrderDate],

			(SELECT SUM(SC.DowntimeHoursMin) FROM EngMaintenanceWorkOrderTxn SWO INNER JOIN EngMwoCompletionInfoTxn	SC ON SWO.WorkOrderId=SC.WorkOrderId
			WHERE MaintenanceWorkCategory=187 and AssetId	=	Asset.AssetId 
			GROUP BY SWO.AssetId)										AS [ScheduledDowntime(YTD)],
			(SELECT SUM(SC.DowntimeHoursMin) FROM EngMaintenanceWorkOrderTxn WO INNER JOIN EngMwoCompletionInfoTxn	SC ON WO.WorkOrderId=SC.WorkOrderId
			WHERE MaintenanceWorkCategory=187 and AssetId	=	Asset.AssetId 
			GROUP BY WO.AssetId)										AS [UnscheduledDowntime(YTD)],
			(SELECT SUM(SC.DowntimeHoursMin) FROM EngMaintenanceWorkOrderTxn WO INNER JOIN EngMwoCompletionInfoTxn	SC ON WO.WorkOrderId=SC.WorkOrderId
			WHERE	AssetId	=	Asset.AssetId 
			GROUP BY WO.AssetId)										AS [TotalDowntime(YTD)],

			(SELECT COUNT(1)
			FROM EngDefectDetailsTxn WHERE AssetId	=Asset.AssetId )	AS DefectCount,

			Asset.PurchaseCostRM										AS PurchaseCostRM,
			PurchaseCategory.FieldValue									AS PurchaseCategory,
			FORMAT(Asset.PurchaseDate,'dd-MMM-yyyy')					AS PurchaseDate,
			Asset.WarrantyDuration										AS [WarrantyDuration(Month)],
			FORMAT(Asset.WarrantyStartDate,'dd-MMM-yyyy')				AS WarrantyStartDate,
			FORMAT(Asset.WarrantyEndDate,'dd-MMM-yyyy')					AS WarrantyEndDate,

			(SELECT	SUM(CompletionInfo.PartsCost)		AS CumilativePartsCost	FROM	EngMaintenanceWorkOrderTxn	AS	MWO 
			INNER JOIN EngMwoCompletionInfoTxn	AS	CompletionInfo	ON MWO.WorkOrderId=CompletionInfo.WorkOrderId
			WHERE	MWO.AssetId = Asset.AssetId
			GROUP BY MWO.AssetId)										AS CumulativePartCost,
			(SELECT	SUM(CompletionInfo.LabourCost)		AS CumilativeLabourCost	FROM	EngMaintenanceWorkOrderTxn	AS	MWO 
			INNER JOIN EngMwoCompletionInfoTxn	AS	CompletionInfo	ON MWO.WorkOrderId=CompletionInfo.WorkOrderId
			WHERE	MWO.AssetId = Asset.AssetId
			GROUP BY MWO.AssetId)										AS CumulativeLabourCost,
			(SELECT	SUM(CompletionInfo.ContractorCost)	AS CumilativeContractorCost	FROM	EngMaintenanceWorkOrderTxn	AS	MWO 
			INNER JOIN EngMwoCompletionInfoTxn	AS	CompletionInfo	ON MWO.WorkOrderId=CompletionInfo.WorkOrderId
			WHERE	MWO.AssetId = Asset.AssetId
			GROUP BY MWO.AssetId)										AS CumulativeContractCost,


			FORMAT(Asset.DisposalApprovalDate,'dd-MMM-yyyy')			AS DisposalApprovalDate,
			FORMAT(Asset.DisposedDate,'dd-MMM-yyyy')					AS DisposedDate,
			Asset.DisposedBy											AS DisposedBy,
			Asset.DisposeMethod											AS DisposeMethod,
			Asset.ModifiedDateUTC										AS ModifiedDateUTC,

			Asset.IsLoaner												AS IsLoaner,
			CASE	WHEN Asset.IsLoaner = 1		THEN 'YES'
					WHEN Asset.IsLoaner	= 0		THEN 'NO'
					ELSE		'NO'
			END															AS IsLoanerValue,
			Asset.TypeOfAsset											AS TypeOfAsset,
			LovAssetType.FieldValue										AS TypeOfAssetValue,
			Asset.[Authorization]										AS [AuthorizationId],
			[Authorization].FieldValue									AS [AuthorizationStatus],
			VarStatus.VariationStatus,
			CASE 
				WHEN Asset.AssetStatusLovId = 1 THEN 'Active'
				WHEN Asset.AssetStatusLovId = 2 THEN 'Inactive'
			END		AS Active,
			SuppUserReg.UserRegistrationId,
			--Asset.ContractType,
			ContractType.FieldValue	 as ContractType,
			--ContractType.FieldValue			AS ContractTypeValue,
			Asset.AssetWorkingStatus,
			AssetWorkingStatus.FieldValue as AssetWorkingStatusValue,
			Asset.CompanyStaffId,
			CompanyStaffId.StaffName
			
	FROM	EngAsset												AS Asset				WITH(NOLOCK)
			INNER JOIN		MstService								AS AssetService			WITH(NOLOCK)			ON Asset.ServiceId							= AssetService.ServiceId
			left JOIN		EngAssetWorkGroup						AS AssetWorkGroup		WITH(NOLOCK)			ON Asset.WorkGroupId						= AssetWorkGroup.WorkGroupId
			LEFT JOIN		EngAssetClassification					AS AssetClassification	WITH(NOLOCK)			ON Asset.AssetClassification				= AssetClassification.AssetClassificationId
			INNER JOIN		EngAssetTypeCode						AS AssetTypeCode		WITH(NOLOCK)			ON Asset.AssetTypeCodeId					= AssetTypeCode.AssetTypeCodeId
			LEFT JOIN		FMLovMst								AS AssetStatus			WITH(NOLOCK)			ON Asset.AssetStatusLovId					= AssetStatus.LovId
			LEFT JOIN		MstLocationUserArea						AS UserArea				WITH(NOLOCK)			ON Asset.UserAreaId							= UserArea.UserAreaId
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
			LEFT JOIN		FMLovMst								AS LovRealTStatus		WITH(NOLOCK)			ON Asset.RealTimeStatusLovId				= LovRealTStatus.LovId
			LEFT JOIN		FMLovMst								AS ContractType			WITH(NOLOCK)			ON Asset.ContractType						= ContractType.LovId
			LEFT JOIN		FMLovMst								AS AssetWorkingStatus	WITH(NOLOCK)			ON Asset.AssetWorkingStatus					= AssetWorkingStatus.LovId
			LEFT JOIN       FMLovMst								AS RiskRatingLovs		WITH(NOLOCK)			ON Asset.RiskRating							= RiskRatingLovs.LovId
			LEFT JOIN		UMUserRegistration						AS CompanyStaffId		WITH(NOLOCK)			ON Asset.CompanyStaffId						= CompanyStaffId.UserRegistrationId
			OUTER APPLY ( 	SELECT TOP 1 MaintenanceWorkNo,MaintenanceWorkDateTime 
							FROM EngMaintenanceWorkOrderTxn 
							WHERE MaintenanceWorkCategory=187 and AssetId	=	Asset.AssetId ORDER BY CreatedDate DESC
						)	AS SchdWo
			OUTER APPLY ( 	SELECT TOP 1 MaintenanceWorkNo,MaintenanceWorkDateTime 
							FROM EngMaintenanceWorkOrderTxn 
							WHERE MaintenanceWorkCategory=188 and AssetId	=	Asset.AssetId ORDER BY CreatedDate DESC
						)	AS UnSchdWo

			OUTER APPLY (SELECT DISTINCT TOP 1 ContractorId,AssetId from
						(SELECT COR.ContractorId,CORDet.AssetId,RANK() over(Partition by CORDet.AssetId order by COR.ContractorId,CORDet.AssetId ) as RowValue
						from EngContractOutRegister COR
						inner join  EngContractOutRegisterDet CORDet on COR.ContractId=CORDet.ContractId 
						WHERE CORDet.AssetId=Asset.AssetId
						group by COR.ContractorId,CORDet.AssetId)a where RowValue =1  ) Contractor

			LEFT JOIN	UMUserRegistration					AS SuppUserReg		WITH(NOLOCK)	ON Contractor.ContractorId	=	SuppUserReg.ContractorId
			OUTER APPLY (SELECT DISTINCT  TOP 1 LovVariation.FieldValue AS VariationStatus
						FROM	EngAsset		AS AssetVS WITH(NOLOCK) 
								INNER JOIN VmVariationTxn	AS	Variation		WITH(NOLOCK)	ON	AssetVS.AssetId				=	Variation.AssetId
								INNER JOIN FMLovMst			AS	LovVariation	WITH(NOLOCK)	ON	Variation.VariationStatus	=	LovVariation.LovId
						WHERE	Asset.AssetId	=	Variation.AssetId
						) VarStatus
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
									Asset.AssetNo AS PreviousAssetNo
							FROM	PorteringTransaction AS Portering	WITH(NOLOCK)
									LEFT JOIN FMLovMst	AS	LovTransferMode	WITH(NOLOCK)	ON Portering.MovementCategory=LovTransferMode.LovId
									LEFT JOIN FMLovMst	AS	LovTransferType	WITH(NOLOCK)	ON Portering.SubCategory=LovTransferType.LovId
									LEFT JOIN MstLocationFacility	AS	PorterFacility	WITH(NOLOCK)	ON Portering.FromFacilityId=PorterFacility.FacilityId
									LEFT JOIN MstLocationUserLocation	AS	UserLocation	WITH(NOLOCK)	ON Portering.ToUserLocationId=UserLocation.UserLocationId
							WHERE	Portering.AssetId=Asset.AssetId
							ORDER BY Asset.ModifiedDate DESC
						) Porter
			OUTER APPLY (	SELECT	TOP 1 AddSpec.AssetTypeCodeAddSpecId,
									AddSpec.SpecificationType,
									LovSpecType.FieldValue AS SpecificationTypeName
							FROM	EngAssetTypeCode										AS TypeCode			WITH(NOLOCK)
									INNER JOIN			EngAssetTypeCodeAddSpecification	AS AddSpec			WITH(NOLOCK)		ON TypeCode.AssetTypeCodeId		= AddSpec.AssetTypeCodeId
									LEFT JOIN			FMLovMst							AS LovSpecType		WITH(NOLOCK)		ON AddSpec.SpecificationType	= LovSpecType.LovId
									LEFT JOIN			FMLovMst							AS LovSpecUnit		WITH(NOLOCK)		ON AddSpec.SpecificationUnit	= LovSpecUnit.LovId
							WHERE	TypeCode.AssetTypeCodeId  = Asset.AssetTypeCodeId 
							ORDER BY AddSpec.ModifiedDateUTC DESC
					) AS Spec
GO
