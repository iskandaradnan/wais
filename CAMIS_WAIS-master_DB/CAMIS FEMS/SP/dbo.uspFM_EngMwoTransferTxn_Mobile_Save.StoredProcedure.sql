USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMwoTransferTxn_Mobile_Save]    Script Date: 20-09-2021 16:56:53 ******/
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

EXECUTE [uspFM_EngMwoTransferTxn_Save] @pWOTransferId=0,@pCustomerId=1,@pFacilityId=2,@pServiceId=2,@pWorkOrderId=6147,@pAssignedUserId=1,@pTransferReasonLovId=1,@pUserId=2


-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngMwoTransferTxn_Mobile_Save]
		
		@EngMwoTransferTxn_Mobile		[dbo].[udt_EngMwoTransferTxn_Mobile]   READONLY


AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)	
	DECLARE @Table1 TABLE (ID INT)	
	DECLARE	@PrimaryKeyId	 INT



		 

--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

--//1.MwoCompletionInfo

			IF EXISTS(SELECT 1 FROM @EngMwoTransferTxn_Mobile WHERE WOTransferId = NULL OR WOTransferId =0)

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
							ModifiedDateUTC,
							TransferStatus
						)	OUTPUT INSERTED.WOTransferId INTO @Table							

			SELECT			
							
							CustomerId,
							FacilityId,
							ServiceId,
							WorkOrderId,
							AssignedUserId,
							[dbo].[udf_GetMalaysiaDateTime] (GETDATE()),
							[dbo].[udf_GetMalaysiaDateTime] (GETUTCDATE()),
							TransferReasonLovId,
							UserId,			
							GETDATE(), 
							GETDATE(),
							UserId, 
							GETDATE(), 
							GETDATE(),
							TransferStatus
			FROM 	@EngMwoTransferTxn_Mobile WHERE WOTransferId = NULL OR WOTransferId =0

			insert into EngMWOHandOverHistoryTxn  (WorkorderId,AssignedUserId,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)
		 select WOT.WorkorderId,WO.AssignedUserId, UserId,	GETDATE(), GETUTCDATE(),UserId, GETDATE(), GETUTCDATE() 
		 from @EngMwoTransferTxn_Mobile WOT	 join EngMaintenanceWorkOrderTxn WO on WO.workorderid = WOT.workorderid
		 where TransferStatus = 'HandOver'
		 AND  ISNULL(WOT.WorkOrderId,0)>0 

			UPDATE B SET B.IsChangeToVendor = A.IsChangeToVendor,B.AssignedVendor = A.AssignedVendor
			FROM @EngMwoTransferTxn_Mobile A INNER JOIN EngMwoAssesmentTxn B ON A.WorkOrderId = B.WorkOrderId
			
			UPDATE B SET B.WorkOrderStatus = 192
			FROM @EngMwoTransferTxn_Mobile A INNER JOIN EngMaintenanceWorkOrderTxn B ON A.WorkOrderId = B.WorkOrderId
			AND A.TransferStatus = 'Transfer'

			update WorkOrderTable set
			WorkOrderTable.AssignedUserId=TransferTable.AssignedUserId,
			WorkOrderTable.EngineerUserId=TransferTable.AssignedUserId
			output inserted.WorkOrderId into @Table
			from EngMaintenanceWorkOrderTxn as WorkOrderTable
			inner join @EngMwoTransferTxn_Mobile as TransferTable on WorkOrderTable.WorkOrderId=TransferTable.WorkOrderId
			where ISNULL(TransferTable.WorkOrderId,0)>0
			
			INSERT INTO QueueWebtoMobile (TableName,Tableprimaryid,UserId)
			select 'EngMaintenanceWorkOrderTxn',TransferTable.WorkOrderId,TransferTable.AssignedUserId 			from EngMaintenanceWorkOrderTxn as WorkOrderTable
			inner join @EngMwoTransferTxn_Mobile as TransferTable on WorkOrderTable.WorkOrderId=TransferTable.WorkOrderId
			where ISNULL(TransferTable.WorkOrderId,0)>0
							
			SELECT	WOTransferId,A.WorkOrderId,
					A.[Timestamp],
					C.Email,
					B.MaintenanceWorkNo,
					'' AS ErrorMessage
			FROM	EngMwoTransferTxn A
			inner join EngMaintenanceWorkOrderTxn B on B.WorkOrderId=A.WorkOrderId
			left join UMUserRegistration C on B.AssignedUserId= C.UserRegistrationId
			WHERE	WOTransferId IN (SELECT ID FROM @Table)


	INSERT INTO	FENotification (	UserId,
									NotificationAlerts,
									Remarks,
									CreatedBy,
									CreatedDate,
									CreatedDateUTC,
									ModifiedBy,
									ModifiedDate,
									ModifiedDateUTC,
									ScreenName,
									DocumentId,
									SingleRecord
								) OUTPUT INSERTED.NotificationId INTO @Table1
					SELECT	B.AssignedUserId,
							'Work Order has been assinged to you - ' + A.MaintenanceWorkNo,
							'Manual Assigned' AS Remarks,
							UserId,
							GETDATE(),
							GETUTCDATE(),
							UserId,
							GETDATE(),
							GETUTCDATE(),
							'EngMaintenanceWorkOrderTxn',
							A.MaintenanceWorkNo,
							1
					FROM EngMaintenanceWorkOrderTxn as A
			inner join @EngMwoTransferTxn_Mobile as B on A.WorkOrderId=B.WorkOrderId
				where ISNULL(B.WorkOrderId,0)>0

	SET @PrimaryKeyId = (SELECT top 1 ID FROM @Table1)

	INSERT INTO QueueWebtoMobile	(		TableName,
											Tableprimaryid,
											UserId
									)
									SELECT	
											'FENotification',						
											@PrimaryKeyId,
											B.AssignedUserId
											FROM EngMaintenanceWorkOrderTxn as A
											inner join @EngMwoTransferTxn_Mobile as B on A.WorkOrderId=B.WorkOrderId
											where ISNULL(B.WorkOrderId,0)>0
	
	--INSERT INTO QueueWebtoMobile	(		TableName,
	--										Tableprimaryid,
	--										UserId
	--								)
	--									SELECT	
	--										'EngMaintenanceWorkOrderTxn',						
	--										B.WorkOrderId,
	--										B.AssignedUserId
	--										FROM EngMaintenanceWorkOrderTxn as A
	--										inner join @EngMwoTransferTxn_Mobile as B on A.WorkOrderId=B.WorkOrderId
	--										where ISNULL(B.WorkOrderId,0)>0
		 

		 --INSERT INTO QueueWebtoMobile (TableName,Tableprimaryid,UserId)
		 --select 'WorkOrderStatus',TransferTable.WorkOrderId,TransferTable.AssignedUserId    
		 --from EngMWOHandOverHistoryTxn as WorkOrderTable
		 --inner join @EngMwoTransferTxn_Mobile as TransferTable on WorkOrderTable.WorkOrderId=TransferTable.WorkOrderId
		 --where ISNULL(TransferTable.WorkOrderId,0)>0


