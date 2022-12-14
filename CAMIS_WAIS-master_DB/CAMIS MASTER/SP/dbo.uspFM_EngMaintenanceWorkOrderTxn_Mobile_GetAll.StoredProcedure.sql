USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMaintenanceWorkOrderTxn_Mobile_GetAll]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngMaintenanceWorkOrderTxn_Sync_GetAll
Description			: To Maintenance WorkOrder details 
Authors				: Dhilip V
Date				: 07-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngMaintenanceWorkOrderTxn_Sync_GetAll] @pFacilityId=2

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngMaintenanceWorkOrderTxn_Mobile_GetAll]   
                        

  @pEngineerUserId		INT


AS                                              

BEGIN TRY


	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


     SELECT MaintenanceWorkOrder.WorkOrderId					AS WorkOrderId,
			MaintenanceWorkOrder.CustomerId						AS CustomerId,
			MaintenanceWorkOrder.FacilityId						AS FacilityId,
			MaintenanceWorkOrder.ServiceId						AS ServiceId,
			ServiceKey.ServiceKey								AS ServiceValue,
			MaintenanceWorkOrder.AssetId						AS AssetId,
			Asset.AssetNo										AS AssetNo,
			Asset.AssetDescription								AS AssetDescription,
			MaintenanceWorkOrder.MaintenanceWorkNo				AS MaintenanceWorkNo,
			MaintenanceWorkOrder.MaintenanceDetails				AS MaintenanceDetails,
			MaintenanceWorkOrder.MaintenanceWorkCategory		AS MaintenanceWorkCategory,
			WorkCategory.FieldValue								AS WorkCategoryValue,
			MaintenanceWorkOrder.MaintenanceWorkType			AS MaintenanceWorkType,
			WorkType.FieldValue									AS MaintenanceWorkTypeValue,
			MaintenanceWorkOrder.TypeOfWorkOrder				AS TypeOfWorkOrder,
			TypeOfWorkOrder.FieldValue							AS TypeOfWorkOrderValue,
			MaintenanceWorkOrder.QRCode							AS QRCode,
			MaintenanceWorkOrder.MaintenanceWorkDateTime		AS MaintenanceWorkDateTime,
			MaintenanceWorkOrder.TargetDateTime					AS TargetDateTime,
			MaintenanceWorkOrder.EngineerUserId					AS EngineerStaffId,
			EngineerStaffId.StaffName							AS EngineerStaffIdValue,
			MaintenanceWorkOrder.RequestorUserId				AS RequestorStaffId,
			RequestorStaffId.StaffName							AS RequestorStaffIdValue,
			MaintenanceWorkOrder.WorkOrderPriority				AS WorkOrderPriority,
			WorkOrderPriority.FieldValue						AS WorkOrderPriorityValue,
			MaintenanceWorkOrder.Image1FMDocumentId				AS Image1FMDocumentId,
			MaintenanceWorkOrder.Image2FMDocumentId				AS Image2FMDocumentId,
			MaintenanceWorkOrder.Image3FMDocumentId				AS Image3FMDocumentId,
			MaintenanceWorkOrder.PlannerId						AS PlannerId,
			MaintenanceWorkOrder.WorkGroupId					AS WorkGroupId,
			WorkGroupId.WorkGroupCode							AS WorkGroupCode,
			WorkGroupId.WorkGroupDescription					AS WorkGroupDescription,
			MaintenanceWorkOrder.WorkOrderStatus				AS WorkOrderStatus,
			WorkOrderStatus.FieldValue							AS WorkOrderStatusValue,
			MaintenanceWorkOrder.PlannerHistoryId				AS PlannerHistoryId,
			MaintenanceWorkOrder.Remarks						AS Remarks,
			MaintenanceWorkOrder.BreakDownRequestId				AS BreakDownRequestId,
			MaintenanceWorkOrder.WOAssignmentId					AS WOAssignmentId,
			MaintenanceWorkOrder.UserAreaId						AS UserAreaId,
			UserAreaId.UserAreaCode								AS UserAreaCode,
			UserAreaId.UserAreaName								AS UserAreaName,
			MaintenanceWorkOrder.UserLocationId					AS UserLocationId,
			UserLocationId.UserLocationCode						AS UserLocationCode,
			UserLocationId.UserLocationName						AS UserLocationName,
			MaintenanceWorkOrder.StandardTaskDetId				AS StandardTaskDetId,
			StandardTaskDetId.TaskCode							AS TaskCode,
			StandardTaskDetId.TaskDescription					AS TaskDescription,
			MaintenanceWorkOrder.Timestamp						AS Timestamp
	FROM	EngMaintenanceWorkOrderTxn							AS MaintenanceWorkOrder				WITH(NOLOCK)
			INNER JOIN  MstService								AS ServiceKey						WITH(NOLOCK)			on MaintenanceWorkOrder.ServiceId				= ServiceKey.ServiceId
			INNER JOIN  EngAsset								AS Asset							WITH(NOLOCK)			on MaintenanceWorkOrder.AssetId					= Asset.AssetId
			LEFT  JOIN  UMUserRegistration						AS EngineerStaffId					WITH(NOLOCK)			on MaintenanceWorkOrder.EngineerUserId			= EngineerStaffId.UserRegistrationId
			LEFT  JOIN  UMUserRegistration						AS RequestorStaffId					WITH(NOLOCK)			on MaintenanceWorkOrder.RequestorUserId			= RequestorStaffId.UserRegistrationId
			LEFT  JOIN  EngAssetWorkGroup						AS WorkGroupId						WITH(NOLOCK)			on MaintenanceWorkOrder.WorkGroupId				= WorkGroupId.WorkGroupId
			LEFT  JOIN  MstLocationUserArea						AS UserAreaId						WITH(NOLOCK)			on MaintenanceWorkOrder.UserAreaId				= UserAreaId.UserAreaId
			LEFT  JOIN  MstLocationUserLocation					AS UserLocationId					WITH(NOLOCK)			on MaintenanceWorkOrder.UserLocationId			= UserLocationId.UserLocationId
			LEFT  JOIN  EngAssetTypeCodeStandardTasksDet		AS StandardTaskDetId				WITH(NOLOCK)			on MaintenanceWorkOrder.StandardTaskDetId		= StandardTaskDetId.StandardTaskDetId
			LEFT  JOIN  FMLovMst								AS WorkCategory						WITH(NOLOCK)			on MaintenanceWorkOrder.MaintenanceWorkCategory	= WorkCategory.LovId
			LEFT  JOIN  FMLovMst								AS WorkType							WITH(NOLOCK)			on MaintenanceWorkOrder.MaintenanceWorkType		= WorkType.LovId
			LEFT  JOIN  FMLovMst								AS TypeOfWorkOrder					WITH(NOLOCK)			on MaintenanceWorkOrder.TypeOfWorkOrder			= TypeOfWorkOrder.LovId
			LEFT  JOIN  FMLovMst								AS WorkOrderPriority				WITH(NOLOCK)			on MaintenanceWorkOrder.WorkOrderPriority		= WorkOrderPriority.LovId
			LEFT  JOIN  FMLovMst								AS WorkOrderStatus					WITH(NOLOCK)			on MaintenanceWorkOrder.WorkOrderStatus			= WorkOrderStatus.LovId
	WHERE	MaintenanceWorkOrder.EngineerUserId = @pEngineerUserId 
	ORDER BY MaintenanceWorkOrder.ModifiedDate ASC


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
