USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_BERApplicationTxnBER2_Export]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V_BERApplicationTxnBER2_Export]

AS
	SELECT	BER.ApplicationId,
    BER.CustomerId,
	Customer.CustomerName,
	BER.FacilityId,
	Facility.FacilityCode,
	DATENAME(MONTH, BER.ApplicationDate) [Month],
	DATENAME(YEAR, BER.ApplicationDate) [Year],
	CAST(BER.ApplicationDate AS DATE)	AS BERDate,
	BER.BERno,	
	FORMAT(BER.ApplicationDate,'dd-MMM-yyyy')	AS ApplicationDate,
	'BEMS'	AS Service,
	Facility.FacilityName,
	Asset.AssetNo,
	typecode.AssetTypeDescription as AssetDescription,
	UserLocation.UserLocationCode as UserLocationCode,
	UserLocation.UserLocationName as LocationName,
	Manufacturer.Manufacturer,
	Model.Model,
	Asset.MainSupplier					AS	[SupplierName],
	Asset.PurchaseCostRM				AS	[PurchaseCost (RM)],
	FORMAT(Asset.PurchaseDate,'dd-MMM-yyyy') as PurchaseDate,
	BER.EstimatedRepairCost				AS	[EstimatedRepairCost(RM)],
	BER.ValueAfterRepair				AS	[AfterRepairValue(RM)],
	BER.CurrentValue					AS	[CurrentValue(RM)],
	BER.EstDurUsgAfterRepair			AS	[EstimatedDurationOfUsageAfterRepair(Months)],
	---	BER.FreqDamSincPurchased			AS	[Frequency ofBreakdownSincePurchased],
	--	BER.TotalCostImprovement			AS	[TotalCost onImprovement(RM)],
	RequestorUser.StaffName				AS	[RequestorName],
	RequestorDesig.Designation			AS	[Position],
	--BER.EstRepcostToExpensive			AS	[EstimatedRepairCostTooExpensive],
	CASE	WHEN BER.EstRepcostToExpensive=1 THEN 'Yes'
		WHEN BER.EstRepcostToExpensive=0 THEN 'No'
		ELSE 'No'
	END EstimatedRepairCostTooExpensive,
	CASE	WHEN BER.Obsolescence=1 THEN 'Yes'

	WHEN BER.Obsolescence=0 THEN 'No'
					ELSE 'No'
			END Obsolescence,
			CASE	WHEN BER.NotReliable=1 THEN 'Yes'
					WHEN isnull(BER.NotReliable,0)=0 THEN 'No'
					ELSE 'No'
			END NotReliable,
			CASE	WHEN BER.StatutoryRequirements=1 THEN 'Yes'
					WHEN isnull(BER.StatutoryRequirements,0)=0 THEN 'No'
					ELSE 'No'
			END StatutoryRequirements,
			--LovNotReliable.FieldValue			AS	NotReliable,
			--LovStatutoryReq.FieldValue			AS	StatutoryRequirements,
			--LovNotReliable.FieldValue			AS	NotReliable,
		--	LovStatutoryReq.FieldValue			AS	StatutoryRequirements,
			BER.OtherObservations,
			UMUser.StaffName					AS	Applicant,
			ApplicantDesig.Designation			AS	Designation,
			BER.BER1Remarks,
			UserArea.UserAreaName,
			UMUserModifiedBy.StaffName			AS	LastActionBy,
			BER.BERStatus						AS	BERStatus,
			LovBERStatus.FieldValue				AS	BERStatusValue,	
			BER.ModifiedDateUTC
	FROM	BERApplicationTxn								AS BER					WITH(NOLOCK)
			INNER JOIN MstCustomer							AS	Customer			WITH(NOLOCK)	ON	BER.CustomerId						=	Customer.CustomerId
			INNER JOIN MstLocationFacility					AS	Facility			WITH(NOLOCK)	ON	BER.FacilityId						=	Facility.FacilityId
			INNER JOIN EngAsset								AS	Asset				WITH(NOLOCK)	ON	BER.AssetId							=	Asset.AssetId
			LEFT JOIN EngAssetStandardizationManufacturer	AS	Manufacturer		WITH(NOLOCK)	ON	Asset.Manufacturer					=	Manufacturer.ManufacturerId
			LEFT JOIN EngAssetStandardizationModel			AS	Model				WITH(NOLOCK)	ON	Asset.Model							=	Model.ModelId
			LEFT JOIN MstLocationUserArea					AS	UserArea			WITH(NOLOCK)	ON	Asset.UserAreaId					=	UserArea.UserAreaId
			LEFT JOIN MstLocationUserLocation				AS	UserLocation		WITH(NOLOCK)	ON	Asset.UserLocationId				=	UserLocation.UserLocationId
			LEFT JOIN FMLovMst								AS	LovBERStatus		WITH(NOLOCK)	ON	BER.BERStatus						=	LovBERStatus.LovId
			LEFT JOIN UMUserRegistration					AS	UMUser				WITH(NOLOCK)	ON	BER.ApplicantUserId					=	UMUser.UserRegistrationId
			LEFT JOIN UserDesignation						AS	ApplicantDesig		WITH(NOLOCK)	ON	UMUser.UserDesignationId			=	ApplicantDesig.UserDesignationId
    		LEFT JOIN UMUserRegistration					AS	UMUserModifiedBy	WITH(NOLOCK)	ON	BER.ModifiedBy						=	UMUserModifiedBy.UserRegistrationId
			LEFT JOIN UMUserRegistration					AS	RequestorUser		WITH(NOLOCK)	ON	BER.RequestorUserId					=	RequestorUser.UserRegistrationId
			LEFT JOIN UserDesignation						AS	RequestorDesig		WITH(NOLOCK)	ON	RequestorUser.UserDesignationId		=	RequestorDesig.UserDesignationId
			LEFT JOIN FMLovMst								AS	LovNotReliable		WITH(NOLOCK)	ON	BER.NotReliable						=	LovNotReliable.LovId
			LEFT JOIN FMLovMst								AS	LovStatutoryReq		WITH(NOLOCK)	ON	BER.StatutoryRequirements			=	LovStatutoryReq.LovId
			inner join EngAssettypecode                      as typecode			WITH(NOLOCK)    ON	Asset.AssetTypeCodeId				=	typecode.AssetTypeCodeId    
	WHERE	BER.BERStage	=	2
GO
