USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngMaintenanceWorkOrderTxn_Delete]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngMaintenanceWorkOrderTxn_Delete
Description			: To Delete Work Order Details from EngMaintenanceWorkOrderTxn table.
Authors				: Balaji M S
Date				: 04-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC UspFM_EngMaintenanceWorkOrderTxn_Delete  @pWorkOrderId=2

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_EngMaintenanceWorkOrderTxn_Delete]                           
	@pWorkOrderId	INT	
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


-- Default Values


-- Execution
	DELETE FROM  EngMwoAssesmentTxn						WHERE WorkOrderId= @pWorkOrderId
	DELETE FROM  EngMwoAttachmentTxn					WHERE WorkOrderId= @pWorkOrderId
	DELETE FROM  EngMwoCompletionInfoTxn				WHERE WorkOrderId= @pWorkOrderId
	DELETE FROM  EngMwoPartReplacementTxn				WHERE WorkOrderId= @pWorkOrderId
	DELETE FROM  EngMwoReschedulingTxn					WHERE WorkOrderId= @pWorkOrderId
	DELETE FROM  EngMwoTransferTxn						WHERE WorkOrderId= @pWorkOrderId
	DELETE FROM  EngPPMRescheduleTxnDet					WHERE WorkOrderId= @pWorkOrderId
	DELETE FROM  QapB1AdditionalInformationTxn			WHERE WorkOrderId= @pWorkOrderId
	DELETE FROM  QRCodeWorkOrder						WHERE WorkOrderId= @pWorkOrderId
	DELETE FROM  EngMaintenanceWorkOrderStatusHistory	WHERE WorkOrderId= @pWorkOrderId
	DELETE FROM  EngMaintenanceWorkOrderTxn				WHERE WorkOrderId= @pWorkOrderId

	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT TRANSACTION
        END   


END TRY

BEGIN CATCH

	IF @mTRANSCOUNT = 0
        BEGIN
            ROLLBACK TRAN
        END

	SELECT 'This record can''t be deleted as it is referenced by another screen'	AS ErrorMessage

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
