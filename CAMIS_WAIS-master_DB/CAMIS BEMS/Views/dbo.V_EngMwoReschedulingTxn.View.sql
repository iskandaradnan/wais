USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngMwoReschedulingTxn]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[V_EngMwoReschedulingTxn]
AS
	SELECT		EngMWO.CustomerId,
				Customer.CustomerName,
				EngMWO.FacilityId,
				Facility.FacilityName,
				EngMWO.WorkOrderId,
				EngMWO.MaintenanceWorkNo AS WorkOrderNo,
				EngMWO.AssetId,
				EngAsset.AssetNo,
				EngAsset.AssetDescription,
				EngMWO.TypeOfWorkOrder,
				LovTypeOfPlanner.FieldValue				AS TypeOfWorkOrderName,
				EngMWO.RescheduleRemarks AS MaintenanceDetails,
				UserLocation.UserLocationId as UserLocationId,
				UserLocation.UserLocationCode as UserLocationCode,
				UserLocation.UserLocationName as UserLocationName,
				Assignee.UserRegistrationId as UserRegistrationId,
				Assignee.StaffName as AssigneeName,
				MAX(EngMWO.ModifiedDateUTC)				AS ModifiedDateUTC
	FROM		EngMaintenanceWorkOrderTxn				AS	EngMWO	WITH(NOLOCK)
				INNER JOIN MstCustomer					AS	Customer			WITH(NOLOCK) ON EngMWO.CustomerId	=	Customer.CustomerId
				INNER JOIN MstLocationFacility			AS	Facility			WITH(NOLOCK) ON EngMWO.FacilityId	=	Facility.FacilityId
				INNER JOIN EngAsset						AS	EngAsset			WITH(NOLOCK) ON EngMWO.AssetId				= EngAsset.AssetId
				LEFT  JOIN MstLocationUserLocation		AS	UserLocation		WITH(NOLOCK) ON EngAsset.UserLocationId		=	UserLocation.UserLocationId
				INNER JOIN FMLovMst						AS	LovTypeOfPlanner	WITH(NOLOCK) ON EngMWO.TypeOfWorkOrder		= LovTypeOfPlanner.LovId
				LEFT  JOIN UMUserRegistration			AS	Assignee			WITH(NOLOCK) ON EngMWO.AssignedUserId		=	Assignee.UserRegistrationId
	WHERE		EngAsset.Active =1
				AND EngMWO.WorkOrderStatus	=	192
				AND EngMWO.MaintenanceWorkCategory = 187
				AND EngMWO.AssignedUserId IS NOT NULL
				AND EngMWO.AssignedUserId != 0
				AND EngMWO.PreviousTargetDateTime IS NOT NULL
	GROUP BY	EngMWO.CustomerId,
				Customer.CustomerName,
				EngMWO.FacilityId,
				Facility.FacilityName,
				EngMWO.WorkOrderId,
				EngMWO.MaintenanceWorkNo,
				EngMWO.AssetId,
				EngAsset.AssetNo,
				EngMWO.TypeOfWorkOrder,
				LovTypeOfPlanner.FieldValue,
				EngMWO.RescheduleRemarks,
				UserLocation.UserLocationId ,
				UserLocation.UserLocationCode,
				UserLocation.UserLocationName,
				Assignee.UserRegistrationId, 
				Assignee.StaffName,
				EngAsset.AssetDescription
GO
