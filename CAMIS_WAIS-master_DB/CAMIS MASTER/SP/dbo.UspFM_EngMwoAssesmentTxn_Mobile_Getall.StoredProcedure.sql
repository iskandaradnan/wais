USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngMwoAssesmentTxn_Mobile_Getall]    Script Date: 20-09-2021 16:43:01 ******/
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
EXEC [UspFM_EngMwoAssesmentTxn_Mobile_Getall] @pFacilityId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_EngMwoAssesmentTxn_Mobile_Getall]                           
 
 @pFacilityId  int=null


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	

	SELECT	MwoAssesment.AssesmentId							AS AssesmentId,
			MwoAssesment.CustomerId								AS CustomerId,
			MwoAssesment.FacilityId								AS FacilityId,
			MwoAssesment.ServiceId								AS ServiceId,
			ServiceKey.ServiceKey								AS ServiceKeyValue,
			MwoAssesment.WorkOrderId							AS WorkOrderId,
			Asset.AssetNo										AS AssetNo,
			MaintenanceWorkOrder.MaintenanceWorkNo				AS MaintenanceWorkNo,
			MaintenanceWorkOrder.MaintenanceWorkDateTime		AS MaintenanceWorkDateTime,
			MaintenanceWorkOrder.EngineerUserId					AS EngineerUserId,
			UMUser.StaffName									AS EngineerUserName,
			MwoAssesment.Justification							AS Justification,
			MwoAssesment.ResponseDateTime						AS ResponseDateTime,
			MwoAssesment.ResponseDateTimeUTC					AS ResponseDateTimeUTC,
			--cast(MwoAssesment.ResponseDuration as numeric(24,2))AS ResponseDuration,
			MwoAssesment.ResponseDuration,
			MwoAssesment.AssetRealtimeStatus					AS AssetRealtimeStatus,
			AssetRealtimeStatus.FieldValue						AS AssetRealtimeStatusValue,
			MwoAssesment.TargetDateTime							AS TargetDateTime,		
			IsChangeToVendor,
			LovChangeToVendor.FieldValue						AS IsChangeToVendorValue,
			AssignedVendor,
			Contractor.ContractorName							AS AssignedVendorName,
			MaintenanceWorkOrder.WorkOrderStatus				AS WorkOrderStatus,
			WorkOrderStatus.FieldValue							AS WorkOrderStatusValue,
			Manufacturer.Manufacturer							AS Manufacturer,
			Model.Model											AS Model
	FROM	EngMwoAssesmentTxn									AS MwoAssesment
			INNER JOIN	EngMaintenanceWorkOrderTxn				AS MaintenanceWorkOrder				WITH(NOLOCK)			on MwoAssesment.WorkOrderId			= MaintenanceWorkOrder.WorkOrderId
			INNER JOIN EngAsset									AS Asset							WITH(NOLOCK)			on MaintenanceWorkOrder.AssetId		=	Asset.AssetId
			INNER JOIN EngAssetStandardizationManufacturer		AS Manufacturer						WITH(NOLOCK)			on Manufacturer.ManufacturerId		=	Asset.Manufacturer
			INNER JOIN EngAssetStandardizationModel				AS Model							WITH(NOLOCK)			on Model.ModelId					=	Asset.Model
			INNER JOIN  MstService								AS ServiceKey						WITH(NOLOCK)			on MwoAssesment.ServiceId			= ServiceKey.ServiceId
			LEFT  JOIN  UMUserRegistration						AS UMUser							WITH(NOLOCK)			on MaintenanceWorkOrder.EngineerUserId		= UMUser.UserRegistrationId
			LEFT  JOIN  FMLovMst								AS AssetRealtimeStatus				WITH(NOLOCK)			on MwoAssesment.AssetRealtimeStatus	= AssetRealtimeStatus.LovId
			LEFT  JOIN  FMLovMst								AS LovChangeToVendor				WITH(NOLOCK)			on MwoAssesment.IsChangeToVendor	= LovChangeToVendor.LovId
			LEFT  JOIN  MstContractorandVendor					AS Contractor						WITH(NOLOCK)			on MwoAssesment.AssignedVendor		= Contractor.ContractorId
			LEFT  JOIN  FMLovMst								AS WorkOrderStatus					WITH(NOLOCK)			on MaintenanceWorkOrder.WorkOrderStatus			= WorkOrderStatus.LovId
	WHERE	MaintenanceWorkOrder.FacilityId = @pFacilityId 
	AND		MaintenanceWorkOrder.WorkOrderStatus=193
	AND     MwoAssesment.IsChangeToVendor=99
	and     MwoAssesment.FMvendorApproveStatus is null
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
