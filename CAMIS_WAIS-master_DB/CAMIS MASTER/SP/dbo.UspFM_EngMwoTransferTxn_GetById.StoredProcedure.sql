USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngMwoTransferTxn_GetById]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngMwoTransferTxn_GetById
Description			: To Get the data from table EngMwoTransferTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngMwoTransferTxn_GetById] @pWorkOrderId=134,@pPageIndex=1,@pPageSize=5,@pUserId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngMwoTransferTxn_GetById]                           
  @pUserId			INT	=	NULL,
  @pWorkOrderId		INT,
  @pPageIndex		INT,
  @pPageSize		INT	



AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @TotalRecords INT
	DECLARE	@pTotalPage		NUMERIC(24,2)

	IF(ISNULL(@pWorkOrderId,0) = 0) RETURN

	SELECT	@TotalRecords	=	COUNT(*)
	FROM	EngMwoTransferTxn									AS MwoTransfer
			INNER JOIN	EngMaintenanceWorkOrderTxn				AS MaintenanceWorkOrder				WITH(NOLOCK)			on MwoTransfer.WorkOrderId							= MaintenanceWorkOrder.WorkOrderId
			INNER JOIN	EngAsset								AS Asset							WITH(NOLOCK)			on MaintenanceWorkOrder.AssetId						= Asset.AssetId
			INNER JOIN	EngAssetTypeCode						AS AssetTypeCode					WITH(NOLOCK)			on Asset.AssetTypeCodeId							= AssetTypeCode.AssetTypeCodeId
			INNER JOIN  MstService								AS ServiceKey						WITH(NOLOCK)			on MwoTransfer.ServiceId							= ServiceKey.ServiceId
			LEFT  JOIN  UMUserRegistration						AS UserReg							WITH(NOLOCK)			on MwoTransfer.AssignedUserId						= UserReg.UserRegistrationId
			LEFT  JOIN  FMLovMst								AS TransferReason					WITH(NOLOCK)			on MwoTransfer.TransferReasonLovId					= TransferReason.LovId
			LEFT  JOIN  FMLovMst								AS WorkOrderCategory				WITH(NOLOCK)			on MaintenanceWorkOrder.MaintenanceWorkCategory		= WorkOrderCategory.LovId
	WHERE	MaintenanceWorkOrder.WorkOrderId = @pWorkOrderId 

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPage = CEILING(@pTotalPage)

	SELECT	MwoTransfer.WOTransferId							AS WOTransferId,
			MwoTransfer.CustomerId								AS CustomerId,
			MwoTransfer.FacilityId								AS FacilityId,
			MwoTransfer.ServiceId								AS ServiceId,
			ServiceKey.ServiceKey								AS ServiceKeyValue,
			MwoTransfer.WorkOrderId								AS WorkOrderId,
			Asset.AssetNo										AS AssetNo,
			Asset.AssetDescription								AS AssetDescription,
			AssetTypeCode.AssetTypeCode							AS AssetTypeCode,
			MwoTransfer.AssignedUserId							AS AssignedUserId,
			UserReg.StaffName									AS AssignedStaffName,
			MwoTransfer.AssignedDate							AS AssignedDate,
			MwoTransfer.AssignedDateUTC							AS AssignedDateUTC,
			MaintenanceWorkOrder.MaintenanceWorkNo				AS MaintenanceWorkNo,
			MaintenanceWorkOrder.MaintenanceWorkDateTime		AS MaintenanceWorkDateTime,
			WorkOrderCategory.FieldValue						AS WorkOrderCategory,
			MwoTransfer.TransferReasonLovId						AS TransferReasonLovId,
			TransferReason.FieldValue							AS TransferReasonValue,
			MwoTransfer.Timestamp,
			MaintenanceWorkOrder.WorkOrderStatus				AS WorkOrderStatus,
			WorkOrderStatus.FieldValue							AS WorkOrderStatusValue,
			@TotalRecords										AS TotalRecords,
			@pTotalPage											AS TotalPageCalc
	FROM	EngMwoTransferTxn									AS MwoTransfer
			INNER JOIN	EngMaintenanceWorkOrderTxn				AS MaintenanceWorkOrder				WITH(NOLOCK)			on MwoTransfer.WorkOrderId							= MaintenanceWorkOrder.WorkOrderId
			INNER JOIN	EngAsset								AS Asset							WITH(NOLOCK)			on MaintenanceWorkOrder.AssetId						= Asset.AssetId
			INNER JOIN	EngAssetTypeCode						AS AssetTypeCode					WITH(NOLOCK)			on Asset.AssetTypeCodeId							= AssetTypeCode.AssetTypeCodeId
			INNER JOIN  MstService								AS ServiceKey						WITH(NOLOCK)			on MwoTransfer.ServiceId							= ServiceKey.ServiceId
			LEFT  JOIN  UMUserRegistration						AS UserReg							WITH(NOLOCK)			on MwoTransfer.AssignedUserId						= UserReg.UserRegistrationId
			LEFT  JOIN  FMLovMst								AS TransferReason					WITH(NOLOCK)			on MwoTransfer.TransferReasonLovId					= TransferReason.LovId
			LEFT  JOIN  FMLovMst								AS WorkOrderCategory				WITH(NOLOCK)			on MaintenanceWorkOrder.MaintenanceWorkCategory		= WorkOrderCategory.LovId
			LEFT  JOIN  FMLovMst								AS WorkOrderStatus					WITH(NOLOCK)			on MaintenanceWorkOrder.WorkOrderStatus			= WorkOrderStatus.LovId
	WHERE	MaintenanceWorkOrder.WorkOrderId = @pWorkOrderId 
	ORDER BY MaintenanceWorkOrder.ModifiedDate ASC
	OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY


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
