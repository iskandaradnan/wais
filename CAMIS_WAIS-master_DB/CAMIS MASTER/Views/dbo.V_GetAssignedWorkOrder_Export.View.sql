USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_GetAssignedWorkOrder_Export]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[V_GetAssignedWorkOrder_Export]
AS

	SELECT		MWO.CustomerId,
				Customer.CustomerName,
				MWO.FacilityId,
				Facility.FacilityName,

				DATEDIFF(DD,MWO.MaintenanceWorkDateTime,GETDATE()) CountingDays,

				MWO.WorkOrderId,
				MWO.MaintenanceWorkNo,
				FORMAT(MWO.MaintenanceWorkDateTime,'dd-MMM-yyyy HH:MM') as MaintenanceWorkDateTime,
				Asset.AssetNo,
				LovTypeOfPlanner.FieldValue AS TypeOfWorkOrder,
				WorkGroup.WorkGroupCode,
				MWO.TargetDateTime,
				LovPriority.FieldValue		AS	WorkOrderPriority,
				LovMWOStatus.FieldValue		AS	WorkOrderStatus,
				MWO.MaintenanceDetails,
				MWO.ModifiedDateUTC,
				SupWarranty.ContractorId,
				SuppUserReg.UserRegistrationId,
				LovAssignType.FieldValue	AS AssigneeType,
				UserReg.StaffName			AS AssignedName
	FROM		EngMaintenanceWorkOrderTxn				AS	MWO					WITH(NOLOCK)
				INNER JOIN MstCustomer					AS	Customer			WITH(NOLOCK) ON MWO.CustomerId				=	Customer.CustomerId
				INNER JOIN MstLocationFacility			AS	Facility			WITH(NOLOCK) ON MWO.FacilityId				=	Facility.FacilityId
				INNER JOIN EngAsset						AS	Asset				WITH(NOLOCK) ON MWO.AssetId					=	Asset.AssetId
				INNER JOIN FMLovMst						AS	LovTypeOfPlanner	WITH(NOLOCK) ON MWO.TypeOfWorkOrder			=	LovTypeOfPlanner.LovId
				LEFT JOIN EngAssetWorkGroup			AS	WorkGroup			WITH(NOLOCK) ON Asset.WorkGroupId			=	WorkGroup.WorkGroupId
				LEFT JOIN FMLovMst						AS	LovPriority			WITH(NOLOCK) ON MWO.WorkOrderPriority		=	LovPriority.LovId
				LEFT JOIN FMLovMst						AS	LovMWOStatus		WITH(NOLOCK) ON MWO.WorkOrderStatus			=	LovMWOStatus.LovId
				LEFT JOIN	EngAssetSupplierWarranty	AS SupWarranty			WITH(NOLOCK) ON Asset.AssetId				=	SupWarranty.AssetId AND SupWarranty.Category=13
				LEFT JOIN	UMUserRegistration			AS SuppUserReg			WITH(NOLOCK) ON SupWarranty.ContractorId	=	SuppUserReg.ContractorId
				LEFT JOIN FMLovMst						AS	LovAssignType		WITH(NOLOCK) ON MWO.AssigneeLovId			=	LovAssignType.LovId
				LEFT JOIN UMUserRegistration			AS	UserReg				WITH(NOLOCK) ON MWO.AssignedUserId			=	UserReg.UserRegistrationId
	WHERE		MWO.MaintenanceWorkCategory	=	188
				AND MWO.AssigneeLovId <> 330
GO
