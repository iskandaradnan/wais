USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMwoTransferTxn_Mobile_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngTestingandCommissioningTxn_GetById
Description			: To Get the Facility code
Authors				: Dhilip V
Date				: 11-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngMwoTransferTxn_Mobile_GetById] @pWorkOrderId=134,@pTransferStatus= NULL

SELECT * FROM EngMwoTransferTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngMwoTransferTxn_Mobile_GetById]
                     
  @pWorkOrderId		INT,
  @pTransferStatus  NVARCHAR(200) = null


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



	IF(@pTransferStatus IS NOT NULL)
	BEGIN
    SELECT	

	MwoTransfer.CustomerId,
	MwoTransfer.FacilityId,
	MwoTransfer.ServiceId,
	MwoTransfer.WorkOrderId,
	WorkOrder.MaintenanceWorkNo,
	WorkOrder.MaintenanceWorkDateTime,
	MwoTransfer.AssignedUserId,
	AssignedUserId.StaffName AS AssignedUserName,
	MwoTransfer.AssignedDate,
	MwoTransfer.AssignedDateUTC,
	MwoTransfer.TransferReasonLovId,
	TransferReasonLovId.FieldValue AS TransferReasonLovValue,
	MwoTransfer.CreatedBy,
	MwoTransfer.CreatedDate,
	MwoTransfer.CreatedDateUTC,
	MwoTransfer.ModifiedBy,
	MwoTransfer.ModifiedDate,
	MwoTransfer.ModifiedDateUTC,
	MwoTransfer.TransferStatus

	FROM	    EngMwoTransferTxn			AS MwoTransfer			WITH(NOLOCK)
	INNER JOIN  EngMaintenanceWorkOrderTxn	AS WorkOrder			WITH(NOLOCK)	ON MwoTransfer.WorkOrderId			= WorkOrder.WorkOrderId
	LEFT JOIN  UMUserRegistration			AS AssignedUserId		WITH(NOLOCK)	ON MwoTransfer.AssignedUserId		= AssignedUserId.UserRegistrationId
	LEFT JOIN  FMLovMst						AS TransferReasonLovId	WITH(NOLOCK)	ON MwoTransfer.TransferReasonLovId	= TransferReasonLovId.LovId
	WHERE	MwoTransfer.WorkOrderId	=	@pWorkOrderId AND TransferStatus = @pTransferStatus
	END

	IF(@pTransferStatus IS NULL)
	BEGIN
    SELECT	

	MwoTransfer.CustomerId,
	MwoTransfer.FacilityId,
	MwoTransfer.ServiceId,
	MwoTransfer.WorkOrderId,
	WorkOrder.MaintenanceWorkNo,
	WorkOrder.MaintenanceWorkDateTime,
	MwoTransfer.AssignedUserId,
	AssignedUserId.StaffName AS AssignedUserName,
	MwoTransfer.AssignedDate,
	MwoTransfer.AssignedDateUTC,
	MwoTransfer.TransferReasonLovId,
	TransferReasonLovId.FieldValue AS TransferReasonLovValue,
	MwoTransfer.CreatedBy,
	MwoTransfer.CreatedDate,
	MwoTransfer.CreatedDateUTC,
	MwoTransfer.ModifiedBy,
	MwoTransfer.ModifiedDate,
	MwoTransfer.ModifiedDateUTC,
	MwoTransfer.TransferStatus

	FROM	    EngMwoTransferTxn			AS MwoTransfer			WITH(NOLOCK)
	INNER JOIN  EngMaintenanceWorkOrderTxn	AS WorkOrder			WITH(NOLOCK)	ON MwoTransfer.WorkOrderId			= WorkOrder.WorkOrderId
	LEFT JOIN  UMUserRegistration			AS AssignedUserId		WITH(NOLOCK)	ON MwoTransfer.AssignedUserId		= AssignedUserId.UserRegistrationId
	LEFT JOIN  FMLovMst						AS TransferReasonLovId	WITH(NOLOCK)	ON MwoTransfer.TransferReasonLovId	= TransferReasonLovId.LovId
	WHERE	MwoTransfer.WorkOrderId	=	@pWorkOrderId 
	END
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
