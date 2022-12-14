USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_GetNotAssignedWorkOrder_Export]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_GetNotAssignedWorkOrder_Export]
AS

	SELECT		MWO.CustomerId,
				Customer.CustomerName,
				MWO.FacilityId,
				Facility.FacilityName,

				DATEDIFF(DD,MWO.MaintenanceWorkDateTime,GETDATE()) CountingDays,

				MWO.WorkOrderId,
				MWO.MaintenanceWorkNo,
				MWO.MaintenanceDetails,
				MWO.MaintenanceWorkDateTime,
				Asset.AssetNo,
				LovTypeOfPlanner.FieldValue AS TypeOfWorkOrder,
				WorkGroup.WorkGroupCode,
				MWO.TargetDateTime,
				LovPriority.FieldValue		AS	WorkOrderPriority,
				LovMWOStatus.FieldValue		AS	WorkOrderStatus,
				MWO.ModifiedDateUTC,
				Model.Model,
				Manufacturer.Manufacturer,
				LovMWOCategory.FieldValue	as Category,
				UserAssigne.StaffName as AssignedUser,
				UserRequestor.StaffName AS RequestorName
	FROM		EngMaintenanceWorkOrderTxn					AS	MWO					WITH(NOLOCK)
				INNER JOIN	MstCustomer						AS	Customer			WITH(NOLOCK) ON MWO.CustomerId				=	Customer.CustomerId
				INNER JOIN	MstLocationFacility				AS	Facility			WITH(NOLOCK) ON MWO.FacilityId				=	Facility.FacilityId
				INNER JOIN	EngAsset						AS	Asset				WITH(NOLOCK) ON MWO.AssetId					=	Asset.AssetId
				INNER JOIN	FMLovMst						AS	LovTypeOfPlanner	WITH(NOLOCK) ON MWO.TypeOfWorkOrder			=	LovTypeOfPlanner.LovId
				LEFT JOIN	EngAssetWorkGroup				AS	WorkGroup			WITH(NOLOCK) ON Asset.WorkGroupId			=	WorkGroup.WorkGroupId
				LEFT JOIN	FMLovMst						AS	LovPriority			WITH(NOLOCK) ON MWO.WorkOrderPriority		=	LovPriority.LovId
				LEFT JOIN	FMLovMst						AS	LovMWOStatus		WITH(NOLOCK) ON MWO.WorkOrderStatus			=	LovMWOStatus.LovId
				LEFT JOIN	EngAssetStandardizationManufacturer			AS Manufacturer		WITH(NOLOCK) ON Asset.Manufacturer	=	Manufacturer.ManufacturerId
				LEFT JOIN	EngAssetStandardizationModel				AS Model			WITH(NOLOCK) ON Asset.Model			=	Model.ModelId
				LEFT JOIN	FMLovMst						AS	LovMWOCategory		WITH(NOLOCK) ON MWO.TypeOfWorkOrder			=	LovMWOCategory.LovId
				LEFT JOIN	UMUserRegistration				AS UserAssigne			WITH(NOLOCK) ON MWO.AssignedUserId			=	UserAssigne.UserRegistrationId
				LEFT JOIN	UMUserRegistration				AS UserRequestor			WITH(NOLOCK) ON MWO.RequestorUserId		=	UserRequestor.UserRegistrationId
	WHERE		MWO.MaintenanceWorkCategory	=	188
				AND(MWO.AssigneeLovId = 330 OR MWO.AssigneeLovId is NULL)
				and  MWO.WorkOrderStatus=192
GO
