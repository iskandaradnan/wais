USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngMwoReschedulingTxn_Export]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[V_EngMwoReschedulingTxn_Export]
AS
	SELECT		DISTINCT EngMWO.FacilityId,
				UserArea.UserAreaId as UserAreaId,
				UserArea.UserAreaCode AS UserAreaCode,
				UserArea.UserAreaName as UserAreaName,
				UserLocation.UserLocationId as UserLocationId,
				UserLocation.UserLocationCode as UserLocationCode,
				UserLocation.UserLocationName as UserLocationName,
				Assignee.UserRegistrationId as UserRegistrationId,
				Assignee.StaffName as AssigneeName,
				LovTypeOfPlanner.FieldValue as TypeOfPlanner,
				LovTypeOfPlanner.FieldValue as TypeOfWorkOrderName,
				EngMWO.RescheduleRemarks as Remarks,
				EngMWO.RescheduleRemarks as MaintenanceDetails,
				EngAsset.AssetNo,
				Engasset.AssetDescription,
				EngMWO.MaintenanceWorkNo AS WorkOrderNo,
				--FORMAT(EngMWO.PreviousTargetDateTime,'dd-MMM-yyyy')	AS	ScheduleDate,
				FORMAT(EngMWO.TargetDateTime,'dd-MMM-yyyy')	AS	ScheduleDate,
				FORMAT(EngMWO.TargetDateTime, 'dd-MMM-yyyy')	AS	RescheduleDate,
				EngMWO.ModifiedDateUTC
	FROM		EngMaintenanceWorkOrderTxn				AS	EngMWO				
				INNER JOIN EngAsset						AS	EngAsset			WITH(NOLOCK) ON EngMWO.AssetId				=	EngAsset.AssetId
				LEFT  JOIN MstLocationUserArea			AS	UserArea			WITH(NOLOCK) ON EngAsset.UserAreaId			=	UserArea.UserAreaId
				LEFT  JOIN MstLocationUserLocation		AS	UserLocation		WITH(NOLOCK) ON EngAsset.UserLocationId		=	UserLocation.UserLocationId
				LEFT  JOIN UMUserRegistration			AS	Assignee			WITH(NOLOCK) ON EngMWO.AssignedUserId		=	Assignee.UserRegistrationId
				INNER JOIN FMLovMst						AS	LovTypeOfPlanner	WITH(NOLOCK) ON EngMWO.TypeOfWorkOrder		=	LovTypeOfPlanner.LovId
	WHERE		EngAsset.Active =1
				AND EngMWO.WorkOrderStatus	=	192
				AND EngMWO.MaintenanceWorkCategory = 187
				AND EngMWO.AssignedUserId IS NOT NULL
				AND EngMWO.AssignedUserId != 0
				AND EngMWO.PreviousTargetDateTime IS NOT NULL
GO
