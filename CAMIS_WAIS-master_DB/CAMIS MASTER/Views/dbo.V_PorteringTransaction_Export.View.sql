USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_PorteringTransaction_Export]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_PorteringTransaction_Export]
AS
	SELECT	Porter.PorteringId,
			Porter.FromCustomerId	AS	CustomerId,
			Customer.CustomerName,
			Porter.FromFacilityId	AS	FacilityId,
			Facility.FacilityName,
			Asset.AssetNo,
			case when   MWO.MaintenanceWorkNo = '0' then null else MWO.MaintenanceWorkNo	end						AS	WorkOrderNo,
			Porter.PorteringNo,
			Porter.PorteringDate,
			Facility.FacilityName					AS	[FromFacility],
			FromBlock.BlockName						AS	[FromBlock],
			FromLevel.LevelName						AS	[FromLevel],
			FromUserArea.UserAreaName				AS	[FromUserArea],
			FromUserLocation.UserLocationName		AS	[FromUserLocation],
			LovMovementCat.FieldValue				AS	MovementCategoryValue,
			ToFacility.FacilityName					AS	[ToFacility],
			ToBlock.BlockName						AS	[ToBlock],
			ToLevel.LevelName						AS	[ToLevel],
			ToUserArea.UserAreaName					AS	[ToUserArea],
			ToUserLocation.UserLocationName			AS	[ToUserLocation],
			LovVendorCat.FieldValue					AS	[VendorCategory],
			Contractor.ContractorName				AS	[VendorName],
			UMUser.StaffName						AS	[RequestorName],
			UMDesignation.Designation				AS	[Position],
			LovRequestType.FieldValue				AS	[RequestType],
			LovModeofTransport.FieldValue			AS	[ModeofTransport],

			LovCurrentWF.FieldValue					AS	WorkFlowStatus,
			LovPorterStatus.FieldValue				AS	PorteringStatusValue,
			Porter.PorteringStatus,
			Porter.ModifiedDateUTC,
			Assignee.StaffName as Assignee
	FROM	PorteringTransaction					AS Porter				WITH(NOLOCK)
			INNER JOIN MstCustomer					AS	Customer			WITH(NOLOCK)	ON	Porter.FromCustomerId		=	Customer.CustomerId
			INNER JOIN MstLocationFacility			AS	Facility			WITH(NOLOCK)	ON	Porter.FromFacilityId		=	Facility.FacilityId
			INNER JOIN EngAsset						AS	Asset				WITH(NOLOCK)	ON	Porter.AssetId				=	Asset.AssetId
			INNER JOIN FMLovMst						AS	LovCurrentWF		WITH(NOLOCK)	ON	Porter.CurrentWorkFlowId	=	LovCurrentWF.LovId
			LEFT JOIN FMLovMst						AS	LovPorterStatus		WITH(NOLOCK)	ON	Porter.PorteringStatus		=	LovPorterStatus.LovId
			--OUTER APPLY (SELECT TOP 1 MaintenanceWorkNo,AssignedUserId FROM EngMaintenanceWorkOrderTxn AS WO WHERE Asset.AssetId				=	WO.AssetId) MWO
			left join EngMaintenanceWorkOrderTxn	AS	MWO					WITH(NOLOCK)	ON	MWO.WorkOrderId				=	Porter.WorkOrderId
			LEFT JOIN MstLocationBlock				AS	FromBlock			WITH(NOLOCK)	ON	Porter.FromBlockId			=	FromBlock.BlockId
			LEFT JOIN MstLocationLevel				AS	FromLevel			WITH(NOLOCK)	ON	Porter.FromLevelId			=	FromLevel.LevelId
			LEFT JOIN MstLocationUserArea			AS	FromUserArea		WITH(NOLOCK)	ON	Porter.FromUserAreaId		=	FromUserArea.UserAreaId
			LEFT JOIN MstLocationUserLocation		AS	FromUserLocation	WITH(NOLOCK)	ON	Porter.FromUserLocationId	=	FromUserLocation.UserLocationId
			LEFT JOIN FMLovMst						AS	LovMovementCat		WITH(NOLOCK)	ON	Porter.MovementCategory		=	LovMovementCat.LovId
			left JOIN MstLocationFacility			AS	ToFacility			WITH(NOLOCK)	ON	Porter.ToFacilityId		=	ToFacility.FacilityId
			LEFT JOIN MstLocationBlock				AS	ToBlock				WITH(NOLOCK)	ON	Porter.ToBlockId			=	ToBlock.BlockId
			LEFT JOIN MstLocationLevel				AS	ToLevel				WITH(NOLOCK)	ON	Porter.ToLevelId			=	ToLevel.LevelId
			LEFT JOIN MstLocationUserArea			AS	ToUserArea			WITH(NOLOCK)	ON	Porter.ToUserAreaId			=	ToUserArea.UserAreaId
			LEFT JOIN MstLocationUserLocation		AS	ToUserLocation		WITH(NOLOCK)	ON	Porter.ToUserLocationId		=	ToUserLocation.UserLocationId
			LEFT JOIN FMLovMst						AS	LovVendorCat		WITH(NOLOCK)	ON	Porter.SupplierLovId		=	LovVendorCat.LovId
			LEFT JOIN EngAssetSupplierWarranty		AS	AssetSupplier		WITH(NOLOCK)	ON	Porter.SupplierId			=	AssetSupplier.SupplierWarrantyId
			LEFT JOIN MstContractorandVendor		AS	Contractor			WITH(NOLOCK)	ON	AssetSupplier.ContractorId	=	Contractor.ContractorId
			LEFT JOIN UMUserRegistration			AS	UMUser				WITH(NOLOCK)	ON	Porter.RequestorId			=	UMUser.UserRegistrationId
			LEFT JOIN UserDesignation				AS	UMDesignation		WITH(NOLOCK)	ON	UMUSER.UserDesignationId	=	UMDesignation.UserDesignationId
			LEFT JOIN FMLovMst						AS	LovRequestType		WITH(NOLOCK)	ON	Porter.RequestTypeLovId		=	LovRequestType.LovId
			LEFT JOIN FMLovMst						AS	LovModeofTransport	WITH(NOLOCK)	ON	Porter.ModeOfTransport		=	LovModeofTransport.LovId
			LEFT  JOIN UMUserRegistration			AS	Assignee			WITH(NOLOCK)	ON Porter.AssignPorterId		=	Assignee.UserRegistrationId
GO
