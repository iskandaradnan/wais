USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngTestingandCommissioningTxn_Export]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[V_EngTestingandCommissioningTxn_Export]
AS
	SELECT	DISTINCT TandC.TestingandCommissioningId,
			TandC.CustomerId,
			Customer.CustomerName,
			TandC.FacilityId,
			Facility.FacilityName,
			Service.ServiceKey								AS	Service,
			LovCatagory.FieldValue								AS	AssetCategory,

			TandC.TandCDocumentNo,
			FORMAT(TandC.TandCDate,'dd-MMM-yyyy') 			AS	TandCDateTime,
			CAST(TandC.TandCDate 	AS DATE)				AS	TandCDate,
			TypeCode.AssetTypeCode,
			TypeCode.AssetTypeDescription,
			TandCDet.AssetPreRegistrationNo,
			LovTCStatus.FieldValue							AS	TandCStatus,
			LovTCStatus.FieldValue							AS	TandCStatusName,
			CAST(TandC.RequiredCompletionDate	AS DATE)	AS	RequiredCompletionDate,
			Model.Model,
			Manufacturer.Manufacturer,
			TandC.SerialNo,
			TandC.AssetNoOld,
			FORMAT(TandC.TandCCompletedDate,'dd-MMM-yyyy') 	AS	TandCCompletedDate,
			FORMAT(TandC.HandoverDate,'dd-MMM-yyyy') 		AS	HandoverDate,
			LovVStatus.FieldValue							AS	VariationStatus,
			TandC.TandCContractorRepresentative,
			UserLocation.UserLocationName					AS	LocationName,
			UserArea.UserAreaName							AS AreaName,
			Block.BlockName,
			Level.LevelName,
			CompStaff.StaffName								AS	CompanyRepresentative,
			FacilityStaff.StaffName							AS	FacilityRepresentative,
			TandC.Remarks,

			--FORMAT(TandC.PurchaseDate,'dd-MMM-yyyy') 		AS	PurchaseDate,
			--TandC.PurchaseCost,
			--TandC.ContractLPONo,
			--FORMAT(TandC.ServiceStartDate,'dd-MMM-yyyy') 	AS	ServiceStartDate,
			--FORMAT(TandC.ServiceEndDate,'dd-MMM-yyyy') 		AS	ServiceEndDate,
			--TandC.MainSupplierCode,
			--TandC.MainSupplierName,
			--TandC.WarrantyDuration,
			--FORMAT(TandC.WarrantyStartDate,'dd-MMM-yyyy') 	AS	WarrantyStartDate,
			--FORMAT(TandC.WarrantyEndDate,'dd-MMM-yyyy') 	AS	WarrantyEndDate,
			--TandC.VerifyRemarks,
			--TandC.ApprovalRemarks,
			--TandC.RejectRemarks,
			Actions.FieldValue								AS StatusName,
			--PurchaseOrderNo,
			TandC.ModifiedDateUTC,
			Asset.AssetNo,
			Request.RequestNo
	FROM	EngTestingandCommissioningTxn					AS TandC			WITH(NOLOCK)
			INNER JOIN MstCustomer							AS	Customer		WITH(NOLOCK)	ON TandC.CustomerId						=	Customer.CustomerId
			INNER JOIN MstLocationFacility					AS	Facility		WITH(NOLOCK)	ON TandC.FacilityId						=	Facility.FacilityId
			INNER JOIN MstService							AS	Service			WITH(NOLOCK)	ON TandC.ServiceId						=	Service.ServiceId
			INNER JOIN EngTestingandCommissioningTxnDet		AS	TandCDet		WITH(NOLOCK)	ON TandC.TestingandCommissioningId		=	TandCDet.TestingandCommissioningId
			LEFT JOIN EngAssetTypeCode						AS	TypeCode		WITH(NOLOCK)	ON TandC.AssetTypeCodeId				=	TypeCode.AssetTypeCodeId
			LEFT JOIN FMLovMst								AS	LovTCStatus		WITH(NOLOCK)	ON TandC.TandCStatus					=	LovTCStatus.LovId
			LEFT JOIN FMLovMst								AS	LovVStatus		WITH(NOLOCK)	ON TandC.VariationStatus				=	LovVStatus.LovId
			LEFT JOIN UMUserRegistration					AS	CompStaff		WITH(NOLOCK)	ON TandC.CustomerRepresentativeUserId	=	CompStaff.UserRegistrationId
			LEFT JOIN UMUserRegistration					AS	FacilityStaff	WITH(NOLOCK)	ON TandC.FacilityRepresentativeUserId	=	FacilityStaff.UserRegistrationId
			LEFT JOIN FMLovMst								AS	Actions			WITH(NOLOCK)	ON TandC.Status							=	Actions.LovId
			LEFT JOIN FMLovMst								AS	LovCatagory		WITH(NOLOCK)	ON TandC.AssetCategoryLovId				=	LovCatagory.LovId
			LEFT JOIN EngAssetStandardizationModel			AS	Model			WITH(NOLOCK)	ON TandC.ModelId						=	Model.ModelId
			LEFT JOIN EngAssetStandardizationManufacturer	AS	Manufacturer	WITH(NOLOCK)	ON TandC.ManufacturerId					=	Manufacturer.ManufacturerId
			LEFT JOIN MstLocationUserLocation				AS	UserLocation	WITH(NOLOCK)	ON TandC.UserLocationId					=	UserLocation.UserLocationId
			LEFT JOIN MstLocationUserArea					AS	UserArea		WITH(NOLOCK)	ON UserLocation.UserAreaId				=	UserArea.UserAreaId
			LEFT JOIN MstLocationBlock						AS	Block			WITH(NOLOCK)	ON UserLocation.BlockId				=	Block.BlockId
			LEFT JOIN MstLocationLevel						AS	Level			WITH(NOLOCK)	ON UserLocation.LevelId				=	Level.LevelId
			LEFT JOIN EngAsset								AS	Asset			WITH(NOLOCK)	ON TandCDet.TestingandCommissioningDetId	=	Asset.TestingandCommissioningDetId
			LEFT  JOIN	CRMRequest							AS Request			WITH(NOLOCK)	on TandC.CRMRequestId						= Request.CRMRequestId
GO
