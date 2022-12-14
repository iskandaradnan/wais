USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngMwoAssesmentTxn_GetById]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngMwoAssesmentTxn_GetById
Description			: To Get the data from table EngMwoAssesmentTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngMwoAssesmentTxn_GetById] @pWorkOrderId=39,@pUserId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_EngMwoAssesmentTxn_GetById]                           
  @pUserId			INT	=	NULL,
  @pWorkOrderId		INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	IF(ISNULL(@pWorkOrderId,0) = 0) RETURN


	SELECT	MwoAssesment.AssesmentId							AS AssesmentId,
			MwoAssesment.CustomerId								AS CustomerId,
			MwoAssesment.FacilityId								AS FacilityId,
			MwoAssesment.ServiceId								AS ServiceId,
			ServiceKey.ServiceKey								AS ServiceKeyValue,
			MwoAssesment.WorkOrderId							AS WorkOrderId,
			MaintenanceWorkOrder.MaintenanceWorkNo				AS MaintenanceWorkNo,
			MaintenanceWorkOrder.MaintenanceWorkDateTime		AS MaintenanceWorkDateTime,
			MwoAssesment.UserId									AS StaffMasterId,
			UMUser.StaffName									AS StaffMasterIdValue,
			MwoAssesment.Justification							AS Justification,
			MwoAssesment.ResponseDateTime						AS ResponseDateTime,
			MwoAssesment.ResponseDateTimeUTC					AS ResponseDateTimeUTC,
			--cast(MwoAssesment.ResponseDuration as numeric(24,2))AS ResponseDuration,
			MwoAssesment.ResponseDuration,
			MwoAssesment.AssetRealtimeStatus					AS AssetRealtimeStatus,
			AssetRealtimeStatus.FieldValue						AS AssetRealtimeStatusValue,
			MwoAssesment.TargetDateTime							AS TargetDateTime,
			MwoAssesment.Timestamp								AS Timestamp,
			IsChangeToVendor,
			LovChangeToVendor.FieldValue						AS IsChangeToVendorValue,
			AssignedVendor,
			Contractor.ContractorName							AS AssignedVendorName,
			MaintenanceWorkOrder.WorkOrderStatus				AS WorkOrderStatus,
			WorkOrderStatus.FieldValue							AS WorkOrderStatusValue,
			MwoAssesment.FMvendorApproveStatus 					AS FMvendorApproveStatus,
			MaintenanceWorkOrder.EngineerUserId					AS EngineerStaffId,
			EngineerStaffId.StaffName							AS EngineerStaffIdValue
	FROM	EngMwoAssesmentTxn									AS MwoAssesment
			INNER JOIN	EngMaintenanceWorkOrderTxn				AS MaintenanceWorkOrder				WITH(NOLOCK)			on MwoAssesment.WorkOrderId			= MaintenanceWorkOrder.WorkOrderId
			INNER JOIN  MstService								AS ServiceKey						WITH(NOLOCK)			on MwoAssesment.ServiceId			= ServiceKey.ServiceId
			LEFT  JOIN  UMUserRegistration						AS UMUser							WITH(NOLOCK)			on MwoAssesment.UserId				= UMUser.UserRegistrationId
			LEFT  JOIN  UMUserRegistration						AS EngineerStaffId					WITH(NOLOCK)			on MaintenanceWorkOrder.EngineerUserId			= EngineerStaffId.UserRegistrationId
			LEFT  JOIN  FMLovMst								AS AssetRealtimeStatus				WITH(NOLOCK)			on MwoAssesment.AssetRealtimeStatus	= AssetRealtimeStatus.LovId
			LEFT  JOIN  FMLovMst								AS LovChangeToVendor				WITH(NOLOCK)			on MwoAssesment.IsChangeToVendor	= LovChangeToVendor.LovId
			LEFT  JOIN  MstContractorandVendor					AS Contractor						WITH(NOLOCK)			on MwoAssesment.AssignedVendor		= Contractor.ContractorId
			LEFT  JOIN  FMLovMst								AS WorkOrderStatus					WITH(NOLOCK)			on MaintenanceWorkOrder.WorkOrderStatus			= WorkOrderStatus.LovId
	WHERE	MaintenanceWorkOrder.WorkOrderId = @pWorkOrderId 
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
