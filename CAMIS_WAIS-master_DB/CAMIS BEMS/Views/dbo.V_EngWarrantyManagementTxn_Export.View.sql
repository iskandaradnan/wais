USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngWarrantyManagementTxn_Export]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_EngWarrantyManagementTxn_Export]
AS
	SELECT	DISTINCT WarrantyMgmt.CustomerId,
			Customer.CustomerName,
			WarrantyMgmt.FacilityId,
			Facility.FacilityName,
			WarrantyMgmt.WarrantyNo,
			FORMAT(WarrantyMgmt.WarrantyDate,'dd-MMM-yyyy')		AS	WarrantyDate,
			TandC.TandCDocumentNo								AS	[T&CReferenceNo.],
			'BEMS'												AS	[Service],
			Asset.AssetNo,
			Classification.AssetClassificationCode				AS	[AssetClassification],
			TypeCode.AssetTypeCode,
			Asset.AssetDescription,

			FORMAT(Asset.WarrantyStartDate,'dd-MMM-yyyy')		AS WarrantyStartDate,
			FORMAT(Asset.WarrantyEndDate,'dd-MMM-yyyy')			AS WarrantyEndDate,
			Asset.WarrantyDuration								AS [WarrantyPeriod (Month)],
			Asset.PurchaseCostRM								AS [PurchaseCost (RM)],
			ISNULL(Variation.MonthlyProposedFeeDW,0)			AS [MonthlyDWFee (RM)],
			ISNULL(Variation.MonthlyProposedFeePW,0)			AS [MonthlyPWFee (RM)],
			ISNULL(MwoCompletionInfo.DowntimeHoursMin,0)		AS TotalWarrantyDownTime,
			WarrantyMgmt.Remarks,
			UserArea.UserAreaName,
			WarrantyMgmt.ModifiedDateUTC
	FROM	EngWarrantyManagementTxn					AS	WarrantyMgmt		WITH(NOLOCK)
			INNER JOIN MstCustomer						AS	Customer			WITH(NOLOCK)	ON	WarrantyMgmt.CustomerId					=	Customer.CustomerId
			INNER JOIN MstLocationFacility				AS	Facility			WITH(NOLOCK)	ON	WarrantyMgmt.FacilityId					=	Facility.FacilityId
			INNER JOIN EngAsset							AS	Asset				WITH(NOLOCK)	ON	Asset.AssetId							=	WarrantyMgmt.AssetId	
			INNER JOIN EngAssetTypeCode					AS	TypeCode			WITH(NOLOCK)	ON	Asset.AssetTypeCodeId					=	TypeCode.AssetTypeCodeId	
			INNER JOIN EngAssetClassification			AS	Classification		WITH(NOLOCK)	ON	Asset.AssetClassification				=	Classification.AssetClassificationId	
			LEFT JOIN MstLocationUserArea				AS	UserArea			WITH(NOLOCK)	ON	Asset.UserAreaId						=	UserArea.UserAreaId
			LEFT JOIN EngTestingandCommissioningTxnDet	AS	TandCDet			WITH(NOLOCK)	ON	Asset.TestingandCommissioningDetId		=	TandCDet.TestingandCommissioningDetId
			LEFT JOIN EngTestingandCommissioningTxn		AS	TandC				WITH(NOLOCK)	ON	TandCDet.TestingandCommissioningId		=	TandC.TestingandCommissioningId
			LEFT  JOIN	VmVariationTxn					AS Variation			WITH(NOLOCK)	ON	WarrantyMgmt.AssetId					=	Variation.AssetId
			LEFT  JOIN	EngMaintenanceWorkOrderTxn		AS MaintenanceWorkOrder	WITH(NOLOCK)	ON	MaintenanceWorkOrder.AssetId			=	Asset.AssetId
			LEFT  JOIN	EngMwoCompletionInfoTxn			AS MwoCompletionInfo	WITH(NOLOCK)	ON	MaintenanceWorkOrder.WorkOrderId		=	MwoCompletionInfo.WorkOrderId
GO