end

ELSE 
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------

--1.MwoCompletionInfo UPDATE

			

BEGIN

PRINT 'ERROR'
--			DECLARE @mTimestamp varbinary(200);
--			SELECT	@mTimestamp = Timestamp FROM	EngMwoTransferTxn 
--			WHERE	WorkOrderId	=	@pWorkOrderId
			
--			IF(@mTimestamp= @pTimestamp)
--			BEGIN
--	    UPDATE  MwoTransfer	SET	
--							MwoTransfer.CustomerId				= @pCustomerId,
--							MwoTransfer.FacilityId				= @pFacilityId,
--							MwoTransfer.ServiceId				= @pServiceId,
--							MwoTransfer.WorkOrderId				= @pWorkOrderId,
--							MwoTransfer.AssignedUserId			= @pAssignedUserId,
--							MwoTransfer.AssignedDate			= GETDATE(),
--							MwoTransfer.AssignedDateUTC			= GETUTCDATE(),
--							MwoTransfer.TransferReasonLovId		= @pTransferReasonLovId,
--							MwoTransfer.ModifiedBy				= @pUserId,
--							MwoTransfer.ModifiedDate				= GETDATE(),
--							MwoTransfer.ModifiedDateUTC			= GETUTCDATE()
--							OUTPUT INSERTED.WOTransferId INTO @Table
--				FROM	EngMwoTransferTxn						AS MwoTransfer
--				WHERE	MwoTransfer.WOTransferId= @pWOTransferId 
--						AND ISNULL(@pWOTransferId,0)>0
		  
--			SELECT	WOTransferId,WorkOrderId,
--					[Timestamp],
--					'' AS ErrorMessage
--			FROM	EngMwoTransferTxn
--			WHERE	WOTransferId IN (SELECT ID FROM @Table)

--END   
--	ELSE
--		BEGIN
--				   SELECT	WOTransferId,WorkOrderId,
--							[Timestamp],
--							'Record Modified. Please Re-Select' ErrorMessage
--				   FROM		EngMwoTransferTxn
--				   WHERE	WOTransferId =@pWOTransferId
--		END
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

----------------------------------------------------------------UDT CREATION ----------------------------------------------------------------

--DROP PROC uspFM_EngMwoTransferTxn_Mobile_Save

--DROP TYPE [udt_EngMwoTransferTxn_Mobile]

--CREATE TYPE [dbo].[udt_EngMwoTransferTxn_Mobile] AS TABLE(
--	[WOTransferId] [int] NULL,
--	[CustomerId] [int] NULL,
--	[FacilityId] [int] NULL,
--	[ServiceId] [int] NULL,
--	[WorkOrderId] [int] NULL,
--	[AssignedUserId] [int] NULL,
--	[TransferReasonLovId] [int] NULL,
--	[UserId] [int] NULL,
--	[IsChangeToVendor] [INT] NULL,
--	[AssignedVendor]  [INT] NULL,
--	[TransferStatus] [nvarchar](200) null
--)
--GO
GO
