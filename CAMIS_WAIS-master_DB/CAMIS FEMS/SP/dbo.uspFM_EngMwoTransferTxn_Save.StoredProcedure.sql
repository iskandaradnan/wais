USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMwoTransferTxn_Save]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngMwoTransferTxn_Save
Description			: If TransFer already exists then update else insert.
Authors				: Balaji M S
Date				: 09-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXECUTE [uspFM_EngMwoTransferTxn_Save] @pWOTransferId=0,@pCustomerId=1,@pFacilityId=2,@pServiceId=2,@pWorkOrderId=134,@pAssignedUserId=1,@pTransferReasonLovId=1,@pUserId=2


-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngMwoTransferTxn_Save]
		
		@pWOTransferId						INT				= NULL,
		@pCustomerId						INT				= NULL,
		@pFacilityId						INT				= NULL,
		@pServiceId							INT				= NULL,
		@pWorkOrderId						INT				= NULL,
		@pAssignedUserId					INT				= NULL,
		@pTransferReasonLovId				INT				= NULL,
		@pUserId							INT				= NULL,
		@pTimestamp							VARBINARY(200)	= NULL

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)	
	DECLARE	@PrimaryKeyId	 INT




--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

--//1.MwoCompletionInfo

			IF(@pWOTransferId = NULL OR @pWOTransferId =0)

BEGIN
	
			INSERT INTO EngMwoTransferTxn
						(	
							CustomerId,
							FacilityId,
							ServiceId,
							WorkOrderId,
							AssignedUserId,
							AssignedDate,
							AssignedDateUTC,
							TransferReasonLovId,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC
						)	OUTPUT INSERTED.WOTransferId INTO @Table							

			VALUES			
						(	
							@pCustomerId,
							@pFacilityId,
							@pServiceId,
							@pWorkOrderId,
							@pAssignedUserId,
							[dbo].[udf_GetMalaysiaDateTime] (GETDATE()),
							[dbo].[udf_GetMalaysiaDateTime] (GETUTCDATE()),
							@pTransferReasonLovId,
							@pUserId,			
							GETDATE(), 
							GETDATE(),
							@pUserId, 
							GETDATE(), 
							GETDATE()
						)
						
						
			UPDATE 	EngMaintenanceWorkOrderTxn SET AssignedUserId	=	@pAssignedUserId , EngineerUserId	=	@pAssignedUserId
			WHERE	WorkOrderId = @pWorkOrderId

			INSERT INTO EngMaintenanceWorkOrderStatusHistory(CustomerId,FacilityId,ServiceId,WorkOrderId,Status,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)
			SELECT CustomerId,FacilityId,ServiceId,WorkOrderId,385,@pUserId,GETDATE(),GETUTCDATE(),@pUserId,GETDATE(),GETUTCDATE()  FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId = @pWorkOrderId

			UPDATE EngMaintenanceWorkOrderTxn SET WorkOrderStatus = 385 WHERE WorkOrderId = @pWorkOrderId


			SELECT	WOTransferId,WorkOrderId,
					[Timestamp],
					'' AS ErrorMessage
			FROM	EngMwoTransferTxn
			WHERE	WOTransferId IN (SELECT ID FROM @Table)


		     

end

ELSE 
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------

--1.MwoCompletionInfo UPDATE

			

BEGIN
			DECLARE @mTimestamp varbinary(200);
			SELECT	@mTimestamp = Timestamp FROM	EngMwoTransferTxn 
			WHERE	WorkOrderId	=	@pWorkOrderId
			
			IF(@mTimestamp= @pTimestamp)
			BEGIN
	    UPDATE  MwoTransfer	SET	
							MwoTransfer.CustomerId				= @pCustomerId,
							MwoTransfer.FacilityId				= @pFacilityId,
							MwoTransfer.ServiceId				= @pServiceId,
							MwoTransfer.WorkOrderId				= @pWorkOrderId,
							MwoTransfer.AssignedUserId			= @pAssignedUserId,
							MwoTransfer.AssignedDate			= [dbo].[udf_GetMalaysiaDateTime] (GETDATE()),
							MwoTransfer.AssignedDateUTC			= [dbo].[udf_GetMalaysiaDateTime] (GETUTCDATE()),
							MwoTransfer.TransferReasonLovId		= @pTransferReasonLovId,
							MwoTransfer.ModifiedBy				= @pUserId,
							MwoTransfer.ModifiedDate				= GETDATE(),
							MwoTransfer.ModifiedDateUTC			= GETUTCDATE()
							OUTPUT INSERTED.WOTransferId INTO @Table
				FROM	EngMwoTransferTxn						AS MwoTransfer
				WHERE	MwoTransfer.WOTransferId= @pWOTransferId 
						AND ISNULL(@pWOTransferId,0)>0

			UPDATE 	EngMaintenanceWorkOrderTxn SET AssignedUserId	=	@pAssignedUserId , EngineerUserId	=	@pAssignedUserId
			WHERE	WorkOrderId = @pWorkOrderId		

			UPDATE EngMaintenanceWorkOrderTxn SET WorkOrderStatus = 385 WHERE WorkOrderId = @pWorkOrderId
			  
			SELECT	WOTransferId,WorkOrderId,
					[Timestamp],
					'' AS ErrorMessage
			FROM	EngMwoTransferTxn
			WHERE	WOTransferId IN (SELECT ID FROM @Table)

END   
	ELSE
		BEGIN
				   SELECT	WOTransferId,WorkOrderId,
							[Timestamp],
							'Record Modified. Please Re-Select' ErrorMessage
				   FROM		EngMwoTransferTxn
				   WHERE	WOTransferId =@pWOTransferId
		END
END



	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT
        END
		
END TRY

BEGIN CATCH

	IF @mTRANSCOUNT = 0
        BEGIN
            ROLLBACK TRAN
        END

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   );
THROW;
END CATCH
GO
