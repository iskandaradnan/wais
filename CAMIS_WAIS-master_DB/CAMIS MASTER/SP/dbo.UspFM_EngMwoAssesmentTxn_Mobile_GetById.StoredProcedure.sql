USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngMwoAssesmentTxn_Mobile_GetById]    Script Date: 20-09-2021 16:43:01 ******/
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
EXEC [UspFM_EngMwoAssesmentTxn_Mobile_GetById] @pWorkOrderId ='32,64'

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_EngMwoAssesmentTxn_Mobile_GetById]                           
  @pUserId			INT	=	NULL,
  @pWorkOrderId		NVARCHAR(200)


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	IF(ISNULL(@pWorkOrderId,'') = '') RETURN


	SELECT	MwoAssesment.AssesmentId							AS AssesmentId,
			MwoAssesment.CustomerId								AS CustomerId,
			MwoAssesment.FacilityId								AS FacilityId,
			MwoAssesment.ServiceId								AS ServiceId,
			ServiceKey.ServiceKey								AS ServiceKeyValue,
			MwoAssesment.WorkOrderId							AS WorkOrderId,
			MaintenanceWorkOrder.MaintenanceWorkNo				AS MaintenanceWorkNo,
			MaintenanceWorkOrder.MaintenanceWorkDateTime		AS MaintenanceWorkDateTime,
			MwoAssesment.UserId									AS StaffMasterId,
			MwoAssesment.FMvendorApproveStatus					AS FMvendorApproveStatus,
			UMUser.StaffName									AS StaffMasterIdValue,
			MwoAssesment.Justification							AS Justification,
			MwoAssesment.ResponseDateTime						AS ResponseDateTime,
			MwoAssesment.ResponseDateTimeUTC					AS ResponseDateTimeUTC,
			MwoAssesment.ResponseDuration						AS ResponseDuration,
			MwoAssesment.AssetRealtimeStatus					AS AssetRealtimeStatus,
			AssetRealtimeStatus.FieldValue						AS AssetRealtimeStatusValue,
			MwoAssesment.TargetDateTime							AS TargetDateTime,
			MwoAssesment.IsChangeToVendor						AS IsChangeToVendor,
			IsChangeToVendor.FieldValue							AS IsChangeToVendorValue,
			MwoAssesment.AssignedVendor							AS AssignedVendor,
			AssignedVendor.SSMRegistrationCode					AS AssignedVendorCode,
			AssignedVendor.ContractorName						AS AssignedVendorName,
			MwoAssesment.Timestamp								AS Timestamp		
	FROM	EngMwoAssesmentTxn									AS MwoAssesment
			INNER JOIN	EngMaintenanceWorkOrderTxn				AS MaintenanceWorkOrder				WITH(NOLOCK)			on MwoAssesment.WorkOrderId			= MaintenanceWorkOrder.WorkOrderId
			INNER JOIN  MstService								AS ServiceKey						WITH(NOLOCK)			on MwoAssesment.ServiceId			= ServiceKey.ServiceId
			LEFT  JOIN  UMUserRegistration						AS UMUser							WITH(NOLOCK)			on MwoAssesment.UserId				= UMUser.UserRegistrationId
			LEFT  JOIN  FMLovMst								AS AssetRealtimeStatus				WITH(NOLOCK)			on MwoAssesment.AssetRealtimeStatus	= AssetRealtimeStatus.LovId
			LEFT  JOIN  FMLovMst								AS IsChangeToVendor					WITH(NOLOCK)			on MwoAssesment.IsChangeToVendor	= IsChangeToVendor.LovId
			LEFT  JOIN  MstContractorandVendor					AS AssignedVendor					WITH(NOLOCK)			on MwoAssesment.AssignedVendor		= AssignedVendor.ContractorId
	WHERE	MaintenanceWorkOrder.WorkOrderId IN  (SELECT ITEM FROM dbo.[SplitString] (@pWorkOrderId,','))
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
